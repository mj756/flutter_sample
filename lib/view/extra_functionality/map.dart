import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/extra_functionality/map_controller.dart';
import 'package:flutter_sample/utils/constants.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleView extends StatelessWidget {
  final TextEditingController addressController = TextEditingController();

  GoogleView({Key? key}) : super(key: key);
  final TextEditingController _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return ChangeNotifierProvider(
        create: (context) => MyMapController(),
        lazy: false,
        builder: (context, child) {
          return FutureBuilder(
              future: context
                  .read<MyMapController>()
                  .getPermissionWithLocationPlugin(),
              builder: (context, AsyncSnapshot<bool> snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapShot.data == false) {
                  return const Center(child: Text('permission not provided'));
                } else {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(arguments['title']),
                    ),
                    body: SafeArea(
                        child: Stack(children: [
                      GoogleMap(
                        padding: const EdgeInsets.only(top: 10.0),
                        myLocationEnabled: true,
                        compassEnabled: true,
                        buildingsEnabled: false,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        mapType:
                            context.watch<MyMapController>().currentMapType,
                        mapToolbarEnabled: true,
                        indoorViewEnabled: false,
                        trafficEnabled: false,
                        markers: Set<Marker>.of(
                            context.watch<MyMapController>().markers),
                        initialCameraPosition:
                            context.watch<MyMapController>().kGooglePlex,
                        onCameraMove:
                            context.read<MyMapController>().onCameraMove,
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId("route"),
                            points: List<LatLng>.of(context
                                .watch<MyMapController>()
                                .polylineCoordinates),
                            color: const Color(0xFF7B61FF),
                            width: 6,
                          ),
                        },
                        onMapCreated: (GoogleMapController mapController) {
                          if (!Provider.of<MyMapController>(context,
                                  listen: false)
                              .googleMapController
                              .isCompleted) {
                            context
                                .read<MyMapController>()
                                .googleMapController
                                .complete(mapController);
                          }
                        },
                        onTap: (location) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 30,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: const BoxDecoration(
                                    color: AppConstants.whiteColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      context
                                          .read<MyMapController>()
                                          .getNearByPlaces(
                                              type: _typeController.text);
                                    },
                                    child: const Icon(
                                      Icons.search,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: AppConstants.whiteColor,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: TextField(
                                      controller: _typeController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Search location',
                                          hintStyle:
                                              CustomStyles.customTextStyle(
                                                  defaultColor:
                                                      AppConstants.themeColor,
                                                  isNormalFont: true),
                                          contentPadding: EdgeInsets.zero),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<MyMapController>()
                                        .toggleMapType();
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: AppConstants.whiteColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                            color: AppConstants.whiteColor,
                                          )),
                                      height: double.maxFinite,
                                      width: 50,
                                      child: Image.asset(
                                        'assets/Filter_icon.png',
                                        height: 30,
                                        width: 30,
                                      )),
                                )
                              ],
                            )),
                      ),
                    ])),
                  );
                }
              });
        });
  }
}
