part of 'create_order_page.dart';

class _CartCard extends StatelessWidget {
  final Rx<Cart> cart;
  final Rx<String> note;
  const _CartCard({
    Key? key,
    required this.cart,
    required this.note,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (_, constraints) => SizedBox(
              height: constraints.maxWidth * 0.4,
              child: Row(
                children: [
                  _getImage(constraints.maxWidth * 0.4),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _title,
                        _totalText,
                        _stockModifier,
                        _noteWidget,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5.0),
        ],
      );

  Widget get _noteWidget => Expanded(
        child: TextFormField(
          decoration: InputDecoration(labelText: S.current.note),
          maxLines: 1,
          onChanged: (final text) => note.value = text,
        ),
      );

  Widget get _stockModifier => Flexible(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_sharp),
              padding: EdgeInsets.zero,
              iconSize: 28,
              onPressed: () =>
                  CartService.instance.subtractCart(cart.value.menu),
            ),
            const SizedBox(width: 5),
            ObxValue<Rx<Cart>>(
              (obs) => Text(
                obs.value.qty.toString(),
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              cart,
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.add_sharp),
              padding: EdgeInsets.zero,
              iconSize: 28,
              onPressed: () => CartService.instance.addCart(cart.value.menu),
            ),
          ],
        ),
      );

  Widget get _totalText => ObxValue<Rx<Cart>>(
        (obs) => Text(
          Helper.formatMoney((obs.value.qty * obs.value.price).toDouble()),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: kPriceColor,
          ),
        ),
        cart,
      );

  Widget get _title => Text(
        cart.value.menu.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Get.theme.primaryColor,
          fontSize: 18.0,
          wordSpacing: 2.5,
        ),
      );

  Widget _getImage(final double size) => SizedBox(
        width: size,
        height: size,
        child: Material(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: OctoImage(
            image:
                CachedNetworkImageProvider(cart.value.menu.imageList.first.url),
            placeholderBuilder: OctoPlaceholder.blurHash(
                cart.value.menu.imageList.first.blurhash),
            errorBuilder:
                OctoError.blurHash(cart.value.menu.imageList.first.blurhash),
            fit: BoxFit.cover,
          ),
        ),
      );
}
