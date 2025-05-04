import 'package:permission_handler/permission_handler.dart';

class PermissionServices {

  static Future<bool> requestNotificationPermission() async{
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
}