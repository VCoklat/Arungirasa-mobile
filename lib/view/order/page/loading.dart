part of 'order_page.dart';

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.current.pleaseWait),
            const SizedBox(height: 10),
            Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
              ),
            ),
          ],
        ),
      );
}
