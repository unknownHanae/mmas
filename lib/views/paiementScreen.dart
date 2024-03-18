import 'dart:html';
import 'dart:math';

import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/ContratModels.dart';
import 'package:adminmmas/models/EtablissementModels.dart';
import 'package:adminmmas/views/CustomerContratScreen.dart';
import 'package:adminmmas/views/TransationScreen.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import '../componnents/dejaimprimer.dart';
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/imprmButton.dart';
import '../componnents/label.dart';
import '../componnents/showButton.dart';
import '../models/AbonnementModels.dart';
import '../models/Admin.dart';
import '../models/ClientModels.dart';
import '../models/CoursModels.dart';
import '../models/PeriodeModel.dart';
import '../models/SalaireModel.dart';
import '../models/SalleModels.dart';
import '../models/SeanceModels.dart';
import '../models/Staff.dart';
import '../models/contratStaffModel.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';

import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


import 'dart:html' as html;


import 'package:confirm_dialog/confirm_dialog.dart';

import 'contratstaffScreen.dart';

class PaiementScreen extends StatefulWidget {
  PaiementScreen({Key? key, Staff? this.staff}) : super(key: key);


  Staff? staff;

  @override
  State<PaiementScreen> createState() => _PaiementScreenState();
}

class _PaiementScreenState extends State<PaiementScreen> {

  List<Salaire> data = [];
  List<Salaire> init_data = [];
  bool loading = false;
  ContratStaff? contratstaff;
  String text_search = "";
  List<periode_salaire> periodes = [];
  List<ContratStaff> contratss = [];
  List<Etablissement> Etablissements = [];
  List<Staff> Staffs = [];

  var _enableDateStart = true;

  double salaire_paye = 0;

  List<Map<String, dynamic>> customers_data = [];


  BsSelectBoxController _selectEtablissement = BsSelectBoxController();
  BsSelectBoxController _selectClients = BsSelectBoxController();
  BsSelectBoxController _selectContract = BsSelectBoxController();
  TextEditingController salaire_controller = TextEditingController();
  TextEditingController prime_controller = TextEditingController();
  TextEditingController salairetrans_controller = TextEditingController();
  TextEditingController periode_controller = TextEditingController();

  // BsSelectBoxController _selectPeriode = BsSelectBoxController(
  //     options: [
  //       BsSelectBoxOption(value: "janvier", text: Text("janvier")),
  //       BsSelectBoxOption(value: "février", text: Text("février")),
  //       BsSelectBoxOption(value: "mars", text: Text("mars")),
  //       BsSelectBoxOption(value: "avril", text: Text("avril")),
  //       BsSelectBoxOption(value: "mai", text: Text("mai")),
  //       BsSelectBoxOption(value: "juin", text: Text("juin")),
  //       BsSelectBoxOption(value: "juillet", text: Text("juillet")),
  //       BsSelectBoxOption(value: "août", text: Text("août")),
  //       BsSelectBoxOption(value: "septembre", text: Text("septembre")),
  //       BsSelectBoxOption(value: "octobre", text: Text("octobre")),
  //       BsSelectBoxOption(value: "novembre", text: Text("novembre")),
  //       BsSelectBoxOption(value: "décembre", text: Text("décembre")),
  //     ]
  // );

  BsSelectBoxController _selectPeriodes = BsSelectBoxController();

  void fetchSalaire() async {
    // setState(() {
    //   loading = true;
    // });
    // print("loading ...");
    final response = await http.get(Uri.parse(
        HOST+'/api/salaire/'),
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
        data = result.map<Salaire>((e) => Salaire.fromJson(e)).toList();
        init_data = result.map<Salaire>((e) => Salaire.fromJson(e)).toList();
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

  void initSelectPeriodes() {
    _selectPeriodes.options = periodes.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
          value: v.id_periode,
          text: Text("${v.PeriodeSalaire}"),
        )).toList();
    periode_salaire periode = periodes.where((el) => el.PeriodeSalaire == "").first;
    _selectPeriodes.setSelected(BsSelectBoxOption(
      value: periode.id_periode,
      text: Text("${periode.PeriodeSalaire}"),
    ));
  }

  void search(String key){
    if(key.length >= 1){
      final List<Salaire> founded = [];
      init_data.forEach((e) {
        if(e.nom_periode!.toLowerCase().contains(key.toLowerCase())
            || e.staff!.toLowerCase().contains(key.toLowerCase())

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

  void getPeriodes() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/periode/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      print("--result--");
      print(result.length);
      result.insert(0, {"id_periode" : 0,"PeriodeSalaire": "Tout"});
      setState(() {
        periodes = result.map<periode_salaire>((e) => periode_salaire.fromJson(e)).toList();
      });
      print("--data--");
      print(data.length);
      initSelectPeriodes();
    } else {
      throw Exception('Failed to load periodes');
    }
  }

  int _index = 0;

  Future<BsSelectBoxResponse> searchcontrats(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in contratss){
      var name = "${v.employe} ";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_employe,
                text: Text("${v.employe}")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }

  Future<BsSelectBoxResponse> searchPeriode(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in periodes){
      if(v.PeriodeSalaire!.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_periode,
                text: Text("${v.PeriodeSalaire}")
            )
        );
      }
    }
    return BsSelectBoxResponse(options: searched);
  }

  Future<BsSelectBoxResponse> searchClient(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in Staffs){
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
  var token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state");

    fetchSalaire();
    getEtablissement();
    getContrat();
    getClient(init: true);
    getPeriodes();


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
      title: Text("Salaire"),
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
  void getContratById(int id_contrat) async{
    final response = await http.get(Uri.parse(
        HOST+'/api/contratstaff/${id_contrat}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      contratstaff = ContratStaff.fromJson(body["data"]);

      salaire_controller.text = contratstaff!.salaire!.toString();

    } else {
      throw Exception('Failed to load data');
    }
  }

  void getContractsForStaff(int employe_id, context) {
    List<BsSelectBoxOption> options = [];
    var staff = Staffs.where((el) => el.id_employe == employe_id).first;
    contratss.forEach((c) {
      if(c.id_employe == employe_id){
        options.add(BsSelectBoxOption(
            value: c.id_contratStaff,
            text: Text(" ${c.employe}-${c.type_contrat}")
        ));
      }
    });
    if(options.length == 0){
      showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Paiement'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("ce staff n'a pas de contrat"),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Créer une contrat", style: TextStyle(color: Colors.orange)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ContratstaffScreen(staff: staff),
                        ));
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
          });

    }else{
      print("nb contrat ${options.length}");
      Navigator.pop(context);
      modal_add2(context);
    }

    _selectContract.options = options;
  }
  void getEtablissement({int? etab_id}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/etablissements/'),
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
        Etablissements = result.map<Etablissement>((e) => Etablissement.fromJson(e)).toList();
      });
      _selectEtablissement.options = Etablissements.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_etablissement,
              text: Text("${c.nom_etablissement}")
          )).toList();
      _selectEtablissement.setSelected(BsSelectBoxOption(
          value: Etablissements[0].id_etablissement,
          text: Text("${Etablissements[0].nom_etablissement}")
      ));
      print("etab id ${etab_id}");
      if(etab_id != null) {
        Etablissement etab = Etablissements.where((element) =>
        element.id_etablissement == etab_id).first;
        _selectEtablissement.setSelected(
            BsSelectBoxOption(
                value: etab.id_etablissement,
                text: Text("${etab.nom_etablissement}")
            )
        );
      }

      print("--data--");
      print(Etablissements.length);
    } else {
      throw Exception('Failed to load data');
    }
  }
  void getContrat({int? abon_id}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/contratstaff/'),
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
        contratss = result.map<ContratStaff>((e) => ContratStaff.fromJson(e)).toList();
      });
      _selectContract.options = contratss.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_contratStaff,
              text: Text("${c.employe} ")
          )).toList();


      print("--data--");
      print(Etablissements.length);
    } else {
      throw Exception('Failed to load data');
    }
  }
  void getClient({bool? init=false}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/staff/'),
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
        Staffs = result.map<Staff>((e) => Staff.fromJson(e)).toList();
      });
      _selectClients.options = Staffs.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_employe,
              text: Text("${c.nom} ${c.prenom}")
          )).toList();

      print("--data--");
      print(Staffs.length);

      if(init!){
        if(widget.staff != null){
          print("client => ${widget.staff!.toJson()}");

          Staff c = Staffs.where((el) => el.id_employe == widget.staff!.id_employe).first;

          _selectClients.setSelected(
              BsSelectBoxOption(
                  value: c.id_employe,
                  text: Text("${c.nom} ${c.prenom}")
              )
          );

          modal_add2(context);
        }
      }

    } else {
      throw Exception('Failed to load data');
    }
  }

  void initData(){
    salaire_controller.text = "";
    salairetrans_controller.text = "";
    prime_controller.text = "";
    periode_controller.text = "";


    setState(() {
      _index = 0;
    });

    _selectPeriodes.clear();
    _selectClients.clear();
    //_selectEtablissement.clear();
    _selectContract.clear();



    if(_selectContract.getSelected() != null){
      _selectContract.removeSelected(_selectContract.getSelected()!);
    }
    if(_selectPeriodes.getSelected()!= null){
      _selectPeriodes.removeSelected(_selectPeriodes.getSelected()!);
    }

    if(_selectClients.getSelected()!= null){
      _selectClients.removeSelected(_selectClients.getSelected()!);
    }


    getClient();
    getContrat();
    //getEtablissement();
    fetchSalaire();
    initSelectPeriodes();
  }


  Admin? admin;

  void add(context) async {
    if(salaire_controller.text.isNotEmpty
        // && prime_controller.text.isNotEmpty
        && _selectClients.getSelected()?.getValue() != null
        && _selectPeriodes.getSelected()?.getValue() != null
        && _selectContract.getSelected()?.getValue() != null
    ){
      //ContratStaff ctr = _selectContract.getSelected()?.getValue();
      var rev = <String, dynamic>{
        "id_contrat": _selectContract.getSelected()?.getValue(),
        "periode": _selectPeriodes.getSelected()!.getValue(),
        "salaire_base" : salaire_controller.text,
        "id_admin": admin!.id,
        "prime": prime_controller.text.isNotEmpty ? prime_controller.text : 0,
        "salaire_final" : salairetrans_controller.text,
      };

      print(rev);
      final response = await http.post(Uri.parse(
          HOST+"/api/salaire/"),
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
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            content: const Text('Ajouté avec succès'),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          initData();

        }else{
          Map<String, dynamic> errors = body["errors"];
          if(errors.containsKey("non_field_errors")){
            showAlertDialog(context, "Vous ne pouvez pas ajouter la même période avec ce contrat");
          }else{
            showAlertDialog(context, body["msg"]);
          }

        }
      } else {
        showAlertDialog(context, "Erreur ajout Contrat $response");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }
  }


  bool showAlert = false;
  List<Widget> items = [];

  void modal_add2(context, {bool init=false}){
    final now = DateTime.now();
    var etab = Etablissements.where((element) => element.id_etablissement == _selectEtablissement.getSelected()?.getValue()).first;

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
                      Text('Ajouter un paiement',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("${etab.nom_etablissement}"),
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
                      child:
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(height: 440.0),
                        child: Stepper(
                          currentStep: _index,
                          type: StepperType.horizontal,
                          controlsBuilder: (context, ControlsDetails details) {
                            return Padding(
                              padding:  EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top:40.0),
                                    child: TextButton(
                                      onPressed: details.onStepCancel,
                                      child:Text('Précédant',
                                          style: TextStyle(color:Colors.blue,fontSize:15,fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:40.0),
                                    child: TextButton(
                                      onPressed: details.onStepContinue,
                                      child: _index < 2 ?
                                      Text('Suivant', style: TextStyle(color:Colors.blue,fontSize:15,fontWeight: FontWeight.bold))
                                          : Text('Enregistrer', style: TextStyle(color:Colors.blue,fontSize:15,fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onStepCancel: () {
                            if (_index > 0) {
                              setState(() {
                                _index -= 1;
                              });
                              Navigator.pop(context);
                              modal_add2(context);
                            }
                          },
                          onStepContinue: () {
                            print(_index);
                            if(_index == 0){
                              if(_selectClients.getSelected()?.getValue() != null

                              ){
                                setState(() {
                                  _index += 1;
                                });
                                Navigator.pop(context);
                                modal_add2(context);
                              }else{
                                showAlertDialog(context, "Selectionez un staff et un contrat");
                              }

                            }else{
                              if(_index == 1){
                                print("step 2");
                                if(
                                 salairetrans_controller.text.isNotEmpty

                                ){
                                  items.clear();
                                  Staff staff = Staffs.where((c) => c.id_employe == _selectClients.getSelected()?.getValue()).first;
                                  ContratStaff ctr = contratss.where((a) => a.id_contratStaff == _selectContract.getSelected()?.getValue()).first;
                                  periode_salaire ps = periodes.where((element) => element.id_periode == _selectPeriodes.getSelected()!.getValue()).first;
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Salarie: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${staff.nom}  ${staff.prenom} ")
                                        ],
                                      )
                                  );

                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("prime ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${prime_controller.text.isNotEmpty ? prime_controller.text : 0} Dhs")
                                        ],
                                      )
                                  );

                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Salaire de Base", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${ctr.salaire}")
                                        ],
                                      )
                                  );
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("periode ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${ps?.PeriodeSalaire}")
                                        ],
                                      )
                                  );
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Le salaire final ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${salairetrans_controller.text}Dhs")
                                        ],
                                      )
                                  );
                                  setState(() {
                                    _index += 1;
                                  });

                                  Navigator.pop(context);
                                  modal_add2(context);
                                }else{
                                  print("alert step 2");
                                  showAlertDialog(context, "Remplir tout les champs");
                                }

                              }else{
                                if(_index == 2){
                                  print("save step");
                                  add(context);
                                }
                              }
                            }
                          },

                          steps: <Step>[
                            Step(
                              title: Text('Informations de contrat', style: TextStyle(color: _index == 0 ? Colors.blue : Colors.grey),),
                              content:  Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              LabelText(
                                                  title: 'Salarie *'
                                              ),
                                              BsSelectBox(
                                                hintText: 'Salaries',
                                                controller: _selectClients,
                                                searchable: true,
                                                serverSide: searchClient,
                                                onChange: (v) {
                                                  int id_employee = _selectClients.getSelected()?.getValue();
                                                  try{
                                                    contratstaff = null ;
                                                    _selectContract.clear();

                                                  }catch(e){
                                                    print(e);
                                                  }

                                                  getContractsForStaff(id_employee, context);

                                                },
                                              ),
                                            ],
                                          )
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              LabelText(
                                                  title: "Contrat *"
                                              ),
                                              BsSelectBox(
                                                hintText: 'Contrat',
                                                controller: _selectContract,
                                                searchable: true,
                                                onChange: (valeur){
                                                  print(_selectContract.getSelected()?.getValue());
                                                  int id_selected_ctr = _selectContract.getSelected()?.getValue();
                                                  ContratStaff crtStaff = contratss.where((cr) => cr.id_contratStaff == id_selected_ctr).first;
                                                  if(crtStaff != null){
                                                    salaire_controller.text = "${crtStaff.salaire}";
                                                    salairetrans_controller.text = "${crtStaff.salaire}";
                                                  }
                                                  /*int id = ctr.id_contratStaff ?? 0 ;
                                                  getContratById(id);*/

                                                },
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
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
                                                  title: "salaire "
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(boxShadow: [
                                                        ]),
                                                        child: TextField(
                                                          controller: salaire_controller,
                                                          decoration: new InputDecoration(
                                                              hintText: "Salaire",
                                                              hintStyle: TextStyle(fontSize: 14)
                                                          ),
                                                          onChanged: (v) {
                                                            if(v.isNotEmpty){
                                                              setState(() {
                                                                salaire_paye = double.parse(v);
                                                              });
                                                              salairetrans_controller.text = "${salaire_paye}";
                                                            }else{
                                                              setState(() {
                                                                salaire_paye = 0;
                                                              });
                                                              salairetrans_controller.text = "${salaire_paye}";
                                                            }

                                                          },
                                                        )
                                                    ),
                                                  ),
                                                  Text("Dhs")
                                                ],
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
                                                  title: "prime"
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(boxShadow: [
                                                        ]),
                                                        child: TextField(
                                                          controller: prime_controller,
                                                          // autofocus: _index == 0 ? true : false,
                                                          decoration: InputDecoration(
                                                              hintText: "prime",
                                                              hintStyle: TextStyle(fontSize: 14)
                                                          ),
                                                          onChanged: (v){
                                                            if(prime_controller.text.isNotEmpty){
                                                              var prime = double.parse(prime_controller.text);
                                                              if(salaire_controller.text.isNotEmpty){
                                                                var salaire = double.parse(salaire_controller.text);
                                                                if(prime >= 0  && prime <= salaire){
                                                                  salaire += prime;
                                                                  salairetrans_controller.text = "${salaire}";
                                                                  setState(() {
                                                                    salaire_paye = salaire;
                                                                  });
                                                                  return null;
                                                                  //Navigator.pop(context);
                                                                  //modal_add2(context);
                                                                }
                                                              }
                                                            }
                                                            setState(() {
                                                              prime_controller.text.isNotEmpty ? prime_controller.text : 0 ;
                                                              salaire_paye = double.parse(salaire_controller.text)+double.parse(prime_controller.text);
                                                            });
                                                            //reste_paye
                                                          },
                                                        )
                                                    ),
                                                  ),
                                                  Text("Dhs")
                                                ],
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
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
                                              LabelText(title: "periode *"),
                                              BsSelectBox(
                                                hintText: 'Periode',
                                                controller: _selectPeriodes,
                                                searchable: true,
                                                serverSide: searchPeriode,
                                              )

                                            ],
                                          )
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            Step(
                              title: Text('Informations de transaction', style: TextStyle(color: _index == 1 ? Colors.blue : Colors.grey),),

                              content: Column(
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
                                                    title: "Salaire final * "
                                                ),
                                                Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(boxShadow: [
                                                    ]),
                                                    child: TextField(
                                                      controller: salairetrans_controller,
                                                      autofocus: _index == 1 ? true : false,
                                                      decoration: InputDecoration(
                                                          hintText: "salaire final",
                                                          hintStyle: TextStyle(fontSize: 14)
                                                      ),
                                                    )
                                                ),
                                                /* Text("la valeur n'est pas correcte",
                                                  style: TextStyle(color: Colors.red)),*/
                                                showAlert ? Text("Le montant saisie n'est pas valide",
                                                    style: TextStyle(color: Colors.red)) : SizedBox(width: 0,)
                                              ],
                                            )
                                        ),

                                      ]
                                  ),
                                ],
                              ),
                            ),
                            Step(

                              title: Text('Vérification', style: TextStyle(color: _index == 2 ? Colors.blue : Colors.grey),),
                              content: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.8,color: Colors.grey),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: items,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            )));
  }


  void print_pdf(int id) async {
    var url = "${HOST}/api/generate_fiche_paie/${id}";

    html.AnchorElement anchorElement =  new html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();


  }

  void filterSalaire(String key) {
    if(key != null){
      if(key == "0"){
        data = init_data;
      }else{
        data = init_data.where((e) => e.periode.toString() == key).toList();
      }

      setState(() {
        data = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    admin = context.watch<AdminProvider>().admin;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200]
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
             // SideBar(postion: 23,msg:"paiement"),
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
                                child: Center(child: Text("Salaires", style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.w700,
                                    color: Colors.black)),),
                              ),
                              SizedBox(height: 30,),
                              screenSize.width < 750 ?
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 180,
                                        child: BsSelectBox(
                                          hintText: 'Filtrer',
                                          controller: _selectPeriodes,
                                          onChange: (v){
                                            print("selected value ${ v.getValueAsString()}");
                                            filterSalaire(v.getValueAsString());
                                          },
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          modal_add2(context, init: true);
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
                              ):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex:4,
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
                                  SizedBox(width: 15,),
                                  Expanded(
                                    flex:3,
                                    child: Container(
                                      width: 180,
                                      child: BsSelectBox(
                                        hintText: 'Filtrer',
                                        controller: _selectPeriodes,
                                        onChange: (v){
                                          print("selected value ${ v.getValueAsString()}");
                                          filterSalaire(v.getValueAsString());
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Expanded(
                                    flex: 2,
                                    child: Container(

                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Expanded(
                                    flex: 3,
                                    child: InkWell(
                                      onTap: (){
                                        modal_add2(context, init: true);
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
                                            child: Text("Paiement",
                                                style: TextStyle(
                                                    fontSize: 15
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )

                                ],
                              )
                              ,
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
                                              child: Text("aucun paiement à afficher")),
                                        )
                                            :
                                        DataTable(
                                            dataRowHeight: DataRowHeight,
                                            headingRowHeight: HeadingRowHeight,
                                            columns: screenSize.width < 900 ?
                                            <DataColumn>[
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Salarie',
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

                                            ] :
                                            <DataColumn>[
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Salarie',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),

                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Type contrat',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    ' Periode',
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

                                            ] ,
                                            rows:
                                            data.map<DataRow>((r) => DataRow(
                                              cells: screenSize.width < 900 ?
                                              <DataCell>[
                                                DataCell(Row(
                                                  children: [

                                                    Expanded(
                                                      child: Text( "${r.staff}",
                                                        overflow: TextOverflow.ellipsis,),
                                                    )
                                                  ],
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
                                                        msg:"•Visualisation Les détails du paiement ",
                                                        onPressed: (){
                                                          showDialog(context: context, builder: (context) =>
                                                              BsModal(
                                                                  context: context,
                                                                  dialog: BsModalDialog(
                                                                    size: BsModalSize.md,
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
                                                                            Text('Paiement',
                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                            BsButton(
                                                                              style: BsButtonStyle.outlinePrimary,
                                                                              label: Text('Fermer'),
                                                                              //prefixIcon: Icons.close,
                                                                              onPressed: () {

                                                                                Navigator.pop(context);


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

                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Nom :" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text( "${r.staff}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Periode:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${r.nom_periode}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Salaire de Base:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.salaire_base} Dhs"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("prime:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${r.prime} dhs"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Salaire final:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${r.salaire_final} Dhs"),
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
                                                    PrintButton(
                                                        msg:"Imprimer Facture",
                                                        onPressed: (){
                                                           print_pdf(r.id_trans!);
                                                        }
                                                    ),
                                                  ],
                                                ))

                                              ]:
                                              <DataCell>[
                                                DataCell(Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("${r.staff}",
                                                        overflow: TextOverflow.ellipsis,),
                                                    )

                                                  ],
                                                )),
                                                DataCell(Text("${r.type}")),
                                                DataCell(Text("${r.nom_periode}")),
                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
                                                        msg:"•Visualisation Les détails du Contrat ",
                                                        onPressed: (){
                                                          showDialog(context: context, builder: (context) =>
                                                              BsModal(
                                                                  context: context,
                                                                  dialog: BsModalDialog(
                                                                    size: BsModalSize.md,
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
                                                                            Text('Paiement: ',
                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                            BsButton(
                                                                              style: BsButtonStyle.outlinePrimary,
                                                                              label: Text('Fermer'),
                                                                              //prefixIcon: Icons.close,
                                                                              onPressed: () {

                                                                                Navigator.pop(context);
                                                                              },
                                                                            )
                                                                          ],
                                                                          //closeButton: true,

                                                                        ),
                                                                        // BsModalContainer(title: Text('Contrat N°: ${r.numcontrat.toString()}',style: TextStyle(
                                                                        //     fontWeight: FontWeight.bold , color: Colors.grey),), closeButton: true),
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

                                                                                        Row(
                                                                                          children: [
                                                                                            Text("Nom salarie:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text(" ${r.staff}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text("Periode:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.nom_periode}"),
                                                                                          ],
                                                                                        ),

                                                                                        SizedBox(height: 4,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text("prime:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text("${r.prime} Dhs"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text("Salaire de Base:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text("${r.salaire_base} Dhs"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text("salaire final:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text("${r.salaire_final
                                                                                            } Dhs"),
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
                                                    PrintButton(
                                                        msg:"Imprimer Facture",
                                                        onPressed: (){
                                                          print_pdf(r.id_trans!);
                                                        }
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

