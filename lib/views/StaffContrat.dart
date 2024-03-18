import 'dart:html';
import 'dart:math';

import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/ContratModels.dart';
import 'package:adminmmas/models/EtablissementModels.dart';
import 'package:adminmmas/views/TransationScreen.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/imprmButton.dart';
import '../componnents/label.dart';
import '../componnents/showButton.dart';
import '../models/AbonnementModels.dart';
import '../models/Admin.dart';
import '../models/ClientModels.dart';
import '../models/CoursModels.dart';
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

class CustomerContratstaffScreen extends StatefulWidget {
  CustomerContratstaffScreen({Key? key, Staff? this.staff, int? this.customer_id}) : super(key: key);


  Staff? staff;

  int? customer_id;

  @override
  State<CustomerContratstaffScreen> createState() => _CustomerContratstaffScreenState();
}

class _CustomerContratstaffScreenState extends State<CustomerContratstaffScreen> {

  List<ContratStaff> data = [];
  List<ContratStaff> init_data = [];
  bool loading = false;

  String text_search = "";

  List<Abonnement> abonnement = [];
  List<Etablissement> Etablissements = [];
  List<Staff> Staffs = [];

  List<Map<String, int>> customers_data = [];

  BsSelectBoxController _selectabonnement = BsSelectBoxController();
  BsSelectBoxController _selectEtablissement = BsSelectBoxController();
  BsSelectBoxController _selectClients = BsSelectBoxController();



  BsSelectBoxController _selectStatus = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 0, text: Text("Impayé")),
        BsSelectBoxOption(value: 1, text: Text("Payé")),
      ]
  );

  BsSelectBoxController _selectFilter = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 2, text: Text("Tous")),
        BsSelectBoxOption(value: 0, text: Text("Payés")),
        BsSelectBoxOption(value: 1, text: Text("Impayés")),
      ]
  );

  TextEditingController date_debut_controller = TextEditingController();
  TextEditingController date_fin_controller = TextEditingController();
  TextEditingController rest_controller = TextEditingController();
  TextEditingController nim_contrat_controller = TextEditingController();
  TextEditingController MontantPaye_controller = TextEditingController();
  TextEditingController tarif_controller = TextEditingController();


  TextEditingController Montant_controller = TextEditingController();
  TextEditingController restOld_controller = TextEditingController();
  TextEditingController restNew_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();

  BsSelectBoxController _selectType = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 0, text: Text("Sortie")),
        BsSelectBoxOption(value: 1, text: Text("Entrée")),
      ]
  );

  BsSelectBoxController _selectMode = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: "Chéques", text: Text("Chéques")),
        BsSelectBoxOption(value: "Espéces", text: Text("Espéces")),
        BsSelectBoxOption(value: "Prélèvements", text: Text("Prélèvements")),
        BsSelectBoxOption(value: "Autres", text: Text("Autres")),
      ]
  );


  void fetchContratStaff(int customer_id) async {
    // setState(() {
    //   loading = true;
    // });
    // print("loading ...");
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
      for(var r in result){
        if(r["id_employe"] == customer_id){
          data.add(ContratStaff.fromJson(r));
          init_data.add(ContratStaff.fromJson(r));
        }
      }
      /*data = result.map<Contrat>((e) => Contrat.fromJson(e)).toList();
      init_data = result.map<Contrat>((e) => Contrat.fromJson(e)).toList();
      setState(() {

      });*/
      print("--data--");
      print(data.length);
    } else {
      throw Exception('Failed to load data');
    }

    setState(() {
      loading = false;
    });
  }

  // void search(String key){
  //   if(key.length >= 1){
  //     final List<Contrat> founded = [];
  //     init_data.forEach((e) {
  //       if(e.id_contrat == key
  //           ||e.client!.toLowerCase().contains(key.toLowerCase())
  //           || e.date_debut!.toLowerCase().contains(key.toLowerCase())
  //           || e.date_fin!.toLowerCase().contains(key.toLowerCase())
  //           || e.abonnement!.toLowerCase().contains(key.toLowerCase())
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

  // void filterContracts(){
  //   if(_selectFilter.getSelected()?.getValue() != null){
  //     print(_selectFilter.getSelected()?.getValue());
  //     setState(() {
  //       data = [];
  //     });
  //     if(_selectFilter.getSelected()?.getValue() == 2){
  //       setState(() {
  //         data = init_data;
  //       });
  //
  //     }
  //     if(_selectFilter.getSelected()?.getValue() == 0){
  //       setState(() {
  //         data = init_data.where((element) => double.parse(element.reste!) == 0).toList();
  //       });
  //
  //     }
  //
  //     if(_selectFilter.getSelected()?.getValue() == 1){
  //       setState(() {
  //         data = init_data.where((element) => double.parse(element.reste!) > 0).toList();
  //       });
  //
  //     }
  //
  //   }
  // }
  int _index = 0;
  Future<BsSelectBoxResponse> searchAbonnement(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in abonnement){
      var name = "${v.type_abonnement}${v.duree_mois} ";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_abn,
                text: Text("${v.type_abonnement}  ${v.duree_mois} mois")
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
    fetchContratStaff(widget.customer_id!);
    getEtablissement();
    getAbonnement();
    getClient(init: true);


  }
  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/contratstaff/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchContratStaff(widget.customer_id!);
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
      title: Text("Contrat"),
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
  void getAbonnement({int? abon_id}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/abonnement/'),
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
        abonnement = result.map<Abonnement>((e) => Abonnement.fromJson(e)).toList();
      });
      _selectabonnement.options = abonnement.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_abn,
              text: Text("${c.type_abonnement} - ${c.duree_mois} mois")
          )).toList();
      print("abon id ${abon_id}");
      // if(abon_id != null) {
      //   Abonnement abon = Abonnement.where((element) =>
      //   element.id_abn == abon_id).first;
      //   _selectabonnement.setSelected(
      //       BsSelectBoxOption(
      //           value: abon.id_abn,
      //           text: Text("${abon.type_abonnement}")
      //       )
      //   );
      // }

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
    rest_controller.text = "";
    nim_contrat_controller.text = "";
    date_debut_controller.text = "";
    date_fin_controller.text = "";

    tarif_controller.text = "";
    MontantPaye_controller.text = "";

    setState(() {
      _index = 0;
    });

    _selectabonnement.clear();
    _selectClients.clear();
    _selectEtablissement.clear();
    _selectStatus.clear();

    Montant_controller.text = "";
    restNew_controller.text = "";


    if(_selectType.getSelected() != null){
      _selectType.removeSelected(_selectType.getSelected()!);
    }
    if(_selectMode.getSelected()!= null){
      _selectMode.removeSelected(_selectMode.getSelected()!);
    }


    getClient();
    getAbonnement();
    //getEtablissement();
    fetchContratStaff(widget.customer_id!);
  }


  Admin? admin;

  void add(context) async {
    if(date_debut_controller.text.isNotEmpty
        && date_fin_controller.text.isNotEmpty
        && _selectabonnement.getSelected()?.getValue() != null
        && _selectClients.getSelected()?.getValue() != null
        && Montant_controller.text.isNotEmpty
        && restNew_controller.text.isNotEmpty
    ){
      var rev = <String, dynamic>{
        "id_employe": _selectClients.getSelected()!.getValue(),
        "date_debut": date_debut_controller.text,
        "date_fin" : date_fin_controller.text,
        //"numcontrat" : nim_contrat_controller.text,
        "id_etablissement": _selectEtablissement.getSelected()!.getValue(),
        "type_contrat": _selectType.getSelected()!.getValue(),
        "salaire" : Montant_controller.text,
        "id_admin": admin!.id
      };

      print(rev);
      final response = await http.post(Uri.parse(
          HOST+"/api/contratstaff/"),
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

          //showAlertDialog(context, "Ajouté avec succès");
          showDialog<void>(
            context: context,
            barrierDismissible: true, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Contrat'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Ajouté avec succès'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Fermer', style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
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
          initData();
          //fetchContrat();
          /* c = Contrat.fromJson(body["contract"]);
          c.montant_paye = MontantPaye_controller.text.isNotEmpty ? MontantPaye_controller.text : "0";
          c.reste = rest_controller.text.isNotEmpty ? rest_controller.text : c.reste ;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionScreen(contrat: c, showCancelBtn: false),
              ));*/
        }else{
          showAlertDialog(context, body["msg"]);
        }
      } else {
        showAlertDialog(context, "Erreur ajout Contrat");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }
  }

  void Update(context, int id) async {

    if(date_debut_controller.text.isNotEmpty
        && date_fin_controller.text.isNotEmpty
        //&& _selectStatus.getSelected()?.getValue() != null
        && MontantPaye_controller.text.isNotEmpty
        && _selectEtablissement.getSelected()?.getValue() != null
        && _selectabonnement.getSelected()?.getValue() != null
        && _selectClients.getSelected()?.getValue() != null
    ){

      var rev = <String, dynamic>{
        "id_contratStaff": id,
        "id_employe": _selectClients.getSelected()!.getValue(),
        "date_debut": date_debut_controller.text,
        "date_fin" : date_fin_controller.text,
        "salaire": MontantPaye_controller.text.isNotEmpty ? MontantPaye_controller.text : 0,
        "id_etablissement": _selectEtablissement.getSelected()!.getValue(),
      };

      print(rev);
      final response = await http.put(Uri.parse(
          HOST+"/api/contratstaff/"),
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
          initData();
          fetchContratStaff(widget.customer_id!);
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context, "Erreur update Contrat");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }

  bool showAlert = false;
  List<Widget> items = [];

  void modal_add2(context, {bool init=false}){
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    var etab = Etablissements.where((element) => element.id_etablissement == _selectEtablissement.getSelected()?.getValue()).first;

    if(init){
      date_debut_controller.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
      _selectType.setSelected(BsSelectBoxOption(value: 1, text: Text("Entrée")));
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
                      Text('Ajouter un Contrat',
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
                        constraints: BoxConstraints.tightFor(height: 380.0),
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
                                  && _selectabonnement.getSelected()?.getValue() != null
                                  && date_debut_controller.text.isNotEmpty
                                  && date_fin_controller.text.isNotEmpty
                              ){
                                setState(() {
                                  _index += 1;
                                });
                                Navigator.pop(context);
                                modal_add2(context);
                              }else{
                                showAlertDialog(context, "Selectionez un client et un abonnement");
                              }

                            }else{
                              if(_index == 1){
                                print("step 2");
                                if(
                                Montant_controller.text.isNotEmpty
                                    && _selectType.getSelected()?.getValue() != null
                                    && _selectMode.getSelected()?.getValue() != null
                                ){
                                  items.clear();
                                  Staff staff = Staffs.where((c) => c.id_employe == _selectClients.getSelected()?.getValue()).first;
                                  Abonnement abn = abonnement.where((a) => a.id_abn == _selectabonnement.getSelected()?.getValue()).first;
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Client: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${staff.nom} ${staff.prenom}")
                                        ],
                                      )
                                  );
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Date Debut: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${DateFormat("dd/MM/yyyy").format(DateTime.parse(date_debut_controller.text))}")
                                        ],
                                      )
                                  );
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Date Fin: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${DateFormat("dd/MM/yyyy").format(DateTime.parse(date_fin_controller.text))}")
                                        ],
                                      )
                                  );
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Salaire: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${Montant_controller.text} Dhs")
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
                          /* onStepTapped: (int index) {
                          setState(() {
                            _index = index;
                          });
                          Navigator.pop(context);
                          modal_add2(context);
                        },*/
                          steps: <Step>[
                            Step(
                              title: Text('Etape 1', style: TextStyle(color: _index == 0 ? Colors.blue : Colors.grey),),
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
                                                  title: 'Staffs *'
                                              ),
                                              BsSelectBox(
                                                hintText: 'Staffs',
                                                controller: _selectClients,
                                                searchable: true,
                                                serverSide: searchClient,

                                              ),
                                            ],
                                          )
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  /* Row(
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
                                                title: "Etablissement *"
                                            ),
                                            BsSelectBox(
                                              hintText: 'Etablissement',
                                              controller: _selectEtablissement,
                                              disabled: true,
                                            ),
                                          ],
                                        )
                                    ),



                                  ],
                                ),*/
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
                                                  title: 'Date debut *'
                                              ),
                                              TextField(
                                                decoration: InputDecoration(
                                                  icon: Icon(Icons.calendar_today),
                                                  labelText: 'Date debut',
                                                ),
                                                readOnly: true,
                                                controller: date_debut_controller,
                                                onTap: () async {
                                                  if(_selectabonnement.getSelected()?.getValue() != null){
                                                    DateTime? pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime(2101),
                                                    );
                                                    if (pickedDate != null) {
                                                      String formattedDate =
                                                      DateFormat("yyyy-MM-dd").format(pickedDate);
                                                      date_debut_controller.text =
                                                          formattedDate.toString();
                                                      var abn_id = _selectabonnement.getSelected()?.getValue();
                                                      Abonnement abn = abonnement.where((element) => element.id_abn == abn_id).first;
                                                      DateTime d = DateTime.parse(formattedDate);
                                                      DateTime date_fin = Jiffy(d).add(months: abn.duree_mois!).dateTime;
                                                      //DateTime date_fin = Jiffy.parse(formattedDate).add(months: abn.duree_mois!).dateTime;
                                                      String formattedDateFin =
                                                      DateFormat("yyyy-MM-dd").format(date_fin);
                                                      print(formattedDate);
                                                      print(formattedDateFin);
                                                      date_fin_controller.text = formattedDateFin;

                                                    } else {
                                                      print('Not selected');
                                                    }
                                                  }else{
                                                    showAlertDialog(context, "Selection un abonnement!");
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
                                                  title: 'Date fin *'
                                              ),
                                              TextField(
                                                decoration: InputDecoration(
                                                  icon: Icon(Icons.calendar_today),
                                                  labelText: 'Date fin',
                                                ),
                                                readOnly: true,
                                                controller: date_fin_controller,

                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            // Step(
                            //   title: Text('Etape 2', style: TextStyle(color: _index == 1 ? Colors.blue : Colors.grey),),
                            //
                            //   content: Column(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Row(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Expanded(
                            //                 flex: 1,
                            //                 child: Column(
                            //                   mainAxisAlignment: MainAxisAlignment.start,
                            //                   crossAxisAlignment: CrossAxisAlignment.start,
                            //                   children: [
                            //                     LabelText(
                            //                         title: "Montant * "
                            //                     ),
                            //                     Container(
                            //                         width: double.infinity,
                            //                         decoration: BoxDecoration(boxShadow: [
                            //                         ]),
                            //                         child: TextField(
                            //                           controller: Montant_controller,
                            //                           autofocus: true,
                            //                           decoration: InputDecoration(
                            //                               hintText: "Montant",
                            //                               hintStyle: TextStyle(fontSize: 14)
                            //                           ),
                            //                           onChanged: (value){
                            //                             String s_montant = "0.0";
                            //                             String s_tarif = "0.0";
                            //
                            //                             if(Montant_controller.text.contains(".")){
                            //                               s_montant = Montant_controller.text;
                            //                             }else {
                            //                               s_montant = "${Montant_controller.text}.0";
                            //                             }
                            //
                            //                             if(tarif_controller.text.contains(".")){
                            //                               s_tarif = tarif_controller.text;
                            //                             }else {
                            //                               s_tarif = "${tarif_controller.text}.0";
                            //                             }
                            //
                            //                             try{
                            //                               double montant = double.parse(s_montant);
                            //                               double tarif = double.parse(s_tarif) ;
                            //                               if(montant>0 && montant<=tarif){
                            //                                 double reslt = tarif - montant ;
                            //                                 restNew_controller.text = reslt.toString();
                            //                                 if(showAlert){
                            //                                   setState(() {
                            //                                     showAlert = false;
                            //                                   });
                            //                                   Navigator.pop(context);
                            //                                   modal_add2(context);
                            //                                 }
                            //
                            //                               }
                            //                               else{
                            //                                 restNew_controller.text="";
                            //                                 setState(() {
                            //                                   showAlert = true;
                            //                                 });
                            //                                 Navigator.pop(context);
                            //                                 modal_add2(context);
                            //                               }
                            //                             }catch(e){
                            //                               restNew_controller.text="";
                            //                               setState(() {
                            //                                 showAlert = true;
                            //                               });
                            //                               Navigator.pop(context);
                            //                               modal_add2(context);
                            //                             }
                            //                             /* Navigator.pop(context);
                            //                 modal_add(context);*/
                            //
                            //                           },
                            //                         )
                            //                     ),
                            //                     /* Text("la valeur n'est pas correcte",
                            //                       style: TextStyle(color: Colors.red)),*/
                            //                     showAlert ? Text("Le montant saisie est supérieur au prix",
                            //                         style: TextStyle(color: Colors.red)) : SizedBox(width: 0,)
                            //                   ],
                            //                 )
                            //             ),
                            //             SizedBox(width: 15,),
                            //             Expanded(
                            //                 flex: 1,
                            //                 child: Column(
                            //                   mainAxisAlignment: MainAxisAlignment.start,
                            //                   crossAxisAlignment: CrossAxisAlignment.start,
                            //                   children: [
                            //                     LabelText(
                            //                         title: "Le reste actuel "
                            //                     ),
                            //                     Container(
                            //                         width: double.infinity,
                            //                         decoration: BoxDecoration(boxShadow: [
                            //                         ]),
                            //                         child: TextField(
                            //                           controller: restNew_controller,
                            //                           enabled: false,
                            //                           decoration: InputDecoration(
                            //                               hintText: "Le reste actuel",
                            //                               hintStyle: TextStyle(fontSize: 14)
                            //                           ),
                            //                         )
                            //                     ),
                            //                   ],
                            //                 )
                            //             ),
                            //             SizedBox(width: 15,),
                            //             Expanded(
                            //                 flex: 1,
                            //                 child: Column(
                            //                   mainAxisAlignment: MainAxisAlignment.start,
                            //                   crossAxisAlignment: CrossAxisAlignment.start,
                            //                   children: [
                            //                     LabelText(
                            //                         title: "Description "
                            //                     ),
                            //                     Container(
                            //                         width: double.infinity,
                            //                         decoration: BoxDecoration(boxShadow: [
                            //                         ]),
                            //                         child: TextField(
                            //                           controller: description_controller,
                            //                           decoration: InputDecoration(
                            //                               hintText: "Description",
                            //                               hintStyle: TextStyle(fontSize: 14)
                            //                           ),
                            //                         )
                            //                     ),
                            //                   ],
                            //                 )
                            //             )
                            //           ]
                            //       ),
                            //       SizedBox(
                            //         height: 15,
                            //       ),
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Expanded(
                            //               flex: 1,
                            //               child: Column(
                            //                 mainAxisAlignment: MainAxisAlignment.start,
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   LabelText(
                            //                       title: "Mode de Réglement *"
                            //                   ),
                            //                   BsSelectBox(
                            //                     hintText: 'mode de réglement',
                            //                     controller: _selectMode,
                            //                   ),
                            //                 ],
                            //               )
                            //           ),
                            //           SizedBox(
                            //             width: 15,
                            //           ),
                            //           Expanded(
                            //               flex: 1,
                            //               child: Column(
                            //                 mainAxisAlignment: MainAxisAlignment.start,
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   LabelText(
                            //                       title: "Type *"
                            //                   ),
                            //                   SizedBox(
                            //                     width: 15,
                            //                   ),
                            //                   BsSelectBox(
                            //                     hintText: 'Type',
                            //                     controller: _selectType,
                            //                   ),
                            //                 ],
                            //               )
                            //           ),
                            //
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Step(

                              title: Text('Etape 3', style: TextStyle(color: _index == 2 ? Colors.blue : Colors.grey),),
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

  void modal_update(context, Contrat c, {bool? init = false}){

    if(init!){
      rest_controller.text = c.reste.toString();
      MontantPaye_controller.text = c.montant_paye.toString();
      nim_contrat_controller.text = c.numcontrat.toString();

      /*_selectStatus.setSelected(
          BsSelectBoxOption(
              value: c.status_paiement == true ? 1 : 0,
              text:  c.status_paiement == true ? Text("Payée") : Text("Impayé")
          )
      );*/

      Abonnement abon = abonnement.where((element) => element.id_abn == c.id_abn).first;

      tarif_controller.text = abon.tarif!;

      _selectabonnement.setSelected(
          BsSelectBoxOption(
              value: c.id_abn,
              text: Text("${c.abonnement}")
          )
      );

      _selectClients.setSelected(
          BsSelectBoxOption(
              value: c.id_etd,
              text: Text("${c.client}")
          )
      );

      _selectEtablissement.setSelected(
          BsSelectBoxOption(
              value: c.id_etablissement,
              text:  Text("${c.etablissement}")
          )
      );



      date_fin_controller.text = c.date_fin.toString();
      date_debut_controller.text = c.date_debut.toString();




    }

    final initDateStart = DateTime.parse(c.date_debut.toString());
    final initDateEnd = DateTime.parse(c.date_fin.toString());
    final now = DateTime.now();


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
                      Text('Modifier une Contrat',
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
                    title: Text('Modifier une Contrat'),
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
                                        title: 'Clients *'
                                    ),

                                    BsSelectBox(
                                      hintText: 'Clients',
                                      controller: _selectClients,
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
                                        title: "Type d'abonnement *"
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    BsSelectBox(
                                      hintText: 'Abonnement',
                                      controller: _selectabonnement,
                                      onChange: (v){
                                        Abonnement abn = abonnement.where(
                                                (element) =>
                                            element.id_abn == _selectabonnement.getSelected()?.getValue()
                                        ).first;
                                        tarif_controller.text = abn.tarif!;
                                        Navigator.pop(context);
                                        modal_update(context, c, init: false);
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
                                        title: "Trif d'abonnement "
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [

                                        ]),
                                        child: TextField(
                                          enabled: false,
                                          controller: tarif_controller,
                                          decoration: new InputDecoration(
                                              hintText: "Trif d'abonnement",
                                              hintStyle: TextStyle(fontSize: 14)
                                          ),
                                        )
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
                            /*Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: "Etablissement *"
                                    ),
                                    BsSelectBox(
                                      hintText: 'Etablissement',
                                      controller: _selectEtablissement,
                                      disabled: true,
                                    ),
                                  ],
                                )
                            ),*/
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        LabelText(
                                            title: 'Montant payé *'
                                        ),
                                        SizedBox(width: 3,),
                                        Text("(Tape Entrer pour calculer le rest)", style: TextStyle(color: Colors.red,fontSize: 13),)
                                      ],
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          controller: MontantPaye_controller,
                                          decoration: new InputDecoration(
                                              hintText: 'Montant payé',
                                              hintStyle: TextStyle(fontSize: 14)
                                          ),
                                          onSubmitted: (value){
                                            String s_montant = "0.0";
                                            String s_tarif = "0.0";
                                            if(MontantPaye_controller.text.contains(".")){
                                              s_montant = MontantPaye_controller.text;
                                            }else {
                                              s_montant = "${MontantPaye_controller.text}.0";
                                            }

                                            if(tarif_controller.text.contains(".")){
                                              s_tarif = tarif_controller.text;
                                            }else {
                                              s_tarif = "${tarif_controller.text}.0";
                                            }

                                            double montant = double.parse(s_montant);
                                            double reslt = double.parse(s_tarif) - montant ;
                                            rest_controller.text = reslt.toString();
                                            Navigator.pop(context);
                                            modal_update(context, c, init: false);



                                          },
                                        )
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
                                        title: 'Numero Contrat *'
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [

                                        ]),
                                        child: TextField(
                                          controller: nim_contrat_controller,
                                          decoration: new InputDecoration(
                                              hintText: 'Numero Contrat',
                                              hintStyle: TextStyle(fontSize: 14)
                                          ),
                                        )
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
                                        title: 'Le reste *'
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [

                                        ]),
                                        child: TextField(
                                          enabled: false,
                                          controller: rest_controller,
                                          keyboardType: TextInputType.number,
                                          decoration: new InputDecoration(
                                              hintText: 'Le reste',
                                              hintStyle: TextStyle(fontSize: 14)
                                          ),
                                        )
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
                                        title: 'Date debut *'
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        labelText: 'Date debut',
                                      ),
                                      readOnly: true,
                                      controller: date_debut_controller,
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: initDateStart,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          String formattedDate =
                                          DateFormat("yyyy-MM-dd").format(pickedDate);
                                          date_debut_controller.text =
                                              formattedDate.toString();
                                          print(formattedDate);
                                        } else {
                                          print('Not selected');
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
                                        title: 'Date fin *'
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        labelText: 'Date fin',
                                      ),
                                      readOnly: true,
                                      controller: date_fin_controller,
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: initDateEnd,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          String formattedDate =
                                          DateFormat("yyyy-MM-dd").format(pickedDate);
                                          date_fin_controller.text =
                                              formattedDate.toString();
                                          print(formattedDate);
                                        } else {
                                          print('Not selected');
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
                        InkWell(
                          onTap: (){
                            Update(context, c.id_contrat!);
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

  void print_pdf(int id_contrat) async {
    var url = "${HOST}/api/generate_contratstaff/${id_contrat}";
    /*html.window.open(
        HOST+"/api/generate_contrat/"+id_contrat.toString(),
        'Contrat ${id_contrat}'
    );*/
    html.AnchorElement anchorElement =  new html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
    /*final response = await http.get(Uri.parse(
        HOST+"/api/generate_contrat/"+id_client.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {


    } else {
      showAlertDialog(context, "Erreur generate contrat");
    }*/
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
             // SideBar(postion: 11,msg:"Coach"),
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
                              screenSize.width < 750 ?
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex:2,
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
                                                      // search(val)
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

                                ],
                              ):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Container(
                                  //   width: 180,
                                  //   child: BsSelectBox(
                                  //     hintText: 'Filtrer',
                                  //     controller: _selectFilter,
                                  //     onChange: (v){
                                  //       // filterContracts();
                                  //     },
                                  //   ),
                                  // ),
                                  /* InkWell(
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
                                          child: Text("Ajouter Contrat",
                                              style: TextStyle(
                                                  fontSize: 15
                                              )),
                                        ),
                                      ),
                                    ),
                                  )*/

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
                                              child: Text("aucun Contrat Salarié à afficher")),
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
                                                    'Staff',
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
                                                    'Staff',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              // DataColumn(
                                              //   label: Expanded(
                                              //     child: Text(
                                              //       'Date de debut',
                                              //       style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                              //     ),
                                              //   ),
                                              // ),
                                              // DataColumn(
                                              //   label: Expanded(
                                              //     child: Text(
                                              //       'Date fin',
                                              //       style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                              //     ),
                                              //   ),
                                              // ),

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
                                                      child: Text( "${r.employe}",
                                                        overflow: TextOverflow.ellipsis,),
                                                    )
                                                  ],
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
                                                        msg:"•Visualisation Les détails du client",
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
                                                                            Text('Contrat N°: ${r.id_contratStaff.toString()}',
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
                                                                                            Text("Nom Staff:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.employe.toString()} "),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),

                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Date de début :" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${r.date_debut.toString()}"),
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
                                                    //SizedBox(width: 10,),
                                                    // EditerButton(
                                                    //     onPressed: (){
                                                    //       modal_update(context, r, init: true);
                                                    //     }
                                                    // ),
                                                    // SizedBox(width: 10,),
                                                    // DeleteButton(
                                                    //   onPressed: () async{
                                                    //     if (await confirm(
                                                    //       context,
                                                    //       title: const Text('Confirmation'),
                                                    //       content: const Text('Souhaitez-vous supprimer ?'),
                                                    //       textOK: const Text('Oui'),
                                                    //       textCancel: const Text('Non'),
                                                    //     )) {
                                                    //
                                                    //       delete(r.id_contrat.toString());
                                                    //     }
                                                    //
                                                    //   },
                                                    // ),
                                                    SizedBox(width: 10,),
                                                    PrintButton(
                                                        msg:"Imprimer contrat",
                                                        onPressed: (){
                                                          print_pdf(r.id_contratStaff!);
                                                        }
                                                    ),
                                                  ],
                                                ))

                                              ]:
                                              <DataCell>[
                                                DataCell(Row(
                                                  children: [

                                                    Expanded(
                                                      child: Text( "${r.employe}",
                                                        overflow: TextOverflow.ellipsis,),
                                                    )
                                                  ],
                                                )),
                                                // DataCell(Text(r.date_debut.toString())),
                                                // DataCell(
                                                //     Text(
                                                //         "${r.date_fin}"
                                                //     )),

                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
                                                        msg:"•Visualisation Les détails du staff",
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
                                                                            Text('Contrat N°: ${r.id_contratStaff.toString()}',
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
                                                                                            Text("Nom client:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text(" ${r.employe.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),


                                                                                        SizedBox(height: 4,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text("Date de début :" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text("${r.date_debut.toString()}"),
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
                                                    //SizedBox(width: 10,),
                                                    // EditerButton(
                                                    //     onPressed: (){
                                                    //       modal_update(context, r, init: true);
                                                    //     }
                                                    // ),
                                                    // SizedBox(width: 10,),
                                                    // DeleteButton(
                                                    //   onPressed: () async{
                                                    //     if (await confirm(
                                                    //       context,
                                                    //       title: const Text('Confirmation'),
                                                    //       content: const Text('Souhaitez-vous supprimer ?'),
                                                    //       textOK: const Text('Oui'),
                                                    //       textCancel: const Text('Non'),
                                                    //     )) {
                                                    //
                                                    //       delete(r.id_contrat.toString());
                                                    //     }
                                                    //
                                                    //   },
                                                    // ),
                                                    SizedBox(width: 10,),
                                                    PrintButton(
                                                        msg:"Imprimer contrat",
                                                        onPressed: (){
                                                          print_pdf(r.id_contratStaff!);
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

