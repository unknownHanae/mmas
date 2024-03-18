import 'package:adminmmas/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/ValidNotifModel.dart';

class ValidNotificationAdminController {
  final String baseUrl = API.NOTIFICATIONS_VALID_ENDPOINT;

  Future<List<ValidNotifModel>> fetchValidNotifications() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<ValidNotifModel> validNotifications =
      body.map((dynamic item) => ValidNotifModel.fromJson(item)).toList();
      return validNotifications;
    } else {
      throw "Failed to load valid notifications list";
    }
  }

  Future<ValidNotifModel> fetchValidNotification(int id) async {
    final response = await http.get(Uri.parse('$baseUrl$id/'));

    if (response.statusCode == 200) {
      return ValidNotifModel.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to load valid notification";
    }
  }

  Future<ValidNotifModel> createValidNotification(
      ValidNotifModel validNotification) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(validNotification.toJson()));
    print(response.body);

    if (response.statusCode == 201) {
      return ValidNotifModel.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to create valid notification";
    }
  }

  Future<ValidNotifModel> updateValidNotification(
      int id, ValidNotifModel validNotification) async {
    final response = await http.put(Uri.parse('$baseUrl$id/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(validNotification.toJson()));

    if (response.statusCode == 200) {
      return ValidNotifModel.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to update valid notification";
    }
  }

  Future<void> deleteValidNotification(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id/'));

    if (response.statusCode == 204) {
      print("Valid notification deleted");
    } else {
      throw "Failed to delete valid notification";
    }
  }
}
