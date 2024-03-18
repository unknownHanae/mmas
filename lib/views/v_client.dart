// import 'package:adminmmas/models/m_client.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:dio/dio.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:intl/intl.dart';
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:html' as html;
// import 'package:http_parser/http_parser.dart';
// import 'dart:ui' as ui;
//
// import '../providers/p_client.dart';
// import '../widgets/navigation_bar.dart';
//
// class ClientPage extends StatefulWidget {
//   const ClientPage({Key? key}) : super(key: key);
//
//   @override
//   State<ClientPage> createState() => _ClientPageState();
// }
//
// class _ClientPageState extends State<ClientPage> {
//   final ClientController clientController = Get.put(ClientController());
//   // final TextEditingController _idclientController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _prenomController = TextEditingController();
//   final TextEditingController _adresseController = TextEditingController();
//   final TextEditingController _telController = TextEditingController();
//   final TextEditingController _mailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _cinController = TextEditingController();
//   final TextEditingController _villeController = TextEditingController();
//   final TextEditingController _datenaissanceController =
//       TextEditingController();
//
//   final TextEditingController _dateinscriptionController =
//       TextEditingController();
//   final TextEditingController _statutController = TextEditingController();
//   final List<bool> _values = [false, true];
//   bool getStatut() {
//     return _statutController.text == 'Actif';
//   }
//
//   final TextEditingController _blacklisteController = TextEditingController();
//   bool getBlackliste() {
//     return _blacklisteController.text == 'Actif';
//   }
//
//   // final TextEditingController _imageController = TextEditingController();
//   ///////////
//
//   ///////////
//   String _searchKeyword = '';
//
//   @override
//   void initState() {
//     super.initState();
//     clientController.fetchClients();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(color: Colors.grey[200]),
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Row(
//             children: [
//               SideBar(postion: 1,),
//               SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                     child: Container(
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(20),
//                                       color: Colors.grey[200],
//                                       border: Border.all(color: Colors.orange)),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(3.0),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         InkWell(
//                                           child: Container(
//                                             width: 33,
//                                             height: 33,
//                                             child: Icon(
//                                               Icons.search,
//                                               color: Colors.white,
//                                             ),
//                                             decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: Colors.orange),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Container(
//                                             height: 30,
//                                             child: TextField(
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   _searchKeyword = value;
//                                                 });
//                                               },
//                                               decoration: InputDecoration(
//                                                 labelText: 'Chercher',
//                                                 border: OutlineInputBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20)),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 )),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Container(
//                                   child: Icon(
//                                     Icons.add_alert_outlined,
//                                     size: 20,
//                                   ),
//                                   height: 40,
//                                   width: 40,
//                                   decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.grey[200],
//                                       border: Border.all(color: Colors.orange)),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Container(
//                                   width: 40,
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                       shape: BoxShape.rectangle,
//                                       borderRadius: BorderRadius.circular(20),
//                                       color: Colors.grey[200]),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text("Client",
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w700,
//                                         color: Colors.grey)),
//                                 InkWell(
//                                   child: Container(
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                         color: Colors.blue[200],
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Center(
//                                         child: ElevatedButton(
//                                           onPressed: () async {
//                                             await _showAddDialog();
//                                           },
//                                           child: Text('Ajouter'),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 40,
//                             ),
//                             Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: Align(
//                                   alignment: Alignment.topLeft,
//                                   child: Obx(
//                                     () => clientController.isLoading.value
//                                         ? Align(
//                                             alignment: Alignment.topLeft,
//                                             child: CircularProgressIndicator())
//                                         : _buildClientTable(),
//                                   ),
//                                 )),
//
//                             // Expanded(
//                             //     child: Container(
//                             //   decoration: BoxDecoration(
//                             //     color: Colors.black,
//                             //     borderRadius: BorderRadius.circular(15),
//                             //   ),
//                             // )
//                             //     // Obx(
//                             //     //   () => clientController.isLoading.value
//                             //     //       ? Center(child: CircularProgressIndicator())
//                             //     //       : _buildClientTable(),
//                             //     // ),
//                             //     ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   PlatformFile? objFile;
//   String image_path = "";
//   Uint8List? _bytesData;
//   List<int>? _selectedFile;
//   Future<void> _dialogBuilder(Clients client) {
//     return showDialog<void>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           title: Text('Client'),
//           content: Column(children: [
//             Image(
//                 image: NetworkImage(
//                     '${"http://127.0.0.1:8000"}/media/${client.image.toString()}')),
//             Text('ID :' + client.idClient.toString()),
//             Text('Adresse :' + client.adresse),
//             Text('Phone :' + client.tel),
//             Text('Email :' + client.mail),
//             Text('Password :' + client.password),
//             Text('CIN :' + client.cin),
//             Text('Ville' + client.ville),
//             Text(client.dateNaissance != null
//                 ? 'Date de Naissance' +
//                     DateFormat('yyyy-MM-dd').format(client.dateNaissance!)
//                 : ''),
//             Text(client.dateNaissance != null
//                 ? DateFormat('yyyy-MM-dd').format(client.dateInscription!)
//                 : ''),
//             Text(client.statut.toString()),
//             Text(client.blackliste.toString()),
//           ]),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Annuler'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future cameraImage(context) async {
//     try {
//       html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
//       uploadInput.multiple = true;
//       uploadInput.draggable = true;
//       uploadInput.click();
//
//       uploadInput.onChange.listen((event) {
//         final files = uploadInput.files;
//         final file = files![0];
//         final reader = html.FileReader();
//
//         reader.onLoadEnd.listen((event) async {
//           _bytesData =
//               Base64Decoder().convert(reader.result.toString().split(",").last);
//           _selectedFile = _bytesData;
//           var url = Uri.parse("http://127.0.0.1:8000" + "/api/saveImage/");
//           var request = http.MultipartRequest("POST", url);
//           request.files.add(await http.MultipartFile.fromBytes(
//               'uploadedFile', _selectedFile!,
//               contentType: MediaType("application", "json"),
//               filename: "image-client"));
//           request.fields["path"] = "client/";
//
//           var response = await request.send();
//           var responseData = await response.stream.toBytes();
//           var responseString = String.fromCharCodes(responseData);
//           final body = Map<String, dynamic>.from(json.decode(responseString));
//           print(responseString);
//
//           if (response.statusCode == 200) {
//             setState(() {
//               image_path = body['path'];
//             });
//           } else {
//             final snackBar = SnackBar(
//               content: const Text('Please try again'),
//               action: SnackBarAction(
//                 label: 'Close',
//                 onPressed: () {
//                   // Some code to undo the change.
//                 },
//               ),
//             );
//             ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           }
//         });
//         reader.readAsDataUrl(file);
//       });
//     } catch (error) {
//       print(error);
//     }
//   }
//
//   Future<void> _showAddDialog() async {
//     // final _statutController = selectedValue.getSelected()?.getValue();
//     // _idclientController.clear();
//     _nameController.clear();
//     _prenomController.clear();
//     _adresseController.clear();
//     _telController.clear();
//     _mailController.clear();
//     _passwordController.clear();
//     _cinController.clear();
//     _villeController.clear();
//     _datenaissanceController.clear();
//     _dateinscriptionController.clear();
//     _statutController.clear();
//     _blacklisteController.clear();
//     // _imageController.clear();
//
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Ajouter Client'),
//           content:
//               Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//             Expanded(
//                 child: Column(children: [
//               // TextField(
//               //   controller: _idclientController,
//               //   decoration: InputDecoration(
//               //     labelText: 'id',
//               //     border: OutlineInputBorder(),
//               //   ),
//               // ),
//               SizedBox(
//                 height: 10,
//               ),
//               TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: 'Nom',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       borderSide: BorderSide(),
//                     ),
//                   )),
//               SizedBox(
//                 height: 10,
//               ),
//               TextField(
//                 controller: _prenomController,
//                 decoration: InputDecoration(
//                   labelText: 'Prenom',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               TextField(
//                 controller: _adresseController,
//                 decoration: InputDecoration(
//                   labelText: 'Adresse',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               TextField(
//                 controller: _telController,
//                 decoration: InputDecoration(
//                   labelText: 'Numero de telephone',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               TextField(
//                 controller: _mailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 width: 300,
//                 child: TextField(
//                   controller: _cinController,
//                   decoration: InputDecoration(
//                     labelText: 'CIN',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//             ]).paddingOnly(right: 20.0)),
//             Expanded(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextField(
//                     controller: _villeController,
//                     decoration: InputDecoration(
//                       labelText: 'ville',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextField(
//                     controller: _datenaissanceController,
//                     decoration: InputDecoration(
//                       icon: Icon(Icons.calendar_today),
//                       labelText: 'Date de naissance',
//                       border: OutlineInputBorder(),
//                     ),
//                     readOnly: true,
//                     onTap: () async {
//                       DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2101),
//                       );
//                       if (pickedDate != null) {
//                         String formattedDate =
//                             DateFormat("yyyy-MM-dd").format(pickedDate);
//                         setState(() {
//                           _datenaissanceController.text =
//                               formattedDate.toString();
//                         });
//                       } else {
//                         print('Not selected');
//                       }
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextField(
//                     controller: _dateinscriptionController,
//                     decoration: InputDecoration(
//                       icon: Icon(Icons.calendar_today),
//                       labelText: 'Date d\'nscription',
//                       border: OutlineInputBorder(),
//                     ),
//                     readOnly: true,
//                     onTap: () async {
//                       DateTime? pickedDat = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2101),
//                       );
//                       if (pickedDat != null) {
//                         String formattedDat =
//                             DateFormat('yyyy-MM-dd').format(pickedDat);
//                         setState(() {
//                           _dateinscriptionController.text =
//                               formattedDat.toString();
//                         });
//                       } else {
//                         print('Not selected');
//                       }
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   DropdownButtonFormField<bool>(
//                     value: null,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         _statutController.text = value! ? 'Actif' : 'Inactif';
//                       });
//                     },
//                     items: _values.map((bool value) {
//                       return DropdownMenuItem<bool>(
//                         value: value,
//                         child: Text(value ? 'Actif' : 'Inactif'),
//                       );
//                     }).toList(),
//                     decoration: InputDecoration(
//                       labelText: 'Status',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Please select a status';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   DropdownButtonFormField<bool>(
//                     value: null,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         _blacklisteController.text =
//                             value! ? 'Actif' : 'Inactif';
//                       });},
//
//                     items: _values.map((bool value) {
//                       return DropdownMenuItem<bool>(
//                         value: value,
//                         child: Text(value ? 'Actif' : 'Inactif'),
//                       );
//                     }).toList(),
//                     decoration: InputDecoration(
//                       labelText: 'blackliste',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Please select a status';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       cameraImage(context);
//                     },
//                     child: Container(
//                       width: 50,
//                       height: 30,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6),
//                           color: Colors.blue),
//                       child: Icon(Icons.camera_alt_outlined,
//                           size: 25, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ).paddingOnly(left: 20.0),
//             )
//           ]),
//           actions: [
//             ButtonBar(
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     if (
//                         //_idclientController.text.isNotEmpty &&
//                         _nameController.text.isEmpty &&
//                             _prenomController.text.isNotEmpty &&
//                             _adresseController.text.isNotEmpty &&
//                             _telController.text.isNotEmpty &&
//                             _mailController.text.isNotEmpty &&
//                             _passwordController.text.isNotEmpty &&
//                             _cinController.text.isNotEmpty &&
//                             _villeController.text.isNotEmpty &&
//                             _datenaissanceController.text.isNotEmpty &&
//                             _dateinscriptionController.text.isNotEmpty &&
//                             _statutController.text.isNotEmpty &&
//                             _blacklisteController.text.isNotEmpty
//                         // &&
//                         // _imageController.text.isNotEmpty
//                         ) {
//                       return;
//                     }
//
//                     final client = Clients(
//                         // idClient: int.parse(_idclientController.text),
//                         nomClient: _nameController.text,
//                         prenomClient: _prenomController.text,
//                         adresse: _adresseController.text,
//                         tel: _telController.text,
//                         mail: _mailController.text,
//                         password: _passwordController.text,
//                         cin: _cinController.text,
//                         ville: _villeController.text,
//                         dateNaissance:
//                             DateTime.parse(_datenaissanceController.text),
//                         dateInscription:
//                             DateTime.parse(_dateinscriptionController.text),
//                         // statut: _statutController.getSelected()?.getValue() != null,
//                         statut: getStatut(),
//                         blackliste: getBlackliste(),
//
//                         // upload the image to the storage and get the download URL
//
//                         image: image_path);
//
//                     await clientController.addClient(client);
//                     await clientController.fetchClients();
//                     Navigator.pop(context);
//                     setState(() {
//                       _searchKeyword = '';
//                     });
//                   },
//                   child: Text('Ajouter'),
//                 ),
//               ],
//             )
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildClientTable() {
//     final clients = clientController.clients.where((client) =>
//         client.nomClient.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
//         client.prenomClient
//             .toLowerCase()
//             .contains(_searchKeyword.toLowerCase()) ||
//         client.adresse.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
//         client.tel.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
//         client.ville.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
//         client.dateNaissance
//             .toString()
//             .toLowerCase()
//             .contains(_searchKeyword.toLowerCase()) ||
//         client.dateInscription
//             .toString()
//             .toLowerCase()
//             .contains(_searchKeyword.toLowerCase()) ||
//         client.statut
//             .toString()
//             .toLowerCase()
//             .contains(_searchKeyword.toLowerCase()) ||
//         client.blackliste
//             .toString()
//             .toLowerCase()
//             .contains(_searchKeyword.toLowerCase()) ||
//         client.image.toLowerCase().contains(_searchKeyword.toLowerCase()));
//     return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//             columns: [
//               DataColumn(
//                   label: Text('image',
//                       style: TextStyle(fontWeight: FontWeight.bold))),
//               // DataColumn(label: Text('ID')),
//               DataColumn(
//                   label: Text('Nom',
//                       style: TextStyle(fontWeight: FontWeight.bold))),
//               // DataColumn(
//               //     label: Text('Prenom',
//               //         style: TextStyle(fontWeight: FontWeight.bold))),
//               DataColumn(
//                   label: Text('adresse',
//                       style: TextStyle(fontWeight: FontWeight.bold))),
//               DataColumn(
//                   label: Text('Télephone',
//                       style: TextStyle(fontWeight: FontWeight.bold))),
//               DataColumn(
//                   label: Text('Email',
//                       style: TextStyle(fontWeight: FontWeight.bold))),
//               // DataColumn(label: Text('password',
//               // style: TextStyle(fontWeight: FontWeight.bold))),
//               // DataColumn(label: Text('cin',
//               // style: TextStyle(fontWeight: FontWeight.bold))),
//               DataColumn(
//                   label: Text('Ville',
//                       style: TextStyle(fontWeight: FontWeight.bold))),
//               DataColumn(
//                   label: Text('Date_naissance',
//                       style: TextStyle(fontWeight: FontWeight.bold))),
//               // DataColumn(label: Text('date_inscription',
//               // style: TextStyle(fontWeight: FontWeight.bold))),
//               // DataColumn(label: Text('statut',
//               // style: TextStyle(fontWeight: FontWeight.bold))),
//               // DataColumn(label: Text('blackliste',
//               // style: TextStyle(fontWeight: FontWeight.bold))),
//
//               DataColumn(
//                   label: Text('Action',
//                       style: TextStyle(fontWeight: FontWeight.bold))),
//             ],
//             rows: clients
//                 .map((client) => DataRow(cells: [
//                       // DataCell(Text(client.id_Client.toString())),
//                       DataCell(
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.grey[200],
//                               image: DecorationImage(
//                                   fit: BoxFit.cover,
//                                   image: NetworkImage(
//                                       '${"http://127.0.0.1:8000"}/media/${client.image.toString()}'))),
//                         ),
//                       ),
//                       DataCell(
//                           Text(client.nomClient + '  ' + client.prenomClient)),
//                       // DataCell(Text(client.prenomClient)),
//                       DataCell(Text(client.adresse)),
//                       DataCell(Text(client.tel)),
//                       DataCell(Text(client.mail)),
//                       // DataCell(Text(client.password)),
//                       // DataCell(Text(client.cin)),
//                       DataCell(Text(client.ville)),
//                       DataCell(Text(client.dateNaissance != null
//                           ? DateFormat('yyyy-MM-dd')
//                               .format(client.dateNaissance!)
//                           : '')),
//                       // DataCell(Text(client.date_inscription.toString())),
//                       // DataCell(Text(client.statut.toString())),
//                       // DataCell(Text(client.blackliste.toString())),
//
//                       DataCell(Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(
//                               Icons.contact_page,
//                               color: Colors.blue,
//                             ),
//                             onPressed: () async {
//                               await _dialogBuilder(client);
//                               setState(() {
//                                 _searchKeyword = '';
//                               });
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.edit, color: Colors.green),
//                             onPressed: () async {
//                               await _showEditDialog(client);
//                               setState(() {
//                                 _searchKeyword = '';
//                               });
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () async {
//                               await _showDeleteDialog(client);
//                               setState(() {
//                                 _searchKeyword = '';
//                               });
//                             },
//                           ),
//                         ],
//                       )),
//                     ]))
//                 .toList()));
//   }
//
//   Future<void> _showEditDialog(Clients client) async {
//     final TextEditingController controller =
//         TextEditingController(text: client.nomClient);
//
//     final TextEditingController prenomController =
//         TextEditingController(text: client.prenomClient);
//     final TextEditingController adresseController =
//         TextEditingController(text: client.adresse);
//     final TextEditingController telController =
//         TextEditingController(text: client.tel);
//     final TextEditingController mailController =
//         TextEditingController(text: client.mail);
//     final TextEditingController passwordController =
//         TextEditingController(text: client.password);
//     final TextEditingController cinController =
//         TextEditingController(text: client.cin);
//     final TextEditingController villeController =
//         TextEditingController(text: client.ville);
//     final TextEditingController dateNaissanceController = TextEditingController(
//         text: client.dateNaissance != null
//             ? DateFormat('yyyy-MM-dd').format(client.dateNaissance!)
//             : '');
//     final TextEditingController dateInscriptionController =
//         TextEditingController(
//             text: client.dateInscription != null
//                 ? DateFormat('yyyy-MM-dd').format(client.dateInscription!)
//                 : '');
//     final TextEditingController statutController =
//         TextEditingController(text: client.statut.toString());
//     final TextEditingController blacklisteController =
//         TextEditingController(text: client.statut.toString());
//     bool _getStatut() {
//       return statutController.text == 'True';
//     }
//
//     bool _getBlackliste() {
//       return blacklisteController.text == 'True';
//     }
//
//     // final TextEditingController imageController =
//     //     TextEditingController(text: client.image);
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Modifier Client'),
//           content: Row(children: [
//             Expanded(
//                 child: Column(children: [
//               SizedBox(
//                 height: 15,
//               ),
//               TextField(
//                 controller: controller,
//                 decoration: InputDecoration(
//                   labelText: 'Nom',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextField(
//                 controller: prenomController,
//                 decoration: InputDecoration(
//                   labelText: 'Prenom',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextField(
//                 controller: adresseController,
//                 decoration: InputDecoration(
//                   labelText: 'Adresse',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextField(
//                 controller: telController,
//                 decoration: InputDecoration(
//                   labelText: 'Numero de telephone',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextField(
//                 controller: mailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextField(
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 width: 300,
//                 child: TextField(
//                   controller: cinController,
//                   decoration: InputDecoration(
//                     labelText: 'CIN',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//             ]).paddingOnly(right: 20.0)),
//             Expanded(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 15,
//                   ),
//                   TextField(
//                     controller: villeController,
//                     decoration: InputDecoration(
//                       labelText: 'Client ville',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   TextField(
//                     controller: dateNaissanceController,
//                     decoration: InputDecoration(
//                       icon: Icon(Icons.calendar_today),
//                       labelText: 'Date de naissance',
//                       border: OutlineInputBorder(),
//                     ),
//                     readOnly: true,
//                     onTap: () async {
//                       DateTime? pickedDa = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2101),
//                       );
//                       if (pickedDa != null) {
//                         String formattedDate =
//                             DateFormat("yyyy-MM-dd").format(pickedDa);
//                         setState(() {
//                           dateNaissanceController.text =
//                               formattedDate.toString();
//                         });
//                       } else {
//                         print('Not selected');
//                       }
//                     },
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   TextField(
//                     controller: dateInscriptionController,
//                     decoration: InputDecoration(
//                       icon: Icon(Icons.calendar_today),
//                       labelText: 'Date d\'inscription',
//                       border: OutlineInputBorder(),
//                     ),
//                     readOnly: true,
//                     onTap: () async {
//                       DateTime? pickeD = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2101),
//                       );
//                       if (pickeD != null) {
//                         String formattedDate =
//                             DateFormat("yyyy-MM-dd").format(pickeD);
//                         setState(() {
//                           dateInscriptionController.text =
//                               formattedDate.toString();
//                         });
//                       } else {
//                         print('Not selected');
//                       }
//                     },
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   DropdownButtonFormField<bool>(
//                     value: null,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         statutController.text = value! ? 'True' : 'False';
//                       });
//                     },
//                     items: _values.map((bool value) {
//                       return DropdownMenuItem<bool>(
//                         value: value,
//                         child: Text(value ? 'True' : 'False'),
//                       );
//                     }).toList(),
//                     decoration: InputDecoration(
//                       labelText: 'Status',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Please select a status';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   DropdownButtonFormField<bool>(
//                     value: null,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         blacklisteController.text = value! ? 'True' : 'False';
//                       });
//                     },
//                     items: _values.map((bool value) {
//                       return DropdownMenuItem<bool>(
//                         value: value,
//                         child: Text(value ? 'True' : 'False'),
//                       );
//                     }).toList(),
//                     decoration: InputDecoration(
//                       labelText: 'Blackliste',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Please select a status';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       cameraImage(context);
//                     },
//                     child: Container(
//                       width: 50,
//                       height: 30,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6),
//                           color: Colors.blue),
//                       child: Icon(Icons.camera_alt_outlined,
//                           size: 25, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ).paddingOnly(left: 20.0),
//             )
//           ]),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Annuler'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 client.nomClient = controller.text;
//                 client.prenomClient = prenomController.text;
//                 client.adresse = adresseController.text;
//                 client.tel = telController.text;
//                 client.mail = mailController.text;
//                 client.password = passwordController.text;
//                 client.cin = cinController.text;
//                 client.ville = villeController.text;
//
//                 client.dateNaissance =
//                     DateTime.parse(dateNaissanceController.text);
//                 client.dateInscription =
//                     DateTime.parse(dateInscriptionController.text);
//                 // client.statut = statutController.text.toLowerCase() == '1';
//                 // client.blackliste =
//                 //     blacklisteController.text.toLowerCase() == '0';
//                 client.statut = _getStatut();
//                 client.blackliste = _getBlackliste();
//                 client.image = image_path;
//                 await clientController.updateClient(client);
//                 Navigator.pop(context);
//               },
//               child: Text('Modifier'),
//             ),
//           ],
//         );
//       },
//     );
//     setState(() {
//       _searchKeyword = '';
//     });
//   }
//
//   Future<void> _showDeleteDialog(Clients client) async {
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Supprimer Client'),
//           content: Text('Êtes-vous sûr de vouloir supprimer ce client ?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Annuler'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await clientController.deleteClient(client.idClient);
//                 Navigator.pop(context);
//               },
//               child: Text('Supprimer'),
//             ),
//           ],
//         );
//       },
//     );
//     setState(() {
//       _searchKeyword = '';
//     });
//   }
// }
