import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage();
  @override
  Widget build(BuildContext context) => new Scaffold(
        body: new SafeArea(
          child: new ListView(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            children: [
              const _ProfileWidget(),
              new _ProfileListTile(
                text: S.current.savedAddresses,
                onPressed: () => Get.toNamed(Routes.address),
              ),
            ],
          ),
        ),
      );
}

class _ProfileListTile extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _ProfileListTile({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => new ListTile(
        title: new Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_sharp,
          size: 30,
        ),
        onTap: onPressed,
      );
}

class _ProfileWidget extends StatelessWidget {
  const _ProfileWidget();
  @override
  Widget build(BuildContext context) => new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PhotoProfile(),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const _UserDisplayName(),
              const SizedBox(height: 5),
              _editProfileButton,
            ],
          ),
        ],
      );

  Widget get _editProfileButton => new InkWell(
        child: new Row(
          children: [
            new Text(
              S.current.editProfile,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.chevron_right_sharp,
              color: Colors.grey,
            ),
          ],
        ),
      );
}

class _UserDisplayName extends GetView<SessionService> {
  const _UserDisplayName();
  @override
  Widget build(BuildContext context) => new Obx(
        () => new Text(
          controller.user.value?.displayName ?? "Arungi Rasa",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      );
}

class _PhotoProfile extends GetView<SessionService> {
  const _PhotoProfile();
  @override
  Widget build(BuildContext context) => new Obx(
        () => controller.user.value!.photoURL == null ||
                controller.user.value!.photoURL!.isEmpty
            ? const Icon(
                Icons.account_circle_outlined,
                size: 100,
              )
            : new CachedNetworkImage(
                imageUrl: controller.user.value!.photoURL!,
              ),
      );
}
