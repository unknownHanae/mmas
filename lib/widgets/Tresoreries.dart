import 'dart:convert';

import 'package:adminmmas/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../componnents/responsive.dart';
import '../constants.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';
class Tresoreries extends StatefulWidget {
  const Tresoreries({super.key});

  @override
  State<Tresoreries> createState() => _TresoreriesState();
}

class _TresoreriesState extends State<Tresoreries> {


  DateTime _startDate = DateTime.now().subtract(Duration(days: 60));
  DateTime _endDate = DateTime.now();

  var solde_recette = 0.0;
  var solde_depense = 0.0;
  var solde_peroid = 0.0;

  Map<String, dynamic>? _dataClientStatu;


  bool _isLoading = true;

  void fetchStatTresorier () async{
    setState(() {
      _isLoading = true;
    });

    var date_s = DateFormat("yyyy-MM-dd").format(_startDate);
    var date_fn = DateFormat("yyyy-MM-dd").format(_endDate);
    var token = context.read<AdminProvider>().admin.token;
    final response = await http.get(
        Uri.parse("${HOST}/api/stat/tresorerie?start_date=${date_s}&end_date=${date_fn}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final data_obj = json.decode(response.body);
      var data = data_obj['data'];
      setState(() {
        solde_recette = data['solde_recette'];
        solde_depense = data['solde_depense'];
        solde_peroid = data['solde_peroid'];
      });
    }
    setState(() {
      _isLoading = false;
    });
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


  @override
  void initState() {
    super.initState();
    fetchStatTresorier();
  }

  @override
  Widget build(BuildContext context) {
    return
     Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
            ],
          ),
          SizedBox(height: defaultPadding),
          Container(
          width: 328,
          height: 300,
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          ),
            child: Column(
              children: [
                SizedBox(height: defaultPadding),
                Row(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.6),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Icon(
                        Icons.payment_outlined,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text('Trésorerie' ,style: TextStyle(color: Colors.black, fontSize: 14),),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'De: ',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(2015),
                          lastDate: _endDate,
                        );
                        if (selectedDate != null) {
                          if(selectedDate.isBefore(_endDate)){
                            setState(() {
                              _startDate = selectedDate;
                            });
                            fetchStatTresorier();

                          }
                         }
                      },
                      child: Text(
                        '${_startDate.year}-${_startDate.month}-${_startDate.day}',
                      ),
                    ),
                    SizedBox(width: 15,),
                    Text(
                      'A: ',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          if(selectedDate.isAfter(_startDate)){
                            setState(() {
                              _endDate = selectedDate;
                            });
                            fetchStatTresorier();
                          }
                        }
                      },
                      child: Text(
                        '${_endDate.year}-${_endDate.month}-${_endDate.day}',
                      ),
                    ),
                  ],
                ),
              Container(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: [
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Recette',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 20,),
                                Text(
                                  '${solde_recette} MAD',

                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Dépenses',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 20,),
                                Text(
                                  '${solde_depense} MAD',

                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Solde de la période',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 20,),
                                Text(
                                  '${solde_peroid} MAD',

                                ),
                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
              ),
              ],
            ),
          ),
        ],
      );
  }

}


