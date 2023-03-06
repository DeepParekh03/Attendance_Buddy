import 'package:flutter/material.dart';
import 'package:image_firebase/admin/colors.dart';

class TableView extends StatefulWidget {
  const TableView({Key? key}) : super(key: key);

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  @override
  Widget build(BuildContext context) {
    List dataList = [];
    final arg = ModalRoute.of(context)!.settings.arguments as List;
    dataList = arg;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Analytics',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Table View'),
          backgroundColor: ColorsUsed.appBarColor,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: ColorsUsed.uiColor),
                onPressed: () {
                  setState(() {
                    dataList.clear();
                  });
                },
                child: Text('Refresh')),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                    child: DataTable(columns: [
                  DataColumn(label: Text('Team Code')),
                  DataColumn(label: Text('SAP ID')),
                  DataColumn(label: Text('Percentage')),
                ], rows: [
                  for (var cols in dataList)
                    DataRow(cells: [
                      DataCell(Text(cols['Team_Code'].toString())),
                      DataCell(Text(cols['SAPID'].toString())),
                      DataCell(Text(cols['Percentage'].toString()))
                    ])
                ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
