import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/extra_functionality/map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';

class GoogleView extends StatelessWidget {
  final TextEditingController addressController = TextEditingController();

  GoogleView({Key? key}) : super(key: key);
  final TextEditingController _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  return SafeArea(
                    child: Stack(
                      children: [
                        GoogleMap(
                          padding: const EdgeInsets.only(top: 10.0),
                          myLocationEnabled: true,
                          compassEnabled: true,
                          buildingsEnabled: false,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                          mapType: MapType.normal,
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
                          left: (MediaQuery.of(context).size.width / 2) -
                              ((MediaQuery.of(context).size.width / 4) + 40),
                          child: Container(
                              height: 60,
                              width:
                                  (MediaQuery.of(context).size.width / 2) + 80,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(color: Colors.white)),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        if (_typeController.text.isNotEmpty) {
                                          await context
                                              .read<MyMapController>()
                                              .getNearByPlaces(context,
                                                  type: _typeController.text);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Please enter category to search')));
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.search,
                                        color: CustomColors.themeColor,
                                      )),
                                  Expanded(
                                    child: TextField(
                                      controller: _typeController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Search Location',
                                      ),
                                    ),
                                  ),
                                  const VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                  ),
                                  const SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Icon(
                                      Icons.settings,
                                      color: CustomColors.themeColor,
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  );
                }
              });
        });
  }
}
