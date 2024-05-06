import 'dart:async';
import 'dart:math';
import 'package:distance_app/Model/location_model.dart';
import 'package:distance_app/utils/local_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationDataController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isTraking = false.obs;
  DatabaseHelper databaseHelper = DatabaseHelper();
  RxList<Map<String, dynamic>> parsedData = <Map<String, dynamic>>[].obs;
  RxString totalTravalTime = "".obs;
  RxDouble totalDistance = 0.0.obs;
  DateTime currentdateTime = DateTime.now();
  final timeStampController = TextEditingController().obs;
  final latitudeController = TextEditingController().obs;
  final longitudeController = TextEditingController().obs;
  final accuracyController = TextEditingController().obs;
  final distanceController = TextEditingController().obs;
  final searchController = TextEditingController().obs;
  StreamSubscription<LocationData>? locationSubscription;

  /// insert data in table
  Future<void> inserData() async {
    isLoading(true);
    var inserData = LocationModel(
        timestamp: timeStampController.value.text,
        latitude: latitudeController.value.text,
        longitude: longitudeController.value.text,
        id: DateTime.now().microsecondsSinceEpoch,
        accuracy: accuracyController.value.text,
        distance: distanceController.value.text);
    await databaseHelper.insertIntoTable(inserData);
    isLoading(false);
  }

  /// read data from table
  Future<void> getData() async {
    isLoading(true);
    parsedData.value =
        await databaseHelper.getData(searchController.value.text) ?? [];
    print("lidatData--> ${parsedData.toString()}");
    isLoading(false);
  }

  Future<void> trackingLocation() async {
    isTraking(true);
    Location location = Location();
    currentdateTime = DateTime.now();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData startLocation;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    startLocation = await location.getLocation();

    location.onLocationChanged.listen((LocationData currentLocation) async {
      print(
        currentLocation.altitude,
      );

      print(currentLocation.longitude);
      print("PrevPosition-- >${currentLocation.latitude.toString()}");
      print("CurrentPosition-- >${currentLocation.latitude.toString()}");

      // Calculate distance from previous location
      // double distanceInMeters = calculateDistance(
      //   startLocation.latitude!,
      //   startLocation.longitude!,
      //   currentLocation.latitude!,
      //   currentLocation.longitude!,
      // );

      double distanceInMeters = calculateDistance(
        startLocation.latitude!,
        startLocation.longitude!,
        34.0522,
        -118.2437,
      );
      totalDistance.value = distanceInMeters;
      print("distance--> $distanceInMeters");
      // Check if distance is greater than or equal to 3 meters
      if (distanceInMeters >= 3) {
        // Save location data to database

        var data = LocationModel(
          latitude: currentLocation.latitude.toString(),
          longitude: currentLocation.longitude.toString(),
          timestamp: currentLocation.time.toString(),
          accuracy: currentLocation.accuracy.toString(),
          distance: distanceInMeters.toString(),
        );
        await databaseHelper.insertIntoTable(data);
        Get.snackbar("Success", "Data inserted",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
      // Use current location
      update();
    });
  }

  void stopTracking() {
    isTraking(false);
    locationSubscription?.cancel(); // Stop location tracking
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double currentLatitude, double currentLongitude) {
    // Use the Haversine formula to calculate distance between two coordinates
    const double earthRadius = 6371000; // in meters

    double dLat = degreesToRadians(currentLatitude - startLatitude);
    double dLon = degreesToRadians(currentLongitude - startLongitude);

    double a = pow(sin(dLat / 2), 2) +
        cos(degreesToRadians(startLatitude)) *
            cos(degreesToRadians(currentLatitude)) *
            pow(sin(dLon / 2), 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;

    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
