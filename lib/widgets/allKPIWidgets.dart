import 'dart:convert';

import 'package:adminmmas/views/metrique1.dart';
import 'package:adminmmas/widgets/clientBirthday.dart';
import 'package:adminmmas/widgets/clientUnpaid.dart';
import 'package:adminmmas/widgets/expiringcontra.dart';
import 'package:adminmmas/widgets/metriques.dart';
import 'package:adminmmas/widgets/resrByDateAllCourse.dart';
import 'package:adminmmas/widgets/unpaidContrat.dart';
import 'package:flutter/material.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../componnents/label.dart';
import '../componnents/responsive.dart';
import '../constants.dart';
import '../env.dart';
import '../models/CoursModels.dart';
import '../providers/admin_provider.dart';
import 'Courbyetud.dart';
import 'EtdNivChart.dart';
import 'SeanceClasse.dart';
import 'Tresoreries.dart';
import 'inscription.dart';
import 'pichart.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<DashboardScreen> {

  BsSelectBoxController _selectCours = BsSelectBoxController();

  Map<String, dynamic>? _dataClientStatu;
  bool _isLoading = true;
  List<Cours> cours = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCours();


  }

  Future<void> _fetchDataStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var token = context.read<AdminProvider>().admin.token;
      final response = await http.get(Uri.parse(API.CLIENT_STATUT_COUNT),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        setState(() {
          _dataClientStatu = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to fetch client status');
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void getCours() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/cours/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer',
        });
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      print("--result--");
      print(result.length);
      setState(() {

        cours = result.map<Cours>((e) => Cours.fromJson(e)).toList();


      });
      print("--data--");
      initSelectCours();
    } else {
      throw Exception('Failed to load villes');
    }
  }

  void initSelectCours() {
    _selectCours.options = cours.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
          value: v.id_cour,
          text: Text("${v.nom_cour}"),
        )).toList();
    Cours cour = cours.where((el) => el.nom_cour == "").first;
    _selectCours.setSelected(BsSelectBoxOption(
      value: cour.id_cour,
      text: Text("${cour.nom_cour}"),
    ));
  }
  void initData() {
    _selectCours.removeSelected(_selectCours.getSelected()!);

    initSelectCours();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              // Header(),
              // SizedBox(height: 10),
              Center(child: Text('Dashbord', style: Theme.of(context).textTheme.subtitle1)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Text('', style: Theme.of(context).textTheme.subtitle1)),
                    InkWell(
                    onTap: () {
                    // refresh data
                    _fetchDataStatus();
                    // display a snackbar bottom of the screen
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                    content: Text(
                    'Les données ont été actualisées',
                    style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                    // tex
                    ),
                    );
                    },
                    child: Tooltip(
                    message: "refrecher",
                    // decoration: BoxDecoration(
                    //   color: Colors.blue, // Couleur de fond du tooltip
                    //   borderRadius: BorderRadius.circular(8.0), // Optionnel : coins arrondis
                    // ),
                    child: Container(
                    // height: 28,
                    // width: 35,
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8),
                    //     border: Border.all(color: Colors.green)
                    // ),
                    child: Center(
                    child: Icon(Icons.refresh, size: 35, color: Colors.black),
                    ),
                    ),
                    ),
                    ),
                  // ElevatedButton.icon(
                  //     style: TextButton.styleFrom(
                  //       backgroundColor: Colors.grey[200],
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: defaultPadding * 1.5, vertical: defaultPadding),
                  //     ),
                  //     onPressed: () {
                  //       // refresh data
                  //       _fetchDataStatus();
                  //       // display a snackbar bottom of the screen
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackBar(
                  //           content: Text(
                  //             'Les données ont été actualisées',
                  //             style: TextStyle(color: Colors.black),
                  //           ),
                  //           backgroundColor: Colors.green,
                  //           duration: Duration(seconds: 1),
                  //           // tex
                  //         ),
                  //       );
                  //     },
                  //     icon: Icon(Icons.refresh),
                  //     label: Text('Refresh'),
                  //   ),
                ],
              ),
              SizedBox(height: 15,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context))
                           Column(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Tresoreries(),
                            SizedBox(height: defaultPadding),
                            Metriques1(),
                            SizedBox(width: defaultPadding / 2),
                          ],
                        ),
                        if (!Responsive.isMobile(context))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(height: defaultPadding),
                                    Tresoreries(),
                                  ],
                                ),
                              ),
                              SizedBox(width: defaultPadding / 2),
                              Expanded(
                                child: Column(
                                  children: [
                                    Metriques1(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        // Metriques(),
                        // SizedBox(height: defaultPadding),
                        // Container(
                        //   padding: EdgeInsets.all(defaultPadding),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.all(Radius.circular(10)),
                        //     color: whiteColor,
                        //   ),
                        //   width: double.infinity,
                        //   child: Column(
                        //     children: [
                        //       Tresoreries(),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context))
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClientBirthdayView(),
                              SizedBox(height: defaultPadding),
                              ContractsScreen(),
                              SizedBox(width: defaultPadding / 2),
                            ],
                          ),
                        if (!Responsive.isMobile(context))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(height: defaultPadding),
                                    ClientBirthdayView(),
                                  ],
                                ),
                              ),
                              SizedBox(width: defaultPadding / 2),
                              Expanded(
                                child: Column(
                                  children: [
                                    ContractsScreen(),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        SizedBox(height: defaultPadding),
                        Container(
                          padding: EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: whiteColor,
                          ),
                          // width: double.infinity,
                          child: Column(
                            children: [

                              ReservationChart(),
                            ],
                          ),
                        ),
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context))
                          Column(
                            children: [
                              PieChartWidget(),
                              SizedBox(height: defaultPadding),
                              PieChartClaseWidget(),
                              SizedBox(height: defaultPadding),
                              //Metriques1(),
                              PieChartEtudiantWidget(),
                              SizedBox(height: defaultPadding),
                              PieChartCourWidget(),
                              SizedBox(height: defaultPadding),
                              UnpaidContractsWidget(),
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: defaultPadding),
                  if (!Responsive.isMobile(context))
                    Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            // UnpaidContractsWidget(),
                            PieChartWidget(),
                            SizedBox(height: defaultPadding),
                            PieChartClaseWidget(),
                            SizedBox(height: defaultPadding),
                            PieChartEtudiantWidget(),
                            SizedBox(height: defaultPadding),
                            PieChartCourWidget(),
                          ],
                        )),
                ],
              )
            ],
          ),
        ));
  }
}