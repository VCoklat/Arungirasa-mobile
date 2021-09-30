import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/address.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/address_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressListPage extends GetView<AddressService> {
  const AddressListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Get.toNamed(Routes.addAddress),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            SliverAppBar(title: Text(S.current.savedAddresses)),
          ],
          body: Obx(
            () => ListView.separated(
              itemCount: controller.itemList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, final int index) =>
                  _AddressTile(address: controller.itemList[index]),
            ),
          ),
        ),
      );
}

class _AddressTile extends StatelessWidget {
  final Address address;

  const _AddressTile({Key? key, required this.address}) : super(key: key);
  @override
  Widget build(BuildContext context) => ListTile(
        leading: const Icon(Icons.location_pin),
        title: Text(address.name),
        subtitle:
            _AddressSubtitle(future: Helper.latLngToString(address.latLng)),
        onTap: () => Get.toNamed(Routes.addAddress, arguments: address),
      );
}

class _AddressSubtitle extends StatelessWidget {
  final Future<String> future;

  const _AddressSubtitle({Key? key, required this.future}) : super(key: key);
  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
        future: future,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data ?? S.current.noData);
          } else if (snapshot.hasError) {
            return Text(S.current.errorOccurred);
          } else {
            return Text(S.current.pleaseWait);
          }
        },
      );
}
