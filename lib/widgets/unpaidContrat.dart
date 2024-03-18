import 'dart:convert';

import 'package:adminmmas/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/admin_provider.dart';

class UnpaidContractsPage extends StatefulWidget {
  const UnpaidContractsPage({Key? key}) : super(key: key);

  @override
  _UnpaidContractsPageState createState() => _UnpaidContractsPageState();
}

class _UnpaidContractsPageState extends State<UnpaidContractsPage> {
  int _unpaidCount = 0;
  double _totalUnpaid = 0.0;
  List<Contract> _unpaidContracts = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var token = context.read<AdminProvider>().admin.token;
    final url =
        Uri.parse('${HOST}/api/clients/contracts/unpaid/',);
    final response = await http.get(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      setState(() {
        _unpaidCount = responseData['unpaid_count'];
        _totalUnpaid = responseData['total_unpaid'];
        _unpaidContracts = (responseData['unpaid_contracts'] as List)
            .map((json) => Contract.fromJson(json))
            .toList();
      });
    } else {
      throw Exception('Failed to load unpaid contracts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nombre de Contrats Impayés: $_unpaidCount',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Total des Contrats Impayés: $_totalUnpaid',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _unpaidContracts.length,
                itemBuilder: (context, index) {
                  final contract = _unpaidContracts[index];
                  return Card(
                    child: ListTile(
                      title: Text('Numéro de Contrat: ${contract.numContrat}', style: TextStyle(fontSize: sousTitreSize),),
                      subtitle: Text('Reste: ${contract.reste}', style: TextStyle(fontSize: sousTitreSize2),),
                      // nom client
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
