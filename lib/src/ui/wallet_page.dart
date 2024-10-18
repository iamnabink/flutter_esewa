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

  /// The URLRequest object that will be used to load the eSewa payment page.
  late final URLRequest paymentRequest;

  /// Esewa page's content widget
  late final EsewaPageContent? content;

  @override
  void initState() {
    content = widget.pageContents;
    // Assign the eSewa configuration object from the widget to the local variable.
    eSewaConfig = widget.eSewaConfig;
    // Generate the URLRequest object from the eSewa configuration parameters.
    paymentRequest = getURLRequest();
    super.initState();
  }

  // The loading state of the WebView.
  bool _isLoading = true;

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

  // Generates the URLRequest object for the eSewa payment page.
  URLRequest getURLRequest() {
    var url =
        "${eSewaConfig.serverUrl}tAmt=${eSewaConfig.tAmt}&amt=${eSewaConfig.amt.toPrecision(2)}&txAmt=${eSewaConfig.txAmt?.toPrecision(2)}&psc=${eSewaConfig.psc}&pdc=${eSewaConfig.pdc}&scd=${eSewaConfig.scd}&pid=${eSewaConfig.pid}&su=${eSewaConfig.su}&fu=${eSewaConfig.fu}";
    var urlRequest = URLRequest(url: WebUri(url));
    if (kDebugMode) {
      print(url);
    }
    return urlRequest;
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
            initialUrlRequest: paymentRequest,
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
              var uri = navigationAction.request.url!;
              var body = navigationAction.request.body;
              if (kDebugMode) {
                print(uri.toString());
                print(body);
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
              ].contains(uri.scheme)) {
                // If the URL scheme is not allowed, cancel the navigation
                return NavigationActionPolicy.CANCEL;
              }
              try {
                var result = Uri.parse(uri.toString());
                var body = result.queryParameters;
                if (body['refId'] != null) {
                  // If the URL contains a refId parameter, create a payment response
                  // and return it to the previous screen using Navigator.pop()
                  _createPaymentResponse(body).then((value) {
                    Navigator.pop(context, EsewaPaymentResult(data: value));
                  });
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
  Future<EsewaPaymentResponse> _createPaymentResponse(
      Map<String, dynamic> body) async {
    final params = EsewaPaymentResponse(
      refId: body['refId'],
      productId: body['oid'],
      totalAmount: body['amt'],
    );
    return params;
  }
}
