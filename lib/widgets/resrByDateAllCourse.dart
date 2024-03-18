import 'dart:convert';

import 'package:adminmmas/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/ContratModels.dart';
import '../providers/admin_provider.dart';

class ReservationChart extends StatefulWidget {
  @override
  _ReservationChartState createState() => _ReservationChartState();
}

class _ReservationChartState extends State<ReservationChart> {
  DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime _endDate = DateTime.now();
  List<Reservation>? _reservations;
  List<Contrat>? _contrats;

  List<ContratData>? chartData;

  List<SplineSeries<Reservation, DateTime>> _createSeriesList(
      List<Reservation> reservations) {
    final Map<String, List<Reservation>> reservationsByCourse = {};
    for (final reservation in reservations) {
      if (!reservationsByCourse.containsKey(reservation.course)) {
        reservationsByCourse[reservation.course] = [];
      }
      reservationsByCourse[reservation.course]!.add(reservation);
    }
    final List<SplineSeries<Reservation, DateTime>> seriesList = [];
    final colorList = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.brown,
      Colors.cyan,
      Colors.lime,
    ];
    var i = 0;
    final courseList = reservationsByCourse.keys.toList();
    final colorsByCourse = <String, Color>{};
    for (final course in courseList) {
      if (!colorsByCourse.containsKey(course)) {
        colorsByCourse[course] = colorList[i++ % colorList.length];
      }
    }
    for (final course in reservationsByCourse.keys) {
      final courseReservations = reservationsByCourse[course]!;
      seriesList.add(SplineSeries<Reservation, DateTime>(
        name: course,
        color: colorsByCourse[course]!,
        dataSource: courseReservations,
        xValueMapper: (reservation, _) => DateTime.parse(reservation.date),
        yValueMapper: (reservation, _) => reservation.numReservations.toInt(),
      ));
    }

    return seriesList;
  }

  Future<void> _fetchDataContrats() async {
    final formatter = DateFormat('yyyy-MM-dd');
    final start = formatter.format(_startDate);
    final end = formatter.format(_endDate);
    var token = context.read<AdminProvider>().admin.token;
    final response = await http.get(Uri.parse(
        '${API.RESERVATIONS_BY_DATE_AND_COURSE}?start_date=${start}&end_date=${end}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );
    if (response.statusCode == 200) {
      final respData = json.decode(response.body);
      final jsonData = respData["data"];
      final List<ContratData> datacontrats = [];
      jsonData.forEach((item) {
        datacontrats.add(ContratData(DateTime.parse("${item['date']}"), item['value']));

      });
      setState(() {
        chartData = datacontrats;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDataContrats();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(0),
      height: 400,
      child: Column(
        children: [
          Text("Nombre des inscriptions par période" ,style: TextStyle(color: Colors.black, fontSize: 14),),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'De: ',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              TextButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2015),
                    lastDate: _endDate,
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _startDate = selectedDate;
                    });
                    await _fetchDataContrats();
                  }
                },
                child: Text(
                  '${_startDate.year}-${_startDate.month}-${_startDate.day}',
                ),
              ),
              Text(
                'A: ',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              TextButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: _startDate,
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _endDate = selectedDate;
                    });
                    await _fetchDataContrats();
                  }
                },
                child: Text(
                  '${_endDate.year}-${_endDate.month}-${_endDate.day}',
                ),
              ),
            ],
          ),
          Expanded(
            child: chartData == null
                ? Center(child: CircularProgressIndicator())
                :
            SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                series: <CartesianSeries>[
                  // Renders line chart
                  LineSeries<ContratData, DateTime>(
                      dataSource: chartData!,
                      xValueMapper: (ContratData contrat, _) => contrat.date,
                      yValueMapper: (ContratData contrat, _) => contrat.value,
                      yAxisName: "Nb Inscriptions",
                    xAxisName: "date d'inscription",
                    enableTooltip: true,
                  )
                ]
            )

            /*SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              series: _createSeriesList(_reservations!),
              tooltipBehavior: TooltipBehavior(
                enable: true,
              ),
              legend: Legend(
                isVisible: true,
                borderColor: Colors.black,
                borderWidth: 1,
                position: LegendPosition.bottom,
              ),
              selectionGesture: ActivationMode.singleTap,
              // trackball overlapping marker
              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: InteractiveTooltip(
                  enable: true,
                ),
              ),
            ),*/
          ),
        ],
      ),
    );
  }
}
class ContratData {
  ContratData(this.date, this.value);
  final DateTime date;
  final int value;
}

class Reservation {
  final String date;
  final String course;
  final num numReservations;

  Reservation({
    required this.date,
    required this.course,
    required this.numReservations,
  });
}