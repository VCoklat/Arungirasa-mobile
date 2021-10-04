part of 'create_order_page.dart';

class _Payment extends GetView<_CreateOrderPageController> {
  const _Payment();
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.payment,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            S.current.uploadPayment,
            style: const TextStyle(fontSize: 14.0),
          ),
          const SizedBox(height: 10),
          InkWell(
            child: Obx(
              () => controller.paymentImage.value == null
                  ? Assets.images.proveOfPaymentUpload.image()
                  : Image.memory(controller.paymentImage.value!),
            ),
            onTap: controller.selectImage,
          ),
          const SizedBox(height: 10),
        ],
      );
}
