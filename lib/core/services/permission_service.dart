import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionServices {

  static Future<bool> requestNotificationPermission() async{
    if (Platform.isAndroid) {
      // Only needed for Android 13+ (API 33)
      final sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
      if (sdkInt < 33) return true;
    }
    final status = await Permission.notification.status;
    if (status.isGranted){
      return true;
    }else if (status.isDenied || status.isLimited){
      final result = await Permission.notification.request();
      return result.isGranted;
    }else if( status.isPermanentlyDenied){
      await openAppSettings();
      return false;
    }
    return false;
  }

  static Future<bool> requestGalleryPermission() async{
    final status = await Permission.photos.status;
    if(status.isGranted){
      return true;
    }else if( status.isDenied || status.isLimited){
      final result = await Permission.photos.request();
      return result.isGranted;
    }else if( status.isPermanentlyDenied){
      await openAppSettings();
      return false;
    }
    return false;
  }
}