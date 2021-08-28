part of 'order_page.dart';

class _NotFoundWidget extends StatelessWidget {
  const _NotFoundWidget();
  @override
  Widget build(BuildContext context) => new Center(
        child: new Text(
          S.current.orderWasNotFound,
        ),
      );
}
