import 'dart:math';

import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_planner/time_planner.dart';

import '../componnents/label.dart';
import '../constants.dart';
import '../models/CoachModels.dart';
import '../models/CoursModels.dart';
import '../models/SalleModels.dart';
import '../models/SeanceModels.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../providers/admin_provider.dart';


class Planning extends StatefulWidget {
  Planning({Key? key}) : super(key: key);
  

  @override
  State<Planning> createState() => _PlanningState();
}

class _PlanningState extends State<Planning> {
  List<TimePlannerTask>  planning = [];
  
  List<Seance> seances = [];

  String cour_name = "";

  // List<Color?> colors = [
  //   Colors.orangeAccent,
  //   Colors.orange,
  //   Colors.grey,
  //   Colors.lightBlueAccent,
  //   Colors.blueGrey
  // ];

  String? selectedTime;

  List<Cours> cour = [];
  List<Salle> Salles = [];
  List<Coach> coaches = [];
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
    for(var v in coaches){
      var name = "${v.nom_coach}";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_coach,
                text: Text("${v.nom_coach}")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }

  BsSelectBoxController _selectCours = BsSelectBoxController();
  BsSelectBoxController _selectSalles = BsSelectBoxController();
  BsSelectBoxController _selectCoach = BsSelectBoxController();

  BsSelectBoxController _selectTimeStart = BsSelectBoxController();
  BsSelectBoxController _selectTimeEnd = BsSelectBoxController();

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


  List<BsSelectBoxOption> times = [];
  List<String> timesString = [];





  void getSeances() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/seance/'),
        headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      
      setState(() {
        seances = result.map<Seance>((e) => Seance.fromJson(e)).toList();
      });

      planning.clear();

      for(var i=0; i<seances.length; i++){

        var times = seances[i].heure_debut!.split(":");
        var format = DateFormat("HH:mm:ss");
        var one = format.parse(seances[i].heure_debut!);
        var two = format.parse(seances[i].heure_fin!);
      // int couleur = seances[i].id_cour!;

        print("duration ${two.difference(one)}");
        var duration = two.difference(one);

        print("duration im min ${duration.inMinutes}");

        planning.add(TimePlannerTask(
         // color: colors[Random().nextInt(colors.length)],
          color: seances[i].colorfinal,
          //color: Color.fromRGBO(seances[i].colorfinal as int , (seances[i].colorfinal as int) * 20, (seances[i].colorfinal as int)  * 100, 0.8),


          dateTime: TimePlannerDateTime(day: seances[i].jour!-1, hour: int.parse(times[0]), minutes: int.parse(times[1])),

          minutesDuration: duration.inMinutes,

          daysDuration: 1,



          onTap: () {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Cour: ${seances[i].cour!} - Jour: ${seances[i].day_name!}'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Coach: ${seances[i].coach!}'),
                        Text('Heure debut: ${seances[i].heure_debut!}'),
                        Text('Heure fin: ${seances[i].heure_fin!}'),
                        Text('Salle: ${seances[i].salle!}'),
                        Text('Capacite: ${seances[i].capacity!}'),
                        Text('Duree: ${duration.inMinutes} min'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Fermer', style: TextStyle(color: Colors.grey)),
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
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Cour: ${seances[i].cour!}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                duration.inMinutes > 30 ? Text(
                  'Coach: ${seances[i].coach!}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ):SizedBox(width: 0,),

              ],
            ),
          ),
        ));
      }
      
    } else {
      throw Exception('Failed to load data');
    }
  }

  void initTime(){

    for(var h=7; h<=21; h++){
      if(h != 21){
        for(var m=0; m<=45 ; m=m+15){
          String time = "${h <10 ? '0${h}' : h}:${m == 0 ? '00' : m}";
          print(time);
          //times.add(BsSelectBoxOption(value: time, text: Text(time)));
          timesString.add(time);
        }
      }else{
        print("21:00");
        //times.add(BsSelectBoxOption(value: "21:00", text: Text("21:00")));
        timesString.add("21:00");
      }
    }
    //_selectTimeStart.options = times;
    //_selectTimeEnd.options = times;
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
 var token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    getSeances();

    getCour();
    getSalle();
    getCoach();

    initTime();
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

  void add(context) async {

    if(

    _selectTimeStart.getSelected()?.getValue() != null
        && _selectTimeEnd.getSelected()?.getValue() != null
        && capacity_controller.text.isNotEmpty
        && _selectCours.getSelected()?.getValue() != null
        && _selectSalles.getSelected()?.getValue() != null
        && _selectCoach.getSelected()?.getValue() != null
        && _selectJour.getSelected()?.getValue() != null
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
        "id_cour": _selectCours.getSelected()?.getValue(),
        "id_salle": _selectSalles.getSelected()?.getValue(),
        "jour": _selectJour.getSelected()?.getValue(),
        "capacity": capacity_controller.text,
        "id_coach" : _selectCoach.getSelected()?.getValue(),
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

  // void modal_add(context){
  //
  //   showDialog(context: context, builder: (context) =>
  //       BsModal(
  //           context: context,
  //
  //           dialog: BsModalDialog(
  //             size: BsModalSize.lg,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             child: BsModalContent(
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //               ),
  //               children: [
  //                 BsModalContainer(
  //                   //title:
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   actions: [
  //                     Text('Ajouter une Seance',
  //                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //                     BsButton(
  //                       style: BsButtonStyle.outlinePrimary,
  //                       label: Text('Annuler'),
  //                       //prefixIcon: Icons.close,
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                         initData();
  //                       },
  //                     )
  //                   ],
  //                   //closeButton: true,
  //
  //                 ),
  //                 BsModalContainer(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Expanded(
  //                               flex: 1,
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   LabelText(
  //                                       title: 'Nom du cour *'
  //                                   ),
  //                                   BsSelectBox(
  //                                     hintText: 'Cour',
  //                                     controller: _selectCours,
  //                                   ),
  //                                 ],
  //                               )
  //                           ),
  //                           SizedBox(
  //                             width: 15,
  //                           ),
  //                           Expanded(
  //                               flex: 1,
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   LabelText(
  //                                       title: 'nom du Salle *'
  //                                   ),
  //                                   BsSelectBox(
  //                                     hintText: 'Salle',
  //                                     controller: _selectSalles,
  //                                     onChange: (value) {
  //                                       if(_selectSalles.getSelected()?.getValue() != null){
  //                                         print("selected salle ${_selectSalles.getSelected()?.getValue()}");
  //                                         Salle s = Salles.where((element) =>
  //                                         element.id_salle == _selectSalles.getSelected()?.getValue()).first;
  //                                         print(s.capacity.toString());
  //                                         setState(() {
  //                                           capacity_controller.text = s!.capacity!.toString();
  //                                         });
  //                                         if(_selectJour.getSelected()?.getValue() != null){
  //                                          _selectJour.removeSelected(_selectJour.getSelected()!);
  //                                         }
  //
  //                                         Navigator.pop(context);
  //                                         modal_add(context);
  //                                       }
  //
  //                                     },
  //                                   ),
  //                                 ],
  //                               )
  //                           )
  //                         ],
  //                       ),
  //
  //                       SizedBox(
  //                         height: 25,
  //                       ),
  //
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Expanded(
  //                               flex: 1,
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   LabelText(
  //                                       title: 'Coach *'
  //                                   ),
  //                                   BsSelectBox(
  //                                     hintText: 'Coach',
  //                                     controller: _selectCoach,
  //                                   ),
  //                                 ],
  //                               )
  //                           ),
  //                           SizedBox(
  //                             width: 15,
  //                           ),
  //                           Expanded(
  //                               flex: 1,
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   LabelText(
  //                                       title: 'Jour *'
  //                                   ),
  //                                   BsSelectBox(
  //                                     hintText: 'Jour',
  //                                     controller: _selectJour,
  //                                     onChange: (val) {
  //                                       if(_selectSalles.getSelected()?.getValue() != null){
  //                                         var salle = Salles.where((s)=> s.id_salle == _selectSalles.getSelected()?.getValue()).first;
  //                                         timeFree(salle, _selectJour.getSelected()?.getValue());
  //                                       }else{
  //                                         showAlertDialog(context, "selection une salle");
  //                                       }
  //                                     },
  //                                   ),
  //                                 ],
  //                               )
  //                           )
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 25,
  //                       ),
  //                       Row(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         children: [
  //                           Expanded(
  //                               flex: 1,
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: [
  //                                   LabelText(
  //                                       title: 'Heur debut *'
  //                                   ),
  //                                   BsSelectBox(
  //                                     hintText: 'Heur debut *',
  //                                     controller: _selectTimeStart,
  //                                     autoClose: true,
  //                                     onChange: (v) {
  //                                       print(timesString);
  //                                       String timeStart = _selectTimeStart.getSelected()?.getValue();
  //                                       int indexStart = timesString.indexOf(timeStart)+1;
  //                                       int indexEnd = indexStart;
  //                                       if(indexStart >= (timesString.length-8)){
  //                                         int difs = timesString.length - indexStart; // 60 - 60 = 0 or 60 - 57 = 3
  //                                         indexEnd = indexStart+difs;
  //                                       }else{
  //                                         indexEnd = indexStart+8;
  //                                       }
  //
  //                                       _selectTimeEnd.clear();
  //                                       Iterable<String> selectedTimes = timesString.getRange(indexStart, indexEnd);
  //
  //                                       _selectTimeEnd.options = selectedTimes.map<BsSelectBoxOption>((time) =>
  //                                           BsSelectBoxOption(
  //                                               value: time,
  //                                               text: Text("${time}"))).toList();
  //                                       Navigator.pop(context);
  //                                       modal_add(context);
  //                                     },
  //                                   )
  //
  //                                 ],
  //                               )
  //                           ),
  //                           SizedBox(width: 15,),
  //                           Expanded(
  //
  //                               flex: 1,
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: [
  //                                   LabelText(
  //                                       title: 'Heur fin *'
  //                                   ),
  //                                   BsSelectBox(
  //                                       hintText: 'Heur fin *',
  //                                       controller: _selectTimeEnd
  //                                   )
  //
  //                                 ],
  //                               )
  //                           )
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 25,
  //                       ),
  //                       LabelText(
  //                           title: 'Capacity'
  //                       ),
  //                       Container(
  //                           width: 300,
  //                           decoration: BoxDecoration(boxShadow: [
  //
  //                           ]),
  //                           child: TextField(
  //                             controller: capacity_controller,
  //                             readOnly: true,
  //                             decoration: new InputDecoration(
  //                                 hintText: 'capacity',
  //                                 hintStyle: TextStyle(fontSize: 14)
  //                             ),
  //                           )
  //                       ),
  //                       SizedBox(height: 25,),
  //
  //                       SizedBox( height: 10),
  //                       InkWell(
  //                         onTap: (){
  //                           add(context);
  //                         },
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Container(
  //                               child:
  //                               Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 13),)),
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
  //                             SizedBox(height: 6,),
  //                             LabelText(
  //                                 title: 'Nb: * designe un champ obligatoire'
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )));
  // }
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
                                        title: 'Coach *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Coach',
                                      controller: _selectCoach,
                                      searchable: true,
                                      serverSide:searchCoach,
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
                                    // Container(
                                    //   height: 45,
                                    //   decoration: BoxDecoration(
                                    //     border: Border.all(color: Color(0xFFCFD8DC)),
                                    //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    //   ),
                                    //   child: Center(
                                    //     child: Padding(
                                    //       padding: EdgeInsets.symmetric(horizontal: 10),
                                    //       child: DropdownButtonFormField<String>(
                                    //         value: selectedTime,
                                    //         decoration: InputDecoration(
                                    //           hintText: "Heur debut *",
                                    //           border: InputBorder.none,
                                    //
                                    //           //prefixIconColor: Color(0xFFCFD8DC),
                                    //
                                    //           //prefixIcon: Icon(Icons.timelapse, size: 15)
                                    //         ),
                                    //         items: _selectTimeStart2,
                                    //         onChanged: (String? timesValue) {
                                    //           print(timesString);
                                    //           String timeStart = timesValue!;
                                    //           int indexStart = timesString.indexOf(timeStart)+1;
                                    //           int indexEnd = indexStart;
                                    //           if(indexStart >= (timesString.length-8)){
                                    //             int difs = timesString.length - indexStart; // 60 - 60 = 0 or 60 - 57 = 3
                                    //             indexEnd = indexStart+difs;
                                    //           }else{
                                    //             indexEnd = indexStart+8;
                                    //           }
                                    //
                                    //           _selectTimeEnd.clear();
                                    //           Iterable<String> selectedTimes = timesString.getRange(indexStart, indexEnd);
                                    //
                                    //           _selectTimeEnd.options = selectedTimes.map<BsSelectBoxOption>((time) =>
                                    //               BsSelectBoxOption(
                                    //                   value: time,
                                    //                   text: Text("${time}"))).toList();
                                    //           setState(() {
                                    //             selectedTime = timesValue;
                                    //           });
                                    //           Navigator.pop(context);
                                    //           modal_add(context);
                                    //         },
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
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
                                    // LabelText(
                                    //     title: 'Heur debut *'
                                    // ),
                                    // BsSelectBox(
                                    //   hintText: 'Heur debut *',
                                    //     controller: _selectTimeStart,
                                    //   autoClose: true,
                                    //   onChange: (v) {
                                    //     print(timesString);
                                    //     String timeStart = _selectTimeStart.getSelected()?.getValue();
                                    //     int indexStart = timesString.indexOf(timeStart)+1;
                                    //     int indexEnd = indexStart;
                                    //     if(indexStart >= (timesString.length-8)){
                                    //       int difs = timesString.length - indexStart; // 60 - 60 = 0 or 60 - 57 = 3
                                    //       indexEnd = indexStart+difs;
                                    //     }else{
                                    //       indexEnd = indexStart+8;
                                    //     }
                                    //
                                    //     _selectTimeEnd.clear();
                                    //     Iterable<String> selectedTimes = timesString.getRange(indexStart, indexEnd);
                                    //
                                    //     _selectTimeEnd.options = selectedTimes.map<BsSelectBoxOption>((time) =>
                                    //         BsSelectBoxOption(
                                    //             value: time,
                                    //             text: Text("${time}"))).toList();
                                    //     Navigator.pop(context);
                                    //     modal_add(context);
                                    //   },
                                    // )
                                    /*TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        labelText: 'Heur debut',
                                      ),
                                      readOnly: true,
                                     controller: heure_debut_controller,
                                      onTap: () async {
                                         var pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        if (pickedTime != null) {
                                          String formattedTime = pickedTime.format(context);

                                          setState(() {
                                            heure_debut_controller.text =
                                                formattedTime.toString();
                                          });
                                          print(formattedTime);
                                        } else {
                                          print('Not selected');
                                        }
                                      },
                                    ),*/
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
                                    //       initialTime: TimeOfDay.now(),
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

  void initData(){

    capacity_controller.text = "";
    _selectJour.removeSelected(_selectJour.getSelected()!);
    _selectCoach.removeSelected(_selectCoach.getSelected()!);
    _selectCours.removeSelected(_selectCours.getSelected()!);
    _selectSalles.removeSelected(_selectSalles.getSelected()!);
    _selectTimeEnd.clear();
    _selectTimeStart.removeSelected(_selectTimeStart.getSelected()!);


    getSeances();

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

  void getCoach({int? coach_id}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/coach/'),
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
        coaches = result.map<Coach>((e) => Coach.fromJson(e)).toList();
      });
      _selectCoach.options = coaches.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_coach,
              text: Text("${c.nom_coach}")
          )).toList();
      print("couid ${coach_id}");
      if(coach_id != null) {
        Coach cou = coaches.where((element) =>
        element.id_coach == coach_id).first;
        _selectCoach.setSelected(
            BsSelectBoxOption(
                value: cou.id_coach,
                text: Text("${cou.nom_coach}")
            )
        );
      }

      print("--data--");
      print(coaches.length);
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
        } );

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

  @override
  Widget build(BuildContext context) {

    DateTime day0 =  DateTime.now();
    var day1 = day0.add(Duration(days: 1));
    var day2 = day0.add(Duration(days: 2));
    var day3 = day0.add(Duration(days: 3));
    var day4 = day0.add(Duration(days: 4));
    var day5 = day0.add(Duration(days: 5));
    var day6 = day0.add(Duration(days: 6));

    print(day0.weekday);
    print(day1.weekday);
    print(day2.weekday);
    print(day3.weekday);
    print(day4.weekday);
    print(day5.weekday);
    print(day6.weekday);

    return MaterialApp(

      home: Scaffold(
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
        body: TimePlanner(

          style: TimePlannerStyle(

            // default value for height is 80
            cellHeight: 90,
            // default value for width is 90
            cellWidth: 170,
            dividerColor: Colors.white,
            showScrollBar: true,
            horizontalTaskPadding: 5,
            borderRadius: const BorderRadius.all(Radius.circular(8)),

          ),

          // time will be start at this hour on table
          startHour: 7,
          // time will be end at this hour on table
          endHour: 21,

          currentTimeAnimation: false,

          // each header is a column and a day
          headers: [
            TimePlannerTitle(
              title: "Lundi",
            ),
            TimePlannerTitle(
              title: "Mardi",
            ),
            TimePlannerTitle(
              title: "Mercredi",
            ),
            TimePlannerTitle(
              title: "Jeudi",
            ),
            TimePlannerTitle(
              title: "Vendredi",
            ),
            TimePlannerTitle(
              title: "Samedi",
            ),
            TimePlannerTitle(
              title: "Dimanche",
            ),
          ],
          // List of task will be show on the time planner
          tasks: planning,
        ),
      ),
    );
  }
}
