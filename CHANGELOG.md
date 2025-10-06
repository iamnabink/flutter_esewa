## 1.0.0
* Initial release of the `esewa_flutter` package.

## 1.0.1
* Updated README.md file with more detailed instructions on how to use the package.

## 1.1.0
* Added `EsewaPayButton` widget for ease of initiating payments.
* Updated README.md file with documentation for `EsewaPayButton` and instructions on how to add a cover image.
* Added example images to the README.md file.
* Minor bug fixes.

## 1.1.1
* Minor bug fixes.
* Updated README.md file, removed un-necessary mentions 

## 1.1.2
* Made minimum `Flutter` SDK requirement 3.
* Example project bug fixes

## 2.0.0
* Migrates to Dart SDK `3.5.3` and Flutter `3.24.3`
* Updated `flutter_inappwebview:^5.7.2+3` to version `^6.1.5` 

## 3.0.0
* Migrate to eSewa v2 form API with server endpoints (RC/Live)
* New configuration model `ESewaConfig.dev/live` with fields:
  - `amount`, `taxAmount`, `productServiceCharge`, `productDeliveryCharge`, `totalAmount`
  - `productCode`, `transactionUuid`, `successUrl`, `failureUrl`, `signedFieldNames`, `secretKey`, `serverUrl`
* HMAC-SHA256 signature generation moved to Dart (no inline HTML)
* WebView now posts `application/x-www-form-urlencoded` directly to v2 endpoint
* Success redirect returns only base64 `data`; plugin surfaces `EsewaPaymentResponse(data)`
* Failure redirect surfaces error message (if present) or a generic message
* Handle completion strictly on redirects to `successUrl` / `failureUrl` and prevent double pops
* Add dependency: `crypto` for HMAC signature
* Breaking changes:
  - Removed legacy params (`scd`, `pid`, `su`, `fu`, `tAmt`, `txAmt`, `psc`, `pdc` names in public API)
  - `EsewaPaymentResponse` now only exposes `data` (base64)
  - Older URL query-style flow replaced with form POST + signature