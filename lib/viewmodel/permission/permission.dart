import 'package:permission_handler/permission_handler.dart';

class TPermission{

  Future<void> requestPermission() async {
    final location = Permission.location;
    final camera = Permission.camera;

    if (await location.isDenied) {
      await location.request();
    }else if(await camera.isDenied){
      await camera.request();
    }
  }

  Future<bool> checkPermissionStatus() async {
    final permission = Permission.location;

    return await permission.status.isGranted;
  }

  Future<bool> shouldShowRequestRationale() async {
    final permission = Permission.location;

    return await permission.shouldShowRequestRationale;
  }



}