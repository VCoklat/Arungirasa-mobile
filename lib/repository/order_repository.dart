import 'dart:convert';

import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/order.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

class OrderRepository extends GetConnect
    with
        RepositorySslHandlerMixin,
        RepositoryErrorHandlerMixin,
        RepositoryAuthHandlerMixin {
  static OrderRepository get instance => Get.find<OrderRepository>();
  Future<Order> create({
    required final String addressId,
    required final String addressDetail,
    required final Map<String, String> note,
  }) async {
    final response = await post("$kRestUrl/order", {
      "address": addressId,
      "addressDetail": addressDetail,
      "note": "${json.encode(note)}",
    });
    if (response.isOk) {
      return Order.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  Future<List<Order>> find({final OrderStatus? status}) async {
    final query = new Map<String, dynamic>();
    if (status != null) query["status"] = orderStatusValues.reverse[status];
    final response = await get("$kRestUrl/order", query: query);
    if (response.isOk) {
      return (response.body as List)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } else {
      throw getException(response);
    }
  }

  Future<Order> findOne(final String id) async {
    final response = await get("$kRestUrl/order/$id");
    if (response.isOk) {
      return Order.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  @override
  List<int> get certificate => [];

  @override
  Future<String> get accessToken async =>
      "Bearer ${await SessionService.instance.accessToken}";
}
