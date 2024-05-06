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
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.verified_user_sharp))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Obx(
              () => Column(
                // spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  locationDataController.isTraking.value
                      ? Contaner(
                          title: "Stop Traking",
                          iconData: Icons.close,
                          color: Colors.redAccent,
                          onTap: () {
                            locationDataController.stopTracking();
                          },
                        )
                      : Contaner(
                          title: "Start Traking",
                          iconData: Icons.start,
                          color: Colors.green,
                          onTap: () {
                            locationDataController.trackingLocation();
                          },
                        ),
                  Contaner(
                      title:
                          "Total Distance : ${locationDataController.totalDistance.value}",
                      color: Colors.amber),
                  const SizedBox(width: 10),
                  Contaner(
                    title: "Traked Location",
                    iconData: Icons.rotate_90_degrees_cw_sharp,
                    color: Colors.green,
                    onTap: () async {
                      await locationDataController.getData();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MyDataTable()));
                    },
                  ),
                  Contaner(
                      title:
                          "Total Time : ${locationDataController.totalTravalTime.value}",
                      color: Colors.amber),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget Contaner(
      {required String title,
      required Color color,
      IconData? iconData,
      void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            iconData == null
                ? const SizedBox.shrink()
                : Icon(
                    iconData,
                    color: Colors.white,
                    size: 28,
                  ),
          ],
        ),
      ),
    );
  }
}
