import 'dart:async';
import 'dart:developer';
import 'package:distance_app/Controller/location_controller.dart';
import 'package:distance_app/Widget/custom_textfield.dart';
import 'package:distance_app/utils/data_source.dart';
import 'package:distance_app/utils/timer_conversion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:time_range_picker/time_range_picker.dart';

class MyDataTable extends StatefulWidget {
  const MyDataTable({super.key});

  @override
  _MyDataTableState createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  EmployeeDataSource? employeeDataSource;
  final locationDataController = Get.put(LocationDataController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await locationDataController.getData('');
      log("data--> ${locationDataController.parsedData}");
      employeeDataSource =
          EmployeeDataSource(tableData: locationDataController.parsedData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Data Table'),
        actions: [
          IconButton(
              onPressed: () {
                locationDataController.getData('');
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => CustomTextField(
                        controller:
                            locationDataController.searchController.value,
                        labelText: "Search",
                        suffixIcon: IconButton(
                            onPressed: () async {
                              if (locationDataController
                                  .searchController.value.text.isNotEmpty) {
                                await locationDataController.getData('');
                                locationDataController.searchController.value
                                    .clear();
                              }
                            },
                            icon: Icon(locationDataController
                                    .searchController.value.text.isNotEmpty
                                ? Icons.close
                                : Icons.search)),
                        onChanged: (p0) async {
                          Future.delayed(const Duration(milliseconds: 500),
                              () async {
                            // do something with query

                            await locationDataController.getData(
                                locationDataController
                                    .searchController.value.text);
                          });
                        },
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        // showIOS_DatePicker(context);
                        TimeRange result = await showTimeRangePicker(
                          context: context,
                        );
                        String startTimeH =
                            result.startTime.hour.toString().padLeft(2, '0');
                        String endTimeH =
                            result.endTime.hour.toString().padLeft(2, '0');
                        String startTimeM =
                            result.startTime.minute.toString().padRight(2, '0');
                        String endTimeM =
                            result.endTime.minute.toString().padRight(2, '0');
                        print(
                            "result  + ${result.endTime.minute.toString().padLeft(2, '0')}");

                        await locationDataController.filterData(
                            stratTime: "$startTimeH:$startTimeM",
                            endTime: "$endTimeH:$endTimeM");
                        employeeDataSource = EmployeeDataSource(
                            tableData: locationDataController.parsedData);
                      },
                      icon: const Icon(Icons.filter))
                ],
              ),
            ),
            locationDataController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : locationDataController.parsedData.isEmpty
                    ? const Center(
                        child: Text("No Data"),
                      )
                    : Expanded(
                        child: SfDataGrid(
                          source: employeeDataSource!,
                          allowSorting: true,
                          columns: <GridColumn>[
                            GridColumn(
                                columnName: 'timestamp',
                                width: 120,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    alignment: Alignment.centerRight,
                                    child: const Text(
                                      'Timestamp',
                                    ))),
                            GridColumn(
                                columnName: 'latitude',
                                width: 120,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Latitude',
                                    ))),
                            GridColumn(
                                columnName: 'longitude',
                                width: 120,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Longitude',
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                            GridColumn(
                                columnName: 'accuracy',
                                width: 120,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.centerRight,
                                    child: const Text('Accuracy'))),
                            GridColumn(
                                columnName: 'distance',
                                width: 120,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.centerRight,
                                    child: const Text('Distance'))),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  void showIOS_DatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 300,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () async {
                              if (locationDataController.filterDate !=
                                  DateTime.now()) {}
                              locationDataController.filterDate.value = '';
                              await locationDataController.getData(
                                  locationDataController.filterDate.value);
                              Navigator.pop(ctx);
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.red),
                            )),
                        TextButton(
                            onPressed: () async {
                              await locationDataController.getData(
                                  locationDataController.filterDate.value);
                              locationDataController.filterDate.value = "";
                              Navigator.pop(ctx);
                            },
                            child: const Text("apple",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.green)))
                      ],
                    ),
                    SizedBox(
                      height: 250,
                      child: CupertinoDatePicker(
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged: (val) {
                            locationDataController.filterDate.value =
                                convertTime(val) ?? "";
                          }),
                    ),
                  ],
                ),
              ),
            ));
  }
}
