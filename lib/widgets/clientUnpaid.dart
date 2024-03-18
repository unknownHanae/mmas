import 'package:adminmmas/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:unicons/unicons.dart';
import '../constants.dart';
import '../providers/admin_provider.dart';

class UnpaidContractsWidget extends StatefulWidget {
  @override
  _UnpaidContractsWidgetState createState() => _UnpaidContractsWidgetState();
}

class _UnpaidContractsWidgetState extends State<UnpaidContractsWidget> {
  List<dynamic> clients = [];
  int _unpaidCount = 0;
  double _totalUnpaid = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var token = context.read<AdminProvider>().admin.token;
      final response = await http.get(Uri.parse(API.CLIENT_CONTRACT_UNPAID),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          clients = data['clients'];
          _unpaidCount = data['unpaid_count'];
          _totalUnpaid = data['total_unpaid'];
        });
      } else {
        throw Exception('Failed to load data {unpaidClients}');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: whiteColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Container(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Contrats impayés',
                            style: TextStyle(
                              color: titreColor,
                              fontWeight: FontWeight.w400,
                              fontSize: titreSize,
                            ),
                          ),
                          Text(
                            'Voir tout',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: sousTitreSize,
                            ),
                          ),
                        ],
                      ),
                      // 2 rectangles that contain the number of contracts and total rest
                      SizedBox(height: defaultPadding),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding / 2),
                              margin: EdgeInsets.only(
                                  top: defaultPadding / 2,
                                  right: defaultPadding / 2),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(defaultPadding),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  // icon
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        UniconsLine.invoice,
                                        color: primaryColor,
                                        size: 24,
                                      ),
                                      Text(
                                        'Contrats',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: sousTitreSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(width: defaultPadding),
                                  // if _isLoading is true, show a circular progress indicator, if else the number of unpaid contracts is 0 then show 0, else show the number of unpaid contracts
                                  _isLoading
                                      ? CircularProgressIndicator()
                                      : _unpaidCount == 0
                                      ? Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: sousTitreSize,
                                    ),
                                  )
                                      : Text(
                                    '$_unpaidCount',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: sousTitreSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding / 2),
                              margin: EdgeInsets.only(
                                  top: defaultPadding / 2,
                                  left: defaultPadding / 2),
                              decoration: BoxDecoration(
                                color: redColor.withOpacity(0.4),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(defaultPadding),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        UniconsLine.money_bill,
                                        color: redColor,
                                        size: 24,
                                      ),
                                      Text(
                                        '  Reste',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: sousTitreSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(width: defaultPadding),
                                  _isLoading
                                      ? CircularProgressIndicator()
                                      : _totalUnpaid == 0
                                      ? Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: sousTitreSize,
                                    ),
                                  )
                                      : Text(
                                    // total rest

                                    '$_totalUnpaid',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: sousTitreSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding / 2),
                      ListView.builder(
                        padding: EdgeInsets.only(top: defaultPadding),
                        shrinkWrap: true,
                        itemCount: clients.length,
                        itemBuilder: (BuildContext context, int index) {
                          final client = clients[index];
                          return Column(
                            children: [
                              InkWell(
                                // space between each item
                                splashColor: Colors.red,
                                highlightColor: Colors.red,
                                onTap: () {
                                  _showContractDetails(context, client);
                                },
                                child: Row(
                                  // space between each item
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child:
                                      // if iame is null or empty, show a icon, else show the image
                                      client['image'] == null ||
                                          client['image'] == ''
                                          ? Icon(
                                        UniconsLine.user,
                                        size: 40,
                                        color: Colors.grey,
                                      )
                                          : Image.network(
                                        API.MEDIA_ENDPOINT +
                                            client['image'],
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: defaultPadding),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                // just first letter of the title must be capitalized
                                                client['nom_client']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: titreSize,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              // Text(
                                              //   'Contras: ${client['num_contrats']}',
                                              //   style: TextStyle(
                                              //     fontSize: sousTitreSize,
                                              //     fontWeight: FontWeight.w400,
                                              //   ),
                                              // ),
                                              Text(
                                                // reste with red color and dirham icon in the left
                                                'Reste: ${client['total_reste']} DH',
                                                style: TextStyle(
                                                  fontSize: sousTitreSize,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              SizedBox(width: defaultPadding / 2),
                                            ],
                                          ),
                                        )),
                                    Icon(
                                      Icons.more_vert_rounded,
                                      color: titreColor.withOpacity(0.5),
                                      size: 18,
                                    ),
                                    // make padding between in the bottom
                                  ],
                                ),

                                // Card(
                                //   // transparent card
                                //   color: whiteColor,
                                //   child: ListTile(
                                //     leading: CircleAvatar(
                                //       backgroundColor: primaryColor,
                                //       child: Text(
                                //         client['nom_client'][0].toUpperCase(),
                                //         style: TextStyle(color: whiteColor),
                                //       ),
                                //     ),
                                //     hoverColor: Colors.green,
                                //     title: Text(
                                //         client['nom_client']
                                //             .toString()
                                //             .toUpperCase(),
                                //         style: TextStyle(color: primaryColor)),
                                //     // the first letter of the title must be capitalized
                                //     subtitle: Text.rich(
                                //       TextSpan(
                                //         text:
                                //             'Number of contracts: ${client['num_contrats']} \n',
                                //         style: TextStyle(color: Colors.black),
                                //         children: [
                                //           TextSpan(
                                //             text:
                                //                 'Reste: ${client['total_reste']} DH',
                                //             style: TextStyle(color: Colors.red),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //     // trailing: Text(
                                //     //   'Reste: ${client['total_reste']} DH',
                                //     //   style: TextStyle(color: Colors.red),
                                //     // ),
                                //   ),
                                //   // stylistic card with shadow, border, and rounded corners
                                //   shape: RoundedRectangleBorder(
                                //     side: BorderSide(
                                //       color: primaryColor,
                                //     ),
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                //   // elevation: 10,
                                // ),
                              ),
                              SizedBox(height: defaultPadding / 2),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Container(
    //   child: clients.isEmpty
    //       ? Center(
    //           child: CircularProgressIndicator(),
    //         )
    //       : ListView.builder(
    //           itemCount: clients.length,
    //           itemBuilder: (BuildContext context, int index) {
    //             final client = clients[index];
    //             return Card(
    //               child: ListTile(
    //                 title: Text(client['nom_client']),
    //                 subtitle: Text(
    //                     'Number of contracts: ${client['num_contrats']} | Reste: ${client['total_reste']} DH'),
    //               ),
    //             );
    //           },
    //         ),
    // );
  }

  void _showContractDetails(BuildContext context, dynamic client) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // gradient background(yellow color)
          backgroundColor: // gradientColor,
          whiteColor,
          title: Text(
            'Les contrats de ${client['nom_client'].toString().toUpperCase()}',
            style: Theme.of(context).textTheme.headline6,
          ),
          content: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total reste: ${client['total_reste']} DH',
                    style: TextStyle(
                      fontSize: sousTitreSize2,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    'Nombre de contrats: ${client['num_contrats']}',
                    style: TextStyle(
                      fontSize: sousTitreSize2,
                      fontWeight: FontWeight.normal,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                // rounded corners
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 400,
                width: 300,
                // padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: ListView.builder(
                  itemCount: client['contrats'].length,
                  itemBuilder: (BuildContext context, int index) {
                    final contrat = client['contrats'][index];
                    return Container(
                      decoration: BoxDecoration(
                        // for each item in the list with color different
                        color: yellowColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin:
                      EdgeInsets.symmetric(vertical: defaultPadding / 2),
                      padding: EdgeInsets.all(defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              // add icon

                              Row(
                                children: [
                                  Icon(
                                    Icons.contact_emergency_rounded,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: defaultPadding / 2),
                                  Text(
                                    'Number: ${contrat['numcontrat']}',
                                    style: TextStyle(
                                      fontSize: sousTitreSize,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: defaultPadding),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.money_off_sharp,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: defaultPadding / 2),
                                  Text(
                                    'Reste: ${contrat['reste']} DH',
                                    style: TextStyle(
                                      fontSize: sousTitreSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: defaultPadding),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.subscriptions,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: defaultPadding / 2),
                                  Text(
                                    'Abonnement : ${contrat['abonnement']}',
                                    style: TextStyle(
                                      fontSize: sousTitreSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: defaultPadding),
                              Row(
                                children: [
                                  Icon(
                                    UniconsLine.calendar_slash,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: defaultPadding / 2),
                                  Text(
                                    'Date fin: ${contrat['date_fin']}',
                                    style: TextStyle(
                                      fontSize: sousTitreSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}