import 'package:distance_app/Controller/location_controller.dart';
import 'package:distance_app/Presentation/table2.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final locationDataController = Get.put(LocationDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Tracker')),
      body: SingleChildScrollView(
        child: Column(
          // spacing: 10,
          // crossAxisAlignment: WrapCrossAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                locationDataController.startTracking();
                // locationDataController.startTracking();
              },
              child: const Text('Start Tracking'),
            ),
            ElevatedButton(
              onPressed: () {
                locationDataController.stopTracking();
              },
              child: const Text('Stop Tracking'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to tracked locations screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
              },
              child: const Text('Show Tracked Locations'),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Divider(
                height: 2,
                color: Colors.black,
              ),
            ),
//             // Display total travelled distance and tracking time
//             CustomTextField(
//                 controller: locationDataController.timeStampController.value,
//                 labelText: "Time"),
//             CustomTextField(
//                 controller: locationDataController.latitudeController.value,
//                 labelText: "Latitude"),
//             CustomTextField(
//                 controller: locationDataController.longitudeController.value,
//                 labelText: "Longitude"),
//             CustomTextField(
//                 controller: locationDataController.accuracyController.value,
//                 labelText: "Accuracy"),
//             CustomTextField(
//                 controller: locationDataController.distanceController.value,
//                 labelText: "Distance"),
//
//             ElevatedButton(
//               onPressed: () async {
//                 locationDataController.inserData();
//               },
//               child: const Text('Insert into Table'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 locationDataController.getData();
//               },
//               child: const Text('Get from Table'),
//             ),
          ],
        ),
      ),
    );
  }
}
