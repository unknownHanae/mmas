import 'dart:math';

import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/EtablissementModels.dart';
import 'package:adminmmas/models/Staff.dart';
import 'package:adminmmas/views/Planning.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../componnents/showButton.dart';
import '../models/ClasseModel.dart';
import '../models/CoachModels.dart';
import '../models/CoursModels.dart';
import '../models/SalleModels.dart';
import '../models/SeanceModels.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';

import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:html' as html;


import 'package:confirm_dialog/confirm_dialog.dart';

import 'CalendarScreen.dart';

class SeanceScreen extends StatefulWidget {
  const SeanceScreen({Key? key}) : super(key: key);

  @override
  State<SeanceScreen> createState() => _SeanceScreenState();
}

class _SeanceScreenState extends State<SeanceScreen> {

  List<Seance> data = [];
  List<Seance> init_data = [];
  bool loading = false;

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";

  List<Cours> cour = [];
  List<Salle> Salles = [];
  List<Staff> profs = [];
  List<Classes> classes = [];
  String capacity = "";
  String jour = "";

  Future<BsSelectBoxResponse> searchCour(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in cour){
      var name = "${v.nom_cour}";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_cour,
                text: Text("${v.nom_cour}")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }
  Future<BsSelectBoxResponse> searchSalle(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in Salles){
      var name = "${v.nom_salle}";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_salle,
                text: Text("${v.nom_salle}")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }
  Future<BsSelectBoxResponse> searchCoach(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in profs){
      var name = "${v.nom}";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_employe,
                text: Text("${v.nom}")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }

  BsSelectBoxController _selectCours = BsSelectBoxController();
  BsSelectBoxController _selectSalles = BsSelectBoxController();
  BsSelectBoxController _selectProf = BsSelectBoxController();

  BsSelectBoxController _selectTimeStart = BsSelectBoxController();
  BsSelectBoxController _selectTimeEnd = BsSelectBoxController();

  BsSelectBoxController _selectClasse = BsSelectBoxController();

  List<DropdownMenuItem<String>>_selectTimeStart2 = [];

  var jours = {
    1: "Lundi",
    2: "Mardi",
    3: "Mercredi",
    4: "Jeudi",
    5: "Vendredi",
    6: "Samedi",
    7: "Dimanche",
  };

  BsSelectBoxController _selectJour = BsSelectBoxController(
    options: [
      BsSelectBoxOption(value: 1, text: Text("Lundi")),
      BsSelectBoxOption(value: 2, text: Text("Mardi")),
      BsSelectBoxOption(value: 3, text: Text("Mercredi")),
      BsSelectBoxOption(value: 4, text: Text("Jeudi")),
      BsSelectBoxOption(value: 5, text: Text("Vendredi")),
      BsSelectBoxOption(value: 6, text: Text("Samedi")),
      BsSelectBoxOption(value: 7, text: Text("Dimanche")),
    ]
  );

  TextEditingController capacity_controller = TextEditingController();
  TextEditingController jour_controller = TextEditingController();
  TextEditingController heure_debut_controller = TextEditingController();
  TextEditingController heure_fin_controller = TextEditingController();

  String image_path = "";

  List<BsSelectBoxOption> times = [];
  List<String> timesString = [];

  String? selectedTime;

  void initSelectClasse() {
    _selectClasse.options = classes.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
          value: v.id_classe,
          text: Text("${v.niveau} - ${v.groupe}"),
        )).toList();
    Classes cla = classes.where((el) => el.niveau == "").first;
    _selectClasse.setSelected(BsSelectBoxOption(
      value: cla.id_classe,
      text: Text("${cla.niveau} - ${cla.groupe}"),
    ));
  }
  void getClasses() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/classe/'),
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

        classes = result.map<Classes>((e) => Classes.fromJson(e)).toList();


      });
      print("--classes--");
      print(classes.length);
      //initSelectClasse();
    } else {
      throw Exception('Failed to load villes');
    }
  }
  void fetchSeance() async {
    // setState(() {
    //   loading = true;
    // });
    // print("loading ...");
    final response = await http.get(Uri.parse(
        HOST+'/api/seance/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        } );

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

  void search(String key){
    if(key.length > 0){
      final List<Seance> founded = [];
      init_data.forEach((e) {
        if( e.capacity == key
            || e.salle!.toLowerCase().contains(key.toLowerCase())
            || e.cour!.toLowerCase().contains(key.toLowerCase())
            || e.day_name!.toLowerCase().contains(key.toLowerCase())
        )
        {
          founded.add(e);
        }
      });
      setState(() {
        data = founded;
      });
    }else {
      setState(() {
        data = init_data;
      });
    }

  }

  void initTime(){
    times.clear();
    _selectTimeStart2.clear();
    for(var h=7; h<=21; h++){
      if(h != 21){
        for(var m=0; m<=45 ; m=m+15){
          String time = "${h <10 ? '0${h}' : h}:${m == 0 ? '00' : m}";
          print(time);
          times.add(BsSelectBoxOption(value: time, text: Text(time)));
          timesString.add(time);
          _selectTimeStart2.add(
              DropdownMenuItem<String>(
                value: time,
                child: Text(time),
              )
          );
        }
      }else{
        print("21:00");
        times.add(BsSelectBoxOption(value: "21:00", text: Text("21:00")));
        timesString.add("21:00");
        _selectTimeStart2.add(
            DropdownMenuItem<String>(
              value: "21:00",
              child: Text("21:00"),
            )
        );
      }
    }

    _selectTimeStart.options = times;

    //_selectTimeEnd.options = times;
  }

  void timeFree(Salle s, int day){

    try{
      times.clear();
      _selectTimeStart.clear();
      List<Seance> seances_inday = init_data.where((sc) => sc.id_salle == s.id_salle && sc.jour == day).toList();

      List<String> timecopy = [...timesString];
      seances_inday.forEach((sce) {
        print(sce.heure_debut!.replaceRange(5, 8, ""));
        print(sce.heure_fin!.replaceRange(5, 8, ""));
        int index_start = timecopy.indexOf(sce.heure_debut!.replaceRange(5, 8, ""));
        int index_end = timecopy.indexOf(sce.heure_fin!.replaceRange(5, 8, ""));
        timecopy.removeRange(index_start, index_end);
      });


      timecopy.remove("21:00");

      timecopy.forEach((time) {
        times.add(BsSelectBoxOption(value: time, text: Text(time)));
      });

      _selectTimeStart.options = times;
      Navigator.pop(context);
      modal_add(context);
    }catch(e){
      print(e);
    }

  }

  var token = "" ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state");
    fetchSeance();
    getCour();
    getSalle();
    getProf();
    getClasses();

    initTime();
  }
  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/seance/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchSeance();
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
      title: Text("seance"),
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

  void getProf({int? coach_id}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/staff_by_type?type=prof'),
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
        profs = result.map<Staff>((e) => Staff.fromJson(e)).toList();
      });
      _selectProf.options = profs.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_employe,
              text: Text("${c.nom} ${c.prenom}")
          )).toList();
      print("couid ${coach_id}");
      if(coach_id != null) {
        Staff cou = profs.where((element) =>
        element.id_employe == coach_id).first;
        _selectProf.setSelected(
            BsSelectBoxOption(
                value: cou.id_employe,
                text: Text("${cou.nom} ${cou.prenom}")
            )
        );
      }

      print("--data--");
      print(profs.length);
    } else {
      throw Exception('Failed to load data');


    }
  }

  void getCour({int? cour_id}) async {
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
      _selectCours.options = cour.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_cour,
              text: Text("${c.nom_cour}")
          )).toList();
      print("couid ${cour_id}");
      if(cour_id != null) {
        Cours cou = cour.where((element) =>
        element.id_cour == cour_id).first;
        _selectCours.setSelected(
            BsSelectBoxOption(
                value: cou.id_cour,
                text: Text("${cou.nom_cour}")
            )
        );
      }

      print("--data--");
      print(cour.length);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void getSalle({int? salle_id}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/salles/'),
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
        Salles = result.map<Salle>((e) => Salle.fromJson(e)).toList();
      });
      _selectSalles.options = Salles.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_salle,
              text: Text("${c.nom_salle}")
          )).toList();

      print("--data--");
      print(Salles.length);
      if(salle_id != null) {
        Salle salles = Salles.where((element) =>
        element.id_salle == salle_id).first;
        _selectSalles.setSelected(
            BsSelectBoxOption(
                value: salles.id_salle,
                text: Text("${salles.nom_salle}")
            )
        );
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void initData(){

    capacity_controller.text = "";
    _selectJour.removeSelected(_selectJour.getSelected()!);
    _selectProf.removeSelected(_selectProf.getSelected()!);
    _selectCours.removeSelected(_selectCours.getSelected()!);
    _selectSalles.removeSelected(_selectSalles.getSelected()!);
    _selectTimeEnd.clear();
    if(_selectTimeStart.getSelected()?.getValue() != null){
      _selectTimeStart.removeSelected(_selectTimeStart.getSelected()!);
    }


    selectedTime = null;
    fetchSeance();

  }

  void add(context) async {

    if(

        // _selectTimeStart.getSelected()?.getValue() != null
    selectedTime != null
        && _selectTimeEnd.getSelected()?.getValue() != null
        && capacity_controller.text.isNotEmpty
        && _selectCours.getSelected()?.getValue() != null
        && _selectSalles.getSelected()?.getValue() != null
        && _selectProf.getSelected()?.getValue() != null
        && _selectJour.getSelected()?.getValue() != null  && _selectClasse.getSelected()?.getValue() != null
    ){


      var h_debut = selectedTime?.split(":");
      var h_fin = _selectTimeEnd.getSelected()?.getValue().toString().split(":");

      print(h_debut);
      print(h_fin);

      var h_start = int.parse(h_debut![0]);
      var m_start = int.parse(h_debut![1]);

      var h_end = int.parse(h_fin![0]);
      var m_end = int.parse(h_fin![1]);

      if(h_start > h_end){
        showAlertDialog(context, "L'heur de debut doit etre inferieur à l'heur de fin (Heure)");
        return;

      }else{
        if(h_start == h_end){
          if(m_start >= m_end){
            showAlertDialog(context, "L'heur de debut doit etre inferieur à l'heur de fin (Minute)");
            return;
          }
        }
      }

      var date_now = DateTime.now();

      var dispo_salle = data.where((s) =>
          s.id_salle == _selectSalles.getSelected()?.getValue()
          && s.jour == _selectJour.getSelected()?.getValue()
          && (DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${s.heure_debut}")
              .isAtSameMomentAs(DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${h_debut.join(":")}"))
          ||
              DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${s.heure_fin}")
                  .isAfter(DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${h_debut.join(":")}"))
          )
              && (DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${s.heure_debut}")
              .isBefore(DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${h_fin.join(":")}"))

          )
        ).toList();
      if(dispo_salle.isNotEmpty){
        showAlertDialog(context, "La salle est occupé pour ce créneau");
        return;
      }
      var dispo_prof = data.where((s) =>
      s.id_prof == _selectProf.getSelected()?.getValue()
          && s.jour == _selectJour.getSelected()?.getValue()
          && (DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${s.heure_debut}")
          .isAtSameMomentAs(DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${selectedTime}"))
          ||
          DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${s.heure_fin}")
              .isAfter(DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${selectedTime}"))
      )
          && (DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${s.heure_debut}")
          .isBefore(DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${_selectTimeEnd.getSelected()?.getValue()}"))

      )
      ).toList();

      if(dispo_prof.isNotEmpty){
        showAlertDialog(context, "Le prof est occupé pour ce créneau");
        return;
      }

      var dispo_classe = data.where((s) =>
      s.id_classe == _selectClasse.getSelected()?.getValue()
          && s.jour == _selectJour.getSelected()?.getValue()
          && (DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${s.heure_debut}")
          .isAtSameMomentAs(DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${selectedTime}"))
          ||
          DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${s.heure_fin}")
              .isAfter(DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${selectedTime}"))
      )
          && (DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${s.heure_debut}")
          .isBefore(DateTime.parse("${DateFormat("yyyy-MM-dd").format(date_now)} ${_selectTimeEnd.getSelected()?.getValue()}"))

      )
      ).toList();

      if(dispo_classe.isNotEmpty){
        showAlertDialog(context, "La classe est occupé pour ce créneau");
        return;
      }
      var rev = <String, dynamic>{
        "id_cour": _selectCours.getSelected()?.getValue(),
        "id_salle": _selectSalles.getSelected()?.getValue(),
        "id_classe": _selectClasse.getSelected()?.getValue(),
        "jour": _selectJour.getSelected()?.getValue(),
        "capacity": capacity_controller.text,
        "id_prof" : _selectProf.getSelected()?.getValue(),
        "heure_debut" : selectedTime!,
        "heure_fin" : _selectTimeEnd.getSelected()?.getValue(),
      };

      print(rev);
      final response = await http.post(Uri.parse(
          HOST+"/api/seance/"),
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
          //fetchSeance();
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context, "Erreur ajout seance");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }

  void update(context, int id) async {

    print(
        {
          "id_seance": id,
          "id_cour": _selectCours.getSelected()?.getValue(),
          "id_salle": _selectSalles.getSelected()?.getValue(),
          "id_classe": _selectClasse.getSelected()?.getValue(),
          "jour": _selectJour.getSelected()?.getValue(),
          "capacity": capacity_controller.text,
          "id_prof" : _selectProf.getSelected()?.getValue(),

        }
    );

    if(  //_selectTimeStart.getSelected()?.getValue() != null
        selectedTime != null
        && _selectTimeEnd.getSelected()?.getValue() != null
        && capacity_controller.text.isNotEmpty
        && _selectCours.getSelected()?.getValue() != null
        && _selectSalles.getSelected()?.getValue() != null
        && _selectClasse.getSelected()?.getValue() != null
        && _selectProf.getSelected()?.getValue() != null
        && _selectJour.getSelected()?.getValue() != null
    ){
      var h_debut = selectedTime?.split(":");
      var h_fin = _selectTimeEnd.getSelected()?.getValue().toString().split(":");

      //print(h_debut);
      print(h_fin);

      var h_start = int.parse(h_debut![0]);
      var m_start = int.parse(h_debut![1]);

      var h_end = int.parse(h_fin![0]);
      var m_end = int.parse(h_fin![1]);

      if(h_start > h_end){
        showAlertDialog(context, "L'heur de debut doit etre inferieur à l'heur de fin (Heure)");
        return;

      }else{
        if(h_start == h_end){
          if(m_start >= m_end){
            showAlertDialog(context, "L'heur de debut doit etre inferieur à l'heur de fin (Minute)");
            return;
          }
        }
      }


      var rev = <String, dynamic>{
        "id_seance": id,
        "id_cour": _selectCours.getSelected()?.getValue(),
        "id_salle": _selectSalles.getSelected()?.getValue(),
        "jour": _selectJour.getSelected()?.getValue(),
        "id_classe": _selectClasse.getSelected()?.getValue(),
        "capacity": capacity_controller.text,
        "id_prof" : _selectProf.getSelected()?.getValue(),
        "heure_debut" : selectedTime!,
        "heure_fin" : _selectTimeEnd.getSelected()?.getValue(),
      };

      print(rev);
      final response = await http.put(Uri.parse(
          HOST+"/api/seance/"),
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
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context, "Erreur ajout seance");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }
  void modal_add(context){

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
                      Text('Ajouter une Seance',
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
                                        title: ' Cours *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Cours',
                                      controller: _selectCours,
                                      searchable: true,
                                      serverSide:searchCour,
                                      onChange: (selected_cour) {
                                        _selectClasse.options = [];
                                        print('id_cour ${selected_cour?.getValue()}');
                                        if(selected_cour != null){
                                          Cours cr = cour.where((element) => element.id_cour == selected_cour.getValue()).first;
                                          List<Classes> classes_by_niv = classes.where((c) => c.id_niveau == cr.id_niveau).toList();
                                          print('classes_by_niv ${classes_by_niv.length}');
                                          _selectClasse.options = classes_by_niv.map<BsSelectBoxOption>((v) =>
                                              BsSelectBoxOption(
                                                value: v.id_classe,
                                                text: Text("${v.niveau} - ${v.groupe}"),
                                              )).toList();
                                        }

                                      },
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Salle *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Salle',
                                      controller: _selectSalles,
                                      searchable: true,
                                      serverSide:searchSalle,
                                      onChange: (value) {
                                        print("selected salle ${_selectSalles.getSelected()?.getValue()}");
                                        Salle s = Salles.where((element) =>
                                        element.id_salle == _selectSalles.getSelected()?.getValue()).first;
                                        print(s.capacity.toString());
                                        setState(() {
                                          capacity_controller.text = s!.capacity!.toString();
                                        });
                                        if(_selectJour.getSelected()?.getValue() != null) {
                                          _selectJour.removeSelected( _selectJour.getSelected()!);
                                        }
                                        Navigator.pop(context);
                                        modal_add(context);
                                      },
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),

                        SizedBox(
                          height: 25,
                        ),

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
                                        title: 'Profs *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Prof',
                                      controller: _selectProf,
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Jour de la semaine *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Jour de la semaine',
                                      controller: _selectJour,
                                      onChange: (val) {
                                        if(_selectSalles.getSelected()?.getValue() != null){
                                          var salle = Salles.where((s)=> s.id_salle == _selectSalles.getSelected()?.getValue()).first;
                                          timeFree(salle, _selectJour.getSelected()?.getValue());
                                        }else{
                                          showAlertDialog(context, "selection une salle");
                                        }
                                      },
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Heur debut *'
                                    ),
                                    Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Color(0xFFCFD8DC)),
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: DropdownButtonFormField<String>(
                                            value: selectedTime,
                                            decoration: InputDecoration(
                                                hintText: "Heur debut *",
                                                border: InputBorder.none,

                                                //prefixIconColor: Color(0xFFCFD8DC),

                                                //prefixIcon: Icon(Icons.timelapse, size: 15)
                                            ),
                                            items: _selectTimeStart2,
                                            onChanged: (String? timesValue) {
                                              print(timesString);
                                              String timeStart = timesValue!;
                                              int indexStart = timesString.indexOf(timeStart)+1;
                                              int indexEnd = indexStart;
                                              if(indexStart >= (timesString.length-8)){
                                                int difs = timesString.length - indexStart; // 60 - 60 = 0 or 60 - 57 = 3
                                                indexEnd = indexStart+difs;
                                              }else{
                                                indexEnd = indexStart+8;
                                              }

                                              _selectTimeEnd.clear();
                                              Iterable<String> selectedTimes = timesString.getRange(indexStart, indexEnd);

                                              _selectTimeEnd.options = selectedTimes.map<BsSelectBoxOption>((time) =>
                                                  BsSelectBoxOption(
                                                      value: time,
                                                      text: Text("${time}"))).toList();
                                              setState(() {
                                                selectedTime = timesValue;
                                              });
                                              Navigator.pop(context);
                                              modal_add(context);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(width: 15,),
                            Expanded(

                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    LabelText(
                                        title: 'Heur fin *'
                                    ),
                                    BsSelectBox(
                                        hintText: 'Heur fin *',
                                        controller: _selectTimeEnd,
                                      //size: BsSelectBoxSize(maxHeight: 45),

                                    )

                                  ],
                                )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  LabelText(
                                      title: 'Capacité'
                                  ),
                                  Container(
                                      width: 300,
                                      decoration: BoxDecoration(boxShadow: [

                                      ]),
                                      child: TextField(
                                        controller: capacity_controller,
                                        readOnly: true,
                                        decoration: new InputDecoration(
                                            hintText: 'capacité',
                                            hintStyle: TextStyle(fontSize: 14)
                                        ),
                                      )
                                  ),
                                ],
                              ),

                            ),
                         SizedBox(width: 15,),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Classe *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Classe',
                                      controller: _selectClasse,
                                      // searchable: true,
                                      // serverSide:searchCoach,
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),

                        SizedBox(height: 25,),

                        SizedBox( height: 10),
                        InkWell(
                          onTap: (){
                            add(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                              SizedBox(height: 6,),
                              LabelText(
                                  title: 'Nb: * designe un champ obligatoire'
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

  void modal_update(context, Seance s, {bool init=false}){

    if(init){
      capacity_controller.text = s.capacity.toString();
      _selectJour.setSelected(
          BsSelectBoxOption(value: s.jour, text: Text(s.day_name.toString()))
      );
      _selectProf.setSelected(
          BsSelectBoxOption(value: s.id_prof, text: Text(s.coach.toString()))
      );
      _selectSalles.setSelected(
          BsSelectBoxOption(value: s.id_salle, text: Text(s.salle.toString()))
      );
      _selectClasse.setSelected(
          BsSelectBoxOption(value: s.id_classe, text: Text(s.classe.toString()))
      );
      _selectCours.setSelected(
          BsSelectBoxOption(value: s.id_cour, text: Text(s.cour.toString()))
      );

      var h_starts = s.heure_debut.toString().split(":");
      var h_end = s.heure_fin.toString().split(":");

      _selectTimeStart.setSelected(BsSelectBoxOption(value: "${h_starts[0]}:${h_starts[1]}", text: Text("${h_starts[0]}:${h_starts[1]}")));

      _selectTimeEnd.setSelected(BsSelectBoxOption(value: "${h_end[0]}:${h_end[1]}", text: Text("${h_end[0]}:${h_end[1]}")));
      selectedTime = "${h_starts[0]}:${h_starts[1]}";
      //heure_debut_controller.text = "${s.heure_debut} AM";
      //heure_fin_controller.text = "${s.heure_fin} AM";

      //var timeStart = new TimeOfDay(hour: h_starts[0] as int, minute: h_starts[1] as int);
      //var timEnd = new TimeOfDay(hour: h_starts[0] as int, minute: h_starts[1] as int);

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
                      Text('Modifier une Seance',
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
                                        title: 'Cours *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Cours',
                                      controller: _selectCours,
                                      searchable: true,
                                      serverSide:searchCour,
                                      onChange: (selected_cour) {
                                        _selectClasse.options = [];
                                        print('id_cour ${selected_cour
                                            ?.getValue()}');
                                        if (selected_cour != null) {
                                          Cours cr = cour
                                              .where((element) =>
                                          element.id_cour ==
                                              selected_cour.getValue())
                                              .first;
                                          List<Classes> classes_by_niv = classes
                                              .where((c) =>
                                          c.id_niveau == cr.id_niveau).toList();
                                          print('classes_by_niv ${classes_by_niv
                                              .length}');
                                          _selectClasse.options =
                                              classes_by_niv.map<
                                                  BsSelectBoxOption>((v) =>
                                                  BsSelectBoxOption(
                                                    value: v.id_classe,
                                                    text: Text(
                                                        "${v.niveau} - ${v
                                                            .groupe}"),
                                                  )).toList();
                                        }
                                      }
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Salle *'
                                    ),
                                     BsSelectBox(
                                       hintText: 'Salle',
                                       controller: _selectSalles,
                                       searchable: true,
                                       serverSide:searchSalle,
                                       onChange: (value) {
                                         print("selected salle ${_selectSalles.getSelected()?.getValue()}");
                                         Salle salle= Salles.where((element) =>
                                         element.id_salle == _selectSalles.getSelected()?.getValue()).first;
                                         print(salle.capacity.toString());
                                         setState(() {
                                           capacity_controller.text = salle.capacity.toString();
                                         });
                                         Navigator.pop(context);
                                         modal_update(context, s,init: false);
                                       },
                                     ),
                                  ],
                                )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
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
                                        title: 'Prof *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'prof',
                                      controller: _selectProf,

                                    ),
                                  ],
                                )
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Jour de la semaine *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Jour',
                                      controller: _selectJour,
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Heur debut *'
                                    ),
                                    Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFCFD8DC)),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: DropdownButtonFormField<String>(
                                            value: selectedTime,
                                            decoration: InputDecoration(
                                              hintText: "Heur debut *",
                                              border: InputBorder.none,

                                              //prefixIconColor: Color(0xFFCFD8DC),
                                              //prefixIcon: Icon(Icons.timelapse, size: 15)
                                            ),
                                            items: _selectTimeStart2,

                                            onChanged: (String? timesValue) {
                                              print(timesString);
                                              String timeStart = timesValue!;
                                              int indexStart = timesString.indexOf(timeStart)+1;
                                              int indexEnd = indexStart;
                                              if(indexStart >= (timesString.length-8)){
                                                int difs = timesString.length - indexStart; // 60 - 60 = 0 or 60 - 57 = 3
                                                indexEnd = indexStart+difs;
                                              }else{
                                                indexEnd = indexStart+8;
                                              }

                                              _selectTimeEnd.clear();
                                              Iterable<String> selectedTimes = timesString.getRange(indexStart, indexEnd);

                                              _selectTimeEnd.options = selectedTimes.map<BsSelectBoxOption>((time) =>
                                                  BsSelectBoxOption(
                                                      value: time,
                                                      text: Text("${time}"))).toList();
                                              setState(() {
                                                selectedTime = timesValue;
                                              });
                                              Navigator.pop(context);
                                              modal_update(context, s, init: false);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                )
                            ),
                            SizedBox(width: 15,),
                            Expanded(

                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Heur fin *'
                                    ),
                              BsSelectBox(controller: _selectTimeEnd , hintText: "Heur fin *", )

                                  ],
                                )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  LabelText(
                                      title: 'Capacité'
                                  ),
                                  Container(
                                      width: 300,
                                      decoration: BoxDecoration(boxShadow: [

                                      ]),
                                      child: TextField(
                                        controller: capacity_controller,
                                        readOnly: true,
                                        decoration: new InputDecoration(
                                            hintText: 'capacité',
                                            hintStyle: TextStyle(fontSize: 14)
                                        ),
                                      )
                                  ),
                                ],
                              ),

                            ),
                            SizedBox(width: 15,),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Classe *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Classe',
                                      controller: _selectClasse,
                                      // searchable: true,
                                      // serverSide:searchCoach,
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),

                        SizedBox( height: 10),
                        InkWell(
                          onTap: (){
                            update(context, s.id_seance!);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                              SizedBox(height: 6,),
                              LabelText(
                                  title: 'Nb: * designe un champ obligatoire'
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
           //   SideBar(postion: 10,msg:"Seances"),
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
                              Padding(
                                padding: const EdgeInsets.only(top:15.0),
                                child: Center(child: Text("Séances", style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.w700,
                                    color: Colors.black)),),
                              ),
                              SizedBox(height: 30,),
                              screenSize.width > 520 ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex:1,
                                      child:Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.grey[200],
                                            border: Border.all(
                                                color: Colors.blue
                                            )
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  width: 33,
                                                  height: 33,
                                                  child: Icon(Icons.search, color: Colors.white,),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.blue

                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  child: TextFormField(
                                                    onChanged: (val)=>{
                                                      search(val)
                                                    },
                                                    decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: "Chercher"
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(width: 15,),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                    ),
                                  ),

                                  Expanded(
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: (){

                                            Navigator.of(context)
                                                .push(
                                                MaterialPageRoute(builder: (context) => CalenderScreen()
                                                )
                                            ).then((value) => fetchSeance());
                                          },

                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.orangeAccent,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.calendar_month_outlined, color: Colors.white, size: 18,),
                                                  SizedBox(width: 3,),
                                                  Text("Planning",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white
                                                      )),
                                                ],
                                              )
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        InkWell(
                                          onTap: (){

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
                                                child: Text("Ajouter une Seance",
                                                    style: TextStyle(
                                                        fontSize: 15
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                    ),
                                  )
                                ],
                              ):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Seances", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context)
                                          .push(
                                          MaterialPageRoute(builder: (context) => Planning()
                                          )
                                      ).then((value) => fetchSeance());
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Icon(
                                              Icons.calendar_month_outlined,
                                              size: 18,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: ListView(
                                      children:[
                                        data.length == 0 ?
                                        Padding(
                                          padding: const EdgeInsets.all(150.0),
                                          child: Center(
                                              child: Text("aucune Seance à afficher")),
                                        )
                                            :
                                        DataTable(
                                            dataRowHeight: DataRowHeight,
                                            headingRowHeight: HeadingRowHeight,
                                            columns: screenSize.width > 520 ?
                                            <DataColumn>[
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    ' Cours',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    ' Salle',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    ' Capacité',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Jour de la semaine',
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
                                                    ' Nom Cours',
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
                                            ],
                                            rows:
                                            data.map<DataRow>((r) => DataRow(
                                              cells: screenSize.width > 520 ?
                                              <DataCell>[
                                                DataCell(Row(
                                                  children: [
                                                    SizedBox(width: 6,),
                                                    Text(r.cour.toString())
                                                  ],
                                                )),
                                                DataCell(Text(r.salle.toString())),
                                                DataCell(
                                                    Text(
                                                        "${r.capacity}"
                                                    )),
                                                DataCell(Text(r.day_name.toString())),
                                                // DataCell(Text(r.motif_annulation == null ? "-" : r.motif_annulation.toString())),
                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
                                                        msg:"•Visualisation Les détails Seance",
                                                        onPressed: (){
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
                                                                            Text('${r.cour.toString()}',
                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                            BsButton(
                                                                              style: BsButtonStyle.outlinePrimary,
                                                                              label: Text('Fermer'),
                                                                              //prefixIcon: Icons.close,
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                initData();
                                                                              },
                                                                            )
                                                                          ],
                                                                        ),
                                                                        BsModalContainer(
                                                                          child: Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(width: 8,),
                                                                                Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Row(
                                                                                              children: [
                                                                                                Center(
                                                                                                  child: Text("Informations Séance:" ,style: TextStyle(
                                                                                                      fontWeight: FontWeight.bold, color:Colors.blue
                                                                                                  ),),
                                                                                                ),
                                                                                                SizedBox(width: 9,),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Text("Cours:" ,style: TextStyle(
                                                                                                    fontWeight: FontWeight.bold, color:Colors.grey
                                                                                                ),),
                                                                                                SizedBox(width: 9,),
                                                                                                Text(" ${r.cour.toString()}"),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Text("Salle:" ,style: TextStyle(
                                                                                                    fontWeight: FontWeight.bold, color:Colors.grey
                                                                                                ),),
                                                                                                SizedBox(width: 9,),
                                                                                                Text("${r.salle.toString()}"),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Text("Classe :" ,style: TextStyle(
                                                                                                    fontWeight: FontWeight.bold, color:Colors.grey
                                                                                                ),),
                                                                                                SizedBox(width: 9,),
                                                                                                Text(" ${r.classe.toString()} "),
                                                                                              ],
                                                                                            ),

                                                                                            Row(
                                                                                              children: [
                                                                                                Text("jour:" ,style: TextStyle(
                                                                                                    fontWeight: FontWeight.bold, color:Colors.grey
                                                                                                ),),
                                                                                                SizedBox(width: 9,),
                                                                                                Text("${r.day_name.toString()}"),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Text("Capacite:" ,style: TextStyle(
                                                                                                    fontWeight: FontWeight.bold, color:Colors.grey
                                                                                                ),),
                                                                                                SizedBox(width: 9,),
                                                                                                Text("${r.capacity.toString()}"),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Text("Créneau: De" ,style: TextStyle(
                                                                                                    fontWeight: FontWeight.bold, color:Colors.grey
                                                                                                ),),
                                                                                                SizedBox(width: 9,),
                                                                                                Text(" ${r.heure_debut.toString()} à ${r.heure_fin.toString()}"),
                                                                                              ],
                                                                                            ),

                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Row(
                                                                                              children: [
                                                                                                Center(
                                                                                                  child: Text("Informations Prof:" ,style: TextStyle(
                                                                                                      fontWeight: FontWeight.bold, color:Colors.blue
                                                                                                  ),),
                                                                                                ),
                                                                                                SizedBox(width: 9,),

                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Text("Prof:" ,style: TextStyle(
                                                                                                    fontWeight: FontWeight.bold, color:Colors.grey
                                                                                                ),),
                                                                                                SizedBox(width: 9,),
                                                                                                Text("${r.coach.toString()}"),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),

                                                                                      ],
                                                                                    )
                                                                                )
                                                                              ]
                                                                          ),
                                                                        ),
                                                                        BsModalContainer(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          actions: [
                                                                            //Navigator.pop(context);
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )));
                                                        }
                                                    ),
                                                    SizedBox(width: 10,),
                                                    EditerButton(
                                                        msg: "Mettre à jour les informations ",
                                                        onPressed: (){
                                                          modal_update(context, r, init: true);
                                                        }
                                                    ),
                                                    SizedBox(width: 10,),
                                                    DeleteButton(
                                                      msg:"Supprimer la seance",
                                                      onPressed: () async{
                                                        if (await confirm(
                                                          context,
                                                          title: const Text('Confirmation'),
                                                          content: const Text('Souhaitez-vous supprimer ?'),
                                                          textOK: const Text('Oui'),
                                                          textCancel: const Text('Non'),
                                                        )) {
                                                          delete(r.id_seance.toString());
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ))

                                              ]:
                                              <DataCell>[
                                                DataCell(Row(
                                                  children: [
                                                    SizedBox(width: 6,),
                                                    Expanded(
                                                      child: Text(r.cour.toString(),
                                                      overflow: TextOverflow.ellipsis,),
                                                    )
                                                  ],
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
                                                        msg:"•Visualisation Les détails Seance",
                                                        onPressed: (){
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
                                                                            Text('${r.cour.toString()}',
                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                            BsButton(
                                                                              style: BsButtonStyle.outlinePrimary,
                                                                              label: Text('Fermer'),
                                                                              //prefixIcon: Icons.close,
                                                                              onPressed: () {

                                                                                Navigator.pop(context);
                                                                                initData();


                                                                              },
                                                                            )
                                                                          ],


                                                                        ),
                                                                        BsModalContainer(
                                                                          child: Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(width: 8,),
                                                                                Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(height: 4,),
                                                                                     /*   Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Nom cour:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey,
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${r.cour.toString()}"),
                                                                                          ],
                                                                                        ),*/
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("jour:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${r.day_name.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Coach:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${r.coach.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Capacité:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.capacity.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Créneau: De" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.heure_debut.toString()} à ${r.heure_fin.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                )
                                                                              ]
                                                                          ),
                                                                        ),
                                                                        BsModalContainer(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          actions: [
                                                                            //Navigator.pop(context);
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )));
                                                        }
                                                    ),
                                                    SizedBox(width: 10,),
                                                    EditerButton(
                                                        msg: "Mettre à jour les informations ",
                                                        onPressed: (){
                                                          modal_update(context, r, init: true);
                                                        }
                                                    ),
                                                    SizedBox(width: 10,),
                                                    DeleteButton(
                                                      msg:"Supprimer la seance",
                                                      onPressed: () async{
                                                        if (await confirm(
                                                          context,
                                                          title: const Text('Confirmation'),
                                                          content: const Text('Souhaitez-vous supprimer ?'),
                                                          textOK: const Text('Oui'),
                                                          textCancel: const Text('Non'),
                                                        )) {

                                                          delete(r.id_seance.toString());
                                                        }

                                                      },
                                                    ),
                                                  ],
                                                ))

                                              ],
                                            )).toList()
                                        ),]
                                  )
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

}

