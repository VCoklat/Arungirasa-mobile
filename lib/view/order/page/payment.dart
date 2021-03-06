part of 'order_page.dart';

class _OrderPayment extends GetView<_OrderPageController> {
  const _OrderPayment();
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.current.payment,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            S.current.uploadPayment,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            child: Obx(
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
          SizedBox(
            height: 45,
            child: LoadingButton(
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
                  backgroundColor:
                      MaterialStateProperty.all(Get.theme.primaryColor),
                  textStyle: MaterialStateProperty.all(const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ))),
              onPressed: controller.uploadPayment,
            ),
          ),
        ],
      );
}
