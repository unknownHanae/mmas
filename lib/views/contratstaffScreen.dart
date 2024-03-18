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

class ContratstaffScreen extends StatefulWidget {
  ContratstaffScreen({Key? key, Staff? this.staff}) : super(key: key);


  Staff? staff;

  @override
  State<ContratstaffScreen> createState() => _ContratstaffScreenState();
}

class _ContratstaffScreenState extends State<ContratstaffScreen> {

  List<ContratStaff> data = [];
  List<ContratStaff> init_data = [];
  bool loading = false;

  String text_search = "";

  List<Etablissement> Etablissements = [];
  List<Staff> Staffs = [];

  var _enableDateStart = true;

  double reste_paye = 0;

  List<Map<String, dynamic>> customers_data = [];

  BsSelectBoxController _selectabonnement = BsSelectBoxController();
  BsSelectBoxController _selectEtablissement = BsSelectBoxController();
  BsSelectBoxController _selectClients = BsSelectBoxController();

  BsSelectBoxController _selectTypeContrat = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: "Femme", text: Text("Femme")),
        BsSelectBoxOption(value: "Homme", text: Text("Homme")),
        BsSelectBoxOption(value: "Kids", text: Text("Kids")),
      ]
  );

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
  TextEditingController reduction_controller = TextEditingController();


  TextEditingController Montant_controller = TextEditingController();
  TextEditingController restOld_controller = TextEditingController();
  TextEditingController restNew_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();



  BsSelectBoxController _selectType = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: "CDD", text: Text("CDD")),
        BsSelectBoxOption(value: "CDI", text: Text("CDI")),
        BsSelectBoxOption(value: "Anapec", text: Text("Anapec")),
        BsSelectBoxOption(value: "vacataire", text: Text("vacataire")),
        BsSelectBoxOption(value: "Autre", text: Text("Autre")),
      ]
  );


  void fetchContratStaff() async {
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

      /*for(var r in result){
        var customer = {
          "name": "${r["client"]} ${r["Prenom_client"] ?? r["Prenom_client"]}",
          "id": r["id_client"]
        };
        //customers_data.indexWhere((el) => el["id"] == r["id"]);
        print("index ${customers_data.indexWhere((el) => el["id"] == customer["id"])}");
        if(customers_data.indexWhere((el) => el["id"] == customer["id"]) == -1){
          customers_data.add(customer);
        }
      }
*/
      //print("len customer data ${customers_data.length}");
      setState(() {
        data = result.map<ContratStaff>((e) => ContratStaff.fromJson(e)).toList();
        init_data = result.map<ContratStaff>((e) => ContratStaff.fromJson(e)).toList();
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
    if(key.length >= 1){
      final List<ContratStaff> founded = [];
      init_data.forEach((e) {
        if(e.id_contratStaff == key
            ||e.employe!.toLowerCase().contains(key.toLowerCase())
            || e.date_debut!.toLowerCase().contains(key.toLowerCase())
            || e.date_fin!.toLowerCase().contains(key.toLowerCase())
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
  //
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
  // int _index = 0;
  // Future<BsSelectBoxResponse> searchAbonnement(Map<String, String> params) async {
  //   List<BsSelectBoxOption> searched = [];
  //   print(params);
  //   for(var v in abonnement){
  //     var name = "${v.type_abonnement}${v.duree_mois} ";
  //     if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
  //       searched.add(
  //           BsSelectBoxOption(
  //               value: v.id_abn,
  //               text: Text("${v.type_abonnement}  ${v.duree_mois} mois")
  //           )
  //       );
  //     }
  //   }
  //
  //   return BsSelectBoxResponse(options: searched);
  // }
  //
  Future<BsSelectBoxResponse> searchStaff(Map<String, String> params) async {
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
    fetchContratStaff();
    getStaff(init: true);


  }
  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/contratstaff/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchContratStaff();
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

  void getStaff({bool? init=false}) async {
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
          print("staff => ${widget.staff!.toJson()}");

          Staff c = Staffs.where((el) => el.id_employe == widget.staff!.id_employe).first;

          _selectClients.setSelected(
              BsSelectBoxOption(
                  value: c.id_employe,
                  text: Text("${c.nom} ${c.prenom}")
              )
          );

          // modal_add2(context);
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
    reduction_controller.text = "";
    tarif_controller.text = "";
    MontantPaye_controller.text = "";

    // setState(() {
    //   _index = 0;
    // });

    _selectabonnement.clear();
    _selectClients.clear();
    //_selectEtablissement.clear();
    _selectStatus.clear();

    Montant_controller.text = "";
    restNew_controller.text = "";


    if(_selectType.getSelected() != null){
      _selectType.removeSelected(_selectType.getSelected()!);
    }



    getStaff();
    fetchContratStaff();
  }


  Admin? admin;

  void add(context) async {
    if(date_debut_controller.text.isNotEmpty
        //&& date_fin_controller.text.isNotEmpty
        && _selectClients.getSelected()?.getValue() != null
        && _selectType.getSelected()?.getValue() != null

    ){

      var rev = <String, dynamic>{
        "id_employe": _selectClients.getSelected()!.getValue(),
        "date_debut": date_debut_controller.text,
        "date_fin" : date_fin_controller.text.isNotEmpty ? date_fin_controller.text.isNotEmpty : null,
        "salaire" : Montant_controller.text,
        "id_admin": admin!.id,
        "type_contrat": _selectType.getSelected()?.getValue(),
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
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            content: const Text('Ajouté avec succès'),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          initData();
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


  int _index = 0;
  bool showAlert = false;
  List<Widget> items = [];



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
                      Text("Ajouter Contrat",
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
                                        title: 'Staffs *'
                                    ),

                                    BsSelectBox(
                                      hintText: 'Staffs',
                                      controller: _selectClients,
                                      searchable: true,
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
                                        title: "type  Contrat *"
                                    ),
                                    BsSelectBox(
                                      hintText: 'type  Contrat',
                                      controller: _selectType,
                                      onChange: (value) {
                                        print("selected  ${_selectType.getSelected()?.getValue()}");
                                        if(_selectType.getSelected()?.getValue() == "CDI") {

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
                                        title: "Montant * "
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          autofocus: true,
                                          controller: Montant_controller,
                                          decoration: InputDecoration(
                                              hintText: "Montant",
                                              hintStyle: TextStyle(fontSize: 14)
                                          ),

                                        )
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
                                    LabelText(title: "Date de debut *"),
                                    TextField(
                                      controller: date_debut_controller,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        hintText: 'Date de debut',

                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          String formattedDate =
                                          DateFormat("yyyy-MM-dd").format(pickedDate);
                                          setState(() {
                                            date_debut_controller.text =
                                                formattedDate.toString();
                                          });
                                        } else {
                                          print('Not selected');
                                        }
                                      },
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(title: "Date de FIN "),
                                    TextField(
                                      enabled: _selectType.getSelected()?.getValue() == "CDI" ? true: false ,
                                      controller: date_fin_controller,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        hintText: 'Date de fin',

                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(2023),
                                          firstDate: DateTime(2023),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          String formattedDate =
                                          DateFormat("yyyy-MM-dd").format(pickedDate);
                                          setState(() {
                                            date_fin_controller.text =
                                                formattedDate.toString();
                                          });
                                        } else {
                                          print('Not selected');
                                        }
                                      },
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 25,
                        ),

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
                              SizedBox(height: 8,),
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
            //  SideBar(postion: 21,msg:"contratStaff"),
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
                                child: Center(child: Text("Contrats salariés", style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.w700,
                                    color: Colors.black)),),
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
                                  Expanded(flex: 3, child: SizedBox(width: 30,),),
                                  Expanded(
                                    flex:2,
                                    child: InkWell(
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
                                            child: Text("Ajouter Contrat",
                                                style: TextStyle(
                                                    fontSize: 15
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Expanded(flex: 3, child: SizedBox(width: 30,),),
                                  Expanded(
                                    flex:2,
                                    child: InkWell(
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
                                            child: Text("Ajouter Contrat",
                                                style: TextStyle(
                                                    fontSize: 15
                                                )),
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
                                          child: Center(child: Text("aucun contrat Salarié à afficher")),
                                        )
                                            :  DataTable(
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
                                                    'Type Contrat',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'salaire',
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
                                                    // double.parse(r.reste!) == 0 ?
                                                    // Icon(Icons.check_circle_outline, size: 22, color: Colors.green,) :
                                                    // Icon(Icons.close_rounded, size: 22, color: Colors.red,),
                                                    SizedBox(width: 3,),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.grey[200],
                                                                image: DecorationImage(
                                                                    fit: BoxFit.cover,
                                                                    image: NetworkImage('${HOST}/media/${r.image.toString()}')
                                                                )
                                                            ),
                                                          ),
                                                          SizedBox(width: 6,),
                                                          Text( "${r.employe}",
                                                            overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
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
                                                                                            Text("Nom staff:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.employe.toString()} "),
                                                                                          ],
                                                                                        ),
                                                                                        // SizedBox(height: 4,),
                                                                                        // Column(
                                                                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                                                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        //   children: [
                                                                                        //     Text("Type:" ,style: TextStyle(
                                                                                        //         fontWeight: FontWeight.bold, color:Colors.grey
                                                                                        //     ),),
                                                                                        //     SizedBox(height: 4,),
                                                                                        //     Text(" ${r.type_contrat.toString()}"),
                                                                                        //   ],
                                                                                        // ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Type contrat:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.type_contrat.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("salaire:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${r.salaire.toString()} DHS"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Date de début :" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${r.date_debut.toString()} "),
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
                                                    DeleteButton(
                                                      onPressed: () async{
                                                        if (await confirm(
                                                          context,
                                                          title: const Text('Confirmation'),
                                                          content: const Text('Souhaitez-vous supprimer ?'),
                                                          textOK: const Text('Oui'),
                                                          textCancel: const Text('Non'),
                                                        )) {

                                                          delete(r.id_contratStaff.toString());
                                                        }

                                                      }, msg: 'supprimer le Contrat',
                                                    ),
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
                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.grey[200],
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage('${HOST}/media/${r.image.toString()}')
                                                          )
                                                      ),
                                                    ),
                                                    SizedBox(width: 6,),
                                                    Expanded(
                                                      child: Text(" ${r.employe.toString()} ",
                                                        overflow: TextOverflow.ellipsis,),
                                                    )

                                                  ],
                                                )),
                                                // DataCell(Text(r.date_debut.toString())),
                                                // DataCell(
                                                //     Text(
                                                //         "${r.date_fin}"
                                                //     )),
                                                DataCell(Text("${r.type_contrat.toString()}")),
                                                DataCell(Text("${r.salaire.toString()}")),
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
                                                                                            Text("Nom staff:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text(" ${r.employe.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        // SizedBox(height: 4,),
                                                                                        // Row(
                                                                                        //   children: [
                                                                                        //     Text("Type:" ,style: TextStyle(
                                                                                        //         fontWeight: FontWeight.bold, color:Colors.grey
                                                                                        //     ),),
                                                                                        //     SizedBox(height: 4,),
                                                                                        //     Text(" ${r.type_contrat.toString()}"),
                                                                                        //   ],
                                                                                        // ),
                                                                                        SizedBox(height: 4,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text("Type contrat:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text(" ${r.type_contrat.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),

                                                                                        //SizedBox(height: 4,),
                                                                                        //Text("Status paiement: ${r.status_paiement == false ? "Impyee" : "Paye"} "),
                                                                                        SizedBox(height: 4,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text("Salaire:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text("${r.salaire.toString()} DHS"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text("Date de début :" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text("${r.date_debut.toString()} "),
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
                                                    SizedBox(width: 10,),
                                                    DeleteButton(
                                                      onPressed: () async{
                                                        if (await confirm(
                                                          context,
                                                          title: const Text('Confirmation'),
                                                          content: const Text('Souhaitez-vous supprimer ?'),
                                                          textOK: const Text('Oui'),
                                                          textCancel: const Text('Non'),
                                                        )) {

                                                          delete(r.id_contratStaff.toString());
                                                        }

                                                      }, msg: 'supprimer le Contrat',
                                                    ),
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

