import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_sample/controller/extra_functionality/permission_handler.dart';
import 'package:flutter_sample/utils/constants.dart';
import 'package:geocoding/geocoding.dart' as geo_coding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../model/extra_functionality/map_model.dart';
import '../../model/extra_functionality/parking_detail.dart';
import '../api_controller.dart';

class MyMapController extends MyPermissionManager with ChangeNotifier {
  MapResponseResult? nearByPlaces;
  Completer<GoogleMapController> googleMapController = Completer();
  MapType currentMapType = MapType.normal;
  List<LatLng> polylineCoordinates = List.empty(growable: true);
  CameraPosition kGooglePlex = const CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(45.521563, -122.677433),
      tilt: 59.440717697143555,
      zoom: 5);

  double distance = 0.0;
  Set<Marker> markers = <Marker>{};
  LatLng center = const LatLng(45.521563, -122.677433);
  LatLng currentLocation = const LatLng(45.521563, -122.677433);
  LatLng previousLocation = const LatLng(45.521563, -122.677433);
  late LatLng selectedMarker = const LatLng(0, 0);

  @override
  void dispose() {
    super.dispose();
  }

  MyMapController() {
    currentLocation = const LatLng(45.521563, -122.677433);
    kGooglePlex = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        tilt: 59.440717697143555,
        zoom: 10);
    center = const LatLng(45.521563, -122.677433);
    getCurrentLocation().then((value) {
      googleMapController.future.then((value2) {
        value2
            .animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: currentLocation, zoom: 16),
          ),
        )
            .then((value) {
          /* getNearByPlaces().then((value1) {
            notifyListeners();
          });*/
        });
      });
    });
  }

  void toggleMapType() {
    if (currentMapType == MapType.normal) {
      currentMapType = MapType.satellite;
    } else {
      currentMapType = MapType.normal;
    }
    notifyListeners();
  }

  Future<void> showBottomSheet(
      BuildContext context, LatLng destination, int index) async {
    ParkingAddress address = ParkingAddress();
    address.distance = await getPolyPointsWithCalculation(
        LatLng(currentLocation.latitude, currentLocation.longitude),
        destination);

    geo_coding.Placemark place = (await geo_coding.placemarkFromCoordinates(
            destination.latitude, destination.longitude))
        .first;

    address.title = index == 0 ? 'Lawnfield park' : 'Skyy’s Drop';
    address.address =
        '${place.name ?? ''}, ${place.street ?? ''}, ${place.locality}'; //1024, Lawnfield road, New York';
    address.imageUrl = index == 0
        ? 'https://www.himalmag.com/wp-content/uploads/2019/07/sample-profile-picture.png'
        : 'https://www.fairtravel4u.org/wp-content/uploads/2018/06/sample-profile-pic.png';
    address.workingHour = '08:00 AM - 10:00 PM';
    address.description =
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500.';
    address.facilities.addAll([
      'Covered roof',
      'Cameras',
      'Overnight',
      'Charging',
      'Disabled parking'
    ]);
    address.charge = 5.0;
    address.spot = 15;
  }

  void onCameraMove(CameraPosition position) {
    //_lastMapPosition = position.target;
  }

  void changeMapType() {
    currentMapType =
        currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
  }

  void addMarker(LatLng value) async {
    markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(value.toString()),
        position: value,
        infoWindow: const InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () async {
          await getPolyPoints(
              LatLng(currentLocation.latitude, currentLocation.longitude),
              value);
        }));
    await getPolyPoints(
        LatLng(currentLocation.latitude, currentLocation.longitude), value);
  }

  Future<LocationData?> getCurrentLocation() async {
    LocationData? temp = await getLocation();
    if (temp != null) {
      currentLocation = LatLng(temp.latitude!, temp.longitude!);
      kGooglePlex = CameraPosition(
        target: LatLng(temp.latitude!, temp.longitude!),
        zoom: 14.4746,
      );
    }
    return temp;
  }

  Future<void> getPolyPoints(LatLng source, LatLng destination) async {
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapKey, // Your Google Map Key
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
    }
    notifyListeners();
  }

  Future<double> getPolyPointsWithCalculation(
      LatLng source, LatLng destination) async {
    double totalDistance = 0.0;

    PolylinePoints polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapKey, // Your Google Map Key
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var i = 0; i < result.points.length - 1; i++) {
        totalDistance += getDistanceFromLatLonInKm(
            LatLng(result.points[i].latitude, result.points[i].longitude),
            LatLng(
                result.points[i + 1].latitude, result.points[i + 1].longitude));
      }
    }
    return totalDistance;
  }

  Future<void> getNearByPlaces(
      {String type = 'petrol', int numberOfLocation = 2}) async {
    try {
      markers.clear();
      polylineCoordinates.clear();
      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?';
      url =
          '${url}location=${currentLocation.latitude},${currentLocation.longitude}';
      // url="$url&rankby=distance";
      url = "$url&radius=10000";
      //url="$url&type=gas_station";
      url = "$url&keyword=$type";
      url = "$url&key=${googleMapKey}";

      nearByPlaces = await ApiController.getNearByPlaces(url);
      if (nearByPlaces != null) {
        //  BitmapDescriptor icon=await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10,10)),'assets/dollar.jpg',mipmaps: false);
        for (int i = 0; i < nearByPlaces!.results.length; i++) {
          markers.add(Marker(
              markerId: MarkerId(LatLng(
                      nearByPlaces!.results[i].geometry!.location!.lat,
                      nearByPlaces!.results[i].geometry!.location!.lng)
                  .toString()),
              position: LatLng(nearByPlaces!.results[i].geometry!.location!.lat,
                  nearByPlaces!.results[i].geometry!.location!.lng),
              infoWindow: InfoWindow(
                title: type,
                //snippet: '5 Star Rating',
              ),
              icon: BitmapDescriptor.defaultMarker,
              //icon:icon,
              onTap: () async {
                await getPolyPoints(
                    LatLng(currentLocation.latitude, currentLocation.longitude),
                    LatLng(nearByPlaces!.results[i].geometry!.location!.lat,
                        nearByPlaces!.results[i].geometry!.location!.lng));
              }));
        }
      }
    } catch (e) {}
    notifyListeners();
  }

  double getDistanceFromLatLonInKm(LatLng source, LatLng destination) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((destination.latitude - source.latitude) * p) / 2 +
        cos(source.latitude * p) *
            cos(destination.latitude * p) *
            (1 - cos((destination.longitude - source.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }
}
