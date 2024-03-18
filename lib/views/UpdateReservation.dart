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
// import 'package:provider/provider.dart';
//
// import '../componnents/label.dart';
// import '../constants.dart';
//
// import 'dart:html' as html;
//
// import '../models/SeanceModels.dart';
// import '../providers/admin_provider.dart';
// import '../widgets/navigation_bar.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:intl/intl.dart';
//
// class UpdateReservation extends StatefulWidget {
//    UpdateReservation({Key? key, required this.reservation}) : super(key: key);
//
//   Reservation reservation;
//   @override
//   State<UpdateReservation> createState() => _UpdateReservationState();
// }
//
//
//
// class _UpdateReservationState extends State<UpdateReservation> {
//
//   List<Client> clients = [];
//   List<Seance> seances = [];
//
//   BsSelectBoxController _selectClient = BsSelectBoxController();
//   BsSelectBoxController _selectSeances = BsSelectBoxController();
//
//   BsSelectBoxController _selectStatus = BsSelectBoxController();
//
//
//   BsSelectBoxController _selectPrsesnce = BsSelectBoxController();
//
//   String motif = "";
//   String date_presence = "";
//
//   TextEditingController moti_controller = TextEditingController();
//
//   void getClient() async {
//     final response = await http.get(Uri.parse(
//         HOST+'/api/clients/'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         });
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
//       Client client = clients.where(
//               (element) => element.id_client == widget.reservation.id_client).first;
//       _selectClient.setSelected(BsSelectBoxOption(
//           value: widget.reservation.id_client,
//           text: Text("${client.nom_client} ${client.prenom_client}")
//       ));
//       print("--data--");
//       print(clients.length);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//   void getSeances(date) async {
//     print("loading seances ...");
//     final response = await http.get(Uri.parse(
//         HOST+'/api/seance/?date='+date),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         });
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
//         Seance seance = seances.where((element)
//         => element.id_seance == widget.reservation.id_seance).first;
//         _selectSeances.setSelected(
//             BsSelectBoxOption(
//                 value: widget.reservation.id_seance,
//                 text: Text("Cours: ${seance.cour} | Coach: ${seance.coach} | De ${seance.heure_debut} à ${seance.heure_fin}",style: TextStyle(color: Colors.indigoAccent),)
//             )
//         );
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
//
//   void update(context) async {
//
//     if(date_presence.length > 0
//         && _selectClient.getSelected()?.getValue() != null
//         && _selectSeances.getSelected()?.getValue() != null
//     // && _selectPrsesnce.getSelected()?.getValue() != null
//     // && _selectStatus.getSelected()?.getValue() != null
//     ){
//       if(_selectPrsesnce.getSelected()?.getValue() == 0){
//         if(motif.length == 0){
//           showAlertDialog(context);
//           return;
//         }
//       }
//       var rev = <String, dynamic>{
//         "id_reservation": widget.reservation.id_reservation,
//         "id_client": _selectClient.getSelected()?.getValue(),
//         "id_seance": _selectSeances.getSelected()?.getValue(),
//         "date_presence": date_presence,
//         "status": _selectStatus.getSelected()?.getValue(),
//         "presence": _selectPrsesnce.getSelected()?.getValue(),
//         "motif_annulation": moti_controller.text,
//       };
//
//       print(rev);
//       final response = await http.put(Uri.parse(
//           HOST+"/api/reservation/"),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization': 'Bearer $token',
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
//   var token = "";
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     token = context.read<AdminProvider>().admin.token;
//     print("init state clients");
//     getClient();
//     getSeances(widget.reservation.date_presence);
//     _selectPrsesnce.options = [
//       BsSelectBoxOption(value: 1, text: Text("present")),
//       BsSelectBoxOption(value: 0, text: Text("abscent")),
//     ];
//     _selectStatus.options =  [
//       BsSelectBoxOption(value: 1, text: Text("Actif")),
//       BsSelectBoxOption(value: 0, text: Text("inactif")),
//     ];
//     if(widget.reservation.status != null){
//       _selectStatus.setSelected(
//           BsSelectBoxOption(
//               value: widget.reservation.status,
//               text: widget.reservation.status == 0 ? Text("Inactive") : Text("Active")
//           ));
//     }
//
//     if(widget.reservation.presence != null){
//       _selectPrsesnce.setSelected(
//           BsSelectBoxOption(
//               value: widget.reservation.presence,
//               text: widget.reservation.presence == 0 ? Text("Prensece") : Text("Absence")
//           ));
//     }
//
//     moti_controller.text = widget.reservation.motif_annulation.toString();
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
//               color: Colors.grey[200]
//           ),
//           child: Padding(
//               padding: EdgeInsets.all(20),
//               child: Row(
//                   children: [
//                     SideBar(postion: 8,msg:"Coach"),
//                     SizedBox(width: 10,),
//                     Expanded(
//                       flex: 3,
//                       child: Container(
//                         height: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   InkWell(
//                                     onTap: (){
//                                       Navigator.pop(context);
//                                     },
//                                     child: Container(
//                                       child: Icon(Icons.arrow_back, size: 20, color: Colors.orange,),
//                                       height: 40,
//                                       width: 40,
//                                       decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.grey[200],
//                                           border: Border.all(
//                                               color: Colors.orange
//                                           )
//                                       ),
//                                     ),
//                                   ),
//                                   Text("Modifier Réservation",
//                                     style: TextStyle(
//                                         fontSize: 22,
//                                         color: Colors.black87,
//                                         fontWeight: FontWeight.bold
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: (){
//                                       update(context);
//                                     },
//                                     child: Container(
//                                       child:
//                                       Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
//                                       height: 40,
//                                       width: 100,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(6),
//                                           color: Colors.blue,
//                                           border: Border.all(
//                                               color: Colors.blueAccent
//                                           )
//                                       ),
//                                     ),
//                                   ),
//
//                                 ],
//                               ),
//                               SizedBox(height: 20,),
//                               Expanded(
//                                   flex: 1,
//                                   child: ListView(
//                                     children: [
//                                       Column(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           LabelText(
//                                               title: 'Client *'
//                                           ),
//                                           BsSelectBox(
//                                             hintText: 'Client',
//                                             controller: _selectClient,
//                                           ),
//                                           SizedBox(
//                                             height: 15,
//                                           ),
//                                           LabelText(
//                                               title: 'Date Présence *'
//                                           ),
//                                           SizedBox(
//                                             width: 300,
//                                             height: 210,
//                                             child: Center(
//                                               child: SfDateRangePicker(
//                                                 view: DateRangePickerView.month,
//                                                 minDate: tomorrow,
//                                                 initialSelectedDate: DateTime.parse(widget.reservation.date_presence.toString()),
//                                                 onSelectionChanged: (args) {
//                                                   print(args.value);
//                                                   var date = "${DateFormat('yyyy-MM-dd').format(args.value)}";
//                                                   print(date);
//                                                   getSeances(date);
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 15,
//                                           ),
//                                           LabelText(
//                                               title: 'Seance *'
//                                           ),
//                                           BsSelectBox(
//                                             hintText: 'Seance',
//                                             controller: _selectSeances,
//                                           ),
//                                           SizedBox(
//                                             height: 15,
//                                           ),
//                                           LabelText(
//                                               title: 'Status'
//                                           ),
//                                           BsSelectBox(
//                                             hintText: 'Status',
//                                           controller: _selectStatus,
//                                           ),
//                                           SizedBox(
//                                             height: 15,
//                                           ),
//                                           LabelText(
//                                               title: 'Presence'
//                                           ),
//                                           BsSelectBox(
//                                             hintText: 'Presence',
//                                             controller: _selectPrsesnce,
//                                           ),
//                                           SizedBox(
//                                             height: 15,
//                                           ),
//                                           LabelText(
//                                               title: 'Motif Annulation'
//                                           ),
//                                           Container(
//                                               width: double.infinity,
//                                               decoration: BoxDecoration(boxShadow: [
//
//                                               ]),
//                                               child: TextField(
//                                                controller: moti_controller,
//                                                 decoration: new InputDecoration(
//                                                   hintText: 'Motif Annulation',
//                                                   hintStyle: TextStyle(fontSize: 14)
//                                                 ),
//                                               )),
//                                         ],
//                                       )
//                                     ],
//                                   )
//                               )
//                             ],
//                           ),
//                         ),
//
//                       ),
//                     ),
//                   ]
//               )
//           )
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
