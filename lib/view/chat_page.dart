import 'package:arungi_rasa/env/env.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            const SliverAppBar(title: Text("Chat")),
          ],
          body: Tawk(
            directChatLink: env.directChatLink,
            visitor: TawkVisitor(
              name: SessionService.instance.user.value!.displayName,
              email: SessionService.instance.user.value!.email,
            ),
            placeholder: Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
            )),
          ),
        ),
      );
}
