import 'package:music_app/helpers/permission_services.dart';
import 'package:permission_handler/permission_handler.dart';

class SpecificPermissionHandlers {
  // Location permission handler
  static Future<PermissionStatus> requestLocationPermission() async {
    if (!await PermissionService.isAndroidMOrAbove()) {
      return PermissionStatus.granted; // Granted at install on older Android
    }

    if (await PermissionService.isAndroidQOrAbove()) {
      // Android 10+ can request background location
      return await Permission.locationAlways.request();
    } else {
      // Android 6-9 request location
      return await Permission.locationWhenInUse.request();
    }
  }

  // Storage permission handler (scoped storage for Android 10+)
  static Future<PermissionStatus> requestStoragePermission() async {
    if (!await PermissionService.isAndroidMOrAbove()) {
      return PermissionStatus.granted;
    }

    if (await PermissionService.isAndroidROrAbove()) {
      // Android 11+ - manage external storage
      return await Permission.manageExternalStorage.request();
    } else if (await PermissionService.isAndroidQOrAbove()) {
      // Android 10 - read external storage
      return await Permission.storage.request();
    } else {
      // Android 6-9 - read/write external storage
      final status = await Permission.storage.request();
      return status;
    }
  }

  // Camera permission handler
  static Future<PermissionStatus> requestCameraPermission() async {
    return await PermissionService.requestPermission(
      Permission.camera,
      requiredForOlderAndroid: true,
    );
  }

  // Microphone permission handler
  static Future<PermissionStatus> requestMicrophonePermission() async {
    return await PermissionService.requestPermission(
      Permission.microphone,
      requiredForOlderAndroid: true,
    );
  }
}
