import 'dart:math';
import 'package:adminmmas/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants.dart';
import '../providers/admin_provider.dart';

class PieChartClaseWidget extends StatefulWidget {
  const PieChartClaseWidget({Key? key}) : super(key: key);

  @override
  _PieChartClaseWidgetState createState() => _PieChartClaseWidgetState();
}

class _PieChartClaseWidgetState extends State<PieChartClaseWidget> {
  List<String> _labels = [];
  List<int> _data = [];
  int sumData = 0;

  Future<void> _getData() async {
    var token = context.read<AdminProvider>().admin.token;
    final response = await http.get(Uri.parse('${API.Salarie_by_contrat}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    final data = jsonDecode(response.body);

    setState(() {
      _labels = List<String>.from(data['labels']);
      _data = List<double>.from(data['data'])
          .map((value) => value.toInt())
          .toList();
      sumData = _data.reduce((a, b) => a + b);
      print(_data);
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: whiteColor,
      ),
      child: _labels.isNotEmpty
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'contrats Salariés',
              style: TextStyle(
                fontSize: titreSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: defaultPadding),
          SfCircularChart(
            series: <CircularSeries>[
              PieSeries<ChartData, String>(
                dataSource: List.generate(_labels.length, (i) {
                  final index = _data.indexOf(_data.reduce(max));
                  final value = _data[index].toDouble();
                  final label = _labels[index];
                  _data[index] = -1;
                  return ChartData(label, value);
                }),
                xValueMapper: (ChartData data, _) => data.label,
                yValueMapper: (ChartData data, _) => data.value,
                radius: '100%',
                explode: true,
                explodeIndex: 0,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside),
                dataLabelMapper: (ChartData data, _) =>
                '${data.value.toInt()} - ${data.label}',
              ),

              // legend
            ],
            // space between chart and legend
            margin: const EdgeInsets.only(bottom: 20),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ChartData {
  ChartData(this.label, this.value);
  final String label;
  final double value;
}
