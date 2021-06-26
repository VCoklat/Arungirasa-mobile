import 'package:flutter/foundation.dart';

const MOCK_HTTP_REQUEST = false;

const IGNORE_BAD_CERTIFICATE = true;

const REST_URL_DEV = "http://103.98.104.19:2929";
const REST_URL = "http://103.98.104.19:2828";
const kRestUrl = kReleaseMode ? REST_URL : REST_URL_DEV;

const CARD_ELEVATION = 7.0;

const TABLE_FONT_SIZE = 16.0;

const PHONE_NUMBER_MAX_LENGTH = 15; ///E.164 Standard https://en.wikipedia.org/wiki/E.164

const REST_TIMEOUT = 15000;