import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/const/const.dart';
import 'package:tech/core/const/string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

String formatDate(String rawDate) {
  DateTime dateTime = DateTime.parse(rawDate);

  String formatted = DateFormat("EEE, d MMM yy 'à' HH:mm", 'fr_FR').format(dateTime);
  return formatted;
}