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

import 'ResrvationscreenCoach2.dart';

class interface1 extends StatefulWidget {

  int classe_id;
  int seance_id;
  int prof_id;
  String date_presence;
  Seance sean_info;
  interface1({Key? key, required this.classe_id,
    required this.seance_id, required this.prof_id,required this.date_presence,required this.sean_info}) : super(key: key);

  @override
  State<interface1> createState() => _interface1State();
}

class _interface1State extends State<interface1> {
  var selectedOption = null;
  List<Client> data = [];
  List<Client> init_data = [];
  List<Staff> data2 = [];
  List<Staff> init_data2 = [];
  List<Seance> data3 = [];
  List<Seance> init_data3 = [];

  bool presence_prof = false;

  bool loading = false;
  int _currentLength = 0;

  var selectedOptions = {};
  var motif_prof = "";
  var selectedMotifOption = {};


  String text_search = "";
  bool showAlert = false;


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
        HOST+'/api/presences_etds?id_seance=${widget.seance_id}&date_presence=${widget.date_presence}&id_classe=${widget.classe_id}'),
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
            selectedMotifOption["${r['id_etd']}"] = r['motif_annulation'];
          }else{
            selectedOptions["${r['id_etd']}"] = 0;
            selectedMotifOption["${r['id_etd']}"] = r['motif_annulation'];
          }
        }else{
          selectedOptions["${r['id_etd']}"] = null;
          selectedMotifOption["${r['id_etd']}"] = "";
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
        HOST+'/api/presences_profs?id_seance=${widget.seance_id}&date_presence=${widget.date_presence}&id_prof=${widget.prof_id}'),
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
            presence_prof = true;
            motif_prof = p['motif_abs'];
          }else{
            presence_prof = false;
            motif_prof = p['motif_abs'];
          }
        }else{
          presence_prof = false;
          motif_prof = "";
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

      print(result.length);
      setState(() {
        data2 = result.map<Staff>((e) => Staff.fromJson(e)).toList();
        init_data2 = result.map<Staff>((e) => Staff.fromJson(e)).toList();
      });
      result.forEach((p) {
        if(p["presence"] != null){
          if(p["presence"]){
            presence_prof = true;
            motif_prof = p['motif_abs'];
          }else{
            presence_prof = false;
            motif_prof = p['motif_abs'];
          }
        }else{
          presence_prof = false;
          motif_prof = "";
        }
      });

    } else {
      throw Exception('Failed to load data');
    }


  }
  void fetchSeance() async {


    final response = await http.get(Uri.parse(
        HOST+'/api/seance_by_id?id_seance=${widget.seance_id}'),
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
        data3 = result.map<Seance>((e) => Seance.fromJson(e)).toList();
        init_data3 = result.map<Seance>((e) => Seance.fromJson(e)).toList();
      });
      print("--data--");
      print(data.length);
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


  var token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state");
    fetchPresencesEtd();
    fetchProfs();
    fetchSeance();

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
      title: Text("Présence"),
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
        "cours": widget.sean_info.cour,
        "heure_debut": widget.sean_info.heure_debut,
        "heure_fin": widget.sean_info.heure_fin,
        "motif_annulation": motif,

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
            selectedMotifOption["${c.id_etudiant}"] = motif;
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
              motif_prof = motif;
            });
          }else{
            setState(() {
              presence_prof = false;
              motif_prof = motif;
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
             // SideBar(postion: 8,msg:"Coach"),
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
                                          //modal_add(context);
                                        },
                                        child: Container(
                                          height: 25,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[200],
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.add , size: 4, color: Colors.black,),
                                                  Text("Présence",
                                                      style: TextStyle(
                                                          fontSize: 9
                                                      )),
                                                ],
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
                                              SizedBox(height: 35,),
                                              Text("Séance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),),
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
                                                          'Date',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Cours',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Créneau',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Salle',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Classe',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),

                                                  ]:

                                                  <DataColumn>[
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Date',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Cours',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Créneau',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Salle',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Classe',
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                  rows:
                                                  data3.map<DataRow>((s) => screenSize.width > 800 ?
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Row(
                                                        children: [
                                                          Text("${s.day_name} ${DateFormat("dd/MM/yyyy").format(DateTime.parse("${widget.date_presence}"))}", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),
                                                      DataCell(Row(
                                                        children: [
                                                          Text("${s.cour}", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),
                                                      DataCell(
                                                        Text(" De ${DateFormat("H:mm").format(DateTime.parse("${widget.date_presence} ${s.heure_debut}"))} à ${DateFormat("H:mm").format(DateTime.parse("${widget.date_presence} ${s.heure_fin}"))} ", overflow: TextOverflow.ellipsis,),
                                                      ),
                                                      DataCell(Row(
                                                        children: [
                                                          Text("${s.salle}", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),
                                                      DataCell(Row(
                                                        children: [
                                                          Text("${s.Nivea}", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      ))
                                                    ],
                                                  ):
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Row(
                                                        children: [
                                                          Text("${s.day_name} ${DateFormat("dd/MM/yyyy").format(DateTime.parse("${widget.date_presence}"))} ", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),
                                                      DataCell(Row(
                                                        children: [
                                                          Text("${s.cour}", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),
                                                      DataCell(
                                                        Text(" De ${DateFormat("H:mm").format(DateTime.parse("${widget.date_presence} ${s.heure_debut}"))} à ${DateFormat("H:mm").format(DateTime.parse("${widget.date_presence} ${s.heure_fin}"))} ", overflow: TextOverflow.ellipsis,),
                                                      ),
                                                      DataCell(Row(
                                                        children: [
                                                          Text("${s.salle}", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),
                                                      DataCell(Row(
                                                        children: [
                                                          Text("${s.Nivea}", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      ))
                                                    ],
                                                  )
                                                  ).toList()
                                              ),
                                              SizedBox(height: 20,),
                                              Text("Prof", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                                              data2.length == 0 ?
                                              Text("aucun Prof à afficher")
                                                  :
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
                                                          "Motif d'absence",
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
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          "Motif d'absence",
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
                                                                        height: 70,
                                                                        child: TextField(
                                                                          //controller: motif_controller,
                                                                          inputFormatters: [
                                                                            LengthLimitingTextInputFormatter(30,),
                                                                          ],
                                                                          decoration: InputDecoration(
                                                                            counterText: '30 au max caractères',
                                                                              hintText: "Motif"
                                                                          ),
                                                                         keyboardType: TextInputType.text,
                                                                          maxLength: 30,
                                                                         expands: true,
                                                                          maxLines: null,
                                                                          onChanged: (v){
                                                                            setState(() {
                                                                              _currentLength = v.length;
                                                                            });
                                                                            motif = v;

                                                                          },
                                                                          autofocus: true,

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
                                                        //Text("Present", overflow: TextOverflow.ellipsis,),
                                                      ),

                                                      DataCell(Row(
                                                        children: [
                                                          Text(motif_prof, overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),

                                                    ],
                                                  ):
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Row(
                                                        children: [
                                                          SizedBox(width: 5,),
                                                          Expanded(
                                                              child: Text(r.nom.toString(),
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          ),
                                                        ],
                                                      )),
                                                      DataCell(
                                                        //Text("Present", overflow: TextOverflow.ellipsis,),
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
                                                                        height: 70,
                                                                        child: TextField(
                                                                          inputFormatters: [
                                                                            LengthLimitingTextInputFormatter(30,),
                                                                          ],
                                                                          decoration: InputDecoration(
                                                                              counterText: '30 au max caractères',
                                                                              hintText: "Motif"
                                                                          ),
                                                                          keyboardType: TextInputType.text,
                                                                          expands: true,
                                                                          maxLines: null,
                                                                          onChanged: (v){
                                                                            setState(() {
                                                                              _currentLength = v.length;
                                                                            });
                                                                            motif = v;

                                                                          },
                                                                          autofocus: true,
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
                                                          Text(motif_prof, overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),

                                                    ],
                                                  )
                                                  ).toList()
                                              ),
                                              SizedBox(height: 10,),
                                              Text("Etudiants", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                                              data.length == 0 ?
                                              Text("aucun étudiant à afficher")
                                                  :
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
                                                          "Motif d’absence",
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
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          "Motif d’absence",
                                                          style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                  rows:
                                                  data.map<DataRow>((r) => screenSize.width > 800 ?
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Row(
                                                        children: [
                                                          Text("${r.nom.toString()} ${r.prenom.toString()}", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),
                                                      DataCell(
                                                        //Text("Present", overflow: TextOverflow.ellipsis,),
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
                                                                        height: 70,
                                                                        child: TextField(
                                                                          inputFormatters: [
                                                                            LengthLimitingTextInputFormatter(30,),
                                                                          ],
                                                                          decoration: InputDecoration(
                                                                              counterText: '30 au max caractères',
                                                                              hintText: "Motif"
                                                                          ),
                                                                          expands: true,
                                                                           maxLines: null,
                                                                          onChanged: (v){
                                                                            setState(() {
                                                                              _currentLength = v.length;
                                                                            });
                                                                            motif = v;
                                                                          },
                                                                          autofocus: true,

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
                                                          Text(selectedMotifOption["${r.id_etudiant}"] != null ? selectedMotifOption["${r.id_etudiant}"]: "", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),
                                                    ],
                                                  ):
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Row(
                                                        children: [
                                                          SizedBox(width: 5,),
                                                          Expanded(
                                                              child: Text("${r.nom.toString()} ${r.prenom.toString()}",
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          ),

                                                        ],
                                                      )),
                                                      DataCell(
                                                       // Text("Present", overflow: TextOverflow.ellipsis,),
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
                                                                        height: 70,
                                                                        child: TextField(
                                                                          inputFormatters: [
                                                                            LengthLimitingTextInputFormatter(30,),
                                                                          ],
                                                                          decoration: InputDecoration(
                                                                              counterText: '30 au max caractères',
                                                                              hintText: "Motif"
                                                                          ),
                                                                          expands: true,
                                                                          // maxLines: null,
                                                                          onChanged: (v){
                                                                            setState(() {
                                                                              _currentLength = v.length;
                                                                            });
                                                                            motif = v;

                                                                          },
                                                                          autofocus: true,
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
                                                          Text(selectedMotifOption["${r.id_etudiant}"] != null ? selectedMotifOption["${r.id_etudiant}"]: "", overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      )),
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

