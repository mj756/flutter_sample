import 'package:location/location.dart';

class MyPermissionManager
{

  Future<bool> getPermissionWithLocationPlugin() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
  Future<LocationData?> getLocation()
  async {
    Location location = Location();
    if (await location.hasPermission()==PermissionStatus.granted) {
           return await location.getLocation();
  } else {
          await location.requestPermission();
  }
   return null;
  }

}