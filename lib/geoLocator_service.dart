import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  final Geolocator geo = Geolocator();

  Stream getCurrentLocation() {
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    return geo.getPositionStream(locationOptions);
  }

  Future getInitialLocation() async {
    return geo.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<double> DistaceCalc(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    return await geo.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  Future<Position> getLocation() async {
    var geoLocator = Geolocator();
    return await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        locationPermissionLevel: GeolocationPermission.location);
  }
}
