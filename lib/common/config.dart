import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
