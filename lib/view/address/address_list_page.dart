import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/address.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/address_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressListPage extends GetView<AddressService> {
  const AddressListPage();
  @override
  Widget build(BuildContext context) => new Scaffold(
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () => Get.toNamed(Routes.addAddress),
        ),
        body: new NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            new SliverAppBar(title: new Text(S.current.savedAddresses)),
          ],
          body: new Obx(
            () => new ListView.separated(
              itemCount: controller.itemList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, final int index) =>
                  new _AddressTile(address: controller.itemList[index]),
            ),
          ),
        ),
      );
}

class _AddressTile extends StatelessWidget {
  final Address address;

  const _AddressTile({Key? key, required this.address}) : super(key: key);
  @override
  Widget build(BuildContext context) => new ListTile(
        leading: const Icon(Icons.location_pin),
        title: new Text(address.name),
        subtitle:
            new _AddressSubtitle(future: Helper.latLngToString(address.latLng)),
      );
}

class _AddressSubtitle extends StatelessWidget {
  final Future<String> future;

  const _AddressSubtitle({Key? key, required this.future}) : super(key: key);
  @override
  Widget build(BuildContext context) => new FutureBuilder<String>(
        future: future,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return new Text(snapshot.data ?? S.current.noData);
          } else if (snapshot.hasError) {
            return new Text(S.current.errorOccurred);
          } else {
            return new Text(S.current.pleaseWait);
          }
        },
      );
}
