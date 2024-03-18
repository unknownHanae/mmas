import 'dart:convert';

import 'package:adminmmas/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../componnents/responsive.dart';
import '../constants.dart';
import '../providers/admin_provider.dart';

class Metriques extends StatefulWidget {
  const Metriques({super.key});

  @override
  State<Metriques> createState() => _MetriquesState();
}

class _MetriquesState extends State<Metriques> {
  Map<String, dynamic>? _dataClientStatu;
  bool _isLoading = false;

  double _totalRevenue = 0.0;
  int _numTransactions = 0;

  int _totalSessions = 0;

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

  Future<void> _fetchDataTransaction() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var token = context.read<AdminProvider>().admin.token;
      final response = await http.get(Uri.parse(API.TRANSACTION_DATA),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final totalRevenue = responseData['total_revenue'];
        final numTransactions = responseData['total_transactions'];

        setState(() {
          _totalRevenue = totalRevenue;
          _numTransactions = numTransactions;
        });
      } else {
        throw Exception('Failed to fetch transaction data');
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchDataSession() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var token = context.read<AdminProvider>().admin.token;
      final response = await http.get(Uri.parse(API.NUMBER_OF_SESSIONS),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _totalSessions = data['total_sessions'];
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDataStatus();
    _fetchDataTransaction();
    _fetchDataSession();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: <Widget>[
        //     Text('Metriques', style: Theme.of(context).textTheme.subtitle1),
        //     ElevatedButton.icon(
        //       style: TextButton.styleFrom(
        //         backgroundColor: primaryColor,
        //         padding: EdgeInsets.symmetric(
        //             horizontal: defaultPadding * 1.5, vertical: defaultPadding),
        //       ),
        //       onPressed: () {
        //         // refresh data
        //         _fetchDataStatus();
        //         _fetchDataTransaction();
        //         // display a snackbar bottom of the screen
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(
        //             content: Text(
        //               'Les données ont été actualisées',
        //               style: TextStyle(color: Colors.black),
        //             ),
        //             backgroundColor: Colors.green,
        //             duration: Duration(seconds: 1),
        //             // tex
        //           ),
        //         );
        //       },
        //       icon: Icon(Icons.refresh),
        //       label: Text('Refresh'),
        //     ),
        //   ],
        // ),
        // SizedBox(height: defaultPadding),
        Responsive(
            mobile: Kpi(
              isLoading: _isLoading,
              dataClientStatu: _dataClientStatu,
              numTransactions: _numTransactions,
              totalRevenue: _totalRevenue,
              totalSessions: _totalSessions,
              crossAxisCount: _size.width < 825 ? 2 : 4,
              childAspectRatio: _size.width < 825 ? 1 : 1.4,
            ),
            tablet: Kpi(
                isLoading: _isLoading,
                dataClientStatu: _dataClientStatu,
                numTransactions: _numTransactions,
                totalRevenue: _totalRevenue,
                totalSessions: _totalSessions),
            desktop: Kpi(
              isLoading: _isLoading,
              dataClientStatu: _dataClientStatu,
              numTransactions: _numTransactions,
              totalRevenue: _totalRevenue,
              totalSessions: _totalSessions,
              childAspectRatio: _size.width < 1400 ? 1 : 1.1,
            ))
      ],
    );
  }
}

class Kpi extends StatelessWidget {
  const Kpi({
    super.key,
    required bool isLoading,
    required Map<String, dynamic>? dataClientStatu,
    required int numTransactions,
    required double totalRevenue,
    required int totalSessions,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  })  : _isLoading = isLoading,
        _dataClientStatu = dataClientStatu,
        _numTransactions = numTransactions,
        _totalRevenue = totalRevenue,
        _totalSessions = totalSessions;

  final bool _isLoading;
  final Map<String, dynamic>? _dataClientStatu;
  final int _numTransactions;
  final double _totalRevenue;
  final int _totalSessions;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: childAspectRatio),
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(defaultPadding * 0.75),
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.all(
              Radius.circular(defaultPadding),
            ),
          ),
          child: _isLoading
              ? CircularProgressIndicator()
              : _dataClientStatu == null
              ? Text('No data available')
              : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.6),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Clients',
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${_dataClientStatu!['total_client']}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Actifs',
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${_dataClientStatu!['active_count']}',
                    // subtitle2 and green
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(
                      color: Colors.green,
                    ),
                    // green
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inactifs',
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${_dataClientStatu!['inactive_count']}',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.6),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        // Container(
        //   padding: EdgeInsets.all(defaultPadding * 0.75),
        //   decoration: BoxDecoration(
        //     color: whiteColor,
        //     borderRadius: const BorderRadius.all(Radius.circular(10)),
        //   ),
        //   child: _isLoading
        //       ? CircularProgressIndicator()
        //       : _numTransactions == null
        //       ? Text('No data available')
        //       : Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       Row(
        //         children: <Widget>[
        //           Container(
        //             height: 40,
        //             width: 40,
        //             decoration: BoxDecoration(
        //               color: Colors.green.withOpacity(0.6),
        //               borderRadius:
        //               const BorderRadius.all(Radius.circular(10)),
        //             ),
        //             child: Icon(
        //               Icons.payment_outlined,
        //               color: Colors.black,
        //             ),
        //           ),
        //         ],
        //       ),
        //       SizedBox(height: defaultPadding),
        //       Column(
        //         children: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.end,
        //             children: <Widget>[
        //               Text(
        //                 'Transactions',
        //                 style: Theme.of(context).textTheme.titleSmall,
        //               ),
        //               Text(
        //                 '$_numTransactions',
        //                 style: Theme.of(context).textTheme.subtitle2,
        //               ),
        //             ],
        //           ),
        //           SizedBox(height: 4),
        //           Container(
        //             width: double.infinity,
        //             height: 5,
        //             decoration: BoxDecoration(
        //               color: Colors.green.withOpacity(0.6),
        //               borderRadius:
        //               const BorderRadius.all(Radius.circular(10)),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        // Container(
        //   padding: EdgeInsets.all(defaultPadding * 0.75),
        //   decoration: BoxDecoration(
        //     color: whiteColor,
        //     borderRadius: const BorderRadius.all(Radius.circular(10)),
        //   ),
        //   child: _isLoading
        //       ? CircularProgressIndicator()
        //       : _totalRevenue == null
        //       ? Text('No data available')
        //       : Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: <Widget>[
        //       Row(
        //         children: <Widget>[
        //           Container(
        //             height: 40,
        //             width: 40,
        //             decoration: BoxDecoration(
        //               color: Colors.blue.withOpacity(0.6),
        //               borderRadius:
        //               const BorderRadius.all(Radius.circular(10)),
        //             ),
        //             child: Icon(
        //               Icons.monetization_on,
        //               color: Colors.black,
        //             ),
        //           ),
        //         ],
        //       ),
        //
        //       // SizedBox(height: defaultPadding),
        //       Column(
        //         children: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.end,
        //             // strat from he
        //             children: <Widget>[
        //               Text(
        //                 'Revenu',
        //                 style: Theme.of(context).textTheme.subtitle2,
        //                 overflow: TextOverflow.ellipsis,
        //               ),
        //               Text(
        //                 '$_totalRevenue',
        //                 style: Theme.of(context).textTheme.subtitle2,
        //               ),
        //             ],
        //           ),
        //           SizedBox(height: 4),
        //           Container(
        //             width: double.infinity,
        //             height: 5,
        //             decoration: BoxDecoration(
        //               color: Colors.blue.withOpacity(0.6),
        //               borderRadius:
        //               const BorderRadius.all(Radius.circular(10)),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        Container(
          padding: EdgeInsets.all(defaultPadding * 0.75),
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.all(
              Radius.circular(defaultPadding),
            ),
          ),
          child: _isLoading
              ? CircularProgressIndicator()
              : _dataClientStatu == null
              ? Text('No data available')
              : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.6),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Séances',
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$_totalSessions',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.6),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Contract {
  final int idContrat;
  final String numContrat;
  final double reste;

  Contract({
    required this.idContrat,
    required this.numContrat,
    required this.reste,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      idContrat: json['id_contrat'],
      numContrat: json['numcontrat'],
      reste: json['reste'],
    );
  }
}