import 'package:distance_app/Controller/location_controller.dart';
import 'package:distance_app/Presentation/data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: () {
                locationDataController.trackingLocation();
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
                        builder: (context) => const MyDataTable()));
              },
              child: const Text('Show Tracked Locations'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: const BoxDecoration(color: Colors.amberAccent),
              child: Obx(() => Text(
                    "Total Distance  :  ${locationDataController.totalDistance.value}",
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: const BoxDecoration(color: Colors.amberAccent),
              child: Obx(() => Text(
                    "Total Travel Time  :  ${locationDataController.totalTravalTime.value}",
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
