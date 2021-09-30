import 'package:arungi_rasa/common/enum.dart';
import 'package:json_annotation/json_annotation.dart';

import 'image_with_blur_hash.dart';

part 'payment.g.dart';

enum PaymentType {
  photo,
  creditCard,
  gopay,
  qris,
  shopeepay,
  bankTransfer,
  mandiriBill01,
  bcaKlikpay,
  bcaKlikbca,
  cimbClicks,
  danamonOnline01,
  cstore,
  akulaku,
  bripay,
}

final _paymentTypeValues = EnumValues<String, PaymentType>({
  "photo": PaymentType.photo,
  "credit_card": PaymentType.creditCard,
  "gopay": PaymentType.gopay,
  "qris": PaymentType.qris,
  "shopeepay": PaymentType.shopeepay,
  "bank_transfer": PaymentType.bankTransfer,
  "mandiri-bill-01": PaymentType.mandiriBill01,
  "bca_klikpay": PaymentType.bcaKlikpay,
  "bca_klikbca": PaymentType.bcaKlikbca,
  "cimb_clicks": PaymentType.cimbClicks,
  "danamon-online-01": PaymentType.danamonOnline01,
  "cstore": PaymentType.cstore,
  "akulaku": PaymentType.akulaku,
  "bri_epay": PaymentType.bripay,
});

PaymentType _paymentTypeFromJson(final String type) =>
    _paymentTypeValues.map[type]!;
String _paymentTypeToJson(final PaymentType type) =>
    _paymentTypeValues.reverse[type]!;

enum PaymentStatus {
  authorize,
  partialRefund,
  refund,
  expire,
  cancel,
  deny,
  pending,
  settlement,
  capture,
}

final _paymentStatusValues = EnumValues<String, PaymentStatus>({
  "authorize": PaymentStatus.authorize,
  "partial_refund": PaymentStatus.partialRefund,
  "refund": PaymentStatus.refund,
  "expire": PaymentStatus.expire,
  "cancel": PaymentStatus.cancel,
  "deny": PaymentStatus.deny,
  "pending": PaymentStatus.pending,
  "settlement": PaymentStatus.settlement,
  "capture": PaymentStatus.capture,
});

PaymentStatus _paymentStatusFromJson(final String type) =>
    _paymentStatusValues.map[type]!;
String _paymentStatusToJson(final PaymentStatus type) =>
    _paymentStatusValues.reverse[type]!;

enum FraudStatus {
  accept,
  deny,
  challenge,
}
final _fraudStatusValues = EnumValues<String, FraudStatus>({
  "accept": FraudStatus.accept,
  "deny": FraudStatus.deny,
  "challenge": FraudStatus.challenge,
});

FraudStatus _fraudStatusFromJson(final String type) =>
    _fraudStatusValues.map[type]!;
String _fraudStatusToJson(final FraudStatus type) =>
    _fraudStatusValues.reverse[type]!;

@JsonSerializable(createToJson: false)
class Payment {
  @JsonKey(required: true, disallowNullValue: true)
  final String id;

  @JsonKey(
    required: true,
    disallowNullValue: true,
    fromJson: _paymentStatusFromJson,
    toJson: _paymentStatusToJson,
  )
  final PaymentStatus status;

  @JsonKey(
    required: true,
    disallowNullValue: true,
    fromJson: _fraudStatusFromJson,
    toJson: _fraudStatusToJson,
  )
  final FraudStatus fraudStatus;

  @JsonKey(
    required: true,
    disallowNullValue: true,
    fromJson: _paymentTypeFromJson,
    toJson: _paymentTypeToJson,
  )
  final PaymentType type;

  @JsonKey(required: true, disallowNullValue: true)
  final List<ImageWithBlurHash> imageList;

  @JsonKey(required: true, disallowNullValue: true)
  final DateTime createAt;

  Payment(
    this.id,
    this.status,
    this.fraudStatus,
    this.type,
    this.imageList,
    this.createAt,
  );

  factory Payment.fromJson(final Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}
