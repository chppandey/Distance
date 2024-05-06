import 'dart:async';
import 'dart:developer';

import 'package:distance_app/Model/location_model.dart';
import 'package:distance_app/utils/local_db.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationDataController extends GetxController {
  RxBool isLoading = false.obs;
  DatabaseHelper databaseHelper = DatabaseHelper();
  StreamSubscription<Position>? locationStream;
  RxList<Map<String, dynamic>> parsedData = <Map<String, dynamic>>[].obs;
  final timeStampController = TextEditingController().obs;
  final latitudeController = TextEditingController().obs;
  final longitudeController = TextEditingController().obs;
  final accuracyController = TextEditingController().obs;
  final distanceController = TextEditingController().obs;
  final searchController = TextEditingController().obs;

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
    log("lidatData--> ${parsedData.toString()}");
    isLoading(false);
  }

  void startTracking() async {
    try {
      Position previousPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      log("PrevPosition-- >${previousPosition.latitude.toString()}");
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      Get.snackbar("Success", "Tracking started",
          backgroundColor: Colors.green, colorText: Colors.white);
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          Get.snackbar("Error!", 'Location Not Available',
              backgroundColor: Colors.red, colorText: Colors.white);
          return Future.error('Location Not Available');
        }
      }
      StreamSubscription<Position> locationStream =
          Geolocator.getPositionStream().listen(
        (Position position) {
          // Calculate distance from previous location
          log("position--> ${position.latitude}, ${position.longitude}");
          Timer.periodic(const Duration(seconds: 30), (timer) async {
            Position currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );
            log("PrevPosition-- >${previousPosition.latitude.toString()}");
            log("CurrentPosition-- >${currentPosition.latitude.toString()}");

            // Calculate distance from previous location
            double distanceInMeters = Geolocator.distanceBetween(
              previousPosition.latitude,
              previousPosition.longitude,
              currentPosition.latitude,
              currentPosition.longitude,
            );
            log("distance--> $distanceInMeters");
            // Check if distance is greater than or equal to 3 meters
            // if (distanceInMeters >= 3) {
            // Save location data to database

            var data = LocationModel(
              latitude: currentPosition.latitude.toString(),
              longitude: currentPosition.longitude.toString(),
              timestamp: DateTime.now().toIso8601String(),
              accuracy: currentPosition.accuracy.toString(),
              distance: distanceInMeters.toString(),
            );
            await databaseHelper.insertIntoTable(data);
            Get.snackbar("Success", "Data inserted",
                backgroundColor: Colors.green, colorText: Colors.white);
            // }

            // Update previous position
            previousPosition = currentPosition;
          });
        },
      );
    } catch (e) {
      print("data--> $e");
    }
  }

  /// stope tracking
  void stopTracking() {
    locationStream?.cancel(); // Stop location tracking
  }
}
