import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const EsewaApp({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EsewaApp> createState() => _EsewaAppState();
}

class _EsewaAppState extends State<EsewaApp> {
  String refId = '';
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
            TextButton(
              onPressed: () async {
                //  just call a method it
                final result = await Esewa.i.init(
                    context: context,
                    eSewaConfig: ESewaConfig.dev(
                      // .live for live
                      su: 'https://www.marvel.com/hello',
                      amt: 10,
                      fu: 'https://www.marvel.com/hello',
                      pid: '1212',
                      // scd: dotenv.env['ESEWA_SCD']!
                    ));
                if (result.hasData) {
                  final response = result.data!;
                  setState(() {
                    refId = response.refId!;
                  });
                  if (kDebugMode) {
                    // call your api here
                    print(response.toJson());
                  }
                } else {
                  setState(() {
                    hasError = result.error!;
                  });
                  if (kDebugMode) {
                    print(result.error);
                  }
                }
              },
              child: const Text('Pay with Esewa'),
            ),
            if (refId.isNotEmpty) Text('Payment Success: Ref Id: $refId'),
            if (hasError.isNotEmpty) Text('Payment Failed: Message: $hasError'),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
