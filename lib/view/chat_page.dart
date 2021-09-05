import 'package:arungi_rasa/env/env.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  const ChatPage();
  @override
  Widget build(BuildContext context) => new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            const SliverAppBar(
              title: const Text("Chat"),
            ),
          ],
          body: new Tawk(
            directChatLink: env.directChatLink,
            visitor: new TawkVisitor(
              name: SessionService.instance.user.value!.displayName,
              email: SessionService.instance.user.value!.email,
            ),
            placeholder: new Center(
                child: new CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
            )),
          ),
        ),
      );
}
