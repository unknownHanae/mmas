//
//
// import 'dart:io';
//
// import 'package:adminmmas/models/ClientModels.dart';
// import 'package:adminmmas/models/ReservationModels.dart';
// import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http_parser/http_parser.dart';
//
// import '../componnents/label.dart';
// import '../constants.dart';
//
// import 'dart:html' as html;
//
// import '../models/SeanceModels.dart';
// import '../widgets/navigation_bar.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:intl/intl.dart';
//
// class AddReservation extends StatefulWidget {
//   const AddReservation({Key? key}) : super(key: key);
//
//   @override
//   State<AddReservation> createState() => _AddReservationState();
// }
//
//
//
// class _AddReservationState extends State<AddReservation> {
//
//   List<Client> clients = [];
//   List<Seance> seances = [];
//
//   BsSelectBoxController _selectClient = BsSelectBoxController();
//   BsSelectBoxController _selectSeances = BsSelectBoxController();
//
//   // BsSelectBoxController _selectStatus = BsSelectBoxController(
//   //   options: [
//   //     BsSelectBoxOption(value: 1, text: Text("Actif")),
//   //     BsSelectBoxOption(value: 0, text: Text("inactif")),
//   //   ]
//   // );
//   // BsSelectBoxController _selectPrsesnce = BsSelectBoxController(
//   //     options: [
//   //       BsSelectBoxOption(value: 1, text: Text("present")),
//   //       BsSelectBoxOption(value: 0, text: Text("abscent")),
//   //     ]
//   // );
//
//
//   String motif = "";
//   String date_presence = "";
//
//   void getClient() async {
//     final response = await http.get(Uri.parse(
//         HOST+'/api/clients/'));
//
//     if (response.statusCode == 200) {
//       final body = json.decode(response.body);
//       final List result = body["data"];
//       print("--result--");
//       print(result.length);
//       setState(() {
//         clients = result.map<Client>((e) => Client.fromJson(e)).toList();
//       });
//       _selectClient.options = clients.map<BsSelectBoxOption>((c) =>
//           BsSelectBoxOption(
//               value: c.id_client,
//               text: Text("${c.nom_client} ${c.prenom_client}")
//           )).toList();
//
//       print("--data--");
//       print(clients.length);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//   void getSeances(date) async {
//     print("loading seances ...");
//     final response = await http.get(Uri.parse(
//         HOST+'/api/seance/?date='+date));
//
//     if (response.statusCode == 200) {
//       final body = json.decode(response.body);
//       print(body);
//       if(body["status"] == true){
//         setState(() {
//           date_presence = date;
//         });
//         final List result = body["data"];
//         print("--result--");
//         print(result.length);
//         setState(() {
//           seances = result.map<Seance>((e) => Seance.fromJson(e)).toList();
//         });
//         _selectSeances.clear();
//         /*_selectSeances.options.add(BsSelectBoxOption(
//             value: 0,
//             text: Text("")
//         ));*/
//         _selectSeances.options = seances.map<BsSelectBoxOption>((s) =>
//             BsSelectBoxOption(
//                 value: s.id_seance,
//                 text: Text("Cours: ${s.cour} | Coach: ${s.coach} | De ${s.heure_debut} à ${s.heure_fin}",style: TextStyle(color: Colors.indigoAccent),)
//             )).toList();
//
//         print("--data--");
//         print(seances.length);
//       }else{
//         print(body);
//       }
//
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   void add(context) async {
//
//     if(date_presence.length > 0
//       && _selectClient.getSelected()?.getValue() != null
//         && _selectSeances.getSelected()?.getValue() != null
//         // && _selectPrsesnce.getSelected()?.getValue() != null
//         // && _selectStatus.getSelected()?.getValue() != null
//     ){
//       // if(_presenceController.getSelected()?.getValue() == 0){
//       //   if(motif.length == 0){
//       //     showAlertDialog(context);
//       //     return;
//       //   }
//       // }
//
//       var rev = <String, dynamic>{
//         "id_client": _selectClient.getSelected()?.getValue(),
//         "id_seance": _selectSeances.getSelected()?.getValue(),
//         "date_presence": date_presence,
//         /*"status": 0,
//         "presence": 0,
//         "motif_annulation": "",*/
//       };
//
//       print(rev);
//
//       final response = await http.post(Uri.parse(
//           HOST+"/api/reservation/"),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(rev),
//       );
//
//       if (response.statusCode == 200) {
//
//         //print("etb added");
//         print(response.body);
//         final body = json.decode(response.body);
//         final status = body["status"];
//         if(status == true){
//           Navigator.pop(context,true);
//         }else{
//           showAlertDialog(context, msg: body["msg"]);
//         }
//
//       } else {
//         throw Exception('Failed to save data');
//       }
//     }else{
//       showAlertDialog(context, msg: "");
//     }
//
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print("init state clients");
//     getClient();
//
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final tomorrow = DateTime(now.year, now.month, now.day + 1);
//     return Scaffold(
//       body: Container(
//           decoration: BoxDecoration(
//           color: Colors.grey[200]
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Row(
//           children: [
//             SideBar(postion: 8,msg:"Réservation"),
//             SizedBox(width: 10,),
//             Expanded(
//               flex: 3,
//               child: Container(
//                 height: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           InkWell(
//                             onTap: (){
//                               Navigator.pop(context);
//                             },
//                             child: Container(
//                               child: Icon(Icons.arrow_back, size: 20, color: Colors.orange,),
//                               height: 40,
//                               width: 40,
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.grey[200],
//                                   border: Border.all(
//                                       color: Colors.orange
//                                   )
//                               ),
//                             ),
//                           ),
//                           Text("Ajouter une Réservation",
//                             style: TextStyle(
//                                 fontSize: 22,
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                           InkWell(
//                             onTap: (){
//                               add(context);
//                             },
//                             child: Container(
//                               child:
//                               Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
//                               height: 40,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(6),
//                                   color: Colors.blue,
//                                   border: Border.all(
//                                       color: Colors.blueAccent
//                                   )
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20,),
//                       Expanded(
//                         flex: 1,
//                         child: ListView(
//                           children: [
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 LabelText(
//                                     title: 'Client *'
//                                 ),
//                                 BsSelectBox(
//                                   hintText: 'Client',
//                                   controller: _selectClient,
//                                 ),
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 LabelText(
//                                     title: 'Date Présence *'
//                                 ),
//                                 SizedBox(
//                                   width: 300,
//                                   height: 210,
//                                   child: Center(
//                                     child: SfDateRangePicker(
//                                       view: DateRangePickerView.month,
//                                       minDate: tomorrow,
//                                         onSelectionChanged: (args) {
//                                           print(args.value);
//                                           var date = "${DateFormat('dd-MM-yy').format(args.value)}";
//                                           print(date);
//                                           getSeances(date);
//                                         },
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 LabelText(
//                                     title: 'Seance *'
//                                 ),
//                                 BsSelectBox(
//                                   hintText: 'Seance',
//                                   controller: _selectSeances,
//                                 ),
//                                 SizedBox(
//                                   height: 25,
//                                 ),
//                                 LabelText(
//                                     title: 'Nb: *  designe un champ obligatoire'
//                                 ),
//
//                                 // LabelText(
//                                 //     title: 'Status'
//                                 // ),
//                                 // BsSelectBox(
//                                 //   hintText: 'Status',
//                                 // controller: _selectStatus,
//                                 // ),
//                                 // SizedBox(
//                                 //   height: 15,
//                                 // ),
//                                 // LabelText(
//                                 //     title: 'Presence'
//                                 // ),
//                                 // BsSelectBox(
//                                 //   hintText: 'Presence',
//                                 //   controller: _selectPrsesnce,
//                                 // ),
//                                 // SizedBox(
//                                 //   height: 15,
//                                 // ),
//                                 // LabelText(
//                                 //     title: 'Motif Annulation'
//                                 // ),
//                                 // Container(
//                                 //     width: double.infinity,
//                                 //     decoration: BoxDecoration(boxShadow: [
//                                 //
//                                 //     ]),
//                                 //     child: TextField(
//                                 //       onChanged: (val){
//                                 //         setState(() {
//                                 //           motif = val;
//                                 //         });
//                                 //       },
//                                 //       decoration: new InputDecoration(
//                                 //         hintText: 'Motif Annulation',
//                                 //         hintStyle: TextStyle(fontSize: 14)
//                                 //       ),
//                                 //     )),
//                               ],
//                             )
//                           ],
//                       )
//                       )
//                         ],
//                   ),
//                 ),
//
//               ),
//             ),
//         ]
//                 )
//       )
//       ),
//     );
//   }
//   showAlertDialog(BuildContext context , {String msg = ""}) {
//     Widget cancelButton = TextButton(
//       child: Text("OK"),
//       onPressed:  () {
//         Navigator.pop(context);
//       },
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("Ajouter Réservation"),
//       content: Text(msg!.length == 0 ? "Remplir toute Champs": msg),
//       actions: [
//         cancelButton,
//       ],
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
