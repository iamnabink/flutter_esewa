# eSewa Flutter [![Share on Twitter](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Flutter%20EsewaPayment%20plugin!&url=https://github.com/iamnabink/flutter_esewa&hashtags=flutter,flutterio,dart,wallet,esewa,paymentgateway) [![Share on Facebook](https://img.shields.io/badge/share-facebook-blue.svg?longCache=true&style=flat&colorB=%234267b2)](https://www.facebook.com/sharer/sharer.php?u=https%3A//github.com/iamnabink/flutter_esewa)

[![Pub Version](https://img.shields.io/pub/v/esewa_flutter.svg)](https://pub.dev/packages/esewa_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An un-official Flutter plugin for eSewa Payment Gateway. With this plugin, you can easily integrate
eSewa Payment Gateway into your Flutter app and start accepting payments from your customers.
Whether you're building an eCommerce app or any other type of app that requires payments, this
plugin makes the integration process simple and straightforward.

![Cover Image](https://github.com/iamnabink/flutter_esewa/raw/main/screenshots/cover.png)

# Note
This package doesn't use any plugin or native APIs for payment initialization. Instead, it is based on the Flutter InAppWebView package. A shoutout to the developer of [InAppWebView](https://pub.dev/packages/flutter_inappwebview) package for providing such a useful package.

## Features

- Easy integration
- No complex setup
- Pure Dart code
- Simple to use

## Requirements

* Android: `minSdkVersion 19` and add support for `androidx` (see [AndroidX Migration](https://flutter.dev/docs/development/androidx-migration))
* iOS: `--ios-language swift`, Xcode version `>= 11`

## Setup

| Platform | Configuration                                                                                                                                                                   |
|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| iOS      | No Configuration Needed. For more info, [see here](https://pub.dev/packages/flutter_inappwebview#important-note-for-ios)                                                        |
| Android  | Set `minSdkVersion` of your `android/app/build.gradle` file to at least 19. For more info, [see here](https://pub.dev/packages/flutter_inappwebview#important-note-for-android) |

# Usage

1. Add `esewa_flutter` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  esewa_flutter: ^1.0.0
```

2. Import the package in your Dart code:

```import 'package:esewa_flutter/esewa_flutter.dart';```

3. Create an instance of `ESewaConfig` with your payment information:

The ESewaConfig class holds the configuration details for the payment gateway. Pass an instance of
ESewaConfig to the init() method of the Esewa class to initiate the payment process.

```
final config = ESewaConfig.live(
  amt: 100,
  scd: 'merchant_id',
  pid: 'product_id',
  su: 'https://success.com.np',
  fu: 'https://failure.com.np',
);

```

4. Initialize the payment by calling `Esewa.init()` method:

```
final result = await Esewa.i.init(
  context: context,
  eSewaConfig: config,
);
```

5. Check the payment result:

After the payment is completed or cancelled by the user, the plugin returns an instance of
EsewaPaymentResult. If the payment was successful, hasData will be true and you can access the
EsewaPaymentResponse object using data. If the payment was unsuccessful, hasError will be true and
you can access the error message using error.

```
if (result.hasData) {
  // Payment successful
  final response = result.data!;
  print('Payment successful. Ref ID: ${response.refId}');
} else {
  // Payment failed or cancelled
  final error = result.error!;
  print('Payment failed or cancelled. Error: $error');
}
```

# Dev/Live Mode

`ESewaConfig` supports both dev and live mode. For live mode, use the `ESewaConfig.live()`
constructor, and for dev mode, use the `ESewaConfig.dev()` constructor. Here's an example of using
the dev mode:

```
final config = ESewaConfig.dev(
  amt: 100,
  pid: 'product_id',
  su: 'https://success.com.np',
  fu: 'https://failure.com.np',
);
```

# APIs

## Class : Esewa

The `Esewa` provides a way to initialize Esewa payment using a custom button or a custom UI.
Here's an example:

### Methods

 ```
 init({required BuildContext context,required ESewaConfig eSewaConfig,EsewaPageContent? pageContents})
 ```
: Initializes the eSewa payment gateway with the given configuration

Initializes payment method

```dart

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
```

## Class : EsewaPageContent

The `EsewaPageContent` class provides options for customizing the Esewa payment screen. You can
add an app bar and a custom loader to the payment screen. Here's an example:

```
EsewaPageContent(
  appBar: AppBar(
    title: Text('Esewa Payment'),
  ),
  progressLoader: CircularProgressIndicator(),
);

```

## Class: ESewaConfig

The `ESewaConfig` class is used to configure the eSewa payment gateway for either live or dev mode.
It has two constructors:

- `ESewaConfig.live()`: used for live mode configuration. It requires `amt`, `scd`, `pid`, `su`,
  and `fu` parameters, and optionally `txAmt`, `psc`, and `pdc` parameters. The `serverUrl`
  parameter is set to the eSewa live URL by default.

- `ESewaConfig.dev()`: used for dev mode configuration. It requires `amt`, `scd`, `pid`, `su`,
  and `fu` parameters, and optionally `txAmt`, `psc`, and `pdc` parameters. The `serverUrl`
  parameter is set to the eSewa dev URL by default.

### Properties

- `serverUrl` (required): URL of the eSewa payment gateway. Use https://esewa.com.np/epay/main for
  live environment, and https://uat.esewa.com.np/epay/main for development environment.
- `amt` (required): Amount of the payment.
- `scd` (required): Merchant code provided by eSewa.
- `pid` (required): A unique ID of the product or item or ticket etc.
- `su` (required): Success URL: a redirect URL of merchant application where customer will be
  redirected after SUCCESSFUL transaction.
- `fu` (required): Failure URL: a redirect URL of merchant application where customer will be
  redirected after FAILURE or PENDING transaction.
- `tAmt` (optional): Total payment amount including tax, service and deliver charge. Default value
  is amt + pdc, where pdc is 0.
- `txAmt` (optional): Tax amount on product or item or ticket etc. Default value is 0.
- `psc` (optional): Service charge by merchant on product or item or ticket etc. Default value is 0.
- `pdc` (optional): Delivery charge by merchant on product or item or ticket etc. Default value is
    0.

## Class: EsewaPaymentResult

Class representing the result of a payment transaction.

### Properties

- `data`: The payment response data, if the payment was successful. Null otherwise.
- `error`: The error message, if the payment failed or was cancelled. Null otherwise.
- `hasData`: A boolean indicating whether the payment was successful and contains a non-null data
  property.
- `hasError`: A boolean indicating whether the payment failed or was cancelled and contains a
  non-null error property.


### Class: EsewaPayButton

The EsewaPayButton is a customizable button widget that allows users to initiate the payment process
for the eSewa Payment Gateway. The button can be easily integrated into your Flutter app by calling
the EsewaPayButton constructor and passing the required parameters.

Here is an example of how to use the EsewaPayButton widget:

```
EsewaPayButton(
  paymentConfig: ESewaConfig.dev(
    su: 'https://www.marvel.com/hello',
    amt: 10,
    fu: 'https://www.marvel.com/hello',
    pid: '1212',
  ),
  width: 40,
  onFailure: (result) async {
    // handle failure scenario here
  },
  onSuccess: (result) async {
    // handle success scenario here
  },
),

```

With `EsewaPayButton`, the integration of eSewa Payment Gateway becomes even easier, as the payment
process can be initiated with just a single button press.

### Properties

The `EsewaPayButton` widget has the following parameters:

- `width`: The width of the button (default is `double.infinity`).
- `height`: The height of the button (default is `40.0`).
- `color`: The background color of the button (default is the primary color of the app).
- `borderColor`: The border color of the button (default is the primary color of the app).
- `onSuccess`: The callback function that is called when the payment is successful.
- `onFailure`: The callback function that is called when the payment fails.
- `paymentConfig`: The eSewa payment configuration object that is required to initialize the payment
  screen.
- `radius`: The border radius of the button (default is `4`).
- `widget`: An optional widget to be placed instead of the title text field. If the user wants to
  place a row with the eSewa icon or different widget.
- `title`: The title of the button (default is "Pay with Esewa").
- `textStyle`: The text style of the button title.

## Dev Testing Information

If you want to test eSewa payment integration in development environment, you can use the following
information:

- `ESEWA_SCD`: Your Merchant code provided by eSewa. You can use `EPAYTEST` for testing purposes.
- `ESEWA_URL`: The URL of the eSewa payment gateway. Use `https://uat.esewa.com.np/epay/main?` for
  development environment.
- Test eSewa IDs: You can use any of the following test eSewa IDs for testing purposes:
    - 9806800001
    - 9806800002
    - 9806800003
    - 9806800004
    - 9806800005
- Password: Nepal@123
- OTP: 123456

## Screenshots

Here are some screenshots of the eSewa Payment Gateway integrated into a ecommerce Flutter app:

<table>
  <tr>
    <td><img src="https://github.com/iamnabink/flutter_esewa/raw/main/screenshots/order_screen.png" alt="Example Order Screen" width="400"/></td>
    <td><img src="https://github.com/iamnabink/flutter_esewa/raw/main/screenshots/payment_screen.png" alt="Payment Screen" width="400"/></td>
  </tr>
</table>

## Run the example app

- Navigate to the example folder `cd example`
- Install the dependencies
    - `flutter pub get`
- Set up configuration `ESewaConfig.live()` or directly run with just `ESewaConfig.dev()` in dev
  mode
- Start the example
    - Terminal : `flutter run`

# License

This plugin is released under the MIT License. See LICENSE for details.

## Contributions

Contributions are welcome! To make this project better, Feel free to open an issue or submit a pull
request on [Github](https://github.com/iamnabink/flutter_esewa/issues)..

## Contact

If you have any questions or suggestions, feel free
to [contact me on LinkedIn](https://www.linkedin.com/in/iamnabink/).




