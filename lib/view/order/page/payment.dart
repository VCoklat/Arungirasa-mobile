part of 'order_page.dart';

class _OrderPayment extends GetView<_OrderPageController> {
  const _OrderPayment();
  @override
  Widget build(BuildContext context) => new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          new Text(
            S.current.payment,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          new Text(
            S.current.uploadPayment,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 10),
          new InkWell(
            child: new Obx(
              () => controller.paymentImage.value == null
                  ? Assets.images.proveOfPaymentUpload.image(
                      height: 135,
                      width: Get.width - 40,
                      fit: BoxFit.fill,
                    )
                  : Image.memory(
                      controller.paymentImage.value!,
                      height: 135,
                      width: Get.width - 40,
                      fit: BoxFit.fitWidth,
                    ),
            ),
            onTap: controller.selectImage,
          ),
          const SizedBox(height: 10),
          new LoadingButton(
            child: new Text(S.current.processTransaction),
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
            style: new ButtonStyle(
                shape: MaterialStateProperty.all(
                  new RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(30))),
                ),
                backgroundColor:
                    MaterialStateProperty.all(Get.theme.accentColor),
                textStyle: MaterialStateProperty.all(const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ))),
            onPressed: controller.uploadPayment,
          ),
        ],
      );
}
