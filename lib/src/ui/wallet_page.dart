part of esewa_flutter;

/// holds Esewa page's content widget
class EsewaPageContent {
  /// Page appbar
  final AppBar? appBar;

  /// Page custom loader
  final Widget? progressLoader;

  EsewaPageContent({this.appBar, this.progressLoader});
}

/// Esewa Payment Screen/View
class EsewaPage extends StatefulWidget {
  /// The eSewa configuration object.
  final ESewaConfig eSewaConfig;

  /// Esewa page's content widget
  final EsewaPageContent? pageContents;

  const EsewaPage(this.eSewaConfig, {this.pageContents, Key? key})
      : super(key: key);

  @override
  State<EsewaPage> createState() => _EsewaPageState();
}

class _EsewaPageState extends State<EsewaPage> {
  /// The eSewa configuration object.
  late final ESewaConfig eSewaConfig;

  /// Generated fields for the v2 POST form
  late final Map<String, String> _formFields;

  /// Esewa page's content widget
  late final EsewaPageContent? content;

  @override
  void initState() {
    content = widget.pageContents;
    // Assign the eSewa configuration object from the widget to the local variable.
    eSewaConfig = widget.eSewaConfig;
    // Prepare the POST form fields from the configuration parameters.
    _formFields = _buildFormFields();
    super.initState();
  }

  // The loading state of the WebView.
  bool _isLoading = true;
  // Prevent duplicate results
  bool _completed = false;

  // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  //     crossPlatform: InAppWebViewOptions(
  //       useShouldOverrideUrlLoading: true,
  //       mediaPlaybackRequiresUserGesture: false,
  //     ),
  //     android: AndroidInAppWebViewOptions(
  //       useHybridComposition: true,
  //     ),
  //     ios: IOSInAppWebViewOptions(
  //       allowsInlineMediaPlayback: true,
  //     ));

  // Build fields and signature for application/x-www-form-urlencoded POST to eSewa v2 API
  Map<String, String> _buildFormFields() {
    final amount = eSewaConfig.amount.toPrecision(2).toString();
    final tax = (eSewaConfig.taxAmount ?? 0).toPrecision(2).toString();
    final psc =
        (eSewaConfig.productServiceCharge ?? 0).toPrecision(2).toString();
    final pdc =
        (eSewaConfig.productDeliveryCharge ?? 0).toPrecision(2).toString();
    final total = (eSewaConfig.totalAmount ??
            (eSewaConfig.amount +
                (eSewaConfig.taxAmount ?? 0) +
                (eSewaConfig.productServiceCharge ?? 0) +
                (eSewaConfig.productDeliveryCharge ?? 0)))
        .toPrecision(2)
        .toString();

    final txnUuid = eSewaConfig.transactionUuid ??
        "TXN-${DateTime.now().millisecondsSinceEpoch}-${DateTime.now().microsecondsSinceEpoch % 1000}";

    final signedData =
        'total_amount=$total,transaction_uuid=$txnUuid,product_code=${eSewaConfig.productCode}';
    final keyBytes = utf8.encode(eSewaConfig.secretKey);
    final dataBytes = utf8.encode(signedData);
    final hmac = crypto.Hmac(crypto.sha256, keyBytes);
    final digest = hmac.convert(dataBytes);
    final signature = base64.encode(digest.bytes);

    if (kDebugMode) {
      print('Signed data -> $signedData');
      print('Signature -> $signature');
    }

    return {
      'amount': amount,
      'tax_amount': tax,
      'total_amount': total,
      'product_service_charge': psc,
      'product_delivery_charge': pdc,
      'transaction_uuid': txnUuid,
      'product_code': eSewaConfig.productCode,
      'success_url': eSewaConfig.successUrl,
      'failure_url': eSewaConfig.failureUrl,
      'signed_field_names': eSewaConfig.signedFieldNames,
      'signature': signature,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: content?.appBar ??
          AppBar(
            title: const Text("Pay Via Esewa"),
          ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(eSewaConfig.serverUrl),
              method: 'POST',
              body: Uint8List.fromList(
                  utf8.encode(Uri(queryParameters: _formFields).query)),
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
              },
            ),
            // initialOptions: options,
            onWebViewCreated: (webViewController) {
              // When the WebView is created, set the isLoading state to false
              setState(() {
                _isLoading = false;
              });
            },
            onLoadStart: (controller, url) {
              // When the WebView starts loading, set the isLoading state to true
              setState(() {
                _isLoading = true;
              });
            },
            onLoadStop: (controller, url) async {
              // When the WebView finishes loading, set the isLoading state to false
              setState(() {
                _isLoading = false;
                if (kDebugMode) {
                  print(url.toString());
                }
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final reqUrl = navigationAction.request.url;
              final body = navigationAction.request.body;
              if (kDebugMode) {
                print(reqUrl?.toString());
                print(body);
              }
              if (reqUrl == null) {
                return NavigationActionPolicy.ALLOW;
              }
              // Check if the URL scheme is one of the allowed schemes
              if (![
                "http",
                "https",
                "file",
                "chrome",
                "data",
                "javascript",
                "about"
              ].contains(reqUrl.scheme)) {
                // If the URL scheme is not allowed, cancel the navigation
                return NavigationActionPolicy.CANCEL;
              }
              try {
                final urlStr = reqUrl.toString();
                final isSuccessRedirect =
                    urlStr.startsWith(eSewaConfig.successUrl);
                final isFailureRedirect =
                    urlStr.startsWith(eSewaConfig.failureUrl);

                // Only handle redirects to success/failure URLs
                if (!isSuccessRedirect && !isFailureRedirect) {
                  return NavigationActionPolicy.ALLOW;
                }

                if (_completed) {
                  return NavigationActionPolicy.CANCEL;
                }

                final resultUri = Uri.parse(urlStr);
                final qp = resultUri.queryParameters;

                if (isSuccessRedirect) {
                  final base64Data = qp['data'];
                  _completed = true;
                  if (base64Data != null && base64Data.isNotEmpty) {
                    final response = EsewaPaymentResponse(data: base64Data);
                    Navigator.pop(context, EsewaPaymentResult(data: response));
                  } else {
                    Navigator.pop(context,
                        EsewaPaymentResult(error: kPaymentErrorMessage));
                  }
                  return NavigationActionPolicy.CANCEL;
                }

                if (isFailureRedirect) {
                  _completed = true;
                  final message = qp['message'] ?? kPaymentErrorMessage;
                  Navigator.pop(context, EsewaPaymentResult(error: message));
                  return NavigationActionPolicy.CANCEL;
                }
              } catch (e) {
                Navigator.pop(
                    context, EsewaPaymentResult(error: kPaymentErrorMessage));
              }

              return NavigationActionPolicy.ALLOW;
            },
            onReceivedError: (controller, url, code) {
              // If there is an error while loading the WebView, print the error message
              // if the app is in debug mode
              if (kDebugMode) {
                print('CODE $code Message ');
              }
            },
            onConsoleMessage: (controller, consoleMessage) {},
          ),
          if (_isLoading)
            Center(
              child:
                  content?.progressLoader ?? const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  // Create a payment response object using the refId, productId, and totalAmount
  // values from the URL
}
