import 'package:flutter/material.dart';
import '../const/const.dart';
import '../services/dio_service.dart';

class ChatProvider with ChangeNotifier {
  final DioService _dioService = DioService(baseUrl: ConstData.urlBase, token: '');

}
