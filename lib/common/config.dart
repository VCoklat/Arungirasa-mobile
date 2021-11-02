import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kIgnoreBadCertificate = true;

const _kRestUrlDev = "http://103.98.104.19:2929";
const _kRestUrl = "http://103.98.104.19:2828";
const kRestUrl = kReleaseMode ? _kRestUrl : _kRestUrlDev;

const kCardElevation = 7.0;

const kTableFontSize = 16.0;

const kPhoneNumberMaxLength = 15;

///E.164 Standard https://en.wikipedia.org/wiki/E.164

const kRestTimeout = 15000;

const kPriceColor = Color(0XFFF7931E);

///default lat lng Monas Indonesia
const kDefaultLatitude = -6.1754137242424445;
const kDefaultLongitude = 106.82715279991743;

const kItemPerPage = 10;

const kPagePaddingHorizontoal = 20.0;
const kPagePaddingVertical = 10.0;

const kSecondaryButtonHeight = 30.0;

const kPagePadding = EdgeInsets.symmetric(
    horizontal: kPagePaddingHorizontoal, vertical: kPagePaddingVertical);

double get secondaryButtonSize =>
    (Get.width - (kPagePaddingHorizontoal * 2)) / 3;

final seondaryButtonStyle = ButtonStyle(
    padding:
        MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 5.0)),
    backgroundColor: MaterialStateProperty.all(Colors.white),
    shape: MaterialStateProperty.all(const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
    side: MaterialStateProperty.all(BorderSide(color: Get.theme.primaryColor)),
    foregroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
    textStyle: MaterialStateProperty.all(const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    )));
