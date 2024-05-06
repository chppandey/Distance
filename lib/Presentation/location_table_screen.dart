import 'package:distance_app/Controller/location_controller.dart';
import 'package:distance_app/Widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class MyDataTable extends StatefulWidget {
  const MyDataTable({super.key});

  @override
  _MyDataTableState createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  final locationController = Get.put(LocationDataController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      locationController.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Table Example')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            CustomTextField(
              controller: locationController.searchController.value,
              onChanged: (p0) {},
              suffixIcon: IconButton(
                  onPressed: () {
                    locationController.getData();
                  },
                  icon: const Icon(Icons.search)),
            ),
            Obx(
              () => locationController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        sortAscending: false,
                        sortColumnIndex: 0,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        headingRowColor:
                            MaterialStateProperty.all(Colors.blueAccent),
                        headingTextStyle: const TextStyle(color: Colors.white),
                        columns: const [
                          DataColumn(label: Text("Id")),
                          DataColumn(label: Text('Timestamp')),
                          DataColumn(label: Text('Latitude')),
                          DataColumn(label: Text('Longitude')),
                          DataColumn(label: Text('Accuracy')),
                          DataColumn(label: Text('Distance')),
                        ],
                        rows: locationController.parsedData.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['id']}')),
                            DataCell(Text('${data['timestamp']}')),
                            DataCell(Text('${data['latitude']}')),
                            DataCell(Text('${data['longitude']}')),
                            DataCell(Text('${data['accuracy']}')),
                            DataCell(Text('${data['distance']}')),
                          ]);
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MyDataTable(),
  ));
}
