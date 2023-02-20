part of esewa_flutter;

class EsewaPaymentResponse {
  EsewaPaymentResponse({
     this.productId,
     this.totalAmount,
     this.refId,
  });

  String? productId;
  String? totalAmount;
  String? refId;

  Map<String, dynamic> toJson() => {
        "oid": productId,
        "amt": totalAmount,
        "refId": refId,
      };

  @override
  String toString() => '''
        "productId": $productId,
        "totalAmount": $totalAmount,
        "refId": $refId,
  ''';
}
