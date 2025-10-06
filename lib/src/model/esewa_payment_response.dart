part of esewa_flutter;

class EsewaPaymentResponse {
  EsewaPaymentResponse({
    this.data,
  });

  /// Base64 encoded payment response data
  String? data;

  Map<String, dynamic> toJson() => {
        "data": data,
      };

  @override
  String toString() => '''
        "data": $data,
  ''';
}
