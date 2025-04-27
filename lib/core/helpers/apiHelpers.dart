import 'package:device_info_plus/device_info_plus.dart';

class ApiHelper {
  static Future<String> getApiUrl() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    bool isEmulator = await _isEmulator(deviceInfo);

    if (isEmulator) {
      return 'http://10.0.2.2:8000/api';
    } else {
      return 'http://192.168.100.113:8000/api';
    }
  }

  static Future<bool> _isEmulator(DeviceInfoPlugin deviceInfo) async {
    try {
      final androidInfo = await deviceInfo.androidInfo;
      return !androidInfo.isPhysicalDevice;
    } catch (e) {
      print('Erreur détection appareil: $e');
      return false;
    }
  }

  static Future<String> getUrl() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    bool isEmulator = await _isEmulator(deviceInfo);

    if (isEmulator) {
      return '10.0.2.2';
    } else {
      return '192.168.100.113';
    }
  }

}
