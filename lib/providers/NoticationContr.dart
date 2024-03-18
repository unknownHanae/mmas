import 'package:adminmmas/env.dart';
import 'package:adminmmas/models/NotificationModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/ClientModels.dart';
import '../models/ContratModels.dart';
import '../models/AbonnementModels.dart';
import '../models/CoachModels.dart';

class NotificationAdminController {
  final String baseUrl = API.NOTIFICATIONS_ENDPOINT;

  Future<List<NotificationAdmin>> fetchNotifications(String token) async {
    final response = await http.get(Uri.parse(baseUrl), headers: {
      'Content-Type':
      'application/json; charset=UTF-8', // Specify the content type and encoding
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<NotificationAdmin> notifications =
      body.map((dynamic item) => NotificationAdmin.fromJson(item)).toList();
      return notifications;
    } else {
      throw "Failed to load notifications list";
    }
  }

  Future<NotificationAdmin> fetchNotification(int id, token) async {
    final response = await http.get(Uri.parse('$baseUrl$id/'), headers: {
      'Content-Type':
      'application/json; charset=UTF-8', // Specify the content type and encoding,
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      print(response.body);
      return NotificationAdmin.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to load notification";
    }
  }

  Future<NotificationAdmin> createNotification(
      NotificationAdmin notification, String token) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(notification.toJson()));
    print(response.body);

    if (response.statusCode == 201) {
      return NotificationAdmin.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to create notification";
    }
  }

  Future<NotificationAdmin> updateNotification(
      int id, NotificationAdmin notification, String token) async {
    final response = await http.put(Uri.parse('$baseUrl$id/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(notification.toJson()));

    if (response.statusCode == 200) {
      return NotificationAdmin.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to update notification";
    }
  }

  Future<void> deleteNotification(int id, token) async {
    final response = await http.delete(Uri.parse('$baseUrl$id/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );

    if (response.statusCode != 204) {
      throw "Failed to delete notification";
    }
  }

  Future<List<Client>> fetchClients(String token) async {
    final response = await http.get(Uri.parse(API.CLIENTS_ENDPOINT),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final clientsData = data['data'] as List<dynamic>;
      final clients = clientsData
          .map((clientData) =>
          Client.fromJson(clientData as Map<String, dynamic>))
          .toList();
      return clients;
    } else {
      throw Exception('Failed to fetch clients');
    }
  }

  Future<List<Coach>> fetchCoachs(String token) async {
    final response = await http.get(Uri.parse(API.COACH_ENDPOINT),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final coachsData = data['data'] as List<dynamic>;
      final coachs = coachsData
          .map((coachData) => Coach.fromJson(coachData as Map<String, dynamic>))
          .toList();
      return coachs;
    } else {
      throw Exception('Failed to fetch coachs');
    }
  }

  // fetch last notification id
  Future<int> fetchLastNotificationId(String token) async {
    final response =
    await http.get(Uri.parse('${API.NOTIFICATIONS_ENDPOINTlast_id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw "Failed to load last notification id";
    }
  }

  Future<void> addClients(List<int> clientIds, String token) async {
    final url = Uri.parse(API.SEND_NOTIFICATION_ENDPOINT);
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token',};
    final body = json.encode({'clients': clientIds});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Clients ids: $clientIds');
        print('Clients added successfully.');
      } else {
        print('Failed to add clients. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<dynamic>> fetchUnpaidContraClients(String token) async {
    final response = await http.get(Uri.parse(API.CLIENT_CONTRACT_UNPAID), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['clients'];
    } else {
      throw Exception('Failed to load unpaid contracts');
    }
  }

  // fetch unpaid contracts
  Future<List<dynamic>> fetchExpiredContracts(String token) async {
    try {
      final response = await http.get(Uri.parse(API.CLIENT_CONTRACT_EXPIRING),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("data: $data");
        final expiringContracts = data['expiring_contracts'];
        print("expiringContracts: $expiringContracts");

        final List<dynamic> contracts = [];
        expiringContracts.values.forEach((contractList) {
          contracts.addAll(contractList);
        });

        return contracts;
      } else {
        throw Exception('Failed to load expired contracts');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<List<dynamic>> getValidNotifications(int notificationId, String token) async {
    final response = await http
        .get(Uri.parse('${API.VALID_NOTIFICATIONS_ENDPOINT}$notificationId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to fetch valid notifications');
    }
  }

  // get clients female or male
  Future<List<Client>> fetchClientsByGender(String gender, String token) async {
    final response = await http.get(Uri.parse(API.CLIENTS_ENDPOINT), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final clientsData = data['data'] as List<dynamic>;

      List<Client> clients = clientsData
          .map((clientData) =>
          Client.fromJson(clientData as Map<String, dynamic>))
          .toList();

      if (gender == 'female') {
        clients = clients
            .where((client) =>
        client.civilite == 'Madame' || client.civilite == 'Madmoiselle')
            .toList();
      } else if ((gender == 'male')) {
        clients =
            clients.where((client) => client.civilite == 'Monsieur').toList(); // to review
      }

      return clients;
    } else {
      throw Exception('Failed to fetch clients');
    }
  }

  Future<List<ClientAbnm>> getClientsByAbonnementType(
      String typeAbonnement, String token) async {
    final response =
    await http.get(Uri.parse(API.CLIENTS_ENDPOINT + '$typeAbonnement/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      final clientsData = data['clients'] as List<dynamic>;
      final clients = clientsData.map((clientData) {
        final Map<String, dynamic> clientJson = clientData;
        clientJson['type_abonnement'] = typeAbonnement;
        return ClientAbnm.fromJson(clientJson);
      }).toList();

      return clients;
    } else {
      throw Exception('Failed to fetch clients by abonnement type');
    }
  }

  Future<List<Abonnement>> getAllAbonnements(String token) async {
    final response = await http.get(Uri.parse(API.ABONNEMENT_ENDPOINT), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final abonnementsData = data['data'] as List<dynamic>;
      final abonnements = abonnementsData
          .map((abonnementData) =>
          Abonnement.fromJson(abonnementData as Map<String, dynamic>))
          .toList();
      return abonnements;
    } else {
      throw Exception('Failed to fetch abonnements');
    }
  }
}

class ClientAbnm {
  int idClient;
  String nomClient;
  String prenomClient;
  String typeAbonnement; // New attribute to store the abonnement type

  ClientAbnm({
    required this.idClient,
    required this.nomClient,
    required this.prenomClient,
    required this.typeAbonnement, // Initialize the new attribute
  });

  factory ClientAbnm.fromJson(Map<String, dynamic> json) {
    return ClientAbnm(
      idClient: json['id_client'],
      nomClient: json['nom_client'],
      prenomClient: json['prenom_client'],
      typeAbonnement:
      json['type_abonnement'], // Assign the value to the new attribute
    );
  }
}
