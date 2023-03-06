import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_firebase/DatabaseManager/DatabaseManager.dart';
import 'package:image_firebase/ServiceManager/AuthenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graphic/graphic.dart';
import 'package:image_firebase/admin/colors.dart';
import 'package:pie_chart/pie_chart.dart';

class StudentBar extends StatefulWidget {
  const StudentBar({Key? key}) : super(key: key);

  @override
  State<StudentBar> createState() => _StudentBarState();
}

class _StudentBarState extends State<StudentBar> {
  @override
  Widget build(BuildContext context) {
    List barChartDataList = [];
    final arg = ModalRoute.of(context)!.settings.arguments as List;
    barChartDataList = arg;
    Map<String, double> pieChartData = {};
    String team = '';
    double percentage = 0.0;
    for (int i = 0; i < barChartDataList.length; i++) {
      team = barChartDataList[i]['code'];
      percentage = barChartDataList[i]['Percentage'].toDouble();
      pieChartData[team] = percentage;
    }
    return MaterialApp(
      title: 'Student Bar Graph',
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                  title: Text('Graphical View'),
                  backgroundColor: ColorsUsed.appBarColor),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 350,
                    width: 360,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Chart(
                        data: [
                          for (var cols in barChartDataList)
                            {
                              'code': cols['code'],
                              'Percentage': cols['Percentage']
                            }
                        ],
                        variables: {
                          'code': Variable(
                            accessor: (Map map) => map['code'] as String,
                          ),
                          'Percentage': Variable(
                            accessor: (Map map) => map['Percentage'] as num,
                          ),
                        },
                        elements: [IntervalElement()],
                        axes: [
                          Defaults.horizontalAxis,
                          Defaults.verticalAxis,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    width: 360,
                    child: Container(
                        child: PieChart(
                      dataMap: pieChartData,
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      centerText: "Attendance",
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                      ),
                    )),
                  )
                ],
              ))),
    );
  }
}
