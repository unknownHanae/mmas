//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:html' as html;
// import 'package:http_parser/http_parser.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:dio/dio.dart';
//
// import '../models/m_coach.dart';
// import '../providers/p_coach.dart';
// import '../widgets/navigation_bar.dart';
//
// class CoachPage extends StatefulWidget {
//   const CoachPage({Key? key}) : super(key: key);
//
//   @override
//   State<CoachPage> createState() => _CoachPageState();
// }
//
// class _CoachPageState extends State<CoachPage> {
//   final CoachController coachController = Get.put(CoachController());
//   // final TextEditingController _idcoachController = TextEditingController();
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
//   final TextEditingController _datedentreeController = TextEditingController();
//   final TextEditingController _statutController = TextEditingController();
//   final List<bool> _values = [false, true];
//   bool getStatut() {
//     return _statutController.text == 'Actif';
//   }
//
//   final TextEditingController _imageController = TextEditingController();
//   ///////////
//
//   ///////////
//   String _searchKeyword = '';
//
//   @override
//   void initState() {
//     super.initState();
//     coachController.fetchCoachs();
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
//              SideBar(postion: 3,),
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
//                                 Text("Coach",
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
//                                     () => coachController.isLoading.value
//                                         ? Align(
//                                             alignment: Alignment.topLeft,
//                                             child: CircularProgressIndicator())
//                                         : _buildCoachTable(),
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
//                             //     //   () => coachController.isLoading.value
//                             //     //       ? Center(child: CircularProgressIndicator())
//                             //     //       : _buildCoachTable(),
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
//   // PlatformFile? objFile;
//   String image_path = "";
//   Uint8List? _bytesData;
//   List<int>? _selectedFile;
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
//           var url = Uri.parse("http://192.168.11.103:8000" + "/api/saveImage/");
//           var request = http.MultipartRequest("POST", url);
//           request.files.add(await http.MultipartFile.fromBytes(
//               'uploadedFile', _selectedFile!,
//               contentType: MediaType("application", "json"),
//               filename: "image-coach"));
//           request.fields["path"] = "coach/";
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
//     // _idcoachController.clear();
//     _nameController.clear();
//     _prenomController.clear();
//     _adresseController.clear();
//     _telController.clear();
//     _mailController.clear();
//     _passwordController.clear();
//     _cinController.clear();
//     _villeController.clear();
//     _datenaissanceController.clear();
//     _datedentreeController.clear();
//     _statutController.clear();
//
//     _imageController.clear();
//
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Ajouter Coach'),
//           content: Row(children: [
//             Expanded(
//                 child: Column(children: [
//               // TextField(
//               //   controller: _idcoachController,
//               //   decoration: InputDecoration(
//               //     labelText: 'id',
//               //     border: OutlineInputBorder(),
//               //   ),
//               // ),
//               SizedBox(
//                 height: 15,
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
//                 height: 15,
//               ),
//               TextField(
//                 controller: _prenomController,
//                 decoration: InputDecoration(
//                   labelText: 'Prenom',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextField(
//                 controller: _adresseController,
//                 decoration: InputDecoration(
//                   labelText: 'Adresse',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextField(
//                 controller: _telController,
//                 decoration: InputDecoration(
//                   labelText: 'Numero de telephone',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextField(
//                 controller: _mailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//
//             ]).paddingOnly(right: 20.0)),
//             Expanded(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Container(
//                     width: 300,
//                     child: TextField(
//                       controller: _cinController,
//                       decoration: InputDecoration(
//                         labelText: 'CIN',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   TextField(
//                     controller: _villeController,
//                     decoration: InputDecoration(
//                       labelText: 'ville',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
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
//                     height: 15,
//                   ),
//                   TextField(
//                     controller: _datedentreeController,
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
//                           _datedentreeController.text = formattedDat.toString();
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
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (
//                     //_idcoachController.text.isNotEmpty &&
//                     _nameController.text.isEmpty &&
//                         _prenomController.text.isNotEmpty &&
//                         _adresseController.text.isNotEmpty &&
//                         _telController.text.isNotEmpty &&
//                         _mailController.text.isNotEmpty &&
//                         _passwordController.text.isNotEmpty &&
//                         _cinController.text.isNotEmpty &&
//                         _villeController.text.isNotEmpty &&
//                         _datenaissanceController.text.isNotEmpty &&
//                         _datedentreeController.text.isNotEmpty &&
//                         _statutController.text.isNotEmpty &&
//                         _imageController.text.isNotEmpty) {
//                   return;
//                 }
//
//                 final coach = Coach(
//                     // idCoach: int.parse(_idcoachController.text),
//                     nomCoach: _nameController.text,
//                     prenomCoach: _prenomController.text,
//                     adresse: _adresseController.text,
//                     tel: _telController.text,
//                     mail: _mailController.text,
//                     cin: _cinController.text,
//                     dateNaissance:
//                         DateTime.parse(_datenaissanceController.text),
//                     datedentree: DateTime.parse(_datedentreeController.text),
//                     // statut: _statutController.getSelected()?.getValue() != null,
//                     statut: getStatut(),
//                     password: _passwordController.text,
//                     image: image_path,
//                     ville: _villeController.text);
//
//                 await coachController.addCoach(coach);
//                 await coachController.fetchCoachs();
//                 Navigator.pop(context);
//                 setState(() {
//                   _searchKeyword = '';
//                 });
//               },
//               child: Text('Ajouter'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildCoachTable() {
//     final coachs = coachController.coachs.where((coach) =>
//         coach.nomCoach.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
//         coach.prenomCoach
//             .toLowerCase()
//             .contains(_searchKeyword.toLowerCase()) ||
//         coach.adresse.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
//         coach.tel.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
//         coach.ville.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
//         coach.dateNaissance
//             .toString()
//             .toLowerCase()
//             .contains(_searchKeyword.toLowerCase()) ||
//         coach.datedentree
//             .toString()
//             .toLowerCase()
//             .contains(_searchKeyword.toLowerCase()) ||
//         coach.statut
//             .toString()
//             .toLowerCase()
//             .contains(_searchKeyword.toLowerCase()) ||
//         coach.image.toLowerCase().contains(_searchKeyword.toLowerCase()));
//     return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//             columns: [
//               DataColumn(label: Text('Image')),
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
//                   label: Text('Date de  naissance',
//                       style: TextStyle(fontWeight: FontWeight.bold))),
//               // DataColumn(label: Text('date_inscription',
//               // style: TextStyle(fontWeight: FontWeight.bold))),
//               // DataColumn(label: Text('statut',
//               // style: TextStyle(fontWeight: FontWeight.bold))),
//               // DataColumn(label: Text('blackliste',
//               // style: TextStyle(fontWeight: FontWeight.bold))),
//               // DataColumn(label: Text('image',
//               // style: TextStyle(fontWeight: FontWeight.bold))),
//               DataColumn(
//                   label: Text(
//                 '',
//               )),
//             ],
//             rows: coachs
//                 .map((coach) => DataRow(cells: [
//                       // DataCell(Text(coach.id_Coach.toString())),
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
//                                       '${"http://127.0.0.1:8000"}/media/${coach.image.toString()}'))),
//                         ),
//                       ),
//                       DataCell(Text(coach.nomCoach + '  ' + coach.prenomCoach)),
//                       // DataCell(Text(coach.prenomCoach)),
//                       DataCell(Text(coach.adresse)),
//                       DataCell(Text(coach.tel)),
//                       DataCell(Text(coach.mail)),
//                       // DataCell(Text(coach.password)),
//                       // DataCell(Text(coach.cin)),
//                       DataCell(Text(coach.ville)),
//                       DataCell(Text(coach.dateNaissance != null
//                           ? DateFormat('yyyy-MM-dd')
//                               .format(coach.dateNaissance!)
//                           : '')),
//                       // DataCell(Text(coach.date_inscription.toString())),
//                       // DataCell(Text(coach.statut.toString())),
//                       // DataCell(Text(coach.blackliste.toString())),
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
//                               await _dialogBuilder(coach);
//                               setState(() {
//                                 _searchKeyword = '';
//                               });
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () async {
//                               await _showEditDialog(coach);
//                               setState(() {
//                                 _searchKeyword = '';
//                               });
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () async {
//                               await _showDeleteDialog(coach);
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
//   Future<void> _showEditDialog(Coach coach) async {
//     final TextEditingController controller =
//         TextEditingController(text: coach.nomCoach);
//
//     final TextEditingController prenomController =
//         TextEditingController(text: coach.prenomCoach);
//     final TextEditingController adresseController =
//         TextEditingController(text: coach.adresse);
//     final TextEditingController telController =
//         TextEditingController(text: coach.tel);
//     final TextEditingController mailController =
//         TextEditingController(text: coach.mail);
//     final TextEditingController passwordController =
//         TextEditingController(text: coach.password);
//     final TextEditingController cinController =
//         TextEditingController(text: coach.cin);
//     final TextEditingController villeController =
//         TextEditingController(text: coach.ville);
//     final TextEditingController dateNaissanceController = TextEditingController(
//         text: coach.dateNaissance != null
//             ? DateFormat('yyyy-MM-dd').format(coach.dateNaissance!)
//             : '');
//     final TextEditingController dateInscriptionController =
//         TextEditingController(
//             text: coach.datedentree != null
//                 ? DateFormat('yyyy-MM-dd').format(coach.datedentree!)
//                 : '');
//     final TextEditingController statutController =
//         TextEditingController(text: coach.statut.toString());
//
//     bool _getStatut() {
//       return statutController.text == 'True';
//     }
//
//     // final TextEditingController imageController =
//     //     TextEditingController(text: coach.image);
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Modifier Coach'),
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
//
//             ]).paddingOnly(right: 20.0)),
//             Expanded(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Container(
//                     width: 300,
//                     child: TextField(
//                       controller: cinController,
//                       decoration: InputDecoration(
//                         labelText: 'CIN',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   TextField(
//                     controller: villeController,
//                     decoration: InputDecoration(
//                       labelText: 'Coach ville',
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
//                 coach.nomCoach = controller.text;
//                 coach.prenomCoach = prenomController.text;
//                 coach.adresse = adresseController.text;
//                 coach.tel = telController.text;
//                 coach.mail = mailController.text;
//                 coach.password = passwordController.text;
//                 coach.cin = cinController.text;
//                 coach.ville = villeController.text;
//
//                 coach.dateNaissance =
//                     DateTime.parse(dateNaissanceController.text);
//                 coach.datedentree =
//                     DateTime.parse(dateInscriptionController.text);
//                 // coach.statut = statutController.text.toLowerCase() == '1';
//
//                 coach.statut = _getStatut();
//
//                 coach.image = image_path;
//
//                 await coachController.updateCoach(coach);
//                 Navigator.pop(context);
//               },
//               child: Text('Modifier'),
//             ),
//           ],
//         );
//       },
//     );
//
//     setState(() {
//       _searchKeyword = '';
//     });
//   }
//
//   Future<void> _dialogBuilder(Coach coach) {
//     return showDialog<void>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(coach.nomCoach),
//           content: Text(''),
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
//   Future<void> _showDeleteDialog(Coach coach) async {
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Supprimer Coach'),
//           content: Text('Êtes-vous sûr de vouloir supprimer ce coach ?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Annuler'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await coachController.deleteCoach(coach.idCoach);
//                 Navigator.pop(context);
//               },
//               child: Text('Supprimer'),
//             ),
//           ],
//         );
//       },
//     );
//
//     setState(() {
//       _searchKeyword = '';
//     });
//   }
// }
