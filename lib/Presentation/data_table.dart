import 'dart:async';
import 'dart:developer';
import 'package:distance_app/Controller/location_controller.dart';
import 'package:distance_app/Widget/custom_textfield.dart';
import 'package:distance_app/utils/data_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
      await locationDataController.getData();
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
                locationDataController.getData();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomTextField(
                controller: locationDataController.searchController.value,
                labelText: "Search",
                suffixIcon: IconButton(
                    onPressed: () async {
                      locationDataController.searchController.value.clear();
                      await locationDataController.getData();
                    },
                    icon: const Icon(Icons.close)),
                onChanged: (p0) async {
                  Future.delayed(const Duration(milliseconds: 500), () async {
                    // do something with query

                    await locationDataController.getData();
                  });
                },
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
}
