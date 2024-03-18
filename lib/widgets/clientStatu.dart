import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/admin_provider.dart';

class ClientStatusPage extends StatefulWidget {
  @override
  _ClientStatusPageState createState() => _ClientStatusPageState();
}

class _ClientStatusPageState extends State<ClientStatusPage> {
  Map<String, dynamic>? _dataClientStatu;
  bool _isLoading = false;

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var token = context.read<AdminProvider>().admin.token;
      final response = await http.get(Uri.parse('${HOST}/api/clients/status/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }
      );

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
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Status'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _dataClientStatu == null
                ? Text('No data available')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Row(
                          children: [
                            Text('Active clients: '),
                            Text(
                              '${_dataClientStatu!['active_count']}',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            Text('Inactive clients: '),
                            Text(
                              '${_dataClientStatu!['inactive_count']}',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            Text('Total clients: '),
                            Text('${_dataClientStatu!['total_client']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
