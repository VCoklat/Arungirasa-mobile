import 'dart:typed_data';

import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/payment.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';
import 'package:uuid/uuid.dart';

import 'mixin_repository_config.dart';

class PaymentRepository extends GetConnect
    with
        RepositoryConfigMixin,
        RepositorySslHandlerMixin,
        RepositoryErrorHandlerMixin,
        RepositoryAuthHandlerMixin {
  static PaymentRepository get instance => Get.find<PaymentRepository>();
  Future<Payment> create({
    required final String orderId,
    required final Uint8List image,
  }) async {
    final response = await post(
        "$kRestUrl/payment/photo",
        new FormData({
          "orderId": orderId,
          "image": new MultipartFile(image, filename: new Uuid().v4()),
        }));
    if (response.isOk) {
      return Payment.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  @override
  List<int> get certificate => [];

  @override
  Future<String> get accessToken async =>
      "Bearer ${await SessionService.instance.accessToken}";

  @override
  void onInit() {
    timeout = const Duration(minutes: 1);
    super.onInit();
  }
}
