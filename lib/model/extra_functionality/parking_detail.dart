import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingAddress
{

    late LatLng coOrdinates;
    late String title;
    late String description;
    late String imageUrl;
    late String address;
    late double distance;
    late String workingHour;
    late List<String> facilities;
    late int spot;
    late double charge;
    ParkingAddress()
    {
        coOrdinates=const LatLng(0,0);
        title='';
        description='';
        imageUrl='';
        address='';
        distance=8.0;
        workingHour='';
        facilities=List.empty(growable: true);
        spot=0;
        charge=0.0;
    }

}