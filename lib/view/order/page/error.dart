part of 'order_page.dart';

class _ErrorWidget extends StatelessWidget {
  final VoidCallback onRefresh;
  const _ErrorWidget(this.onRefresh);
  @override
  Widget build(BuildContext context) => new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Text(
              S.current.errorOccurred,
            ),
            const SizedBox(height: 10),
            new IconButton(
              icon: const Icon(Icons.refresh_sharp),
              color: Get.theme.primaryColor,
              iconSize: 48.0,
              onPressed: onRefresh,
            ),
          ],
        ),
      );
}
