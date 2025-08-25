import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shop_app/common/app_log_util.dart';
import 'package:shop_app/common/location_util.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/location_service/locatiin_latlong.dart';
import 'package:shop_app/location_service/tracking_service.dart';
import 'package:shop_app/models/employee_response.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class LocationTestViewWidget extends StatefulWidget {
  const LocationTestViewWidget({super.key});

  @override
  State<LocationTestViewWidget> createState() => _LocationTestViewWidgetState();
}

class _LocationTestViewWidgetState extends State<LocationTestViewWidget> {
  List<UserDateLatRequest> locations = [];
  String myLocations = "";
  String liveLoc = "";
  bool isLoading = false;
  Stream<Position> stm = LocationService().getLocationUpdates();

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  void loadLocation() async {
    final syncService = LocationSyncService();
    await syncService.init();
    await syncService.loadLocationsFromPrefs();
    locations.addAll(syncService.getLocationsToBeSent());
    setState(() {});
    if (locations.isNotEmpty) {
      aLog("No locations found");
      aLog(locations.sublist(30, locations.length - 1).toString());
    }
    // LocationService().getLocationUpdates().listen((event) {
    //   stm
    // });

    // .then((value) {
    //   stm = value;
    //   setState(() {});
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Check locations')),
      body: Center(
        child: Column(
          children: [
            buttonWithLoader(
              disable: false,
              isLoading: isLoading,
              context: context,
              label: "Get Location",
              onPressed: () {
                LocationUtil.getLocation((value) {
                  myLocations = "Lat: ${value.lat}, Lng: ${value.long}";
                  setState(() {});
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'My Loc:: $myLocations',
                style: TextStyle(fontSize: 20, color: AppColors.green),
              ),
            ),

            buttonWithLoader(
              disable: false,
              isLoading: isLoading,
              context: context,
              label: "Get Location",
              onPressed: () {
                LocationUtil.getLocation((value) {
                  myLocations = "Lat: ${value.lat}, Lng: ${value.long}";
                  setState(() {});
                });
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: FutureBuilder(
            //     future: LocationService().getCurrentLocation(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         final position = snapshot.data;
            //         if (position != null) {
            //           liveLoc =
            //               "Lat: ${position.latitude}, Lng: ${position.longitude}";
            //           setState(() {});
            //         }
            //       }
            //       return Text(
            //         'Stream Loc:: $myLocations',
            //         style: TextStyle(fontSize: 18, color: AppColors.green),
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    locations.length, // Replace with your actual data length
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return ListTile(
                    title: Text(
                      "${location.createdDate}\n${location.lat}${location.lng}",
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
