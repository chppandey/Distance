import 'package:distance_app/Controller/location_controller.dart';
import 'package:distance_app/utils/data_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EmployeeDataSource? _employeeDataSource;
  final locationDataController = Get.put(LocationDataController());

  @override
  void initState() {
    super.initState();
    _employeeDataSource =
        EmployeeDataSource(tableData: locationDataController.parsedData);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      locationDataController.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Data Table'),
      ),
      body: Obx(
        () => locationDataController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : SfDataGrid(
                source: _employeeDataSource!,
                allowSorting: true,
                columns: <GridColumn>[
                  GridColumn(
                      columnName: 'timestamp',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'timestamp',
                          ))),
                  GridColumn(
                      columnName: 'latitude',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'latitude',
                          ))),
                  GridColumn(
                      columnName: 'longitude',
                      width: 120,
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Longitude',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'accuracy',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerRight,
                          child: const Text('accuracy'))),
                  GridColumn(
                      columnName: 'distance',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerRight,
                          child: const Text('distance'))),
                ],
              ),
      ),
    );
  }

  // List<Employee> populateData() {
  //   return <Employee>[
  //     Employee(10001, 'James', 'Bruxelles', 20000),
  //     Employee(10002, 'Kathryn', 'Rosario', 30000),
  //     Employee(10003, 'Lara', 'Recife', 15000),
  //     Employee(10004, 'Michael', 'Graz', 15000),
  //     Employee(10005, 'Martin', 'Montreal', 15000),
  //     Employee(10006, 'Newberry', 'Tsawassen', 15000),
  //     Employee(10007, 'Balnc', 'Campinas', 15000),
  //     Employee(10008, 'Perry', 'Resende', 15000),
  //     Employee(10009, 'Gable', 'Resende', 15000),
  //     Employee(10010, 'Grimes', 'Recife', 15000),
  //     Employee(10011, 'Newberry', 'Tsawassen', 15000),
  //     Employee(10012, 'Balnc', 'Campinas', 15000),
  //     Employee(10013, 'Perry', 'Resende', 15000),
  //     Employee(10014, 'Gable', 'Resende', 15000),
  //     Employee(10015, 'Grimes', 'Recife', 15000),
  //   ];
  // }
}

class Employee {
  int? id;
  String? name;
  String? city;
  int? freight;
  Employee(this.id, this.name, this.city, this.freight);
}
