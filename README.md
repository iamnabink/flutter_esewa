# eSewa Flutter

[![Pub Version](https://img.shields.io/pub/v/esewa_flutter.svg)](https://pub.dev/packages/esewa_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter plugin for integrating eSewa payment gateway into your Flutter app.

# Usage

1. Add `esewa_flutter` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  esewa_flutter: ^1.0.0
```

2. Import the package in your Dart code:

```import 'package:esewa_flutter/esewa_flutter.dart';```

3. Create an instance of `ESewaConfig` with your payment information:

The ESewaConfig class holds the configuration details for the payment gateway. Pass an instance of ESewaConfig to the init() method of the Esewa class to initiate the payment process.
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

After the payment is completed or cancelled by the user, the plugin returns an instance of EsewaPaymentResult. If the payment was successful, hasData will be true and you can access the EsewaPaymentResponse object using data. If the payment was unsuccessful, hasError will be true and you can access the error message using error.

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

`ESewaConfig` supports both dev and live mode. For live mode, use the `ESewaConfig.live()` constructor, and for dev mode, use the `ESewaConfig.dev()` constructor. Here's an example of using the dev mode:

```
final config = ESewaConfig.dev(
  amt: 100,
  pid: 'product_id',
  su: 'https://success.com.np',
  fu: 'https://failure.com.np',
);
```

# API

### Class: ESewaConfig

The `ESewaConfig` class is used to configure the eSewa payment gateway for either live or dev mode. It has two constructors:

- `ESewaConfig.live()`: used for live mode configuration. It requires `amt`, `scd`, `pid`, `su`, and `fu` parameters, and optionally `txAmt`, `psc`, and `pdc` parameters. The `serverUrl` parameter is set to the eSewa live URL by default.

- `ESewaConfig.dev()`: used for dev mode configuration. It requires `amt`, `scd`, `pid`, `su`, and `fu` parameters, and optionally `txAmt`, `psc`, and `pdc` parameters. The `serverUrl` parameter is set to the eSewa dev URL by default.


### Properties
- `serverUrl` (required): URL of the eSewa payment gateway. Use https://esewa.com.np/epay/main for live environment, and https://uat.esewa.com.np/epay/main for development environment.
- `amt` (required): Amount of the payment.
- `scd` (required): Merchant code provided by eSewa.
- `pid` (required): A unique ID of the product or item or ticket etc.
- `su` (required): Success URL: a redirect URL of merchant application where customer will be redirected after SUCCESSFUL transaction.
- `fu` (required): Failure URL: a redirect URL of merchant application where customer will be redirected after FAILURE or PENDING transaction.
- `tAmt` (optional): Total payment amount including tax, service and deliver charge. Default value is amt + pdc, where pdc is 0.
- `txAmt` (optional): Tax amount on product or item or ticket etc. Default value is 0.
- `psc` (optional): Service charge by merchant on product or item or ticket etc. Default value is 0.
- `pdc` (optional): Delivery charge by merchant on product or item or ticket etc. Default value is 0.

### Class: EsewaPaymentResult
Class representing the result of a payment transaction.

### Properties
- `data`: The payment response data, if the payment was successful. Null otherwise.
- `error`: The error message, if the payment failed or was cancelled. Null otherwise.
- `hasData`: A boolean indicating whether the payment was successful and contains a non-null data property.
- `hasError`: A boolean indicating whether the payment failed or was cancelled and contains a non-null error property.

### Class: Esewa
Class providing the main interface for the eSewa payment integration.

### Methods
- `init(BuildContext context, ESewaConfig e)`: Initializes the eSewa payment gateway with the given configuration.

## Dev Testing Information
If you want to test eSewa payment integration in development environment, you can use the following information:

- `ESEWA_SCD`: Your Merchant code provided by eSewa. You can use `EPAYTEST` for testing purposes.
- `ESEWA_URL`: The URL of the eSewa payment gateway. Use `https://uat.esewa.com.np/epay/main?` for development environment.
- Test eSewa IDs: You can use any of the following test eSewa IDs for testing purposes:
    - 9806800001
    - 9806800002
    - 9806800003
    - 9806800004
    - 9806800005
- Password: Nepal@123
- OTP: 123456

# License
This plugin is released under the MIT License. See LICENSE for details.

## Contributions

Contributions are welcome! Feel free to open an issue or submit a pull request on [Github](https://github.com/iamnabink/flutter_esewa/issues)..

## Contact

If you have any questions or suggestions, feel free to [contact me on LinkedIn](https://www.linkedin.com/in/iamnabink/).




