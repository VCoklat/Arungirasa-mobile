part of 'order_page.dart';

class _ErrorWidget extends StatelessWidget {
  final VoidCallback onRefresh;
  const _ErrorWidget(this.onRefresh);
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.current.errorOccurred),
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(Icons.refresh_sharp),
              color: Get.theme.primaryColor,
              iconSize: 48.0,
              onPressed: onRefresh,
            ),
          ],
        ),
      );
}
