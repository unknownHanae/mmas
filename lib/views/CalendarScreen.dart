import 'dart:math';

import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../constants.dart';
import '../models/ClasseModel.dart';
import '../models/ClientModels.dart';
import '../models/CoachModels.dart';
import '../models/CoursModels.dart';
import '../models/SalleModels.dart';
import '../models/SeanceModels.dart';

import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Staff.dart';
import '../providers/admin_provider.dart';

class CalenderScreen extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {


  List<Seance> seances = [];

  String cour_name = "";

  List<Color?> colors = [
    Colors.lightBlue,
    Colors.blueAccent,
    Colors.grey,
    Colors.lightBlueAccent,
    Colors.blueGrey
  ];

  String? selectedTime;

  List<Cours> cour = [];
  List<Salle> Salles = [];
  List<Client> clients =[];
  List<Staff> profs = [];
  String capacity = "";
  String jour = "";
  List<Seance> data = [];
  List<Seance> init_data = [];
  bool loading = false;
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
  Future<BsSelectBoxResponse> searchCoach(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in profs){
      var name = "${v.nom} ${v.prenom}";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_employe,
                text: Text("${v.nom} ${v.prenom}")
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
  BsSelectBoxController _selectClient = BsSelectBoxController();
  BsSelectBoxController _selectClasse = BsSelectBoxController();

  List<BsSelectBoxOption> times = [];
  List<String> timesString = [];
  List<Classes> classes = [];

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
  void fetchSeance() async {

    final response = await http.get(Uri.parse(
        HOST+'/api/seance/'),
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

  void initTime(){
    times.clear();
    for(var h=7; h<=21; h++){
      if(h != 21){
        for(var m=0; m<=45 ; m=m+15){
          String time = "${h <10 ? '0${h}' : h}:${m == 0 ? '00' : m}";
          print(time);
          times.add(BsSelectBoxOption(value: time, text: Text(time)));
          timesString.add(time);
        }
      }else{
        print("21:00");
        times.add(BsSelectBoxOption(value: "21:00", text: Text("21:00")));
        timesString.add("21:00");
      }
    }
    _selectTimeStart.options = times;
    //_selectTimeEnd.options = times;
  }
  void delete(id) async {
    Navigator.pop(context);
    final response = await http.delete(Uri.parse(
        HOST+'/api/seance/'+id),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

    if (response.statusCode == 200) {
      ///fetchSeance();
      setState(() {
        _future = getDataFromWeb();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  void timeFree(Salle s, int day){

    try{
      times.clear();
      _selectTimeStart.clear();
      List<Seance> seances_inday = seances.where((sc) => sc.id_salle == s.id_salle && sc.jour == day).toList();
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
  List<DropdownMenuItem<String>>_selectTimeStart2 = [];
  var _future;
  String token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    //getSeances();

    _future = getDataFromWeb();

    getCour();
    getSalle();
    getProf();
    getClient();
    getClasses();
    initTime();
  }
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

  var days = {
    1: "Lundi",
    2: "Mardi",
    3: "Mercredi",
    4: "Jeudi",
    5: "Vendredi",
    6: "Samedi",
    7: "Dimanche"
  };
  void update(context, int id) async {

    if(  _selectTimeStart.getSelected()?.getValue() != null
        && _selectTimeEnd.getSelected()?.getValue() != null
        && capacity_controller.text.isNotEmpty
        && _selectCours.getSelected()?.getValue() != null
        && _selectSalles.getSelected()?.getValue() != null
        && _selectProf.getSelected()?.getValue() != null
        && _selectJour.getSelected()?.getValue() != null   && _selectClasse.getSelected()?.getValue() != null
    ){
      var h_debut = _selectTimeStart.getSelected()?.getValue().toString().split(":");
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


      var rev = <String, dynamic>{
        "id_seance": id,
        "id_cour": _selectCours.getSelected()?.getValue(),
        "id_salle": _selectSalles.getSelected()?.getValue(),
        "id_classe": _selectClasse.getSelected()?.getValue(),
        "jour": _selectJour.getSelected()?.getValue(),
        "capacity": capacity_controller.text,
        "id_prof" : _selectProf.getSelected()?.getValue(),
        "heure_debut" : _selectTimeStart.getSelected()?.getValue(),
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
          setState(() {
            _future = getDataFromWeb();
          });
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

  void add(context) async {

    if(

    _selectTimeStart.getSelected()?.getValue() != null
        && _selectTimeEnd.getSelected()?.getValue() != null
        && capacity_controller.text.isNotEmpty
        && _selectCours.getSelected()?.getValue() != null
        && _selectSalles.getSelected()?.getValue() != null
        && _selectProf.getSelected()?.getValue() != null
        && _selectJour.getSelected()?.getValue() != null && _selectClasse.getSelected()?.getValue() != null
    ){


      var h_debut = _selectTimeStart.getSelected()?.getValue().toString().split(":");
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
        "jour": _selectJour.getSelected()?.getValue(),
        "id_classe": _selectClasse.getSelected()?.getValue(),
        "capacity": capacity_controller.text,
        "id_prof" : _selectProf.getSelected()?.getValue(),
        "heure_debut" : _selectTimeStart.getSelected()?.getValue(),
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
          setState(() {
            _future = getDataFromWeb();
          });
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
                                        title: 'Nom du cour *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Cour',
                                      controller: _selectCours,
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
                                        title: 'nom du Salle *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Salle',
                                      controller: _selectSalles,
                                      onChange: (value) {
                                        if(_selectSalles.getSelected()?.getValue() != null){
                                          print("selected salle ${_selectSalles.getSelected()?.getValue()}");
                                          Salle s = Salles.where((element) =>
                                          element.id_salle == _selectSalles.getSelected()?.getValue()).first;
                                          print(s.capacity.toString());
                                          setState(() {
                                            capacity_controller.text = s!.capacity!.toString();
                                          });
                                          /*if(_selectJour.getSelected()?.getValue() != null){
                                            _selectJour.removeSelected(_selectJour.getSelected()!);
                                          }*/
                                          Navigator.pop(context);
                                          modal_add(context);
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
                                        title: 'Jour *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Jour',
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
                                    BsSelectBox(
                                      hintText: 'Heur debut *',
                                      controller: _selectTimeStart,
                                      autoClose: true,
                                      onChange: (v) {
                                        print(timesString);
                                        String timeStart = _selectTimeStart.getSelected()?.getValue();
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
                                        Navigator.pop(context);
                                        modal_add(context);
                                      },
                                    )

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
                                        controller: _selectTimeEnd
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
      Navigator.pop(context);
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
                                        title: 'Nom du cour *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Cour',
                                      controller: _selectCours,
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
                                        title: 'nom du Salle *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Salle',
                                      controller: _selectSalles,
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
                        // SizedBox(height: 10,),
                        // LabelText(
                        //     title: 'Nom du cour *'
                        // ),
                        // BsSelectBox(
                        //   hintText: 'Cour',
                        //   controller: _selectCours,
                        // ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        // LabelText(
                        //     title: 'nom du Salle *'
                        // ),
                        // BsSelectBox(
                        //   hintText: 'Salle',
                        //   controller: _selectSalles,
                        //   onChange: (value) {
                        //     print("selected salle ${_selectSalles.getSelected()?.getValue()}");
                        //     Salle salle= Salles.where((element) =>
                        //     element.id_salle == _selectSalles.getSelected()?.getValue()).first;
                        //     print(salle.capacity.toString());
                        //     setState(() {
                        //       capacity_controller.text = salle.capacity.toString();
                        //     });
                        //     Navigator.pop(context);
                        //     modal_update(context, s,init: false);
                        //   },
                        // ),
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
                                        title: 'Jour *'
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
                                    BsSelectBox(
                                      controller: _selectTimeStart ,
                                      hintText: "Heur debut *",
                                      onChange: (v) {
                                        print(timesString);
                                        String timeStart = _selectTimeStart.getSelected()?.getValue();
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
                                        Navigator.pop(context);
                                        modal_update(context, s, init: false);
                                      },
                                    )
                                    // TextField(
                                    //   decoration: InputDecoration(
                                    //     icon: Icon(Icons.calendar_today),
                                    //     labelText: 'Heur debut',
                                    //   ),
                                    //   readOnly: true,
                                    //   controller: heure_debut_controller,
                                    //   onTap: () async {
                                    //     var pickedTime = await showTimePicker(
                                    //       context: context,
                                    //       //initialTime: timeStart,
                                    //       initialTime: TimeOfDay.now()
                                    //     );
                                    //     if (pickedTime != null) {
                                    //       String formattedTime = pickedTime.format(context);
                                    //
                                    //       setState(() {
                                    //         heure_debut_controller.text =
                                    //             formattedTime.toString();
                                    //       });
                                    //       print(formattedTime);
                                    //     } else {
                                    //       print('Not selected');
                                    //     }
                                    //   },
                                    // ),
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
                                    // TextField(
                                    //   decoration: InputDecoration(
                                    //     icon: Icon(Icons.calendar_today),
                                    //     labelText: 'Heur fin',
                                    //   ),
                                    //   readOnly: true,
                                    //   controller: heure_fin_controller,
                                    //   onTap: () async {
                                    //     var pickedTime = await showTimePicker(
                                    //       context: context,
                                    //       initialTime: TimeOfDay.now()
                                    //       //initialTime: timEnd,
                                    //     );
                                    //     if (pickedTime != null) {
                                    //       String formattedTime = pickedTime.format(context);
                                    //
                                    //       setState(() {
                                    //         heure_fin_controller.text =
                                    //             formattedTime.toString();
                                    //       });
                                    //       print(formattedTime);
                                    //     } else {
                                    //       print('Not selected');
                                    //     }
                                    //   },
                                    // ),
                                  ],
                                )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  LabelText(
                                      title: 'Capacity'
                                  ),
                                  Container(
                                      width: 300,
                                      decoration: BoxDecoration(boxShadow: [

                                      ]),
                                      child: TextField(
                                        controller: capacity_controller,
                                        readOnly: true,
                                        decoration: new InputDecoration(
                                            hintText: 'capacity',
                                            hintStyle: TextStyle(fontSize: 14)
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),

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

  void initData(){

    capacity_controller.text = "";
    _selectJour.removeSelected(_selectJour.getSelected()!);
    _selectProf.removeSelected(_selectProf.getSelected()!);
    _selectCours.removeSelected(_selectCours.getSelected()!);
    _selectSalles.removeSelected(_selectSalles.getSelected()!);
    _selectTimeEnd.clear();
    _selectTimeStart.removeSelected(_selectTimeStart.getSelected()!);


    //getSeances();

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
      },);

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

  void reserver(context, Seance seance) async {

    if(seance != null
        && _selectClient.getSelected()?.getValue() != null
    ){

      var rev = <String, dynamic>{
        "id_client": _selectClient.getSelected()?.getValue(),
        "id_seance": seance.id_seance,
        "date_presence": seance.date_reservation,

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


        print(response.body);
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context,true);
          Navigator.pop(context,true);
          setState(() {
            _future = getDataFromWeb();
          });
          final snackBar = SnackBar(
            content: const Text('Votre réservation bien effectue'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Reservation',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          //showAlertDialog(context, "Votre réservation bien effectue");
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

  void modal_reservation(context, Seance seance){
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
                        SizedBox(height: 10,),
                        LabelText(
                            title: 'Etudiant *'
                        ),
                        BsSelectBox(
                          hintText: 'Etudiant',
                          controller: _selectClient,
                          searchable: true,
                          serverSide: searchClient,

                        ),
                        SizedBox(height: 10,),
                        LabelText(
                            title: 'Seance *'
                        ),
                        Text('Prof: ${seance.coach!}'),
                        Text('Heure debut: ${seance.heure_debut!}'),
                        Text('Heure fin: ${seance.heure_fin!}'),
                        Text('Salle: ${seance.salle!}'),
                        Text('Capacite: ${seance.capacity!}'),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            reserver(context, seance);
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Planning Seances", style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),

          onPressed: () => Navigator.of(context).pop(
              {
                "selected": false,
                "seance": null
              }
          ),
        ),
        actions: [
          TextButton(
            child: Text('+ Ajouter Seance', style: TextStyle(color: Colors.white)),

            onPressed: () {
              modal_add(context);
            },
          ),
        ],
      ),
        body:
        FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return SafeArea(
                child: Container(
                    child: SfCalendar(

                      view: CalendarView.week,
                      firstDayOfWeek: 1,
                      minDate: DateTime.now(),
                      maxDate: DateTime.now().add(Duration(days: 7)),
                      timeSlotViewSettings: TimeSlotViewSettings(
                        startHour: 6,
                        endHour: 22,
                        dayFormat: 'EEEE',
                        timeFormat: 'HH:mm',

                      ),
                      initialDisplayDate: DateTime(2017, 6, 01, 9, 0, 0),
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
    );

  }

  Future<List<Meeting>> getDataFromWeb() async {

    var data =  await http.get(Uri.parse(
        HOST+'/api/seance/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
    var jsonData = json.decode(data.body);

    final List<Meeting> appointmentData = [];
    final Random random = new Random();

    if (data.statusCode == 200) {
      final body = json.decode(data.body);
      final List result = body["data"];

      setState(() {
        seances = result.map<Seance>((e) => Seance.fromJson(e)).toList();
      });

      print("nb seances ${seances.length}");
      print("nb appointmentData ${appointmentData.length}");
      seances.forEach((seance) {
        print("seance id ${seance.id_seance}");
        //var date = DateTime.now();
        try{
          print("date fin ${seance.date_reservation} ${seance.heure_fin}");
          print("date ${DateTime.parse("${seance.date_reservation} ${seance.heure_fin}")}");
          appointmentData.add(
              Meeting(
                seance_id: seance.id_seance!,
                eventName: "${seance.cour!}\n${seance.salle!}",
                from: DateTime.parse("${seance.date_reservation} ${seance.heure_debut}"),
                to: DateTime.parse("${seance.date_reservation} ${seance.heure_fin}"),
                background: (seance.capacity! - seance.nb_reservations!) == 0 ? Colors.black : seance.colorfinal!,
                isAllDay: false,

              )
          );
        }catch(e){
          print(e);
        }

      });



      print("nb appointmentData 2 ${appointmentData.length}");
      return appointmentData;

    } else {
      throw Exception('Failed to load data');
    }


  }

  void calendarTapped(CalendarTapDetails details) {

    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Meeting appointmentDetails = details.appointments![0];
      print(appointmentDetails.seance_id);
      Seance seance = seances.where((element) => element.id_seance == appointmentDetails.seance_id).first;
      var format = DateFormat("HH:mm");
      var one = format.parse(seance.heure_debut!);
      var two = format.parse(seance.heure_fin!);

      print("duration ${two.difference(one)}");
      var duration = two.difference(one);

      print(seance.toJson());

      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text('Cours: ${seance.cour!}'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Informations Séance:',style: TextStyle(
                      fontWeight: FontWeight.bold, color:Colors.blue),),
                  Text('Cours: ${seance.cour!}'),
                  Text('Prof: ${seance.coach!}'),
                  Text('Classe: ${seance.classe!}'),
                  Text('Salle: ${seance.salle!}'),
                  Text('Capacite: ${seance.capacity!}'),
                  Text('Jour: ${seance.day_name!}'),
                  Text('Heure debut: ${DateFormat("HH:mm").format(DateTime.parse("${seance.date_reservation} ${seance.heure_debut!}"))}'),
                  Text('Heure fin: ${DateFormat("HH:mm").format(DateTime.parse("${seance.date_reservation} ${seance.heure_fin!}"))}'),
                  Text('Duree: ${duration.inMinutes} min'),


                ],
              ),
            ),
            actions: <Widget>[
              EditerButton(
                msg: "mettre à jour les informations",
                onPressed: (){
                  modal_update(context,seance,init: true);
                },
              ),
              DeleteButton(
                msg:"Supprimer Seance ",
                onPressed: () async{

                  if (await confirm(
                    context,
                    title: const Text('Confirmation'),
                    content: const Text('Souhaitez-vous supprimer ?'),
                    textOK: const Text('Oui'),
                    textCancel: const Text('Non'),
                  )) {

                    delete(seance.id_seance.toString());
                  }

                },
              ),
              TextButton(
                child: const Text('Fermer', style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              /*TextButton(
                      child: const Text('Selection', style: TextStyle(color: Colors.green),),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop({
                          "selected": true,
                          "seance": seances[i]
                        });
                      },
                    ),*/
            ],
          );
        },
      );
    }else{
      var date = details.date.toString();
      var items = date.split(" ");
      var times = items[1].split(":");
      var selected_date = "${times[0]}:${times[1]}";
      DateTime date_time = DateTime.parse(items[0]);

      print(date_time.weekday);

      _selectTimeStart.setSelected(BsSelectBoxOption(value: selected_date, text: Text(selected_date)));

      _selectJour.setSelected(BsSelectBoxOption(value: date_time.weekday, text: Text("${jours[date_time.weekday]}")));

      int indexStart = timesString.indexOf(selected_date)+1;
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



      modal_add(context);
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
  Meeting({required this.seance_id, required this.eventName, required this.from, required this.to, required this.background, required this.isAllDay});

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
}
