import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/model/image_with_blur_hash.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

part 'restaurant.banner.dart';
part 'restaurant.info.dart';
part 'menu.card.dart';

class MainPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_MainPageController>( () => new _MainPageController() );
  }
}

class MainPage extends GetView<_MainPageController> {
  const MainPage();
  @override Widget build(BuildContext context) => new Scaffold(
    body: new NestedScrollView(
      headerSliverBuilder: ( _, __ ) => [
        new SliverAppBar(
          centerTitle: true,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          elevation: 0.0,
          title: const _RestaurantSelector(),
          actions: [ const _UserPhotoProfile() ],
        ),
      ],
      body: new Padding(
        padding: const EdgeInsets.symmetric( horizontal: 20.0 ),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox( height: 10, ),
            new _SearchTextField(),
            const SizedBox( height: 20.0, ),
            const _RestaurantBanner(),
            const SizedBox( height: 7.0, ),
            const _RestaurantInfo(),
            const SizedBox( height: 10.0, ),
            new Expanded(
              child: new SingleChildScrollView(
                child: new AnimatedList(
                  key: controller.menuListKey,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: ( _, index, animation ) => new _MenuCard(
                    menu: controller.menuList[index],
                    animation: animation,
                    isInWishList: false,
                    onPressed: (_){},
                    onAddPressed: (_){},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _MainPageController extends GetxController {
  final menuListKey = new GlobalKey<AnimatedListState>();

  final menuList = new RxList<FoodDrinkMenu>();

  Future<void> onSort() async {}

  @override
  void onReady() {
    super.onReady();
    new Future.delayed( Duration.zero, _loadMenu );
  }

  Future<void> _loadMenu() async {
    await new Future.delayed( const Duration( seconds: 2 ) );
    menuList.add( new FoodDrinkMenu(
      id: "1", name: "Sate Ayam", description: "1 Pax isi 10 tusuk",
      imageList: [ new ImageWithBlurHash( "https://firebasestorage.googleapis.com/v0/b/arungi-rasa.appspot.com/o/restaurant%2F1%2Fmenu%2F1%2Fsate.jpg?alt=media&token=9650894a-0fbf-499e-ad6a-c8d846928e44", "LBGkml4p_Jpa1HRR0N.6BOS#+L\$i") ],
      price: 50000,
    ) );
    menuListKey.currentState!.insertItem( 0 );

    await new Future.delayed( const Duration( milliseconds: 50 ) );

    menuList.add( new FoodDrinkMenu(
      id: "2", name: "Bebek Goreng", description: "Bebek yang enak!!!",
      imageList: [ new ImageWithBlurHash( "https://firebasestorage.googleapis.com/v0/b/arungi-rasa.appspot.com/o/restaurant%2F1%2Fmenu%2F1%2Fbebek%20goreng.jpg?alt=media&token=cbb407a2-8f63-46f9-82d8-7f5afddccf28", "UPJ@n0E1~VDit5IoM{tlxvaeIANasDRPWBoe" ) ],
      price: 70000,
    ) );
    menuListKey.currentState!.insertItem( 1 );

    await new Future.delayed( const Duration( milliseconds: 50 ) );

    menuList.add( new FoodDrinkMenu(
      id: "3", name: "Rendang", description: "1 Pax isi 3 potong",
      imageList: [new ImageWithBlurHash( "https://firebasestorage.googleapis.com/v0/b/arungi-rasa.appspot.com/o/restaurant%2F1%2Fmenu%2F1%2Frendang.jpg?alt=media&token=ff851293-461d-44d0-9f33-863ea94e961c", "U%NJXiNH.8sp-=t7RQjb?^n~xakCogV[NFWB")],
      price: 60000,
    ) );
    menuListKey.currentState!.insertItem( 2 );

    await new Future.delayed( const Duration( milliseconds: 50 ) );

    menuList.add( new FoodDrinkMenu(
      id: "4", name: "Gado Gado", description: "Gado gado yang menyegarkan dan enak.",
      imageList: [ new ImageWithBlurHash( "https://firebasestorage.googleapis.com/v0/b/arungi-rasa.appspot.com/o/restaurant%2F1%2Fmenu%2F1%2Fgado-gado.jpg?alt=media&token=e9c02f2d-cd46-4771-bf7b-a30e35cd2fdd", "UGGkzU01SlRh~CNaI;s+9cR%wIxtX9Rkae%0" ) ],
      price: 10000,
    ) );
    menuListKey.currentState!.insertItem( 3 );
  }

}

class _UserPhotoProfile extends StatelessWidget {
  const _UserPhotoProfile();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 40.0,
      height: 60.0,
      child: new Material(
        shape: new ContinuousRectangleBorder(
          borderRadius: const BorderRadius.all( const Radius.circular( 15 ) ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderOnForeground: true,
        child: new ObxValue<Rxn<User>>(
          ( data ) => data.value == null || data.value?.photoURL == null ? Assets.images.placeholderProfile.image(
            fit: BoxFit.cover,
          ) : new Image.network(
            data.value!.photoURL!,
            fit: BoxFit.cover,
          ),
          SessionService.instance.user,
        ),
      ),
    ),
  );
}

class _SearchTextField extends StatelessWidget {
  final ValueChanged<String>? onChange;

  const _SearchTextField({Key? key, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) => new TextField(
    decoration: new InputDecoration(
      labelText: S.current.searchCulinary,
      border: new OutlineInputBorder( borderRadius: const BorderRadius.all( const Radius.circular( 30 ) ) ),
      focusedBorder: new OutlineInputBorder( borderRadius: const BorderRadius.all( const Radius.circular( 30 ) ) ),
      suffixIcon: const Icon( Icons.search ),
    ),
    onChanged: onChange,
  );
}

class ImageContinuousClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return ContinuousRectangleBorder(borderRadius: BorderRadius.circular(200 * 0.625))
        .getOuterPath(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _RestaurantSelector extends GetView<_MainPageController> {
  const _RestaurantSelector();
  @override
  Widget build(BuildContext context) => new Center(
    child: new Container(
      //color: Colors.redAccent,
      //width: 120,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Center(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                new Text(
                  S.current.location,
                  style: const TextStyle( color: Colors.grey, fontSize: 14.0, ),
                ),
                new Icon( Icons.keyboard_arrow_down_sharp, color: Get.theme.primaryColor, size: 30.0, ),
              ],
            ),
          ),
          new Center(
            child: new Text(
              "Bintaro Tangerang",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
