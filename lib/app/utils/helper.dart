import 'dart:convert' show utf8;
import 'dart:convert';

import 'package:intl/intl.dart';

String decodedUtf8(String text) {
  try {
    return utf8.decode(text.runes.toList()).toString();
  } catch (e) {
    return text;
  }
}

String formatDateString(String dateStr) {
  DateTime dateTime = DateTime.parse(dateStr).toLocal();

  var formatter = DateFormat("dd MMM yyyy \nhh:mm a", "es_ES");

  return formatter.format(dateTime);
}
