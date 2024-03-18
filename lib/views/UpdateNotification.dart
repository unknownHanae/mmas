// import 'package:adminmmas/views/NotificationScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:adminmmas/providers/NoticationContr.dart';
// import 'package:adminmmas/models/NotificationModel.dart';
// import 'package:adminmmas/models/ClientModels.dart';
// import 'package:adminmmas/models/CoachModels.dart';
// import 'package:provider/provider.dart';
//
// import '../models/ValidNotifModel.dart';
// import '../providers/ValidNotifController.dart';
// import '../providers/admin_provider.dart';
// // intl
// import 'package:intl/intl.dart';
// // responsive
// import '../componnents/responsive.dart';
// // json
// import 'dart:convert';
// // env
// import '../env.dart';
// // http
// import 'package:http/http.dart' as http;
//
// class UpdateNotificationStepper extends StatefulWidget {
//   final Function onNotificationUpdated;
//
//   NotificationAdmin notificationAdmin;
//   List<dynamic> clients;
//
//   UpdateNotificationStepper({required this.onNotificationUpdated, required this.notificationAdmin, required this.clients});
//   @override
//   _UpdateNotificationStepperState createState() => _UpdateNotificationStepperState();
// }
//
// enum ReceiverType { client, unpaidContra, expiredContra }
//
// ReceiverType _selectedReceiver = ReceiverType.client;
//
// class _UpdateNotificationStepperState extends State<UpdateNotificationStepper> {
//   // controller
//   final NotificationAdminController _controller = NotificationAdminController();
//   final ValidNotificationAdminController _validController =
//   ValidNotificationAdminController();
//
//   // model
//   NotificationAdmin _notification = NotificationAdmin();
//
//   ValidNotifModel _validNotif = ValidNotifModel();
//
//   // text controller
//   final TextEditingController _subjectController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();
//   final _datePickerController = TextEditingController(
//     text: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
//   );
//
//   // variables
//   List<int> _selectedClients = [];
//   List<int> _selectedUnpaid = [];
//   List<int> _selectedExpired = [];
//   bool _isSending = false;
//   int _currentStep = 0;
//   final _formKey = GlobalKey<FormState>();
//   DateTime _selectedDate = DateTime.now();
//   late int id_admin;
//   ScrollController _scrollController = ScrollController();
//   int _characterCount = 0;
//
//   // Flag for indicating whether the form is currently submitting
//   bool _isSubmitting = false;
//
//   // Flag for indicating whether the form has been successfully submitted
//   bool _submitSuccess = false;
//
//   // Focus node for handling textfield focus
//   late FocusNode _dateFocusNode;
//
//   late Future<List<dynamic>> _unpaidContraClientsFuture;
//   late Future<Map<String, dynamic>> _expiredContractsFuture;
//
//   // Map<String, List<dynamic>> _expiringContracts = {};
//   // Map<String, List<dynamic>> _soonExpiringContracts = {};
//
//   Future<Map<String, dynamic>> _fetchContracts() async {
//     var token = context.read<AdminProvider>().admin.token;
//     final response = await http.get(Uri.parse(API.CLIENT_CONTRACT_EXPIRING),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         });
//     final data = json.decode(response.body);
//     return {
//       'expiring_contracts': data['expiring_contracts'],
//       'soon_expiring_contracts': data['soon_expiring_contracts'],
//     };
//   }
//
//   void _updateState() {
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   String token = "";
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       token = context.read<AdminProvider>().admin.token;
//     });
//     final adminProvider = Provider.of<AdminProvider>(context, listen: false);
//     id_admin = adminProvider.admin.id;
//     _notification.cible = "Clients";
//     _dateFocusNode = FocusNode();
//     _unpaidContraClientsFuture = _controller.fetchUnpaidContraClients(token);
//     // _expiredContractsFuture = _controller.fetchExpiredContracts();
//     _expiredContractsFuture = _fetchContracts();
//     if(widget.notificationAdmin != null){
//       _subjectController.text = widget.notificationAdmin.sujet!;
//       _contentController.text = widget.notificationAdmin.contenu!;
//       _datePickerController.text = widget.notificationAdmin.dateEnvoye!;
//       //_notification.cible = widget.notificationAdmin.cible!;
//       _notification = widget.notificationAdmin;
//
//       var cible = widget.notificationAdmin.cible!;
//       if (cible == "Clients") {
//         setState(() {
//           _selectedReceiver = ReceiverType.client;
//         });
//         widget.clients.forEach((c) {
//           _selectedClients.add(c["id_client"]);
//         });
//       } else if (cible == "Contrats Impayes") {
//         setState(() {
//           _selectedReceiver = ReceiverType.unpaidContra;
//         });
//         widget.clients.forEach((c) {
//           _selectedUnpaid.add(c["id_client"]);
//         });
//       } else if (cible == "Contrats Expires") {
//         setState(() {
//           _selectedReceiver = ReceiverType.expiredContra;
//         });
//         widget.clients.forEach((c) {
//           _selectedExpired.add(c["id_client"]);
//         });
//       }
//     }
//   }
//
//   void updateCharacterCount(String value) {
//     setState(() {
//       _characterCount = value.length;
//     });
//   }
//
//   @override
//   void dispose() {
//     _datePickerController.dispose();
//     _dateFocusNode.dispose();
//     super.dispose();
//   }
//
//   Future<void> _showDatePicker() async {
//     _datePickerController.clear();
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//
//     if (pickedDate != null) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//
//       if (pickedTime != null) {
//         setState(() {
//           _selectedDate = DateTime(
//             pickedDate.year,
//             pickedDate.month,
//             pickedDate.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );
//           _datePickerController.text = _selectedDate.toString();
//           _notification.dateEnvoye = _selectedDate.toString();
//           print("date ${_datePickerController.text}");
//         });
//       }
//     }
//   }
//
//   // submit form for valid_notification table
//   Future<void> _submitValidForm() async {
//     setState(() {
//       _isSubmitting = true;
//       _submitSuccess = false;
//     });
//     _notification.idAdmin = id_admin;
//     _formKey.currentState!.save();
//     try {
//       // Submit the notification
//       await _controller.updateNotification(_notification.idNotif!,_notification, token);
//       if (_selectedReceiver == ReceiverType.client &&
//           _selectedClients.isNotEmpty) {
//         await _controller.addClients(_selectedClients, token);
//       } else if (_selectedReceiver == ReceiverType.unpaidContra &&
//           _selectedUnpaid.isNotEmpty) {
//         await _controller.addClients(_selectedUnpaid, token);
//       } else if (_selectedReceiver == ReceiverType.expiredContra &&
//           _selectedExpired.isNotEmpty) {
//         await _controller.addClients(_selectedExpired, token);
//       }
//       widget.onNotificationUpdated();
//
//       // check if the notification has been submitted successfully
//
//       // Set the submit success flag to true
//       if (mounted) {
//         setState(() {
//           _submitSuccess = true;
//         });
//       }
//     } catch (e) {
//       print(e.toString());
//     } finally {
//       // Set the submitting flag to false
//       setState(() {
//         _isSubmitting = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Modifier une notification'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Stepper(
//             currentStep: _currentStep,
//             onStepContinue: _handleContinue,
//             onStepCancel: _handleCancel,
//             physics: ClampingScrollPhysics(),
//             type: Responsive.isMobile(context)
//                 ? StepperType.vertical
//                 : StepperType.horizontal,
//             steps: [
//               _buildStep1(),
//               _buildStep2(),
//               _buildStep3(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Step _buildStep1() {
//     return Step(
//       title: Text('Sujet, contenu et date'),
//       content: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Entrez le sujet',
//                 icon: Icon(Icons.subject),
//                 iconColor: Colors.orange,
//               ),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'S\'il vous plaît entrer le sujet';
//                 }
//                 return null;
//               },
//               onSaved: (value) {
//                 _subjectController.text = value!;
//                 _notification.sujet = value;
//               },
//               controller: _subjectController,
//             ),
//             SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               child: SingleChildScrollView(
//                 controller: _scrollController,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       decoration: InputDecoration(
//                         labelText: 'Entrez le contenu',
//                         icon: Icon(Icons.content_paste),
//                         iconColor: Colors.orange,
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'S\'il vous plaît entrer le contenu';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _contentController.text = value.toString();
//                         _notification.contenu = value.toString();
//                       },
//                       controller: _contentController,
//                       onChanged: (value) {
//                         // Scroll to the end of the content whenever the text changes
//                         _scrollController
//                             .jumpTo(_scrollController.position.maxScrollExtent);
//                         updateCharacterCount(value);
//                       },
//                       maxLines: 5, // <-- SEE HERE
//                       minLines: 1,
//                       keyboardType: TextInputType.multiline,
//                     ),
//                     Container(
//                       // no padding
//                         padding: EdgeInsets.zero,
//                         alignment: Alignment.bottomRight,
//                         child: Text(
//                           '$_characterCount',
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: Colors.grey[600],
//                           ),
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             // dropdown button for selecting the cible
//
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Date',
//                 icon: Icon(Icons.date_range),
//                 iconColor: Colors.orange,
//               ),
//               controller: _datePickerController,
//               focusNode: _dateFocusNode, // add a FocusNode
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'S\'il vous plaît entrer la date';
//                 }
//                 return null;
//               },
//               onTap: () {
//                 _dateFocusNode.requestFocus(); // set focus to the field
//                 _showDatePicker();
//               },
//               readOnly: true,
//               onSaved: (value) => _notification.dateEnvoye = value.toString(),
//             ),
//           ],
//         ),
//       ),
//       isActive: _currentStep >= 0,
//       state: _currentStep == 0 ? StepState.editing : StepState.indexed,
//     );
//   }
//
//   void _clearSelectedClients() {
//     if (_selectedReceiver == ReceiverType.client) {
//       _selectedClients.clear();
//     } else if (_selectedReceiver == ReceiverType.unpaidContra) {
//       _selectedUnpaid.clear();
//     } else if (_selectedReceiver == ReceiverType.expiredContra) {
//       _selectedExpired.clear();
//     }
//   }
//
//   Step _buildStep2() {
//     return Step(
//       title: Text('Choisissez les destinataires'),
//       content: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (Responsive.isMobile(context))
//             DropdownButton<ReceiverType>(
//               value: _selectedReceiver,
//               onChanged: (ReceiverType? value) {
//                 setState(() {
//                   _selectedReceiver = value!;
//                   if (value == ReceiverType.client) {
//                     _notification.cible = "Clients";
//                   } else if (value == ReceiverType.unpaidContra) {
//                     _notification.cible = "Contrats Impayes";
//                   } else if (value == ReceiverType.expiredContra) {
//                     _notification.cible = "Contrats Expires";
//                   }
//                   _clearSelectedClients();
//                 });
//               },
//               items: [
//                 DropdownMenuItem(
//                   value: ReceiverType.client,
//                   child: Text('Tous les clients'),
//                 ),
//                 DropdownMenuItem(
//                   value: ReceiverType.unpaidContra,
//                   child: Text('Clients avec des contrats impayés'),
//                 ),
//                 DropdownMenuItem(
//                   value: ReceiverType.expiredContra,
//                   child: Text('Clients avec des contrats expirés'),
//                 ),
//               ],
//             ),
//           if (!Responsive.isMobile(context))
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Radio(
//                   value: ReceiverType.client,
//                   groupValue: _selectedReceiver,
//                   onChanged: (ReceiverType? value) {
//                     setState(() {
//                       _selectedReceiver = value!;
//                       _notification.cible = "Clients";
//                       //_selectedClients.clear();
//                     });
//                   },
//                 ),
//                 Text('Tous les clients'),
//                 Radio(
//                   value: ReceiverType.unpaidContra,
//                   groupValue: _selectedReceiver,
//                   onChanged: (ReceiverType? value) {
//                     setState(() {
//                       _selectedReceiver = value!;
//                       _notification.cible = "Contrats Impayes";
//                       //_selectedUnpaid.clear();
//                     });
//                   },
//                 ),
//                 Text('Clients avec des contrats impayés'),
//                 Radio(
//                   value: ReceiverType.expiredContra,
//                   groupValue: _selectedReceiver,
//                   onChanged: (ReceiverType? value) {
//                     setState(() {
//                       _selectedReceiver = value!;
//                       _notification.cible = "Contrats Expires";
//                       //_selectedExpired.clear();
//                     });
//                   },
//                 ),
//                 Text('Clients avec des contrats expirés'),
//               ],
//             ),
//           if (_selectedReceiver == ReceiverType.client) feCli(),
//           if (_selectedReceiver == ReceiverType.unpaidContra)
//             feUnpaidContraClients(),
//           if (_selectedReceiver == ReceiverType.expiredContra)
//             feExpiredContraClients(),
//         ],
//       ),
//       isActive: _currentStep >= 1,
//       state: _currentStep == 1 ? StepState.editing : StepState.indexed,
//     );
//   }
//
//   Step _buildStep3() {
//     return Step(
//       title: Text('Envoyer notification'),
//       content: Column(
//         children: [
//           SizedBox(height: 20.0),
//           // lenght of list of selected clients
//           if (_selectedReceiver == ReceiverType.client)
//             Text(
//               'Nombre de clients sélectionnés: ${_selectedClients.length}',
//               style: TextStyle(fontSize: 18.0),
//             ),
//           if (_selectedReceiver == ReceiverType.unpaidContra)
//             Text(
//               'Nombre de clients sélectionnés: ${_selectedUnpaid.length}',
//               style: TextStyle(fontSize: 18.0),
//             ),
//           if (_selectedReceiver == ReceiverType.expiredContra)
//             Text(
//               'Nombre de clients sélectionnés: ${_selectedExpired.length}',
//               style: TextStyle(fontSize: 18.0),
//             ),
//           // ElevatedButton(
//           //   child: Text('Send'),
//           //   onPressed: () async {
//           //     if (_formKey.currentState!.validate()) {
//           //       _formKey.currentState!.save();
//           //       _notification.idAdmin = id_admin;
//           //       try {
//           //         _submitValidForm();
//           //       } catch (e) {
//           //         ScaffoldMessenger.of(context)
//           //             .showSnackBar(SnackBar(content: Text(e.toString())));
//           //       }
//           //     }
//           //   },
//           // ),
//         ],
//       ),
//       isActive: _currentStep >= 2,
//     );
//   }
//
//   FutureBuilder<List<Client>> feCli() {
//     return FutureBuilder<List<Client>>(
//       future: _controller.fetchClients(token),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final List<Client> clients = snapshot.data!;
//           return Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         if (_selectedClients.length == clients.length) {
//                           _selectedClients.clear(); // Deselect all clients
//                         } else {
//                           _selectedClients = List.from(clients.map((client) =>
//                           client.id_client!)); // Select all clients
//                         }
//                       });
//                     },
//                     child: Text(_selectedClients.length == clients.length
//                         ? 'Deselect All'
//                         : 'Select All'),
//                   ),
//                 ],
//               ),
//               Container(
//                 height: 200,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: clients
//                         .map((client) => CheckboxListTile(
//                       title: Text(
//                           '${client.nom_client!} ${client.prenom_client!}'),
//                       value:
//                       _selectedClients.contains(client.id_client),
//                       onChanged: (bool? value) {
//                         setState(() {
//                           if (value == true) {
//                             _selectedClients.add(client.id_client!);
//                             print(
//                                 "selected clients: $_selectedClients");
//                           } else {
//                             _selectedClients.remove(client.id_client);
//                             print("removed clients: $_selectedClients");
//                           }
//                         });
//                       },
//                       checkColor: Colors.green,
//                       activeColor: Colors.green,
//                     ))
//                         .toList(),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         } else if (snapshot.hasError) {
//           return Text('Failed to load clients: ${snapshot.error}');
//         } else {
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }
//
//   FutureBuilder<List<dynamic>> feUnpaidContraClients() {
//     return FutureBuilder<List<dynamic>>(
//       future: _unpaidContraClientsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text(
//               'Failed to load unpaid contra clients: ${snapshot.error}');
//         } else if (snapshot.data!.isEmpty) {
//           return Text('il n\'y a pas de clients avec des contrats impayés');
//         } else if (snapshot.hasData) {
//           final List<dynamic> unpaidClients = snapshot.data!;
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   // single button select all/ deselect all
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         if (_selectedUnpaid.length == unpaidClients.length) {
//                           _selectedUnpaid.clear();
//                         } else {
//                           _selectedUnpaid.clear();
//                           _selectedUnpaid.addAll(unpaidClients
//                               .map((client) => client['id_client'] as int));
//                         }
//                       });
//                     },
//                     child: Text(
//                       _selectedClients.length == unpaidClients.length
//                           ? 'Deselect all'
//                           : 'Select all',
//                     ),
//                   )
//                 ],
//               ),
//               Container(
//                 height: 200,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: unpaidClients
//                         .map((client) => ListTile(
//                       title: Text('${client['nom_client']}'),
//                       subtitle: Text(
//                           'Reste: ${client['total_reste']}, Nombre de contrats: ${client['num_contrats']}'),
//                       trailing: Checkbox(
//                         value: _selectedUnpaid
//                             .contains(client['id_client'] as int),
//                         onChanged: (bool? value) {
//                           setState(() {
//                             if (value == true) {
//                               _selectedUnpaid
//                                   .add(client['id_client'] as int);
//                               print(
//                                   "selected clients: $_selectedUnpaid");
//                             } else {
//                               _selectedUnpaid
//                                   .remove(client['id_client'] as int);
//                               print(
//                                   "removed clients: $_selectedUnpaid");
//                             }
//                           });
//                         },
//                         checkColor: Colors.green,
//                         activeColor: Colors.green,
//                       ),
//                     ))
//                         .toList(),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }
//
//   FutureBuilder<Map<String, dynamic>> feExpiredContraClients() {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: _expiredContractsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Failed to load expired contracts: ${snapshot.error}');
//         } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//           return Text('No expired contracts');
//         } else {
//           final Map<String, dynamic> expiringContracts =
//           snapshot.data!['expiring_contracts'];
//           final List<dynamic> expiredContracts = expiringContracts.values
//               .expand((contracts) => contracts)
//               .toList();
//
//           final Map<String, int> clientContractCounts = {};
//           expiredContracts.forEach((contract) {
//             final String clientName = expiringContracts.keys.firstWhere(
//                     (key) => expiringContracts[key]!.contains(contract));
//             clientContractCounts[clientName] =
//                 (clientContractCounts[clientName] ?? 0) + 1;
//           });
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         if (_selectedExpired.length ==
//                             expiredContracts.length) {
//                           _selectedExpired.clear();
//                         } else {
//                           _selectedExpired = expiredContracts
//                               .map((contract) =>
//                               int.parse(contract['id_client'].toString()))
//                               .toList();
//                         }
//                       });
//                     },
//                     child: Text(
//                       _selectedExpired.length == expiredContracts.length
//                           ? 'Deselect All'
//                           : 'Select All',
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 height: 200,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: clientContractCounts.entries.map((entry) {
//                       final String clientName = entry.key;
//                       final int contractCount = entry.value;
//                       return CheckboxListTile(
//                         title: Text(clientName),
//                         subtitle: Text('$contractCount contrat(s) expiré(s)'),
//                         value: _selectedExpired.contains(int.parse(
//                             expiringContracts[clientName][0]['id_client']
//                                 .toString())),
//                         onChanged: (bool? value) {
//                           setState(() {
//                             if (value == true) {
//                               _selectedExpired.add(int.parse(
//                                   expiringContracts[clientName][0]['id_client']
//                                       .toString()));
//                               print("selected clients: $_selectedExpired");
//                             } else {
//                               _selectedExpired.remove(int.parse(
//                                   expiringContracts[clientName][0]['id_client']
//                                       .toString()));
//                               print("remove clients: $_selectedExpired");
//                             }
//                           });
//                         },
//                         checkColor: Colors.green,
//                         activeColor: Colors.green,
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }
//       },
//     );
//   }
//
//   void checkSelectionAndContinue() {
//     /*if (_selectedReceiver == ReceiverType.client && _selectedClients.isEmpty) {
//       // User selected "Tous les clients" group, but no clients are selected
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Veuillez sélectionner au moins un client.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }
//
//     if (_selectedReceiver == ReceiverType.unpaidContra &&
//         _selectedUnpaid.isEmpty) {
//       // User selected "Clients avec des contrats expirés" group, but no clients are selected
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text(
//               'Veuillez sélectionner au moins un client avec des contrats expirés.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }
//
//     if (_selectedReceiver == ReceiverType.expiredContra &&
//         _selectedExpired.isEmpty) {
//       // User selected "Clients avec des contrats impayés" group, but no clients are selected
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text(
//               'Veuillez sélectionner au moins un client avec des contrats impayés.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }
// $*/
//     // All checks passed, proceed to the next step
//     setState(() {
//       _currentStep += 1;
//     });
//   }
//
//   Future<void> _handleContinue() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     switch (_currentStep) {
//       case 0:
//         setState(() {
//           _currentStep++;
//         });
//         break;
//       case 1:
//         setState(() {
//           checkSelectionAndContinue();
//         });
//         break;
//       case 2:
//         try {
//           await _submitValidForm();
//           if (_submitSuccess) {
//             showDialog(
//               barrierDismissible: false,
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: Text('Succès'),
//                 content: Text('Notification a été modifée avec succès.'),
//                 icon: Icon(Icons.check, color: Colors.green),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       // Reset form
//                       _formKey.currentState?.reset();
//                       _notification = NotificationAdmin();
//                       _selectedClients = [];
//                       _selectedUnpaid = [];
//                       _selectedExpired = [];
//                       _currentStep = 0;
//                       _submitSuccess = false;
//                       _clearSelectedClients();
//
//                       // Navigate to the NotificationsPage
//                       Navigator.of(context).pop();
//                       Navigator.of(context).pushNamed('/notification');
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('La notification n\'a pas été envoyée.')),
//             );
//           }
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: $e')),
//           );
//         }
//         break;
//       default:
//         break;
//     }
//   }
//
//   void _handleCancel() {
//     if (_currentStep > 0) {
//       setState(() {
//         _currentStep--;
//       });
//     } else {
//       Navigator.of(context).pop();
//     }
//   }
//
// // Widget _buildSubmitSuccessView() {
// //   return Center(
// //     child: Column(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         Icon(
// //           Icons.check_circle,
// //           color: Colors.green,
// //           size: 50.0,
// //         ),
// //         SizedBox(height: 20.0),
// //         Text(
// //           'Notification submitted successfully!',
// //           style: TextStyle(fontSize: 20.0),
// //         ),
// //         SizedBox(height: 20.0),
// //         ElevatedButton(
// //           onPressed: () {
// //             // Reset form
// //             _formKey.currentState?.reset();
// //             _notification = NotificationAdmin();
// //             _selectedClients = [];
// //             _selectedUnpaid = [];
// //             _selectedExpired = [];
// //             _currentStep = 0;
// //             _submitSuccess = false;
//
// //             // kill step by step form
// //             Navigator.of(context).pop();
// //           },
// //           child: Text('Add another notification'),
// //         ),
// //       ],
// //     ),
// //   );
// // }
// }
