part of esewa_flutter;
// Extension method to convert a double to a string with the specified number of decimal places
extension ExtensionOnDouble on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}