import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionService {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  // Check if device is running Android 6.0+ (API 23+)
  static Future<bool> isAndroidMOrAbove() async {
    try {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 23;
    } catch (e) {
      return false; // Assume older version if can't determine
    }
  }

  // Check if device is running Android 10+ (API 29+)
  static Future<bool> isAndroidQOrAbove() async {
    try {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 29;
    } catch (e) {
      return false;
    }
  }

  // Check if device is running Android 11+ (API 30+)
  static Future<bool> isAndroidROrAbove() async {
    try {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 30;
    } catch (e) {
      return false;
    }
  }

  // Generic permission request with version check
  static Future<PermissionStatus> requestPermission(
    Permission permission, {
    bool? requiredForOlderAndroid,
  }) async {
    try {
      // For Android M+, request permission normally
      if (await isAndroidMOrAbove()) {
        return await permission.request();
      } else {
        // For older Android versions, permissions are granted at install time
        // Return granted if it's required for older versions, otherwise check status
        if (requiredForOlderAndroid == true) {
          return PermissionStatus.granted;
        } else {
          return await permission.status;
        }
      }
    } catch (e) {
      // Handle any exceptions gracefully
      print('Permission request error: $e');
      return PermissionStatus.denied;
    }
  }

  // Check permission status with version awareness
  static Future<PermissionStatus> checkPermissionStatus(
    Permission permission,
  ) async {
    try {
      if (!await isAndroidMOrAbove()) {
        // On older Android, most permissions are granted at install
        return PermissionStatus.granted;
      }
      return await permission.status;
    } catch (e) {
      print('Permission check error: $e');
      return PermissionStatus.denied;
    }
  }
}
