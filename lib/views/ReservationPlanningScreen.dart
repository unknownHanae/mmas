import 'dart:math';

import 'package:adminmmas/constants.dart';
import 'package:adminmmas/views/Addreservation.dart';
import 'package:adminmmas/views/ReservationScreen2.dart';
import 'package:adminmmas/views/UpdateReservation.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:time_planner/time_planner.dart';
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../componnents/showButton.dart';
import '../models/CatContratModels.dart';
import '../models/ClientModels.dart';
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


class ReservationPlanningScreen extends StatefulWidget {
  const ReservationPlanningScreen({Key? key}) : super(key: key);

  @override
  State<ReservationPlanningScreen> createState() => _ReservationPlanningState();
}

class _ReservationPlanningState extends State<ReservationPlanningScreen> {

  List<Seance> data = [];
  List<Seance> init_data = [];
  List<Reservation> init_data2 = [];
  List<Reservation> data2 = [];
  List<Reservation> reservations = [];
  bool loading = false;

  List<dynamic> resvs = [];

  var jours = {
    1: "Lundi",
    2: "Mardi",
    3: "Mercredi",
    4: "Jeudi",
    5: "Vendredi",
    6: "Samedi",
    7: "Dimanche",
  };

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";

  List<category_contrat> category = [];
  List<Cours> cour = [];
  List<Client> clients = [];
  List<Seance> seances = [];

  String motif = "";
  String date_presence = "";



  Future<BsSelectBoxResponse> searchClient(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in clients){
      var name = "${v.nom} ${v.prenom}";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_etudiant,
                text: Text("${v.nom} ${v.prenom}")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }


  final TextEditingController datePresenceController =
  TextEditingController();

  BsSelectBoxController _selectClient = BsSelectBoxController();
  BsSelectBoxController _selectSeances = BsSelectBoxController();

  BsSelectBoxController _selectStatus = BsSelectBoxController();

  BsSelectBoxController _selectCours = BsSelectBoxController();


  BsSelectBoxController _selectPrsesnce = BsSelectBoxController();
  BsSelectBoxController _selectStatusResrvation = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 2, text: Text("Tout")),
        BsSelectBoxOption(value: 3, text: Text("Sans Status")),
        BsSelectBoxOption(value: 0, text: Text("Validée")),
        BsSelectBoxOption(value: 1, text: Text("Annulée")),
      ]
  );

  TextEditingController moti_controller = TextEditingController();

  BsSelectBoxController _selectFilter = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 2, text: Text("Jour")),
        BsSelectBoxOption(value: 0, text: Text("Semaine")),
        BsSelectBoxOption(value: 1, text: Text("Mois")),
        BsSelectBoxOption(value: 3, text: Text("Année")),
        BsSelectBoxOption(value: 4, text: Text("Planning")),
      ]
  );


  void fetchReservation() async {
    setState(() {
      loading = true;
    });
    print("loading ...");
    final response = await http.get(Uri.parse(
        HOST+'/api/reservation/'),
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
        data2 = result.map<Reservation>((e) => Reservation.fromJson(e)).toList();
        init_data2 = result.map<Reservation>((e) => Reservation.fromJson(e)).toList();
      });
      print("--data--");
      print(data.length);
    } else {
      throw Exception('Failed to load data');
    }

    setState(() {
      loading = false;
    });
  }



  var token = "";
  var _future;
  List<Color?> colors = [
    Colors.orangeAccent,
    Colors.orange,
    Colors.grey,
    Colors.lightBlueAccent,
    Colors.blueGrey
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    _future = getDataFromWeb();
    print("init state");
    fetchReservation();
    getClient();
    getCour();

  }
  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/reservation/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchReservation();
    } else {
      throw Exception('Failed to load data');
    }
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
      title: Text("Abonnement"),
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

  void modal_add_planning(context){
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    showDialog(context: context, builder: (context) =>
        BsModal(
            context: context,
            dialog: BsModalDialog(
              size: BsModalSize.lg,
              crossAxisAlignment: CrossAxisAlignment.center,
              child: BsModalContent(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  BsModalContainer(
                    //title:
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    actions: [
                      Text('Ajouter Reservation',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Annuler'),
                        //prefixIcon: Icons.close,
                        onPressed: () {
                          Navigator.pop(context);
                          initData();
                        },
                      )
                    ],
                    //closeButton: true,

                  ),
                  // BsModalContainer(
                  //     title: Text('Ajouter Reservation'),
                  //     closeButton: true,
                  //   onClose: (){
                  //     Navigator.pop(context);
                  //     initData();
                  //
                  //   },
                  // ),
                  BsModalContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelText(
                                title: 'Client *'
                            ),
                            BsSelectBox(
                              hintText: 'Client',
                              controller: _selectClient,
                              onChange: (v){
                                Client c = clients.where(
                                        (el) => el.id_etudiant == _selectClient.getSelected()?.getValue()
                                ).first;

                                var genders = {
                                  "Madmoiselle": "Femme",
                                  "Monsieur": "Homme",
                                  "Madame": "Femme"
                                };

                                List<Cours> crs = cour.where(
                                        (cr) => cr.id_niveau == c.id_classe
                                ).toList();
                                _selectCours.clear();
                                _selectSeances.clear();
                                datePresenceController.text = "";
                                _selectCours.options = crs.map<BsSelectBoxOption>((c) =>
                                    BsSelectBoxOption(
                                        value: c.id_cour,
                                        text: Text("${c.nom_cour}")
                                    )
                                ).toList();
                                Navigator.pop(context);
                                modal_add(context);
                              },
                            ),
                            SizedBox(height: 10,),
                            LabelText(
                                title: 'Cours *'
                            ),
                            BsSelectBox(
                              hintText: 'Cours',
                              controller: _selectCours,
                              onChange: (val){
                                //getSeances(context,_selectCours.getSelected()?.getValue());
                              },
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 15,
                        ),
                        LabelText(
                            title: 'Seance *'
                        ),
                        BsSelectBox(
                          hintText: 'Seance',
                          controller: _selectSeances,
                          onChange: (v){
                            datePresenceController.text = "";
                            date_presence = "";
                            Seance s = seances.where(
                                    (el) => el.id_seance == _selectSeances.getSelected()?.getValue()).first;
                            DateTime date = DateTime.parse(s.date_reservation!);
                            datePresenceController.text = DateFormat("dd/MM/yyyy").format(date);
                            date_presence = s.date_reservation!;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        LabelText(
                            title: 'Créneau *'
                        ),
                        TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: 'Créneau',
                          ),
                          readOnly: true,
                          controller: datePresenceController,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            add(context);
                          },
                          child:
                          MediaQuery.of(context).size.width > 800 ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child:
                                Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.blue,
                                    border: Border.all(
                                        color: Colors.blueAccent
                                    )
                                ),
                              ),

                              LabelText(
                                  title: 'Nb: *  un champ obligatoire'
                              ),
                            ],
                          ):
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child:
                                Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.blue,
                                    border: Border.all(
                                        color: Colors.blueAccent
                                    )
                                ),
                              ),
                              SizedBox(height: 5),
                              LabelText(
                                  title: 'Nb: * un champ obligatoire'
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  void getClient() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/etudiants/'),
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
        clients = result.map<Client>((e) => Client.fromJson(e)).toList();
      });
      _selectClient.options = clients.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_etudiant,
              text: Text("${c.nom} ${c.prenom}")
          )).toList();

      print("--data--");
      print(clients.length);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void getCour() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/cours/'),
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
        cour = result.map<Cours>((e) => Cours.fromJson(e)).toList();
      });


      /*_selectCours.options = cour.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_cour,
              text: Text("${c.nom_cour}")
          )
      ).toList();*/

      print("--data--");
      print(cour.length);
    } else {
      throw Exception('Failed to load data');
    }
  }


  void fetchSeance() async {

    final response = await http.get(Uri.parse(
        HOST+'/api/seances/by/reservation'),
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
        data = result.map<Seance>((e) => Seance.fromJson(e)).toList();
        init_data = result.map<Seance>((e) => Seance.fromJson(e)).toList();
      });
      print("--data--");
      print(data.length);
    } else {
      throw Exception('Failed to load data');
    }

    setState(() {
      loading = false;
    });
  }

  void add(context) async {

    if(date_presence.isNotEmpty
        && _selectClient.getSelected()?.getValue() != null
        && _selectSeances.getSelected()?.getValue() != null
    // && _selectPrsesnce.getSelected()?.getValue() != null
    // && _selectStatus.getSelected()?.getValue() != null
    ){
      // if(_presenceController.getSelected()?.getValue() == 0){
      //   if(motif.length == 0){
      //     showAlertDialog(context);
      //     return;
      //   }
      // }

      var rev = <String, dynamic>{
        "id_client": _selectClient.getSelected()?.getValue(),
        "id_seance": _selectSeances.getSelected()?.getValue(),
        "date_presence": date_presence,
        /*"status": 0,
        "presence": 0,
        "motif_annulation": "",*/
      };

      print(rev);
      final response = await http.post(Uri.parse(
          HOST+"/api/reservation/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(rev),
      );

      if (response.statusCode == 200) {

        //print("etb added");
        print(response.body);
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context,true);
          initData();
          fetchReservation();

        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context, "Erreur ajout reservation");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }

  void modal_add(context){
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    showDialog(context: context, builder: (context) =>
        BsModal(
            context: context,

            dialog: BsModalDialog(
              size: BsModalSize.lg,
              crossAxisAlignment: CrossAxisAlignment.center,
              child: BsModalContent(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  BsModalContainer(
                    //title:
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    actions: [
                      Text('Ajouter Reservation',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Annuler'),
                        //prefixIcon: Icons.close,
                        onPressed: () {

                          Navigator.pop(context);
                          initData();
                        },
                      )
                    ],
                    //closeButton: true,

                  ),
                  // BsModalContainer(
                  //     title: Text('Ajouter Reservation'),
                  //     closeButton: true,
                  //   onClose: (){
                  //     Navigator.pop(context);
                  //     initData();
                  //
                  //   },
                  // ),
                  BsModalContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        LabelText(
                            title: 'Client *'
                        ),
                        BsSelectBox(
                          hintText: 'Client',
                          controller: _selectClient,
                          searchable: true,
                          serverSide: searchClient,
                          onChange: (v){
                            Client c = clients.where(
                                    (el) => el.id_etudiant == _selectClient.getSelected()?.getValue()
                            ).first;

                            var genders = {
                              "Madmoiselle": "Femme",
                              "Monsieur": "Homme",
                              "Madame": "Femme"
                            };

                            List<Cours> crs = cour.where(
                                    (cr) => cr.id_niveau == c.id_classe
                            ).toList();
                            _selectCours.clear();
                            _selectSeances.clear();
                            datePresenceController.text = "";
                            _selectCours.options = crs.map<BsSelectBoxOption>((c) =>
                                BsSelectBoxOption(
                                    value: c.id_cour,
                                    text: Text("${c.nom_cour}")
                                )
                            ).toList();
                            Navigator.pop(context);
                            modal_add(context);
                          },
                        ),
                        SizedBox(height: 10,),
                        LabelText(
                            title: 'Cours *'
                        ),
                        BsSelectBox(
                          hintText: 'Cours',
                          controller: _selectCours,
                          onChange: (val){
                            //getSeances(context, _selectCours.getSelected()?.getValue());
                          },
                        ),

                        SizedBox(
                          height: 15,
                        ),
                        LabelText(
                            title: 'Seance *'
                        ),
                        BsSelectBox(
                          hintText: 'Seance',
                          controller: _selectSeances,
                          disabled: true,
                         /* onChange: (v){
                            datePresenceController.text = "";
                            date_presence = "";
                            Seance s = seances.where(
                                    (el) => el.id_seance == _selectSeances.getSelected()?.getValue()).first;
                            DateTime date = DateTime.parse(s.date_reservation!);
                            datePresenceController.text = DateFormat("dd/MM/yyyy").format(date);
                            date_presence = s.date_reservation!;
                          },*/
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        LabelText(
                            title: 'Créneau *'
                        ),
                        TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: 'Créneau',
                          ),
                          readOnly: true,
                          controller: datePresenceController,
                          /*onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: tomorrow,
                              firstDate: tomorrow,
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              String formattedDate =
                              DateFormat("yyyy-MM-dd").format(pickedDate);
                              setState(() {
                                datePresenceController.text =
                                    formattedDate.toString();
                              });
                              print(formattedDate);
                              date_presence = formattedDate;
                              getSeances(formattedDate);
                            } else {
                              print('Not selected');
                            }
                          },*/
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            add(context);
                          },
                          child:
                          MediaQuery.of(context).size.width > 800 ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child:
                                Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.blue,
                                    border: Border.all(
                                        color: Colors.blueAccent
                                    )
                                ),
                              ),

                              LabelText(
                                  title: 'Nb: *  un champ obligatoire'
                              ),
                            ],
                          ):
                          Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child:
                              Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.blue,
                                  border: Border.all(
                                      color: Colors.blueAccent
                                  )
                              ),
                            ),
                            SizedBox(height: 5),
                            LabelText(
                                title: 'Nb: * un champ obligatoire'
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }



  void modal_update(context, Reservation reservation, {bool update_select = false}) async {

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if(!update_select){

      //getSeances(reservation.date_presence, seance_id: reservation.id_seance);
      _selectPrsesnce.options = [
        BsSelectBoxOption(value: 1, text: Text("present")),
        BsSelectBoxOption(value: 0, text: Text("abscent")),
      ];
      _selectStatus.options =  [
        BsSelectBoxOption(value: 1, text: Text("Validée")),
        BsSelectBoxOption(value: 0, text: Text("Annulée")),
      ];
      if(reservation.status != null){
        _selectStatus.setSelected(
            BsSelectBoxOption(
                value: reservation.status! ? 1 : 0,
                text: reservation.status == false ? Text("Annulée") : Text("Validée")
            ));
      }

      if(reservation.presence != null){
        _selectPrsesnce.setSelected(
            BsSelectBoxOption(
                value: reservation.presence! ? 1 : 0,
                text: reservation.presence == true ? Text("Présent") : Text("Absent")
            ));
      }

      Client client = clients.where(
              (element) => element.id_etudiant == reservation.id_etd).first;
      _selectClient.setSelected(BsSelectBoxOption(
          value: reservation.id_etd,
          text: Text("${client.nom} ${client.prenom}")
      ));
      //Seance s = seances.where((el) => el.id_seance == reservation.id_seance).first;
      _selectSeances.setSelected(BsSelectBoxOption(
          value: reservation.id_seance,
          text: Text("Cours: ${reservation.cour} | Salle: ${reservation.salle} | Jour : ${reservation.day_name}| De ${reservation.heur_debut} à ${reservation.heure_fin}",style: TextStyle(color: Colors.black),)
      ));

      moti_controller.text =  reservation.motif_annulation != null ?
      reservation.motif_annulation.toString():
      "";
      datePresenceController.text = reservation.date_presence != null ?
      reservation.date_presence.toString():
      ""
      ;
      date_presence = reservation.date_presence.toString();
    }


    showDialog(context: context, builder: (context) =>
        BsModal(
            context: context,

            dialog: BsModalDialog(
              size: BsModalSize.lg,
              crossAxisAlignment: CrossAxisAlignment.center,
              child: BsModalContent(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  BsModalContainer(
                    //title:
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    actions: [
                      Text('Modifier une Reservation',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Annuler'),
                        //prefixIcon: Icons.close,
                        onPressed: () {
                          initData();
                          Navigator.pop(context);
                        },
                      )
                    ],
                    //closeButton: true,

                  ),
                  /*BsModalContainer(
                      title: Text('Modifier une Reservation'),
                      closeButton: true,
                    onClose: (){
                      initData();
                      Navigator.pop(context);
                    },
                  ),*/
                  BsModalContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Client *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Client',
                                      controller: _selectClient,
                                      disabled: true,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    LabelText(
                                        title: 'Créneau *'
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        labelText: 'Créneau',
                                      ),
                                      readOnly: true,
                                      controller: datePresenceController,
                                      /*onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.parse(reservation.date_presence.toString()),
                                          firstDate: tomorrow,
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          String formattedDate =
                                          DateFormat("yyyy-MM-dd").format(pickedDate);
                                          datePresenceController.text =
                                              formattedDate.toString();
                                          print(formattedDate);
                                          getSeances(formattedDate);
                                        } else {
                                          print('Not selected');
                                        }
                                      },*/
                                    ),

                                    SizedBox(
                                      height: 15,
                                    ),
                                    LabelText(
                                        title: 'Seance *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Seance',
                                      controller: _selectSeances,
                                      disabled: true,
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(width: 60,),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Statut de la réservation'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Status',
                                      controller: _selectStatus,
                                      onChange: (value) {
                                        Navigator.pop(context);
                                        print(_selectStatus.getSelected()?.getValue());
                                        if(_selectStatus.getSelected()?.getValue() == 0){
                                          _selectPrsesnce.setSelected(BsSelectBoxOption(value: 0, text: Text('Absent')));
                                        }
                                        modal_update(context, reservation, update_select: true);
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    LabelText(
                                        title: 'Présence'
                                            ),
                                    BsSelectBox(
                                      hintText: 'Présence',
                                      controller: _selectPrsesnce,
                                      disabled: _selectStatus.getSelected() == null ? true : _selectStatus.getSelected()?.getValue() == 0 ? true : false,
                                      onChange: (value){
                                        if(_selectPrsesnce.getSelected()?.getValue() == 1){
                                          moti_controller.text = "";
                                        }
                                        Navigator.pop(context);
                                        modal_update(context, reservation, update_select: true);
                                      }
                                    ),
                                    /*if(_selectStatus.getSelected()?.getValue())...[
                                      BsSelectBox(
                                        hintText: 'Présence',
                                        controller: _selectPrsesnce,
                                        disabled: false,
                                      ),
                                    ]else ...[
                                      BsSelectBox(
                                        hintText: 'Présence',
                                        controller: _selectPrsesnce,
                                        disabled: true,
                                      ),
                                    ],*/
                                    SizedBox(
                                          height: 15,
                                        ),
                                    LabelText(
                                        title: 'Motif Annulation'
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [

                                        ]),
                                        child: TextField(
                                          controller: moti_controller,
                                          enabled: _selectPrsesnce.getSelected()?.getValue() != null ?
                                          _selectPrsesnce.getSelected()?.getValue() == 1 ? false : true : false,
                                          autofocus: _selectStatus.getSelected()?.getValue() == 0 ? true : _selectPrsesnce.getSelected()?.getValue() == 0 ? true : false,
                                          decoration: new InputDecoration(
                                              hintText: 'Motif Annulation',
                                              hintStyle: TextStyle(fontSize: 14),
                                          ),
                                        )
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            update(context, reservation.id_reservation!);
                          },
                          child: Row(
                            children: [
                              Container(
                                child:
                                Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 13),)),
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.blue,
                                    border: Border.all(
                                        color: Colors.blueAccent
                                    )
                                ),
                              ),
                              SizedBox(width: 350,),
                              LabelText(
                                  title: 'Nb: *  designe un champ obligatoire'
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     LabelText(
                    //         title: 'Client *'
                    //     ),
                    //     BsSelectBox(
                    //       hintText: 'Client',
                    //       controller: _selectClient,
                    //     ),
                    //     SizedBox(
                    //       height: 15,
                    //     ),
                    //     LabelText(
                    //         title: 'Date Présence *'
                    //     ),
                    //     TextField(
                    //       decoration: InputDecoration(
                    //         icon: Icon(Icons.calendar_today),
                    //         labelText: 'Date de Présence',
                    //       ),
                    //       readOnly: true,
                    //       controller: datePresenceController,
                    //       onTap: () async {
                    //         DateTime? pickedDate = await showDatePicker(
                    //           context: context,
                    //           initialDate: DateTime.parse(reservation.date_presence.toString()),
                    //           firstDate: tomorrow,
                    //           lastDate: DateTime(2101),
                    //         );
                    //         if (pickedDate != null) {
                    //           String formattedDate =
                    //           DateFormat("yyyy-MM-dd").format(pickedDate);
                    //
                    //           datePresenceController.text =
                    //               formattedDate.toString();
                    //           print(formattedDate);
                    //           getSeances(formattedDate);
                    //         } else {
                    //           print('Not selected');
                    //         }
                    //       },
                    //     ),
                    //
                    //     SizedBox(
                    //       height: 15,
                    //     ),
                    //     LabelText(
                    //         title: 'Seance *'
                    //     ),
                    //     BsSelectBox(
                    //       hintText: 'Seance',
                    //       controller: _selectSeances,
                    //     ),
                    //     SizedBox(
                    //       height: 15,
                    //     ),
                    //     LabelText(
                    //         title: 'Status'
                    //     ),
                    //     BsSelectBox(
                    //       hintText: 'Status',
                    //       controller: _selectStatus,
                    //     ),
                    //     SizedBox(
                    //       height: 15,
                    //     ),
                    //     LabelText(
                    //         title: 'Présence'
                    //     ),
                    //     BsSelectBox(
                    //       hintText: 'Présence',
                    //       controller: _selectPrsesnce,
                    //     ),
                    //     SizedBox(
                    //       height: 15,
                    //     ),
                    //     LabelText(
                    //         title: 'Motif Annulation'
                    //     ),
                    //     Container(
                    //         width: double.infinity,
                    //         decoration: BoxDecoration(boxShadow: [
                    //
                    //         ]),
                    //         child: TextField(
                    //           controller: moti_controller,
                    //           decoration: new InputDecoration(
                    //               hintText: 'Motif Annulation',
                    //               hintStyle: TextStyle(fontSize: 14)
                    //           ),
                    //         )
                    //     ),
                    //     SizedBox(
                    //       height: 25,
                    //     ),
                    //
                    //     SizedBox(height: 15,),
                    //     InkWell(
                    //       onTap: (){
                    //         update(context, reservation.id_reservation!);
                    //       },
                    //       child: Row(
                    //         children: [
                    //           Container(
                    //             child:
                    //             Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
                    //             height: 40,
                    //             width: 120,
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(6),
                    //                 color: Colors.blue,
                    //                 border: Border.all(
                    //                     color: Colors.blueAccent
                    //                 )
                    //             ),
                    //           ),
                    //           SizedBox(width: 350,),
                    //           LabelText(
                    //               title: 'Nb: *  designe un champ obligatoire'
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ],
              ),
            )));
  }

  void update(context, int id) async {

    /*if(!datePresenceController.text.isNotEmpty){
      showAlertDialog(context, "date is null");
    }

    if(_selectClient.getSelected()?.getValue() == null){
      showAlertDialog(context, "_selectClient is null");
    }

    if(_selectSeances.getSelected()?.getValue() == null){
      showAlertDialog(context, "_selectSeances is null");
    }*/

    if(
    //datePresenceController.text.isNotEmpty
      //  && _selectClient.getSelected()?.getValue() != null
        //&& _selectSeances.getSelected()?.getValue() != null
    // && _selectPrsesnce.getSelected()?.getValue() != null
    // && _selectStatus.getSelected()?.getValue() != null
    true
    )
    {
      if(_selectPrsesnce.getSelected()?.getValue() == 0){
        if(moti_controller.text.length == 0){
          showAlertDialog(context, "Ajouter un motif");
          return;
        }
      }
      var rev = <String, dynamic>{
        "id_reservation": id,
        "id_client": _selectClient.getSelected()?.getValue(),
        "id_seance": _selectSeances.getSelected()?.getValue(),
        "date_presence": datePresenceController.text,
        "status": _selectStatus.getSelected()?.getValue(),
        "presence": _selectPrsesnce.getSelected()?.getValue(),
        "motif_annulation": moti_controller.text,
      };


      if(_selectStatus.getSelected() != null){
        rev["status"] = _selectStatus.getSelected()?.getValue();
      }

      if(_selectPrsesnce.getSelected() != null){
        rev["presence"] = _selectPrsesnce.getSelected()?.getValue();
      }

      print(rev);
      final response = await http.put(Uri.parse(
          HOST+"/api/reservation/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(rev),
      );

      if (response.statusCode == 200) {

        //print("etb added");
        print(response.body);
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context,true);
          fetchReservation();
          initData();
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context,"Failed to update data");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }

  void initData(){
    moti_controller.text = "";
    datePresenceController.text = "";
    date_presence = "";
    _selectPrsesnce.clear();
    _selectSeances.clear();
    _selectStatus.clear();
    _selectClient.clear();
    if(_selectCours.getSelected()?.getValue() != null){
      _selectCours.removeSelected(_selectCours.getSelected()!);
    }

    getClient();
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
                              screenSize.width > 520 ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Les Réservations", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
                                  Container(
                                    width: 180,
                                    child: BsSelectBox(
                                      hintText: 'Filtrer',
                                      controller: _selectFilter,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddReservation(),
                                          )).then((val)=>fetchReservation()
                                      );*/
                                      modal_add(context);
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
                                          child: Text("Ajouter une réservation",
                                              style: TextStyle(
                                                  fontSize: 15
                                              )),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ):
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Liste des Réservations", style: TextStyle(
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
                                          //
                                          modal_add(context);
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
                                                  Icons.add,
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
                                height: 10,
                              ),
                              Expanded(
                                  flex: 1,
                                  child:
                                  FutureBuilder(
                                    future: _future,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      if (snapshot.data != null) {
                                        return SafeArea(
                                          child: Container(
                                              child: SfCalendar(
                                                allowedViews: [CalendarView.day,  CalendarView.week,CalendarView.month, CalendarView.schedule, CalendarView.timelineMonth],
                                                view: CalendarView.schedule,
                                                firstDayOfWeek: 1,
                                                //minDate: DateTime.now(),
                                                //maxDate: DateTime.now().add(Duration(days: 7)),
                                                timeSlotViewSettings: TimeSlotViewSettings(
                                                  startHour: 6,
                                                  endHour: 22,
                                                  dayFormat: 'EEEE',
                                                  timeFormat: 'HH:mm',
                                                ),
                                                initialDisplayDate:  DateTime.now(),
                                                dataSource: MeetingDataSource(snapshot.data),
                                                onTap: calendarTapped,
                                              )),
                                        );
                                      } else {
                                        return Container(
                                          child: Center(
                                            child: Text('Aucune donnée à afficher'),
                                          ),
                                        );
                                      }
                                    },
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

  Future<List<Meeting>> getDataFromWeb() async {

    var data =  await http.get(Uri.parse(
        HOST+'/api/seances/by/reservation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    var jsonData = json.decode(data.body);

    final List<Meeting> appointmentData = [];
    final Random random = new Random();

    if (data.statusCode == 200) {
      try{
        final body = json.decode(data.body);
        final List<dynamic> result = body["data"];

        print(result);
        setState(() {
          seances = result.map<Seance>((e) => Seance.fromJson(e)).toList();
        });


        //var reservations = result.map<Reservation>((e) => Reservation.fromJson(e)).toList();

        print("nb seances ${seances.length}");
        print("nb appointmentData ${appointmentData.length}");
        seances.forEach((s) {
          print("seance id ${s.id_seance}");
          //var date = DateTime.now();
          try{
            print("date heure_debut ${s.date_reservation} ${s.heure_debut}");
            print("date fin ${s.date_reservation} ${s.heure_fin}");
            appointmentData.add(
                Meeting(
                  seance_id: s.id_seance!,
                  date_reservation: s.date_reservation!,
                  eventName: "${s.cour}\n${s.salle}",
                  from: DateTime.parse("${s.date_reservation} ${s.heure_debut}"),
                  to: DateTime.parse("${s.date_reservation} ${s.heure_fin}"),
                  background: colors[random.nextInt(5)]!,
                  isAllDay: false,
                )
            );
          }catch(e){
            print(e);
          }

        });



        print("nb appointmentData 2 ${appointmentData.length}");
        return appointmentData;

      }catch(e){
        print(e);
      }
    } else {
      print("Failed to load data");
      //throw Exception('Failed to load data');
    }

    return [];
  }

  void calendarTapped(CalendarTapDetails details) {

    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Meeting appointmentDetails = details.appointments![0];
      print(appointmentDetails.seance_id);

      Seance seance = seances.where(
              (sn) => sn.id_seance == appointmentDetails.seance_id
                  && sn.date_reservation == appointmentDetails.date_reservation
      ).first;


      var format = DateFormat("HH:mm:ss");
      var one = format.parse(seance.heure_debut!);
      var two = format.parse(seance.heure_fin!);

      print("duration ${two.difference(one)}");
      var duration = two.difference(one);


      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cours: ${seance.cour!} - Jour: ${seance.day_name!}'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Nombre des réservations: ${seance.nb_reservations}',style: TextStyle(fontSize: 20,fontFamily: 'RobotoMono'),),
                  Center(child: Text("-----------------")),
                  Text('Coach: ${seance.coach!}'),
                  Text('Heure debut: ${seance.heure_debut!}'),
                  Text('Heure fin: ${seance.heure_fin!}'),
                  Text('Salle: ${seance.salle!}'),
                  Text('Capacite: ${seance.capacity!}'),
                  Text('Durée: ${duration.inMinutes} min'),

                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Les clients', style: TextStyle(color: Colors.orange)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>
                          ReservationScreen2(reservations: seance.reservations)
                      ),
                  ).then((value) {
                    setState(() {
                      _future = getDataFromWeb();
                    });
                  });
                },
              ),
              TextButton(
                child: const Text('Fermer', style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

    }
  }

}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting({required this.seance_id, required this.date_reservation, required this.eventName, required this.from, required this.to, required this.background, required this.isAllDay});

  int seance_id;
  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;

  String date_reservation;
}


