part of 'create_order_page.dart';

class _CreateButton extends GetView<_CreateOrderPageController> {
  const _CreateButton();
  @override
  Widget build(BuildContext context) => LoadingButton(
        child: Text(S.current.processTransaction),
        successChild: const Icon(
          Icons.check_sharp,
          size: 35,
          color: Colors.white,
        ),
        errorChild: const Icon(
          Icons.close_sharp,
          size: 35,
          color: Colors.white,
        ),
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            ),
            backgroundColor: MaterialStateProperty.all(Get.theme.accentColor),
            textStyle: MaterialStateProperty.all(const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ))),
        onPressed: controller.createOrder,
      );
}
