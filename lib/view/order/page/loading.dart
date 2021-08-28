part of 'order_page.dart';

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();
  @override
  Widget build(BuildContext context) => new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Text(
              S.current.pleaseWait,
            ),
            const SizedBox(height: 10),
            new Center(
              child: new CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
              ),
            ),
          ],
        ),
      );
}
