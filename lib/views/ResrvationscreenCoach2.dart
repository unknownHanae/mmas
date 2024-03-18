import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/Staff.dart';
import 'package:adminmmas/my_flutter_app_icons.dart';
import 'package:adminmmas/views/Addreservation.dart';
import 'package:adminmmas/views/UpdateReservation.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_planner/time_planner.dart';
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../componnents/showButton.dart';
import '../componnents/showButtonCoach.dart';
import '../models/CatContratModels.dart';
import '../models/ClientModels.dart';
import '../models/ContratModels.dart';
import '../models/CoursModels.dart';
import '../models/ReservationModels.dart';
import '../models/SeanceModels.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import 'package:confirm_dialog/confirm_dialog.dart';

import '../widgets/navigation_bar_Coach.dart';
import 'ContratScreen.dart';
import 'PlanningScreen.dart';

import 'dart:html' as html;

class ReservationScreenCoach2 extends StatefulWidget {

  int classe_id;
  int seance_id;
  int prof_id;
  String date_presence;
  ReservationScreenCoach2({Key? key, required this.classe_id, required this.seance_id, required this.prof_id,required this.date_presence}) : super(key: key);

  @override
  State<ReservationScreenCoach2> createState() => _ReservationState();
}

class _ReservationState extends State<ReservationScreenCoach2> {
  var selectedOption = null;
  List<Client> data = [];
  List<Client> init_data = [];
  List<Staff> data2 = [];
  List<Staff> init_data2 = [];

  bool presence_prof = false;

  bool loading = false;

  var selectedOptions = {};

  String text_search = "";


  String motif = "";
  String date_presence = "";
  BsSelectBoxController _selectpresence = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 1, text: Text("Present")),
        BsSelectBoxOption(value: 0, text: Text("absent")),
      ]
  );


  void fetchPresencesEtd() async {


    final response = await http.get(Uri.parse(
        HOST+'/api/presences_etds?id_seance=${widget.seance_id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      print("--result--");
      print(result.length);
      result.forEach((r) {
        if(r["presence"] != null){
          if(r["presence"]){
            selectedOptions["${r['id_etd']}"] = 1;
          }else{
            selectedOptions["${r['id_etd']}"] = 0;
          }
        }else{
          selectedOptions["${r['id_etd']}"] = null;
        }
      });
      print(selectedOptions);
      fetchEtudiants();
    } else {
      throw Exception('Failed to load data');
    }


  }

  void fetchPresencesProf() async {


    final response = await http.get(Uri.parse(
        HOST+'/api/presences_profs?id_seance=${widget.seance_id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data2"];
      print("--result--");
      print(result.length);
      result.forEach((p) {
        if(p["presence"] != null){
          if(p["presence"]){
            selectedOptions["${p['id_prof']}"] = 1;
          }else{
            selectedOptions["${p['id_prof']}"] = 0;
          }
        }else{
          selectedOptions["${p['id_prof']}"] = null;
        }
      });
      print(selectedOptions);
      fetchProfs();
    } else {
      throw Exception('Failed to load data');
    }


  }

  void fetchProfs() async {


    final response = await http.get(Uri.parse(
        HOST+'/api/prof_by_id?id_prof=${widget.prof_id}&id_seance=${widget.seance_id}&date_presence=${widget.date_presence}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      print("--result--");
      print(result.length);
      setState(() {
        data2 = result.map<Staff>((e) => Staff.fromJson(e)).toList();
        init_data2 = result.map<Staff>((e) => Staff.fromJson(e)).toList();
      });
      print("--data--");
      print(data.length);
      var prof = result != null && result.length > 0 ? result[0] : null;
      if(prof != null){
        if(prof["presence"] != null){
          if(prof["presence"]){
            presence_prof = true;
          }else{
            presence_prof = false;
          }
        }else {
          presence_prof = false;
        }
      }
    } else {
      throw Exception('Failed to load data');
    }


  }


  void fetchEtudiants() async {


    final response = await http.get(Uri.parse(
        HOST+'/api/Etudiant_by_classe?id_classe=${widget.classe_id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      print("--result--");
      print(result.length);
      setState(() {
        data = result.map<Client>((e) => Client.fromJson(e)).toList();
        init_data = result.map<Client>((e) => Client.fromJson(e)).toList();
      });
      print("--data--");
      print(data.length);
    } else {
      throw Exception('Failed to load data');
    }


  }

  // void search(String key){
  //   if(key.length > 0){
  //     final List<Reservation> founded = [];
  //     init_data.forEach((e) {
  //       if( e.id_seance == key
  //           || e.client!.toLowerCase().contains(key.toLowerCase())
  //           || e.cour!.toLowerCase().contains(key.toLowerCase())
  //           || e.date_presence!.toLowerCase().contains(key.toLowerCase())
  //       )
  //       {
  //         founded.add(e);
  //       }
  //     });
  //     setState(() {
  //       data = founded;
  //     });
  //   }else {
  //     setState(() {
  //       data = init_data;
  //     });
  //   }
  //
  // }

  var token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state");
    fetchPresencesEtd();
    fetchProfs();

  }


  showAlertDialog(BuildContext context, String msg) {
    Widget cancelButton = TextButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reservation"),
      content: Text(msg),
      actions: [
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  void setPresence(Client c, value, {String motif=""}) async {
    if(c != null){
      var obj_data = <String, dynamic>{
        "id_etd": c.id_etudiant,
        "presence": value,
        "id_seance": widget.seance_id,
        "date_presence": widget.date_presence,
        "status": 1,
        "motif_annulation": motif
      };
      final response = await http.post(Uri.parse(
          HOST+"/api/set_presence"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(obj_data),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          setState(() {
            selectedOptions["${c.id_etudiant}"] = value;
          });
          print(selectedOptions);
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context,"Failed to update data");
      }
    }
  }
  void setPresenceprof(Staff p, value, {String motif=""}) async {
    if(p != null){
      var obj_data = <String, dynamic>{
        "id_prof": p.id_employe,
        "presence": value,
        "id_seance": widget.seance_id,
        "date_pres": widget.date_presence,
        "status": 1,
        "motif_abs" : motif
      };
      final response = await http.post(Uri.parse(
          HOST+"/api/set_presenceProf"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(obj_data),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          if(value == 1){
            setState(() {
              presence_prof = true;
            });
          }else{
            setState(() {
              presence_prof = false;
            });
          }
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context,"Failed to update data");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200]
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              SideBar(postion: 8,msg:"Coach"),
              SizedBox(width: 10,),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      child: Icon(Icons.arrow_back, size: 20, color: Colors.orange,),
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[200],
                                          border: Border.all(
                                              color: Colors.orange
                                          )
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 20,),
                              screenSize.width > 520 ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Pointage", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                    ],
                                  ),
                                ],
                              ):
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("les seances", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      InkWell(
                                        onTap: (){
                                          //fiche_presence();
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[200],
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Icon(
                                                  Icons.library_books,
                                                  size: 18,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,

                                  child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child:
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text("Prof", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                                                SizedBox(height: 10,),
                                                DataTable(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                  ),
                                                  dataRowHeight: DataRowHeight,
                                                  headingRowHeight: HeadingRowHeight,

                                                  columns: screenSize.width > 800 ?
                                                  <DataColumn>[
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Prof',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Présence',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),

                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          "",
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ]:
                                                  <DataColumn>[
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Prof',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Présence',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                  rows:
                                                  data2.map<DataRow>((r) => screenSize.width > 800 ?
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Row(
                                                        children: [
                                                          Text("${r.nom.toString()} ${r.prenom.toString()}", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),
                                                      DataCell(
                                                        Switch(
                                                          value: presence_prof,
                                                          onChanged: (bool value) async {
                                                            if(!value){
                                                              String motif = "";
                                                              return await showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return
                                                                    AlertDialog(

                                                                      title: const Text("Motif d'absence"),
                                                                      content: SizedBox(
                                                                        height: 100,
                                                                        child: TextField(
                                                                          keyboardType: TextInputType.multiline,
                                                                          expands: true,
                                                                          maxLines: null,
                                                                          onChanged: (v){
                                                                            motif = v;
                                                                          },
                                                                          autofocus: true,

                                                                          decoration: const InputDecoration(
                                                                              hintText: "Motif"),
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          child: Text('Valider'),
                                                                          onPressed: () {
                                                                            setPresenceprof(r, value ? 1 : 0, motif: motif);

                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                },
                                                              );
                                                            }else{
                                                              setPresenceprof(r, value ? 1 : 0);
                                                            }

                                                          },
                                                        ),
                                                      ),

                                                      DataCell(Row(
                                                        children: [
                                                          // ShowButton(
                                                          //     msg:"•Visualisation Les détails du reservation",
                                                          //     onPressed: (){
                                                          //       showDialog(context: context, builder: (context) =>
                                                          //           BsModal(
                                                          //               context: context,
                                                          //               dialog: BsModalDialog(
                                                          //                 size: BsModalSize.md,
                                                          //                 crossAxisAlignment: CrossAxisAlignment.center,
                                                          //                 child: BsModalContent(
                                                          //                   decoration: BoxDecoration(
                                                          //                     color: Colors.white,
                                                          //                   ),
                                                          //                   children: [
                                                          //                     BsModalContainer(
                                                          //                       //title:
                                                          //                       crossAxisAlignment: CrossAxisAlignment.center,
                                                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                       actions: [
                                                          //                         Text('${r.client.toString()}',
                                                          //                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                          //                         BsButton(
                                                          //                           style: BsButtonStyle.outlinePrimary,
                                                          //                           label: Text('Fermer'),
                                                          //                           //prefixIcon: Icons.close,
                                                          //                           onPressed: () {
                                                          //                             initData();
                                                          //                             Navigator.pop(context);
                                                          //                           },
                                                          //                         )
                                                          //                       ],
                                                          //                       //closeButton: true,
                                                          //
                                                          //                     ),
                                                          //                     //BsModalContainer(title: Text('${r.client.toString()}'), closeButton: true),
                                                          //                     BsModalContainer(
                                                          //                       child: Row(
                                                          //                           crossAxisAlignment: CrossAxisAlignment.start,
                                                          //                           children: [
                                                          //                             SizedBox(width: 8,),
                                                          //                             Expanded(
                                                          //                                 child: Column(
                                                          //                                   mainAxisAlignment: MainAxisAlignment.start,
                                                          //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                          //                                   children: [
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     Row(
                                                          //                                       children: [
                                                          //                                         Text("Seance:" ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(width: 9,),
                                                          //                                         Text("${r.cour.toString()}"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     //Text("Date séance reserver: ${r.datereservation.toString()}"),
                                                          //                                     // SizedBox(height: 4,),
                                                          //                                     Row(
                                                          //                                       children: [
                                                          //                                         Text("Créneau cours:" ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(width: 9,),
                                                          //                                         Text("le ${r.date_presence.toString()} De ${r.heur_debut.toString()} à ${r.heure_fin.toString()}"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                     // ${seance.heure_debut} à ${seance.heure_fin}/
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     Row(
                                                          //                                       children: [
                                                          //                                         Text("Motif d'annulation :" ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(width: 9,),
                                                          //                                         if(r.motif_annulation != null)
                                                          //                                           Text("${r.motif_annulation }"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                     // if(r.motif_annulation != null)
                                                          //                                     //   Text(" Motif d'annulation : ${r.motif_annulation }"),
                                                          //                                     //!= null ? r.motif_annulation.toString() : "-"
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     Row(
                                                          //                                       children: [
                                                          //                                         Text("Statut de la réservation :" ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(width: 9,),
                                                          //                                         Text("${r.status == null ? "-" : r.status == false ? "Annulée" : "Validée"}"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                   ],
                                                          //                                 )
                                                          //                             )
                                                          //                           ]
                                                          //                       ),
                                                          //                     ),
                                                          //                     BsModalContainer(
                                                          //                       crossAxisAlignment: CrossAxisAlignment.end,
                                                          //                       actions: [
                                                          //                         //Navigator.pop(context);
                                                          //                       ],
                                                          //                     )
                                                          //                   ],
                                                          //                 ),
                                                          //               )));
                                                          //     }
                                                          // ),
                                                          SizedBox(width: 10,),


                                                        ],
                                                      ))

                                                    ],
                                                  ):
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Row(
                                                        children: [
                                                          //   ShowButtonCoach(
                                                          //     msg:"•Visualisation Les détails du reservation",
                                                          //     onPressed: (){
                                                          //       showDialog(context: context, builder: (context) =>
                                                          //           BsModal(
                                                          //               context: context,
                                                          //               dialog: BsModalDialog(
                                                          //                 size: BsModalSize.md,
                                                          //                 crossAxisAlignment: CrossAxisAlignment.center,
                                                          //                 child: BsModalContent(
                                                          //                   decoration: BoxDecoration(
                                                          //                     color: Colors.white,
                                                          //                   ),
                                                          //                   children: [
                                                          //                     BsModalContainer(
                                                          //                       //title:
                                                          //                       crossAxisAlignment: CrossAxisAlignment.center,
                                                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                       actions: [
                                                          //                         Text('${r.client.toString()}',
                                                          //                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                          //                         BsButton(
                                                          //                           style: BsButtonStyle.outlinePrimary,
                                                          //                           label: Text('Fermer'),
                                                          //                           //prefixIcon: Icons.close,
                                                          //                           onPressed: () {
                                                          //                             initData();
                                                          //                             Navigator.pop(context);
                                                          //                           },
                                                          //                         )
                                                          //                       ],
                                                          //                       //closeButton: true,
                                                          //
                                                          //                     ),
                                                          //                     // BsModalContainer(title: Text('${r.client.toString()}'), closeButton: true),
                                                          //                     BsModalContainer(
                                                          //                       child: Row(
                                                          //                           crossAxisAlignment: CrossAxisAlignment.start,
                                                          //                           children: [
                                                          //                             SizedBox(width: 8,),
                                                          //                             Expanded(
                                                          //                                 child: Column(
                                                          //                                   mainAxisAlignment: MainAxisAlignment.start,
                                                          //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                          //                                   children: [
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     Column(
                                                          //                                       mainAxisAlignment: MainAxisAlignment.start,
                                                          //                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                          //                                       children: [
                                                          //                                         Text("Seance:" ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(height: 4,),
                                                          //                                         Text("${r.cour.toString()}"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     //Text("Date séance reserver: ${r.datereservation.toString()}"),
                                                          //                                     // SizedBox(height: 4,),
                                                          //                                     Column(
                                                          //                                       mainAxisAlignment: MainAxisAlignment.start,
                                                          //                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                          //                                       children: [
                                                          //                                         Text("Créneau cours: " ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(height: 4,),
                                                          //                                         Text(" le ${r.date_presence.toString()} De ${r.heur_debut.toString()} à ${r.heure_fin.toString()}"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                     // ${seance.heure_debut} à ${seance.heure_fin}/
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     Column(
                                                          //                                       mainAxisAlignment: MainAxisAlignment.start,
                                                          //                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                          //                                       children: [
                                                          //                                         Text("Motif d'annulation :" ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(height: 4,),
                                                          //                                         if(r.motif_annulation != null)
                                                          //                                           Text("${r.motif_annulation }"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                     // if(r.motif_annulation != null)
                                                          //                                     //   Text(" Motif d'annulation : ${r.motif_annulation }"),
                                                          //                                     //!= null ? r.motif_annulation.toString() : "-"
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     Column(
                                                          //                                       mainAxisAlignment: MainAxisAlignment.start,
                                                          //                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                          //                                       children: [
                                                          //                                         Text("Statut de la réservation :" ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(height: 4,),
                                                          //                                         Text("${r.status == null ? "-" : r.status == false ? "Annulée" : "Validée"}"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                   ],
                                                          //                                 )
                                                          //                             )
                                                          //                           ]
                                                          //                       ),
                                                          //                     ),
                                                          //                     BsModalContainer(
                                                          //                       crossAxisAlignment: CrossAxisAlignment.end,
                                                          //                       actions: [
                                                          //                         //Navigator.pop(context);
                                                          //                       ],
                                                          //                     )
                                                          //                   ],
                                                          //                 ),
                                                          //               )));
                                                          //     }
                                                          // ),
                                                          SizedBox(width: 5,),
                                                          Expanded(
                                                              child: Text(r.nom.toString(),
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          ),


                                                        ],
                                                      )),
                                                      DataCell(
                                                        Switch(
                                                          value: presence_prof,
                                                          onChanged: (bool value) async {
                                                            if(!value){
                                                              String motif = "";
                                                              return await showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return
                                                                    AlertDialog(

                                                                      title: const Text("Motif d'abscence"),
                                                                      content: SizedBox(
                                                                        height: 100,
                                                                        child: TextField(
                                                                          keyboardType: TextInputType.multiline,
                                                                          expands: true,
                                                                          maxLines: null,
                                                                          onChanged: (v){
                                                                            motif = v;
                                                                          },
                                                                          autofocus: true,
                                                                          decoration: const InputDecoration(
                                                                              hintText: "Motif"),
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          child: Text('Valider'),
                                                                          onPressed: () {
                                                                            setPresenceprof(r, value ? 1 : 0, motif: motif);

                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                },
                                                              );
                                                            }else{
                                                              setPresenceprof(r, value ? 1 : 0);
                                                            }

                                                          },
                                                        ),

                                                      ),

                                                    ],
                                                  )
                                                  ).toList()
                                              ),
                                                Text("Etudiants", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                                                DataTable(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle
                                                  ),
                                                  dataRowHeight: DataRowHeight,
                                                  headingRowHeight: HeadingRowHeight,

                                                  columns: screenSize.width > 800 ?
                                                  <DataColumn>[
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          ' Etudiant',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Présence',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),

                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          "",
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ]:
                                                  <DataColumn>[
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          ' Etudiant',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Présence',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    // DataColumn(
                                                    //   label: Expanded(
                                                    //     child: Text(
                                                    //       '',
                                                    //       style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                  rows:
                                                  data.map<DataRow>((r) => screenSize.width > 800 ?
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Row(
                                                        children: [
                                                          Text(r.nom.toString(), overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),
                                                      DataCell(
                                                        Switch(
                                                          value: selectedOptions["${r.id_etudiant}"] != null ? selectedOptions["${r.id_etudiant}"] == 1 ? true : false : false,
                                                          onChanged: (bool value) async {
                                                            if(!value){
                                                              String motif = "";
                                                              return await showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return
                                                                 AlertDialog(

                                                                  title: const Text("Motif d'absence"),
                                                                  content: SizedBox(
                                                                    height: 100,
                                                                    child: TextField(
                                                                      keyboardType: TextInputType.multiline,
                                                                      expands: true,
                                                                      maxLines: null,
                                                                      onChanged: (v){
                                                                        motif = v;
                                                                      },
                                                                      autofocus: true,
                                                                      decoration: const InputDecoration(
                                                                          hintText: "Motif"),
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      child: Text('Valider'),
                                                                      onPressed: () {
                                                                        setPresence(r, value ? 1 : 0, motif: motif);

                                                                        Navigator.pop(context);
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                                },
                                                              );
                                                            }else{
                                                              setPresence(r, value ? 1 : 0);
                                                            }

                                                          },
                                                        ),
                                                      ),

                                                      DataCell(Row(
                                                        children: [
                                                          // ShowButton(
                                                          //     msg:"•Visualisation Les détails du reservation",
                                                          //     onPressed: (){
                                                          //       showDialog(context: context, builder: (context) =>
                                                          //           BsModal(
                                                          //               context: context,
                                                          //               dialog: BsModalDialog(
                                                          //                 size: BsModalSize.md,
                                                          //                 crossAxisAlignment: CrossAxisAlignment.center,
                                                          //                 child: BsModalContent(
                                                          //                   decoration: BoxDecoration(
                                                          //                     color: Colors.white,
                                                          //                   ),
                                                          //                   children: [
                                                          //                     BsModalContainer(
                                                          //                       //title:
                                                          //                       crossAxisAlignment: CrossAxisAlignment.center,
                                                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                       actions: [
                                                          //                         Text('${r.client.toString()}',
                                                          //                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                          //                         BsButton(
                                                          //                           style: BsButtonStyle.outlinePrimary,
                                                          //                           label: Text('Fermer'),
                                                          //                           //prefixIcon: Icons.close,
                                                          //                           onPressed: () {
                                                          //                             initData();
                                                          //                             Navigator.pop(context);
                                                          //                           },
                                                          //                         )
                                                          //                       ],
                                                          //                       //closeButton: true,
                                                          //
                                                          //                     ),
                                                          //                     //BsModalContainer(title: Text('${r.client.toString()}'), closeButton: true),
                                                          //                     BsModalContainer(
                                                          //                       child: Row(
                                                          //                           crossAxisAlignment: CrossAxisAlignment.start,
                                                          //                           children: [
                                                          //                             SizedBox(width: 8,),
                                                          //                             Expanded(
                                                          //                                 child: Column(
                                                          //                                   mainAxisAlignment: MainAxisAlignment.start,
                                                          //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                          //                                   children: [
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     Row(
                                                          //                                       children: [
                                                          //                                         Text("Seance:" ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(width: 9,),
                                                          //                                         Text("${r.cour.toString()}"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     //Text("Date séance reserver: ${r.datereservation.toString()}"),
                                                          //                                     // SizedBox(height: 4,),
                                                          //                                     Row(
                                                          //                                       children: [
                                                          //                                         Text("Créneau cours:" ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(width: 9,),
                                                          //                                         Text("le ${r.date_presence.toString()} De ${r.heur_debut.toString()} à ${r.heure_fin.toString()}"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                     // ${seance.heure_debut} à ${seance.heure_fin}/
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     Row(
                                                          //                                       children: [
                                                          //                                         Text("Motif d'annulation :" ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(width: 9,),
                                                          //                                         if(r.motif_annulation != null)
                                                          //                                           Text("${r.motif_annulation }"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                     // if(r.motif_annulation != null)
                                                          //                                     //   Text(" Motif d'annulation : ${r.motif_annulation }"),
                                                          //                                     //!= null ? r.motif_annulation.toString() : "-"
                                                          //                                     SizedBox(height: 4,),
                                                          //                                     Row(
                                                          //                                       children: [
                                                          //                                         Text("Statut de la réservation :" ,style: TextStyle(
                                                          //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                          //                                         ),),
                                                          //                                         SizedBox(width: 9,),
                                                          //                                         Text("${r.status == null ? "-" : r.status == false ? "Annulée" : "Validée"}"),
                                                          //                                       ],
                                                          //                                     ),
                                                          //                                   ],
                                                          //                                 )
                                                          //                             )
                                                          //                           ]
                                                          //                       ),
                                                          //                     ),
                                                          //                     BsModalContainer(
                                                          //                       crossAxisAlignment: CrossAxisAlignment.end,
                                                          //                       actions: [
                                                          //                         //Navigator.pop(context);
                                                          //                       ],
                                                          //                     )
                                                          //                   ],
                                                          //                 ),
                                                          //               )));
                                                          //     }
                                                          // ),
                                                          SizedBox(width: 10,),


                                                        ],
                                                      ))

                                                    ],
                                                  ):
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Row(
                                                        children: [
                                                        //   ShowButtonCoach(
                                                        //     msg:"•Visualisation Les détails du reservation",
                                                        //     onPressed: (){
                                                        //       showDialog(context: context, builder: (context) =>
                                                        //           BsModal(
                                                        //               context: context,
                                                        //               dialog: BsModalDialog(
                                                        //                 size: BsModalSize.md,
                                                        //                 crossAxisAlignment: CrossAxisAlignment.center,
                                                        //                 child: BsModalContent(
                                                        //                   decoration: BoxDecoration(
                                                        //                     color: Colors.white,
                                                        //                   ),
                                                        //                   children: [
                                                        //                     BsModalContainer(
                                                        //                       //title:
                                                        //                       crossAxisAlignment: CrossAxisAlignment.center,
                                                        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        //                       actions: [
                                                        //                         Text('${r.client.toString()}',
                                                        //                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                        //                         BsButton(
                                                        //                           style: BsButtonStyle.outlinePrimary,
                                                        //                           label: Text('Fermer'),
                                                        //                           //prefixIcon: Icons.close,
                                                        //                           onPressed: () {
                                                        //                             initData();
                                                        //                             Navigator.pop(context);
                                                        //                           },
                                                        //                         )
                                                        //                       ],
                                                        //                       //closeButton: true,
                                                        //
                                                        //                     ),
                                                        //                     // BsModalContainer(title: Text('${r.client.toString()}'), closeButton: true),
                                                        //                     BsModalContainer(
                                                        //                       child: Row(
                                                        //                           crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                           children: [
                                                        //                             SizedBox(width: 8,),
                                                        //                             Expanded(
                                                        //                                 child: Column(
                                                        //                                   mainAxisAlignment: MainAxisAlignment.start,
                                                        //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                                   children: [
                                                        //                                     SizedBox(height: 4,),
                                                        //                                     Column(
                                                        //                                       mainAxisAlignment: MainAxisAlignment.start,
                                                        //                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                                       children: [
                                                        //                                         Text("Seance:" ,style: TextStyle(
                                                        //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                        //                                         ),),
                                                        //                                         SizedBox(height: 4,),
                                                        //                                         Text("${r.cour.toString()}"),
                                                        //                                       ],
                                                        //                                     ),
                                                        //                                     SizedBox(height: 4,),
                                                        //                                     //Text("Date séance reserver: ${r.datereservation.toString()}"),
                                                        //                                     // SizedBox(height: 4,),
                                                        //                                     Column(
                                                        //                                       mainAxisAlignment: MainAxisAlignment.start,
                                                        //                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                                       children: [
                                                        //                                         Text("Créneau cours: " ,style: TextStyle(
                                                        //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                        //                                         ),),
                                                        //                                         SizedBox(height: 4,),
                                                        //                                         Text(" le ${r.date_presence.toString()} De ${r.heur_debut.toString()} à ${r.heure_fin.toString()}"),
                                                        //                                       ],
                                                        //                                     ),
                                                        //                                     // ${seance.heure_debut} à ${seance.heure_fin}/
                                                        //                                     SizedBox(height: 4,),
                                                        //                                     Column(
                                                        //                                       mainAxisAlignment: MainAxisAlignment.start,
                                                        //                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                                       children: [
                                                        //                                         Text("Motif d'annulation :" ,style: TextStyle(
                                                        //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                        //                                         ),),
                                                        //                                         SizedBox(height: 4,),
                                                        //                                         if(r.motif_annulation != null)
                                                        //                                           Text("${r.motif_annulation }"),
                                                        //                                       ],
                                                        //                                     ),
                                                        //                                     // if(r.motif_annulation != null)
                                                        //                                     //   Text(" Motif d'annulation : ${r.motif_annulation }"),
                                                        //                                     //!= null ? r.motif_annulation.toString() : "-"
                                                        //                                     SizedBox(height: 4,),
                                                        //                                     Column(
                                                        //                                       mainAxisAlignment: MainAxisAlignment.start,
                                                        //                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                                       children: [
                                                        //                                         Text("Statut de la réservation :" ,style: TextStyle(
                                                        //                                             fontWeight: FontWeight.bold, color:Colors.grey
                                                        //                                         ),),
                                                        //                                         SizedBox(height: 4,),
                                                        //                                         Text("${r.status == null ? "-" : r.status == false ? "Annulée" : "Validée"}"),
                                                        //                                       ],
                                                        //                                     ),
                                                        //                                   ],
                                                        //                                 )
                                                        //                             )
                                                        //                           ]
                                                        //                       ),
                                                        //                     ),
                                                        //                     BsModalContainer(
                                                        //                       crossAxisAlignment: CrossAxisAlignment.end,
                                                        //                       actions: [
                                                        //                         //Navigator.pop(context);
                                                        //                       ],
                                                        //                     )
                                                        //                   ],
                                                        //                 ),
                                                        //               )));
                                                        //     }
                                                        // ),
                                                          SizedBox(width: 5,),
                                                          Expanded(
                                                              child: Text(r.nom.toString(),
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          ),


                                                        ],
                                                      )),
                                                      DataCell(
                                                        Switch(
                                                          value: selectedOptions["${r.id_etudiant}"] != null ? selectedOptions["${r.id_etudiant}"] == 1 ? true : false : false,
                                                          onChanged: (bool value) async {
                                                            if(!value){
                                                              String motif = "";
                                                              return await showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return
                                                                    AlertDialog(

                                                                      title: const Text("Motif d'absence"),
                                                                      content: SizedBox(
                                                                        height: 100,
                                                                        child: TextField(
                                                                          keyboardType: TextInputType.multiline,
                                                                          expands: true,
                                                                          maxLines: null,
                                                                          onChanged: (v){
                                                                            motif = v;
                                                                          },
                                                                          autofocus: true,
                                                                          decoration: const InputDecoration(
                                                                              hintText: "Motif"),
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          child: Text('Valider'),
                                                                          onPressed: () {
                                                                            setPresence(r, value ? 1 : 0, motif: motif);

                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                },
                                                              );
                                                            }else{
                                                              setPresence(r, value ? 1 : 0);
                                                            }

                                                          },
                                                        ),

                                                      ),

                                                    ],
                                                  )
                                                  ).toList()
                                        ),

                                            ],
                                          ),

                                        ),

                                      ],
                                    )

                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _listItems() {
    List<Widget> items = [];
    for(var i=0; i<40; i++){
      items.add(SizedBox(child: Text("${i} Text"), height: 20,));
    }

    return items;
  }

}

