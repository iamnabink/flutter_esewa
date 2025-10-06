import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Esewa Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const EsewaApp(title: 'Esewa Payment'),
    );
  }
}

class EsewaApp extends StatefulWidget {
  const EsewaApp({super.key, required this.title});

  final String title;

  @override
  State<EsewaApp> createState() => _EsewaAppState();
}

class _EsewaAppState extends State<EsewaApp> {
  String data = '';
  String hasError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Example Use case - 1
            EsewaPayButton(
              paymentConfig: ESewaConfig.dev(
                amount: 10.0,
                successUrl: 'https://developer.esewa.com.np/success',
                failureUrl: 'https://developer.esewa.com.np/failure',
                secretKey: '8gBm/:&EnhH.1/q',
                // productCode: 'EPAYTEST', // optional for dev
              ),
              width: 100,
              onFailure: (result) async {
                setState(() {
                  data = '';
                  hasError = result;
                });
                if (kDebugMode) {
                  print(result);
                }
              },
              onSuccess: (result) async {
                setState(() {
                  hasError = '';
                  data = result.data!;
                });
                if (kDebugMode) {
                  print(result.toJson());
                }
              },
            ),
            if (data.isNotEmpty)
              Text('Console: Payment Success, Data is: $data'),
            if (hasError.isNotEmpty)
              Text('Console: Payment Failed, Message: $hasError'),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
