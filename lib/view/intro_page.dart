import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/fonts.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';

class IntroPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_IntroPageController>( () => new _IntroPageController() );
  }
}

class IntroPage extends GetView<_IntroPageController> {
  const IntroPage();
  @override Widget build(BuildContext context) => new Scaffold(
    body: new PageView.builder(
      controller: controller.pageController,
      itemCount: controller.items.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: ( _, final int index ) => new Container(
        color: controller.items[index].backgroundColor,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            new Image.asset(
              controller.items[index].imagePath,
              width: Get.width,
              height: Get.height / 2,
              fit: BoxFit.fill,
            ),
            const SizedBox( height: 20.0, ),
            new Padding(
              padding: const EdgeInsets.symmetric( horizontal: 40.0 ),
              child: new Text(
                controller.items[index].title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: new TextStyle(
                  color: controller.items[index].titleColor,
                  fontSize: 38.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.monetaSans,
                ),
              ),
            ),
            const SizedBox( height: 10.0, ),
            new Expanded(
              child: new Center(
                child: new Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 20.0 ),
                  child: new Text(
                    controller.items[index].content,
                    textAlign: TextAlign.center,
                    maxLines: 6,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.symmetric( horizontal: 10.0 ),
              child: new Row(
                children: [
                  new TextButton(
                    child: new Text( S.current.skip, ),
                    style: new ButtonStyle(
                      foregroundColor: MaterialStateProperty.all( Colors.white ),
                      textStyle: MaterialStateProperty.all( const TextStyle(
                        fontWeight: FontWeight.bold,
                      ) ),
                    ),
                    onPressed: controller.onSkip,
                  ),
                  new Expanded(
                    child: new Center(
                      child: new Obx(
                        () => new DotStepper(
                          activeStep: controller.index.value,
                          dotCount: controller.items.length,
                          dotRadius: 12.0,
                          shape: Shape.circle,
                          spacing: 10.0,
                          indicator: Indicator.magnify,
                          onDotTapped: controller.goToPage,
                          fixedDotDecoration: const FixedDotDecoration(
                            color: Colors.white,
                          ),
                          indicatorDecoration: const IndicatorDecoration(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  new TextButton(
                    child: new Text( S.current.next, ),
                    style: new ButtonStyle(
                      foregroundColor: MaterialStateProperty.all( Colors.white ),
                      textStyle: MaterialStateProperty.all( const TextStyle(
                        fontWeight: FontWeight.bold,
                      ) ),
                    ),
                    onPressed: controller.onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _IntroItem {
  final String imagePath;
  final String title;
  final String content;
  final Color backgroundColor;
  final Color titleColor;
  _IntroItem({
    required this.imagePath,
    required this.title,
    required this.content,
    required this.backgroundColor,
    required this.titleColor,
  });
}

class _IntroPageController extends GetxController {
  late PageController pageController;

  final index = new RxInt( 0 );
  final items = new RxList([
    new _IntroItem(
      imagePath: Assets.images.intro1.path,
      title: "Pempek Khas Palembang",
      content: "Pempek disajikan dengan kuah lezat berwarna coklat yang kental yang memadukan rasa pedas, manis, dan seikit asam atau tidak terlalu menyengat di mulut dan lidah.",
      backgroundColor: const Color( 0xFF12676D ),
      titleColor: Colors.yellow,
    ),
    new _IntroItem(
      imagePath: Assets.images.intro2.path,
      title: "Gudeg Khas Yogyakarta",
      content: "Gudeg telah dikenal oleh masyarakat Indonesia khususnya sebagai makanan khas dari kota Pelajar.",
      backgroundColor: const Color( 0xFFC1272D ),
      titleColor: Colors.white,
    ),
  ]);

  bool onPageChange = false;

  @override
  void onInit() {
    pageController = new PageController();
    pageController.addListener( _onPageIndexChanged );
    super.onInit();
  }

  @override
  void onClose() {
    pageController.removeListener( _onPageIndexChanged );
    pageController.dispose();
    super.onClose();
  }

  void onSkip() {
    SessionService.instance.setHasViewIntro();
    SessionService.instance.navigate();
  }

  void goToPage( final int index ) {
    if ( onPageChange ) return;
    if ( index < 0 || index >= items.length ) return;
    try {
      onPageChange = true;
      pageController.animateToPage( index, duration: const Duration( milliseconds: 500 ), curve: Curves.bounceInOut );
    } finally {
      new Future.delayed( const Duration( milliseconds: 500 ), () => onPageChange = false );
    }
  }
  
  void onNext() {
    if ( index.value < items.length - 1 )
      pageController.nextPage( duration: const Duration( milliseconds: 500 ), curve: Curves.bounceInOut );
    else
      onSkip();
  }
  
  void _onPageIndexChanged() => index.value = pageController.page?.toInt() ?? 0;
}
