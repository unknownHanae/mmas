// import 'package:adminmmas/constants.dart';
// import 'package:adminmmas/views/Addreservation.dart';
// import 'package:adminmmas/views/UpdateReservation.dart';
// import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
// import 'package:bs_flutter_modal/bs_flutter_modal.dart';
// import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:time_planner/time_planner.dart';
// import '../componnents/deleteButton.dart';
// import '../componnents/editerButton.dart';
// import '../componnents/label.dart';
// import '../componnents/showButton.dart';
// import '../models/CatContratModels.dart';
// import '../models/ClientModels.dart';
// import '../models/CoursModels.dart';
// import '../models/ReservationModels.dart';
// import '../models/SeanceModels.dart';
// import '../providers/admin_provider.dart';
// import '../widgets/navigation_bar.dart';
//
//
// import 'package:flutter/rendering.dart';
//
// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:intl/intl.dart';
//
// import 'package:confirm_dialog/confirm_dialog.dart';
//
// import 'PlanningScreen.dart';
//
// class ReservationScreen extends StatefulWidget {
//   const ReservationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ReservationScreen> createState() => _ReservationState();
// }
//
// class _ReservationState extends State<ReservationScreen> {
//
//   List<Reservation> data = [];
//   List<Reservation> init_data = [];
//   bool loading = false;
//
//   //final TextEditingController input_search = TextEditingController();
//   String text_search = "";
//
//   List<category_contrat> category = [];
//   List<Cours> cour = [];
//   List<Client> clients = [];
//   List<Seance> seances = [];
//
//   String motif = "";
//   String date_presence = "";
//
//
//
//   Future<BsSelectBoxResponse> searchClient(Map<String, String> params) async {
//     List<BsSelectBoxOption> searched = [];
//     print(params);
//     for(var v in clients){
//       var name = "${v.nom_client} ${v.prenom_client}";
//       if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
//         searched.add(
//             BsSelectBoxOption(
//                 value: v.id_client,
//                 text: Text("${v.nom_client} ${v.prenom_client}")
//             )
//         );
//       }
//     }
//
//     return BsSelectBoxResponse(options: searched);
//   }
//
//
//   final TextEditingController datePresenceController =
//   TextEditingController();
//
//   BsSelectBoxController _selectClient = BsSelectBoxController();
//   BsSelectBoxController _selectSeances = BsSelectBoxController();
//
//   BsSelectBoxController _selectStatus = BsSelectBoxController();
//
//   BsSelectBoxController _selectCours = BsSelectBoxController();
//
//
//   BsSelectBoxController _selectPrsesnce = BsSelectBoxController();
//   BsSelectBoxController _selectStatusResrvation = BsSelectBoxController(
//       options: [
//         BsSelectBoxOption(value: 2, text: Text("Tout")),
//         BsSelectBoxOption(value: 3, text: Text("Sans Status")),
//         BsSelectBoxOption(value: 0, text: Text("Validée")),
//         BsSelectBoxOption(value: 1, text: Text("Annulée")),
//       ]
//   );
//
//   TextEditingController moti_controller = TextEditingController();
//
//   void filterReservation(){
//     if(_selectStatusResrvation.getSelected()?.getValue() != null){
//       setState(() {
//         data = [];
//       });
//       if(_selectStatusResrvation.getSelected()?.getValue() == 2){
//         setState(() {
//           data = init_data;
//         });
//
//       }
//
//       if(_selectStatusResrvation.getSelected()?.getValue() == 3){
//         setState(() {
//           data = init_data.where((element) => element.status == null).toList();
//         });
//
//       }
//
//       if(_selectStatusResrvation.getSelected()?.getValue() == 0){
//         setState(() {
//           data = init_data.where((element) => element.status == true).toList();
//         });
//
//       }
//
//       if(_selectStatusResrvation.getSelected()?.getValue() == 1){
//         setState(() {
//           data = init_data.where((element) => element.status == false).toList();
//         });
//
//       }
//
//     }
//   }
//
//   void fetchReservation() async {
//     // setState(() {
//     //   loading = true;
//     // });
//     // print("loading ...");
//     final response = await http.get(Uri.parse(
//         HOST+'/api/reservation/'),
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
//         data = result.map<Reservation>((e) => Reservation.fromJson(e)).toList();
//         init_data = result.map<Reservation>((e) => Reservation.fromJson(e)).toList();
//       });
//       print("--data--");
//       print(data.length);
//     } else {
//       throw Exception('Failed to load data');
//     }
//
//     setState(() {
//       loading = false;
//     });
//   }
//
//   void search(String key){
//     if(key.length > 0){
//       final List<Reservation> founded = [];
//       init_data.forEach((e) {
//         if( e.id_seance == key
//             || e.client!.toLowerCase().contains(key.toLowerCase())
//             || e.cour!.toLowerCase().contains(key.toLowerCase())
//             || e.date_presence!.toLowerCase().contains(key.toLowerCase())
//             )
//         {
//           founded.add(e);
//         }
//       });
//       setState(() {
//         data = founded;
//       });
//     }else {
//       setState(() {
//         data = init_data;
//       });
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
//     print("init state");
//     fetchReservation();
//     getClient();
//     getCour();
//
//   }
//   void delete(id) async {
//     final response = await http.delete(Uri.parse(
//         HOST+'/api/reservation/'+id),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         });
//
//     if (response.statusCode == 200) {
//       fetchReservation();
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   showAlertDialog(BuildContext context, String msg) {
//     Widget cancelButton = TextButton(
//       child: Text("OK"),
//       onPressed:  () {
//         Navigator.pop(context);
//       },
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("Abonnement"),
//       content: Text(msg),
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
//
//   void modal_add_planning(context){
//     final now = DateTime.now();
//     final tomorrow = DateTime(now.year, now.month, now.day + 1);
//
//     showDialog(context: context, builder: (context) =>
//         BsModal(
//             context: context,
//             dialog: BsModalDialog(
//               size: BsModalSize.lg,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               child: BsModalContent(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                 ),
//                 children: [
//                   BsModalContainer(
//                     //title:
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     actions: [
//                       Text('Ajouter Reservation',
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       BsButton(
//                         style: BsButtonStyle.outlinePrimary,
//                         label: Text('Annuler'),
//                         //prefixIcon: Icons.close,
//                         onPressed: () {
//                           Navigator.pop(context);
//                           initData();
//                         },
//                       )
//                     ],
//                     //closeButton: true,
//
//                   ),
//                   // BsModalContainer(
//                   //     title: Text('Ajouter Reservation'),
//                   //     closeButton: true,
//                   //   onClose: (){
//                   //     Navigator.pop(context);
//                   //     initData();
//                   //
//                   //   },
//                   // ),
//                   BsModalContainer(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 10,),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             LabelText(
//                                 title: 'Client *'
//                             ),
//                             BsSelectBox(
//                               hintText: 'Client',
//                               controller: _selectClient,
//                               onChange: (v){
//                                 Client c = clients.where(
//                                         (el) => el.id_client == _selectClient.getSelected()?.getValue()
//                                 ).first;
//
//                                 var genders = {
//                                   "Madmoiselle": "Femme",
//                                   "Monsieur": "Homme",
//                                   "Madame": "Femme"
//                                 };
//
//                                 List<Cours> crs = cour.where(
//                                         (cr) => cr.genre == genders[c.civilite]
//                                         || cr.genre == "Mixte"
//                                 ).toList();
//                                 _selectCours.clear();
//                                 _selectSeances.clear();
//                                 datePresenceController.text = "";
//                                 _selectCours.options = crs.map<BsSelectBoxOption>((c) =>
//                                     BsSelectBoxOption(
//                                         value: c.id_cour,
//                                         text: Text("${c.nom_cour}")
//                                     )
//                                 ).toList();
//                                 Navigator.pop(context);
//                                 modal_add(context);
//                               },
//                             ),
//                             SizedBox(height: 10,),
//                             LabelText(
//                                 title: 'Cours *'
//                             ),
//                             BsSelectBox(
//                               hintText: 'Cours',
//                               controller: _selectCours,
//                               onChange: (val){
//                                 getSeances(context,_selectCours.getSelected()?.getValue());
//                               },
//                             ),
//                           ],
//                         ),
//
//                         SizedBox(
//                           height: 15,
//                         ),
//                         LabelText(
//                             title: 'Seance *'
//                         ),
//                         BsSelectBox(
//                           hintText: 'Seance',
//                           controller: _selectSeances,
//                           onChange: (v){
//                             datePresenceController.text = "";
//                             date_presence = "";
//                             Seance s = seances.where(
//                                     (el) => el.id_seance == _selectSeances.getSelected()?.getValue()).first;
//                             DateTime date = DateTime.parse(s.date_reservation!);
//                             datePresenceController.text = DateFormat("dd/MM/yyyy").format(date);
//                             date_presence = s.date_reservation!;
//                           },
//                         ),
//                         SizedBox(
//                           height: 15,
//                         ),
//                         LabelText(
//                             title: 'Créneau *'
//                         ),
//                         TextField(
//                           decoration: InputDecoration(
//                             icon: Icon(Icons.calendar_today),
//                             labelText: 'Créneau',
//                           ),
//                           readOnly: true,
//                           controller: datePresenceController,
//                         ),
//                         SizedBox(
//                           height: 25,
//                         ),
//                         SizedBox(height: 15,),
//                         InkWell(
//                           onTap: (){
//                             add(context);
//                           },
//                           child:
//                           MediaQuery.of(context).size.width > 800 ?
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 child:
//                                 Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
//                                 height: 40,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(6),
//                                     color: Colors.blue,
//                                     border: Border.all(
//                                         color: Colors.blueAccent
//                                     )
//                                 ),
//                               ),
//
//                               LabelText(
//                                   title: 'Nb: *  un champ obligatoire'
//                               ),
//                             ],
//                           ):
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 child:
//                                 Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
//                                 height: 40,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(6),
//                                     color: Colors.blue,
//                                     border: Border.all(
//                                         color: Colors.blueAccent
//                                     )
//                                 ),
//                               ),
//                               SizedBox(height: 5),
//                               LabelText(
//                                   title: 'Nb: * un champ obligatoire'
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )));
//   }
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
//
//       print("--data--");
//       print(clients.length);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   void getCour() async {
//     final response = await http.get(Uri.parse(
//         HOST+'/api/cours/'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         });
//
//     if (response.statusCode == 200) {
//       final body = json.decode(response.body);
//       final List result = body["data"];
//
//
//       print("--result--");
//       print(result.length);
//
//       setState(() {
//         cour = result.map<Cours>((e) => Cours.fromJson(e)).toList();
//       });
//
//
//       /*_selectCours.options = cour.map<BsSelectBoxOption>((c) =>
//           BsSelectBoxOption(
//               value: c.id_cour,
//               text: Text("${c.nom_cour}")
//           )
//       ).toList();*/
//
//       print("--data--");
//       print(cour.length);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//
//   void getSeances(context, cour_id, {int? seance_id}) async {
//     if(_selectClient.getSelected()?.getValue() != null){
//       _selectSeances.clear();
//       datePresenceController.text = "";
//       date_presence = "";
//       print("loading seances ...");
//       var client_id = _selectClient.getSelected()?.getValue();
//       final response = await http.get(Uri.parse(
//           HOST+'/api/seance/?cour_id=${cour_id}&client_id=${client_id}'),
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           });
//
//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);
//         print(body);
//         if(body["status"] == true){
//           final List result = body["data"];
//           print("--result--");
//           print(result.length);
//           setState(() {
//             seances = result.map<Seance>((e) => Seance.fromJson(e)).toList();
//           });
//           _selectSeances.clear();
//           _selectSeances.options = seances.map<BsSelectBoxOption>((s) =>
//               BsSelectBoxOption(
//                   value: s.id_seance,
//                   text: Text("Cours: ${s.cour} | Salle: ${s.salle} | Jour :  ${s.day_name} | De ${s.heure_debut} à ${s.heure_fin}",style: TextStyle(color: Colors.black),)
//               )).toList();
//           Navigator.of(context)
//               .push(
//               MaterialPageRoute(builder: (context) => PlanningScreen(seances: seances, )
//               )
//           ).then((val){
//             if(val["selected"] == true){
//               Seance sc = val["seance"];
//               print(sc.toJson());
//               _selectSeances.setSelected(
//                   BsSelectBoxOption(
//                       value: sc.id_seance,
//                       text: Text("Cours: ${sc.cour} | Salle: ${sc.salle} | Jour :  ${sc.day_name} | De ${sc.heure_debut} à ${sc.heure_fin}",style: TextStyle(color: Colors.black),)
//                   )
//               );
//               DateTime date = DateTime.parse(sc.date_reservation!);
//               datePresenceController.text = DateFormat("dd/MM/yyyy").format(date);
//               date_presence = sc.date_reservation!;
//               Navigator.pop(context);
//               modal_add(context);
//             }
//           });
//           print("--data--");
//           print(seances.length);
//           if(seance_id != null){
//             Seance seance = seances.where((element)
//             => element.id_seance == seance_id).first;
//             _selectSeances.setSelected(
//                 BsSelectBoxOption(
//                     value: seance_id,
//                     text: Text("Cours: ${seance.cour} |Salle: ${seance.salle} | Jour :  ${seance.day_name}| De ${seance.heure_debut} à ${seance.heure_fin}",style: TextStyle(color: Colors.indigoAccent),)
//                 )
//             );
//
//           }
//         }else{
//           print(body);
//         }
//
//       } else {
//         throw Exception('Failed to load data');
//       }
//     }else{
//       showAlertDialog(context, "s'il vous plait selection un client");
//     }
//
//   }
//
//   void add(context) async {
//
//     if(date_presence.isNotEmpty
//         && _selectClient.getSelected()?.getValue() != null
//         && _selectSeances.getSelected()?.getValue() != null
//     // && _selectPrsesnce.getSelected()?.getValue() != null
//     // && _selectStatus.getSelected()?.getValue() != null
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
//       final response = await http.post(Uri.parse(
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
//           initData();
//           fetchReservation();
//
//         }else{
//           showAlertDialog(context, body["msg"]);
//         }
//
//       } else {
//         showAlertDialog(context, "Erreur ajout reservation");
//       }
//     }else{
//       showAlertDialog(context, "Remplir tous les champs");
//     }
//
//   }
//
//   void modal_add(context){
//     final now = DateTime.now();
//     final tomorrow = DateTime(now.year, now.month, now.day + 1);
//
//     showDialog(context: context, builder: (context) =>
//         BsModal(
//             context: context,
//
//             dialog: BsModalDialog(
//               size: BsModalSize.lg,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               child: BsModalContent(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                 ),
//                 children: [
//                   BsModalContainer(
//                     //title:
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     actions: [
//                       Text('Ajouter Reservation',
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       BsButton(
//                         style: BsButtonStyle.outlinePrimary,
//                         label: Text('Annuler'),
//                         //prefixIcon: Icons.close,
//                         onPressed: () {
//
//                           Navigator.pop(context);
//                           initData();
//                         },
//                       )
//                     ],
//                     //closeButton: true,
//
//                   ),
//                   // BsModalContainer(
//                   //     title: Text('Ajouter Reservation'),
//                   //     closeButton: true,
//                   //   onClose: (){
//                   //     Navigator.pop(context);
//                   //     initData();
//                   //
//                   //   },
//                   // ),
//                   BsModalContainer(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 10,),
//                         LabelText(
//                             title: 'Client *'
//                         ),
//                         BsSelectBox(
//                           hintText: 'Client',
//                           controller: _selectClient,
//                           searchable: true,
//                           serverSide: searchClient,
//                           onChange: (v){
//                             Client c = clients.where(
//                                     (el) => el.id_client == _selectClient.getSelected()?.getValue()
//                             ).first;
//
//                             var genders = {
//                               "Madmoiselle": "Femme",
//                               "Monsieur": "Homme",
//                               "Madame": "Femme"
//                             };
//
//                             List<Cours> crs = cour.where(
//                                     (cr) => cr.genre == genders[c.civilite]
//                                         || cr.genre == "Mixte"
//                             ).toList();
//                             _selectCours.clear();
//                             _selectSeances.clear();
//                             datePresenceController.text = "";
//                             _selectCours.options = crs.map<BsSelectBoxOption>((c) =>
//                                 BsSelectBoxOption(
//                                     value: c.id_cour,
//                                     text: Text("${c.nom_cour}")
//                                 )
//                             ).toList();
//                             Navigator.pop(context);
//                             modal_add(context);
//                           },
//                         ),
//                         SizedBox(height: 10,),
//                         LabelText(
//                             title: 'Cours *'
//                         ),
//                         BsSelectBox(
//                           hintText: 'Cours',
//                           controller: _selectCours,
//                           onChange: (val){
//                             getSeances(context, _selectCours.getSelected()?.getValue());
//                           },
//                         ),
//
//                         SizedBox(
//                           height: 15,
//                         ),
//                         LabelText(
//                             title: 'Seance *'
//                         ),
//                         BsSelectBox(
//                           hintText: 'Seance',
//                           controller: _selectSeances,
//                           disabled: true,
//                          /* onChange: (v){
//                             datePresenceController.text = "";
//                             date_presence = "";
//                             Seance s = seances.where(
//                                     (el) => el.id_seance == _selectSeances.getSelected()?.getValue()).first;
//                             DateTime date = DateTime.parse(s.date_reservation!);
//                             datePresenceController.text = DateFormat("dd/MM/yyyy").format(date);
//                             date_presence = s.date_reservation!;
//                           },*/
//                         ),
//                         SizedBox(
//                           height: 15,
//                         ),
//                         LabelText(
//                             title: 'Créneau *'
//                         ),
//                         TextField(
//                           decoration: InputDecoration(
//                             icon: Icon(Icons.calendar_today),
//                             labelText: 'Créneau',
//                           ),
//                           readOnly: true,
//                           controller: datePresenceController,
//                           /*onTap: () async {
//                             DateTime? pickedDate = await showDatePicker(
//                               context: context,
//                               initialDate: tomorrow,
//                               firstDate: tomorrow,
//                               lastDate: DateTime(2101),
//                             );
//                             if (pickedDate != null) {
//                               String formattedDate =
//                               DateFormat("yyyy-MM-dd").format(pickedDate);
//                               setState(() {
//                                 datePresenceController.text =
//                                     formattedDate.toString();
//                               });
//                               print(formattedDate);
//                               date_presence = formattedDate;
//                               getSeances(formattedDate);
//                             } else {
//                               print('Not selected');
//                             }
//                           },*/
//                         ),
//                         SizedBox(
//                           height: 25,
//                         ),
//                         SizedBox(height: 15,),
//                         InkWell(
//                           onTap: (){
//                             add(context);
//                           },
//                           child:
//                           MediaQuery.of(context).size.width > 800 ?
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 child:
//                                 Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
//                                 height: 40,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(6),
//                                     color: Colors.blue,
//                                     border: Border.all(
//                                         color: Colors.blueAccent
//                                     )
//                                 ),
//                               ),
//
//                               LabelText(
//                                   title: 'Nb: *  un champ obligatoire'
//                               ),
//                             ],
//                           ):
//                           Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               child:
//                               Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
//                               height: 40,
//                               width: 120,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(6),
//                                   color: Colors.blue,
//                                   border: Border.all(
//                                       color: Colors.blueAccent
//                                   )
//                               ),
//                             ),
//                             SizedBox(height: 5),
//                             LabelText(
//                                 title: 'Nb: * un champ obligatoire'
//                             ),
//                           ],
//                         ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )));
//   }
//
//
//
//   void modal_update(context, Reservation reservation, {bool update_select = false}) async {
//
//     final now = DateTime.now();
//     final tomorrow = DateTime(now.year, now.month, now.day + 1);
//
//     if(!update_select){
//
//       //getSeances(reservation.date_presence, seance_id: reservation.id_seance);
//       _selectPrsesnce.options = [
//         BsSelectBoxOption(value: 1, text: Text("present")),
//         BsSelectBoxOption(value: 0, text: Text("abscent")),
//       ];
//       _selectStatus.options =  [
//         BsSelectBoxOption(value: 1, text: Text("Validée")),
//         BsSelectBoxOption(value: 0, text: Text("Annulée")),
//       ];
//       if(reservation.status != null){
//         _selectStatus.setSelected(
//             BsSelectBoxOption(
//                 value: reservation.status! ? 1 : 0,
//                 text: reservation.status == false ? Text("Annulée") : Text("Validée")
//             ));
//       }
//
//       if(reservation.presence != null){
//         _selectPrsesnce.setSelected(
//             BsSelectBoxOption(
//                 value: reservation.presence! ? 1 : 0,
//                 text: reservation.presence == true ? Text("Présent") : Text("Absent")
//             ));
//       }
//
//       Client client = clients.where(
//               (element) => element.id_client == reservation.id_client).first;
//       _selectClient.setSelected(BsSelectBoxOption(
//           value: reservation.id_client,
//           text: Text("${client.nom_client} ${client.prenom_client}")
//       ));
//       //Seance s = seances.where((el) => el.id_seance == reservation.id_seance).first;
//       _selectSeances.setSelected(BsSelectBoxOption(
//           value: reservation.id_seance,
//           text: Text("Cours: ${reservation.cour} | Salle: ${reservation.salle} | Jour : ${reservation.day_name}| De ${reservation.heur_debut} à ${reservation.heure_fin}",style: TextStyle(color: Colors.black),)
//       ));
//
//       moti_controller.text =  reservation.motif_annulation != null ?
//       reservation.motif_annulation.toString():
//       "";
//       datePresenceController.text = reservation.date_presence != null ?
//       reservation.date_presence.toString():
//       ""
//       ;
//       date_presence = reservation.date_presence.toString();
//     }
//
//
//     showDialog(context: context, builder: (context) =>
//         BsModal(
//             context: context,
//
//             dialog: BsModalDialog(
//               size: BsModalSize.lg,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               child: BsModalContent(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                 ),
//                 children: [
//                   BsModalContainer(
//                     //title:
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     actions: [
//                       Text('Modifier une Reservation',
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       BsButton(
//                         style: BsButtonStyle.outlinePrimary,
//                         label: Text('Annuler'),
//                         //prefixIcon: Icons.close,
//                         onPressed: () {
//                           initData();
//                           Navigator.pop(context);
//                         },
//                       )
//                     ],
//                     //closeButton: true,
//
//                   ),
//                   /*BsModalContainer(
//                       title: Text('Modifier une Reservation'),
//                       closeButton: true,
//                     onClose: (){
//                       initData();
//                       Navigator.pop(context);
//                     },
//                   ),*/
//                   BsModalContainer(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                                 flex: 1,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     LabelText(
//                                         title: 'Client *'
//                                     ),
//                                     BsSelectBox(
//                                       hintText: 'Client',
//                                       controller: _selectClient,
//                                       disabled: true,
//                                     ),
//                                     SizedBox(
//                                       height: 15,
//                                     ),
//                                     LabelText(
//                                         title: 'Créneau *'
//                                     ),
//                                     TextField(
//                                       decoration: InputDecoration(
//                                         icon: Icon(Icons.calendar_today),
//                                         labelText: 'Créneau',
//                                       ),
//                                       readOnly: true,
//                                       controller: datePresenceController,
//                                       /*onTap: () async {
//                                         DateTime? pickedDate = await showDatePicker(
//                                           context: context,
//                                           initialDate: DateTime.parse(reservation.date_presence.toString()),
//                                           firstDate: tomorrow,
//                                           lastDate: DateTime(2101),
//                                         );
//                                         if (pickedDate != null) {
//                                           String formattedDate =
//                                           DateFormat("yyyy-MM-dd").format(pickedDate);
//                                           datePresenceController.text =
//                                               formattedDate.toString();
//                                           print(formattedDate);
//                                           getSeances(formattedDate);
//                                         } else {
//                                           print('Not selected');
//                                         }
//                                       },*/
//                                     ),
//
//                                     SizedBox(
//                                       height: 15,
//                                     ),
//                                     LabelText(
//                                         title: 'Seance *'
//                                     ),
//                                     BsSelectBox(
//                                       hintText: 'Seance',
//                                       controller: _selectSeances,
//                                       disabled: true,
//                                     ),
//                                   ],
//                                 )
//                             ),
//                             SizedBox(width: 60,),
//                             Expanded(
//                                 flex: 1,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     LabelText(
//                                         title: 'Statut de la réservation'
//                                     ),
//                                     BsSelectBox(
//                                       hintText: 'Status',
//                                       controller: _selectStatus,
//                                       onChange: (value) {
//                                         Navigator.pop(context);
//                                         print(_selectStatus.getSelected()?.getValue());
//                                         if(_selectStatus.getSelected()?.getValue() == 0){
//                                           _selectPrsesnce.setSelected(BsSelectBoxOption(value: 0, text: Text('Absent')));
//                                         }
//                                         modal_update(context, reservation, update_select: true);
//                                       },
//                                     ),
//                                     SizedBox(
//                                       height: 15,
//                                     ),
//                                     LabelText(
//                                         title: 'Présence'
//                                             ),
//                                     BsSelectBox(
//                                       hintText: 'Présence',
//                                       controller: _selectPrsesnce,
//                                       disabled: _selectStatus.getSelected() == null ? true : _selectStatus.getSelected()?.getValue() == 0 ? true : false,
//                                       onChange: (value){
//                                         if(_selectPrsesnce.getSelected()?.getValue() == 1){
//                                           moti_controller.text = "";
//                                         }
//                                         Navigator.pop(context);
//                                         modal_update(context, reservation, update_select: true);
//                                       }
//                                     ),
//                                     /*if(_selectStatus.getSelected()?.getValue())...[
//                                       BsSelectBox(
//                                         hintText: 'Présence',
//                                         controller: _selectPrsesnce,
//                                         disabled: false,
//                                       ),
//                                     ]else ...[
//                                       BsSelectBox(
//                                         hintText: 'Présence',
//                                         controller: _selectPrsesnce,
//                                         disabled: true,
//                                       ),
//                                     ],*/
//                                     SizedBox(
//                                           height: 15,
//                                         ),
//                                     LabelText(
//                                         title: 'Motif Annulation'
//                                     ),
//                                     Container(
//                                         width: double.infinity,
//                                         decoration: BoxDecoration(boxShadow: [
//
//                                         ]),
//                                         child: TextField(
//                                           controller: moti_controller,
//                                           enabled: _selectPrsesnce.getSelected()?.getValue() != null ?
//                                           _selectPrsesnce.getSelected()?.getValue() == 1 ? false : true : false,
//                                           autofocus: _selectStatus.getSelected()?.getValue() == 0 ? true : _selectPrsesnce.getSelected()?.getValue() == 0 ? true : false,
//                                           decoration: new InputDecoration(
//                                               hintText: 'Motif Annulation',
//                                               hintStyle: TextStyle(fontSize: 14),
//                                           ),
//                                         )
//                                     ),
//                                     SizedBox(
//                                       height: 25,
//                                     ),
//                                   ],
//                                 )
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 15,),
//                         InkWell(
//                           onTap: (){
//                             update(context, reservation.id_reservation!);
//                           },
//                           child: Row(
//                             children: [
//                               Container(
//                                 child:
//                                 Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 13),)),
//                                 height: 40,
//                                 width: 100,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(6),
//                                     color: Colors.blue,
//                                     border: Border.all(
//                                         color: Colors.blueAccent
//                                     )
//                                 ),
//                               ),
//                               SizedBox(width: 350,),
//                               LabelText(
//                                   title: 'Nb: *  designe un champ obligatoire'
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     // child: Column(
//                     //   mainAxisAlignment: MainAxisAlignment.start,
//                     //   crossAxisAlignment: CrossAxisAlignment.start,
//                     //   children: [
//                     //     LabelText(
//                     //         title: 'Client *'
//                     //     ),
//                     //     BsSelectBox(
//                     //       hintText: 'Client',
//                     //       controller: _selectClient,
//                     //     ),
//                     //     SizedBox(
//                     //       height: 15,
//                     //     ),
//                     //     LabelText(
//                     //         title: 'Date Présence *'
//                     //     ),
//                     //     TextField(
//                     //       decoration: InputDecoration(
//                     //         icon: Icon(Icons.calendar_today),
//                     //         labelText: 'Date de Présence',
//                     //       ),
//                     //       readOnly: true,
//                     //       controller: datePresenceController,
//                     //       onTap: () async {
//                     //         DateTime? pickedDate = await showDatePicker(
//                     //           context: context,
//                     //           initialDate: DateTime.parse(reservation.date_presence.toString()),
//                     //           firstDate: tomorrow,
//                     //           lastDate: DateTime(2101),
//                     //         );
//                     //         if (pickedDate != null) {
//                     //           String formattedDate =
//                     //           DateFormat("yyyy-MM-dd").format(pickedDate);
//                     //
//                     //           datePresenceController.text =
//                     //               formattedDate.toString();
//                     //           print(formattedDate);
//                     //           getSeances(formattedDate);
//                     //         } else {
//                     //           print('Not selected');
//                     //         }
//                     //       },
//                     //     ),
//                     //
//                     //     SizedBox(
//                     //       height: 15,
//                     //     ),
//                     //     LabelText(
//                     //         title: 'Seance *'
//                     //     ),
//                     //     BsSelectBox(
//                     //       hintText: 'Seance',
//                     //       controller: _selectSeances,
//                     //     ),
//                     //     SizedBox(
//                     //       height: 15,
//                     //     ),
//                     //     LabelText(
//                     //         title: 'Status'
//                     //     ),
//                     //     BsSelectBox(
//                     //       hintText: 'Status',
//                     //       controller: _selectStatus,
//                     //     ),
//                     //     SizedBox(
//                     //       height: 15,
//                     //     ),
//                     //     LabelText(
//                     //         title: 'Présence'
//                     //     ),
//                     //     BsSelectBox(
//                     //       hintText: 'Présence',
//                     //       controller: _selectPrsesnce,
//                     //     ),
//                     //     SizedBox(
//                     //       height: 15,
//                     //     ),
//                     //     LabelText(
//                     //         title: 'Motif Annulation'
//                     //     ),
//                     //     Container(
//                     //         width: double.infinity,
//                     //         decoration: BoxDecoration(boxShadow: [
//                     //
//                     //         ]),
//                     //         child: TextField(
//                     //           controller: moti_controller,
//                     //           decoration: new InputDecoration(
//                     //               hintText: 'Motif Annulation',
//                     //               hintStyle: TextStyle(fontSize: 14)
//                     //           ),
//                     //         )
//                     //     ),
//                     //     SizedBox(
//                     //       height: 25,
//                     //     ),
//                     //
//                     //     SizedBox(height: 15,),
//                     //     InkWell(
//                     //       onTap: (){
//                     //         update(context, reservation.id_reservation!);
//                     //       },
//                     //       child: Row(
//                     //         children: [
//                     //           Container(
//                     //             child:
//                     //             Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
//                     //             height: 40,
//                     //             width: 120,
//                     //             decoration: BoxDecoration(
//                     //                 borderRadius: BorderRadius.circular(6),
//                     //                 color: Colors.blue,
//                     //                 border: Border.all(
//                     //                     color: Colors.blueAccent
//                     //                 )
//                     //             ),
//                     //           ),
//                     //           SizedBox(width: 350,),
//                     //           LabelText(
//                     //               title: 'Nb: *  designe un champ obligatoire'
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                   ),
//                 ],
//               ),
//             )));
//   }
//
//   void update(context, int id) async {
//
//     /*if(!datePresenceController.text.isNotEmpty){
//       showAlertDialog(context, "date is null");
//     }
//
//     if(_selectClient.getSelected()?.getValue() == null){
//       showAlertDialog(context, "_selectClient is null");
//     }
//
//     if(_selectSeances.getSelected()?.getValue() == null){
//       showAlertDialog(context, "_selectSeances is null");
//     }*/
//
//     if(
//     //datePresenceController.text.isNotEmpty
//       //  && _selectClient.getSelected()?.getValue() != null
//         //&& _selectSeances.getSelected()?.getValue() != null
//     // && _selectPrsesnce.getSelected()?.getValue() != null
//     // && _selectStatus.getSelected()?.getValue() != null
//     true
//     )
//     {
//       if(_selectPrsesnce.getSelected()?.getValue() == 0){
//         if(moti_controller.text.length == 0){
//           showAlertDialog(context, "Ajouter un motif");
//           return;
//         }
//       }
//       var rev = <String, dynamic>{
//         "id_reservation": id,
//         "id_client": _selectClient.getSelected()?.getValue(),
//         "id_seance": _selectSeances.getSelected()?.getValue(),
//         "date_presence": datePresenceController.text,
//         "status": _selectStatus.getSelected()?.getValue(),
//         "presence": _selectPrsesnce.getSelected()?.getValue(),
//         "motif_annulation": moti_controller.text,
//       };
//
//
//       if(_selectStatus.getSelected() != null){
//         rev["status"] = _selectStatus.getSelected()?.getValue();
//       }
//
//       if(_selectPrsesnce.getSelected() != null){
//         rev["presence"] = _selectPrsesnce.getSelected()?.getValue();
//       }
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
//           fetchReservation();
//           initData();
//         }else{
//           showAlertDialog(context, body["msg"]);
//         }
//
//       } else {
//         showAlertDialog(context,"Failed to update data");
//       }
//     }else{
//       showAlertDialog(context, "Remplir tous les champs");
//     }
//
//   }
//
//   void initData(){
//     moti_controller.text = "";
//     datePresenceController.text = "";
//     date_presence = "";
//     _selectPrsesnce.clear();
//     _selectSeances.clear();
//     _selectStatus.clear();
//     _selectClient.clear();
//     if(_selectCours.getSelected()?.getValue() != null){
//       _selectCours.removeSelected(_selectCours.getSelected()!);
//     }
//
//     getClient();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             color: Colors.grey[200]
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Row(
//             children: [
//               SideBar(postion: 8,msg:"Coach"),
//               SizedBox(width: 10,),
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                       child:Container(
//                                         height: 40,
//                                         decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(20),
//                                             color: Colors.grey[200],
//                                             border: Border.all(
//                                                 color: Colors.orange
//                                             )
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(3.0),
//                                           child: Row(
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               InkWell(
//                                                 child: Container(
//                                                   width: 33,
//                                                   height: 33,
//                                                   child: Icon(Icons.search, color: Colors.white,),
//                                                   decoration: BoxDecoration(
//                                                       shape: BoxShape.circle,
//                                                       color: Colors.orange
//
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(width: 5,),
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: SizedBox(
//                                                   child: TextFormField(
//                                                     onChanged: (val)=>{
//                                                       search(val)
//                                                     },
//                                                     decoration: InputDecoration(
//                                                         border: InputBorder.none,
//                                                         hintText: "Chercher"
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                   ),
//                                   SizedBox(width: 10,),
//                                   Container(
//                                     child: Icon(Icons.add_alert_outlined, size: 20,),
//                                     height: 40,
//                                     width: 40,
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.grey[200],
//                                         border: Border.all(
//                                             color: Colors.orange
//                                         )
//                                     ),
//                                   ),
//                                   SizedBox(width: 10,),
//                                   Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.rectangle,
//                                         image: DecorationImage(
//                                           fit: BoxFit.cover,
//                                           image: NetworkImage('https://cdn-icons-png.flaticon.com/512/219/219969.png'),
//                                         ),
//                                         borderRadius: BorderRadius.circular(20),
//                                         color: Colors.grey[200]
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 20,),
//                               screenSize.width > 520 ?
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text("Les Réservations", style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.grey
//                                   )),
//                                   Container(
//                                     width: 180,
//                                     child: BsSelectBox(
//                                       hintText: 'Filtrer',
//                                       controller: _selectStatusResrvation,
//                                       onChange: (v){
//                                         filterReservation();
//                                       },
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: (){
//                                       /*Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => AddReservation(),
//                                           )).then((val)=>fetchReservation()
//                                       );*/
//                                       modal_add(context);
//                                     },
//                                     child: Container(
//                                       height: 40,
//                                       decoration: BoxDecoration(
//                                           color: Colors.blue[200],
//                                           borderRadius: BorderRadius.circular(10)
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text("Ajouter une réservation",
//                                               style: TextStyle(
//                                                   fontSize: 15
//                                               )),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ):
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text("Liste des Réservations", style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.grey
//                                   )),
//                                   SizedBox(height: 5,),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         width: 180,
//                                         child: BsSelectBox(
//                                           hintText: 'Filtrer',
//                                           controller: _selectStatusResrvation,
//                                           onChange: (v){
//                                             filterReservation();
//                                           },
//                                         ),
//                                       ),
//                                       InkWell(
//                                         onTap: (){
//                                           //
//                                           modal_add(context);
//                                         },
//                                         child: Container(
//                                           height: 40,
//                                           decoration: BoxDecoration(
//                                               color: Colors.blue[200],
//                                               borderRadius: BorderRadius.circular(10)
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Center(
//                                               child: Icon(
//                                                   Icons.add,
//                                                   size: 18,
//                                                   color: Colors.white
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Expanded(
//                                   flex: 1,
//                                   child: ListView(
//                                       children:[
//                                         DataTable(
//                                             dataRowHeight: DataRowHeight,
//                                             headingRowHeight: HeadingRowHeight,
//                                             columns: screenSize.width > 800 ?
//                                             <DataColumn>[
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     ' Nom du Client',
//                                                     style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     'Cours',
//                                                     style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                               // DataColumn(
//                                               //   label: Expanded(
//                                               //     child: Text(
//                                               //       'date reservation',
//                                               //       style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     ' Date seance',
//                                                     style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     ' Statut de la réservation',
//                                                     style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                               // DataColumn(
//                                               //   label: Expanded(
//                                               //     child: Text(
//                                               //       "Motif",
//                                               //       style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     "",
//                                                     style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//
//                                             ]:
//                                             <DataColumn>[
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     ' Nom du Client',
//                                                     style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     '',
//                                                     style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                             rows:
//                                             data.map<DataRow>((r) => screenSize.width > 800 ?
//                                                 DataRow(
//                                                   cells: <DataCell>[
//                                                     DataCell(Row(
//                                                       children: [
//                                                         r.status == null ?
//                                                         Icon(Icons.pending, size: 22, color: Colors.orangeAccent,) :
//                                                             r.status == true ?
//                                                         Icon(Icons.check_circle_outline, size: 22, color: Colors.green,) :
//                                                         Icon(Icons.close_rounded, size: 22, color: Colors.red,),
//                                                         SizedBox(width: 9,),
//                                                         Text(r.client.toString(), overflow: TextOverflow.ellipsis,),
//                                                       ],
//                                                     )),
//                                                     DataCell(Text(r.cour.toString())),
//
//                                                     DataCell(
//                                                         Text(
//                                                             "${r.date_presence}"
//                                                         )),
//                                                     DataCell(
//                                                         Text(
//                                                             "${r.status == null ? "-" : r.status == false ? "Annulée" : "Validée"}"
//                                                         )),
//
//                                                     DataCell(Row(
//                                                       children: [
//                                                         ShowButton(
//                                                             msg:"•Visualisation Les détails du reservation",
//                                                             onPressed: (){
//                                                               showDialog(context: context, builder: (context) =>
//                                                                   BsModal(
//                                                                       context: context,
//                                                                       dialog: BsModalDialog(
//                                                                         size: BsModalSize.md,
//                                                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                                                         child: BsModalContent(
//                                                                           decoration: BoxDecoration(
//                                                                             color: Colors.white,
//                                                                           ),
//                                                                           children: [
//                                                                             BsModalContainer(
//                                                                               //title:
//                                                                               crossAxisAlignment: CrossAxisAlignment.center,
//                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                               actions: [
//                                                                                 Text('${r.client.toString()}',
//                                                                                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                                                                 BsButton(
//                                                                                   style: BsButtonStyle.outlinePrimary,
//                                                                                   label: Text('Fermer'),
//                                                                                   //prefixIcon: Icons.close,
//                                                                                   onPressed: () {
//                                                                                     initData();
//                                                                                     Navigator.pop(context);
//                                                                                   },
//                                                                                 )
//                                                                               ],
//                                                                               //closeButton: true,
//
//                                                                             ),
//                                                                             //BsModalContainer(title: Text('${r.client.toString()}'), closeButton: true),
//                                                                             BsModalContainer(
//                                                                               child: Row(
//                                                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                   children: [
//                                                                                     SizedBox(width: 8,),
//                                                                                     Expanded(
//                                                                                         child: Column(
//                                                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                           children: [
//                                                                                             SizedBox(height: 4,),
//                                                                                             Row(
//                                                                                               children: [
//                                                                                                 Text("Seance:" ,style: TextStyle(
//                                                                                                     fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                                 ),),
//                                                                                                 SizedBox(width: 9,),
//                                                                                                 Text("${r.cour.toString()}"),
//                                                                                               ],
//                                                                                             ),
//                                                                                             SizedBox(height: 4,),
//                                                                                             //Text("Date séance reserver: ${r.datereservation.toString()}"),
//                                                                                            // SizedBox(height: 4,),
//                                                                                             Row(
//                                                                                               children: [
//                                                                                                 Text("Créneau cours:" ,style: TextStyle(
//                                                                                                     fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                                 ),),
//                                                                                                 SizedBox(width: 9,),
//                                                                                                 Text("le ${r.date_presence.toString()} De ${r.heur_debut.toString()} à ${r.heure_fin.toString()}"),
//                                                                                               ],
//                                                                                             ),
//                                                                                             // ${seance.heure_debut} à ${seance.heure_fin}/
//                                                                                             SizedBox(height: 4,),
//                                                                                             Row(
//                                                                                               children: [
//                                                                                                 Text("Motif d'annulation :" ,style: TextStyle(
//                                                                                                     fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                                 ),),
//                                                                                                 SizedBox(width: 9,),
//                                                                                                 if(r.motif_annulation != null)
//                                                                                                   Text("${r.motif_annulation }"),
//                                                                                               ],
//                                                                                             ),
//                                                                                             // if(r.motif_annulation != null)
//                                                                                             //   Text(" Motif d'annulation : ${r.motif_annulation }"),
//                                                                                             //!= null ? r.motif_annulation.toString() : "-"
//                                                                                             SizedBox(height: 4,),
//                                                                                             Row(
//                                                                                               children: [
//                                                                                                 Text("Statut de la réservation :" ,style: TextStyle(
//                                                                                                     fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                                 ),),
//                                                                                                 SizedBox(width: 9,),
//                                                                                                 Text("${r.status == null ? "-" : r.status == false ? "Annulée" : "Validée"}"),
//                                                                                               ],
//                                                                                             ),
//                                                                                           ],
//                                                                                         )
//                                                                                     )
//                                                                                   ]
//                                                                               ),
//                                                                             ),
//                                                                             BsModalContainer(
//                                                                               crossAxisAlignment: CrossAxisAlignment.end,
//                                                                               actions: [
//                                                                                 //Navigator.pop(context);
//                                                                               ],
//                                                                             )
//                                                                           ],
//                                                                         ),
//                                                                       )));
//                                                             }
//                                                         ),
//                                                         SizedBox(width: 10,),
//                                                         EditerButton(
//                                                             msg: "mettre à jour les informations de la Réservation",
//                                                             onPressed: (){
//                                                               modal_update(context, r);
//                                                             }
//                                                         ),
//                                                         SizedBox(width: 10,),
//                                                         DeleteButton(
//                                                           msg:"supprimer Réservation",
//                                                           onPressed: () async{
//                                                             if (await confirm(
//                                                                 context,
//                                                                 title: const Text('Confirmation'),
//                                                                 content: const Text('Souhaitez-vous supprimer ?'),
//                                                                 textOK: const Text('Oui'),
//                                                                 textCancel: const Text('Non'),
//                                                             )) {
//
//                                                               delete(r.id_reservation.toString());
//                                                             }
//
//                                                           },
//                                                         ),
//                                                       ],
//                                                     ))
//
//                                                   ],
//                                                 ):
//                                                 DataRow(
//                                                   cells: <DataCell>[
//                                                     DataCell(Row(
//                                                       children: [
//
//                                                         r.status == true ?
//                                                         Icon(Icons.check_circle_outline, size: 22, color: Colors.green,) :
//                                                         r.status == false ?
//                                                         Icon(Icons.close_rounded, size: 22, color: Colors.red,) :
//                                                         Icon(Icons.pending, size: 22, color: Colors.orangeAccent,) ,
//
//                                                         SizedBox(width: 3,),
//                                                         Expanded(
//                                                             child: Text(r.client.toString(),
//                                                             overflow: TextOverflow.ellipsis,
//                                                             )
//                                                         ),
//                                                       ],
//                                                     )),
//                                                     DataCell(Row(
//                                                       children: [
//                                                         ShowButton(
//                                                             msg:"•Visualisation Les détails du reservation",
//                                                             onPressed: (){
//                                                               showDialog(context: context, builder: (context) =>
//                                                                   BsModal(
//                                                                       context: context,
//                                                                       dialog: BsModalDialog(
//                                                                         size: BsModalSize.md,
//                                                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                                                         child: BsModalContent(
//                                                                           decoration: BoxDecoration(
//                                                                             color: Colors.white,
//                                                                           ),
//                                                                           children: [
//                                                                             BsModalContainer(
//                                                                               //title:
//                                                                               crossAxisAlignment: CrossAxisAlignment.center,
//                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                               actions: [
//                                                                                 Text('${r.client.toString()}',
//                                                                                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                                                                 BsButton(
//                                                                                   style: BsButtonStyle.outlinePrimary,
//                                                                                   label: Text('Fermer'),
//                                                                                   //prefixIcon: Icons.close,
//                                                                                   onPressed: () {
//                                                                                     initData();
//                                                                                     Navigator.pop(context);
//                                                                                   },
//                                                                                 )
//                                                                               ],
//                                                                               //closeButton: true,
//
//                                                                             ),
//                                                                            // BsModalContainer(title: Text('${r.client.toString()}'), closeButton: true),
//                                                                             BsModalContainer(
//                                                                               child: Row(
//                                                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                   children: [
//                                                                                     SizedBox(width: 8,),
//                                                                                     Expanded(
//                                                                                         child: Column(
//                                                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                           children: [
//                                                                                             SizedBox(height: 4,),
//                                                                                             Column(
//                                                                                               mainAxisAlignment: MainAxisAlignment.start,
//                                                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                               children: [
//                                                                                                 Text("Seance:" ,style: TextStyle(
//                                                                                                     fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                                 ),),
//                                                                                                 SizedBox(height: 4,),
//                                                                                                 Text("${r.cour.toString()}"),
//                                                                                               ],
//                                                                                             ),
//                                                                                             SizedBox(height: 4,),
//                                                                                             //Text("Date séance reserver: ${r.datereservation.toString()}"),
//                                                                                             // SizedBox(height: 4,),
//                                                                                             Column(
//                                                                                               mainAxisAlignment: MainAxisAlignment.start,
//                                                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                               children: [
//                                                                                                 Text("Créneau cours: " ,style: TextStyle(
//                                                                                                     fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                                 ),),
//                                                                                                 SizedBox(height: 4,),
//                                                                                                 Text(" le ${r.date_presence.toString()} De ${r.heur_debut.toString()} à ${r.heure_fin.toString()}"),
//                                                                                               ],
//                                                                                             ),
//                                                                                             // ${seance.heure_debut} à ${seance.heure_fin}/
//                                                                                             SizedBox(height: 4,),
//                                                                                             Column(
//                                                                                               mainAxisAlignment: MainAxisAlignment.start,
//                                                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                               children: [
//                                                                                                 Text("Motif d'annulation :" ,style: TextStyle(
//                                                                                                     fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                                 ),),
//                                                                                                 SizedBox(height: 4,),
//                                                                                                 if(r.motif_annulation != null)
//                                                                                                   Text("${r.motif_annulation }"),
//                                                                                               ],
//                                                                                             ),
//                                                                                             // if(r.motif_annulation != null)
//                                                                                             //   Text(" Motif d'annulation : ${r.motif_annulation }"),
//                                                                                             //!= null ? r.motif_annulation.toString() : "-"
//                                                                                             SizedBox(height: 4,),
//                                                                                             Column(
//                                                                                               mainAxisAlignment: MainAxisAlignment.start,
//                                                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                               children: [
//                                                                                                 Text("Statut de la réservation :" ,style: TextStyle(
//                                                                                                     fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                                 ),),
//                                                                                                 SizedBox(height: 4,),
//                                                                                                 Text("${r.status == null ? "-" : r.status == false ? "Annulée" : "Validée"}"),
//                                                                                               ],
//                                                                                             ),
//                                                                                           ],
//                                                                                         )
//                                                                                     )
//                                                                                   ]
//                                                                               ),
//                                                                             ),
//                                                                             BsModalContainer(
//                                                                               crossAxisAlignment: CrossAxisAlignment.end,
//                                                                               actions: [
//                                                                                 //Navigator.pop(context);
//                                                                               ],
//                                                                             )
//                                                                           ],
//                                                                         ),
//                                                                       )));
//                                                             }
//                                                         ),
//                                                         SizedBox(width: 5,),
//                                                         EditerButton(
//                                                             msg: "mettre à jour les informations de la Réservation",
//                                                             onPressed: (){
//                                                               modal_update(context, r);
//                                                             }
//                                                         ),
//                                                         SizedBox(width: 10,),
//                                                         // DeleteButton(
//                                                         //   onPressed: () async{
//                                                         //     if (await confirm(
//                                                         //       context,
//                                                         //       title: const Text('Confirmation'),
//                                                         //       content: const Text('Souhaitez-vous supprimer ?'),
//                                                         //       textOK: const Text('Oui'),
//                                                         //       textCancel: const Text('Non'),
//                                                         //     )) {
//                                                         //
//                                                         //       delete(r.id_reservation.toString());
//                                                         //     }
//                                                         //
//                                                         //   },
//                                                         // ),
//                                                       ],
//                                                     ))
//                                                   ],
//                                                 )
//                                             ).toList()
//                                         ),]
//                                   )
//                               )
//                             ],
//                           ),
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
// }
//
