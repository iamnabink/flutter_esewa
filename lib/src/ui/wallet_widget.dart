part of esewa_flutter;

class WalletPage extends StatefulWidget {
  final ESewaConfig eSewaConfig;

  const WalletPage(this.eSewaConfig, {Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late ESewaConfig eSewaConfig;
  late URLRequest paymentRequest;

  @override
  void initState() {
    eSewaConfig = widget.eSewaConfig;
    paymentRequest = getURLRequest();
    super.initState();
  }

  bool _isLoading = true;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  URLRequest getURLRequest() {
    var url =
        "${eSewaConfig.serverUrl}tAmt=${eSewaConfig.tAmt}&amt=${eSewaConfig.amt.toPrecision(2)}&txAmt=${eSewaConfig.txAmt?.toPrecision(2)}&psc=${eSewaConfig.psc}&pdc=${eSewaConfig.pdc}&scd=${eSewaConfig.scd}&pid=${eSewaConfig.pid}&su=${eSewaConfig.su}&fu=${eSewaConfig.fu}";
    var urlRequest = URLRequest(url: Uri.tryParse(url));
    if (kDebugMode) {
      print(url);
    }
    return urlRequest;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay Via Esewa"),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: paymentRequest,
            initialOptions: options,
            onWebViewCreated: (webViewController) {
              setState(() {
                _isLoading = false;
              });
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
            },
            onLoadStop: (controller, url) async {
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
              if (![
                "http",
                "https",
                "file",
                "chrome",
                "data",
                "javascript",
                "about"
              ].contains(uri.scheme)) {
                return NavigationActionPolicy.CANCEL;
              }
              try {
                var result = Uri.parse(uri.toString());
                var body = result.queryParameters;
                if (body['refId'] != null) {
                  await createPaymentResponse(body).then((value) {
                    Navigator.pop(context, EsewaPaymentResult(data: value));
                  });
                }
              } catch (e) {
                Navigator.pop(
                    context, EsewaPaymentResult(error: 'Payment Cancelled'));
              }

              return NavigationActionPolicy.ALLOW;
            },
            onLoadError: (controller, url, code, message) {
              if (kDebugMode) {
                print('CODE $code Message $message');
              }
            },
            onConsoleMessage: (controller, consoleMessage) {},
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<EsewaPaymentResponse> createPaymentResponse(
      Map<String, dynamic> body) async {
    final params = EsewaPaymentResponse(
      refId: body['refId'],
      productId: body['oid'],
      totalAmount: body['amt'],
    );
    return params;
  }
}

extension ExtensionOnDouble on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
