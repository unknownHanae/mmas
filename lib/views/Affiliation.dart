import 'dart:html';

import 'package:adminmmas/componnents/deleteButton.dart';
import 'package:adminmmas/componnents/label.dart';
import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/ClientModels.dart';
import 'package:adminmmas/models/ParentModels.dart';
import 'package:adminmmas/views/ParentScreen.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../componnents/editerButton.dart';
import '../componnents/showButton.dart';
import '../models/AffiliationModel.dart';
import '../models/CatContratModels.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Abonnement.dart';
import 'AddCatcontrat.dart';


class AfilliationScreen extends StatefulWidget {

  AfilliationScreen({Key? key, Client? this.client , Parent? this.parent}) : super(key: key);

  Client? client;
  Parent? parent;

  @override
  State<AfilliationScreen> createState() => AfilliationScreenState();
}

class AfilliationScreenState extends State<AfilliationScreen> {

  List<Afilliation> data = [];
  List<Afilliation> init_data = [];
  List<Parent> parents = [];
  List<Client> etudiants = [];
  List<Client> Clients = [];

  bool loading = false;

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";

  BsSelectBoxController _selectParent = BsSelectBoxController();
  BsSelectBoxController _selectEtudiant = BsSelectBoxController();

  void getClient({bool? init=false}) async {
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
        Clients = result.map<Client>((e) => Client.fromJson(e)).toList();
      });
      _selectEtudiant.options = Clients.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_etudiant,
              text: Text("${c.nom} ${c.prenom}")
          )).toList();

      print("--data--");
      print(Clients.length);

      if(init!){
        if(widget.client != null){
          print("client => ${widget.client!.toJson()}");

          Client c = Clients.where((el) => el.id_etudiant == widget.client!.id_etudiant).first;

          _selectEtudiant.setSelected(
              BsSelectBoxOption(
                  value: c.id_etudiant,
                  text: Text("${c.nom} ${c.prenom}")
              )
          );

          modal_add(context);
        }
      }

    } else {
      throw Exception('Failed to load data');
    }
  }
  void getParents({bool? init=false}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/Parentt/'),
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
        parents = result.map<Parent>((e) => Parent.fromJson(e)).toList();
      });
      _selectParent.options = parents.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_parent,
              text: Text("${c.nom} ${c.prenom}")
          )).toList();

      print("--data--");
      print(parents.length);

      if(init!){
        if(widget.parent != null){
          print("parent => ${widget.parent!.toJson()}");

          Parent c = parents.where((el) => el.id_parent == widget.parent!.id_parent).first;

          _selectParent.setSelected(
              BsSelectBoxOption(
                  value: c.id_parent,
                  text: Text("${c.nom} ${c.prenom}")
              )
          );

          modal_add(context);
        }
      }

    } else {
      throw Exception('Failed to load data');
    }
  }
  void fetchAfilliation() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/affiliation/'),
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
        data = result.map<Afilliation>((e) => Afilliation.fromJson(e)).toList();
        init_data = result.map<Afilliation>((e) => Afilliation.fromJson(e)).toList();
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
  void initSelectParent() {
    _selectParent.options = parents.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
          value: v.id_parent,
          text: Text("${v.nom} ${v.prenom} "),
        )).toList();
    Parent par = parents.where((el) => el.nom == "").first;
    _selectParent.setSelected(BsSelectBoxOption(
      value: par.id_parent,
      text: Text("${par.nom} ${par.prenom}"),
    ));
  }
  void getParent() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/Parentt/'),
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

        parents = result.map<Parent>((e) => Parent.fromJson(e)).toList();


      });
      print("--data--");
      print(data.length);
      initSelectParent();
    } else {
      throw Exception('Failed to load villes');
    }
  }

  void initSelectEtudiant() {
    _selectEtudiant.options = etudiants.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
          value: v.id_etudiant,
          text: Text("${v.nom} ${v.prenom} "),
        )).toList();
    Client clt = etudiants.where((el) => el.nom == "").first;
    _selectParent.setSelected(BsSelectBoxOption(
      value: clt.id_etudiant,
      text: Text("${clt.nom} ${clt.prenom}"),
    ));
  }
  void getEtudiant() async {
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

        etudiants = result.map<Client>((e) => Client.fromJson(e)).toList();


      });
      print("--data--");
      print(data.length);
      initSelectEtudiant();
    } else {
      throw Exception('Failed to load villes');
    }
  }

  void search(String key){
    if(key.length >= 1){
      final List<Afilliation> founded = [];
      init_data.forEach((e) {
        if(e.parent!.toLowerCase().contains(key.toLowerCase())
            || e.etudiant!.toLowerCase().contains(key.toLowerCase()))
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
  Future<BsSelectBoxResponse> searchParent(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in parents){
      var name = "${v.nom}${v.prenom} ";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_parent,
                text: Text("${v.nom}  ${v.prenom} ")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }

  Future<BsSelectBoxResponse> searchClient(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in Clients){
      var name = "${v.nom}${v.prenom} ";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_etudiant,
                text: Text("${v.nom}  ${v.prenom} ")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }

  String id_affiliation = "";
  String parent = "";



  TextEditingController type_contrat_controller = TextEditingController();

  var key_modal_add = new GlobalKey();
  //
  void add(context) async {

    if(_selectParent.getSelected()?.getValue() != null
        && _selectEtudiant.getSelected()?.getValue() != null

    //&& image_path.isNotEmpty
    ){

      var affil = <String, dynamic>{
        "id_etudiant": _selectEtudiant.getSelected()?.getValue(),
        "id_parent": _selectParent.getSelected()?.getValue(),


      };


      print(affil);
      final response = await http.post(Uri.parse(
          HOST+"/api/affiliation/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode(affil),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          initData();
        }else{
          if(body['errors'].containsKey("non_field_errors")){
            showAlertDialog(context, "afilliation existe déja");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      }  else {
        showAlertDialog(context, "Erreur ajout affil");
        //throw Exception('Failed to load data');
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }

  void initData(){
    _selectEtudiant.removeSelected(_selectEtudiant.getSelected()!);
    _selectParent.removeSelected(_selectParent.getSelected()!);
    fetchAfilliation();
  }

  void update(context, int? id) async  {
    if(_selectParent.getSelected()?.getValue() != null
        && _selectEtudiant.getSelected()?.getValue() != null

    //&& image_path.isNotEmpty
    ){

      var affil = <String, int?>{
        "id_affiliation": id,
        "id_parent": _selectParent.getSelected()?.getValue(),
        "id_etudiant": _selectEtudiant.getSelected()?.getValue(),

      };


      print(affil);
      final response = await http.put(Uri.parse(
          HOST+"/api/affiliation/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode(affil),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          initData();
        }else{
          if(body['error'].containsKey("non_field_errors")){
            showAlertDialog(context, "afilliation existe déja");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      }   else {
        showAlertDialog(context, "Erreur ajout client");
        //throw Exception('Failed to load data');
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }


  List<String> errors_add = [];

  void modal_add1(context, {bool init=false}){
    setState(() {
      errors_add = [];
    });
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
                      Text("Ajouter Affiliation",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Annuler'),
                        // prefixIcon: Icons.close,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                           Expanded(
                             flex:2,
                             child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(title: "Etudiant"),
                                    SizedBox(height: 10,),
                                    BsSelectBox(
                                      controller: _selectEtudiant,
                                      hintText: "étudiant",
                                      searchable: true,
                                      serverSide: searchClient,
                                    )
                                  ],
                                ),
                           ),
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 2,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(title: "Parent"),
                                    SizedBox(height: 10,),
                                    BsSelectBox(
                                      controller: _selectParent,
                                      hintText: "parent",
                                      searchable: true,
                                      serverSide: searchParent,
                                    )
                                  ],
                                ),
                            ),
                            SizedBox(width: 2,),
                             Padding(
                                padding: const EdgeInsets.only(top:25.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InkWell(
                                      onTap: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ParentScreen(),
                                                ));
                                      },
                                      child: Tooltip(
                                        message: "Ajouter Parent",
                                        decoration: BoxDecoration(
                                          color: Colors.blue, // Couleur de fond du tooltip
                                          borderRadius: BorderRadius.circular(8.0), // Optionnel : coins arrondis
                                        ),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.lightBlue)
                                          ),
                                          child: Center(
                                            child: Icon(Icons.add, size: 15, color: Colors.orange),
                                          ),
                                        ),
                                      ),
                                  ),
                                    ),
                                    ],
                                  ),
                                ),

                          ],
                        ),

                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            add(context);
                          },
                          child: Container(
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
                        ),
                      ],
                    ),

                  ),

                ],
              ),
            )));
  }
  void modal_add(context){
    setState(() {
      errors_add = [];
    });
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
                      Text("Ajouter Affiliation",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Annuler'),
                        // prefixIcon: Icons.close,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex:1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelText(title: "Etudiant"),
                                  SizedBox(height: 10,),
                                  BsSelectBox(
                                    controller: _selectEtudiant,
                                    hintText: "étudiant",
                                    searchable: true,
                                    serverSide: searchClient,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelText(title: "Parent"),
                                  SizedBox(height: 10,),
                                  BsSelectBox(
                                    controller: _selectParent,
                                    hintText: "parent",
                                    searchable: true,
                                    serverSide: searchParent,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            modal_add(context);
                          },
                          child: Container(
                            child:
                            Center(child: Text('ajouter parent', style: TextStyle(color: Colors.white, fontSize: 18),)),
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
                        ),
                        // SizedBox(height: 15,),
                        // Padding(
                        //   padding: const EdgeInsets.only(top:25.0),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.all(10.0),
                        //         child: InkWell(
                        //           onTap: (){
                        //             Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       ParentScreen(),
                        //                 ));
                        //           },
                        //           child: Tooltip(
                        //             message: "Ajouter Parent",
                        //             decoration: BoxDecoration(
                        //               color: Colors.blue, // Couleur de fond du tooltip
                        //               borderRadius: BorderRadius.circular(8.0), // Optionnel : coins arrondis
                        //             ),
                        //             child: Container(
                        //               height: 30,
                        //               width: 30,
                        //               decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(8),
                        //                   border: Border.all(color: Colors.lightBlue)
                        //               ),
                        //               child: Center(
                        //                 child: Icon(Icons.add, size: 15, color: Colors.orange),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 30,),
                        InkWell(
                          onTap: (){
                            add(context);
                          },
                          child: Container(
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
                        ),
                      ],
                    ),

                  ),

                ],
              ),
            )));
  }

  void modal_update(context , Afilliation affil){

    _selectEtudiant.setSelected(BsSelectBoxOption(value: affil.id_etudiant, text: Text("${affil.etudiant} ")));
    _selectParent.setSelected(BsSelectBoxOption(value: affil.id_parent, text: Text("${affil.parent} ")));

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
                      Text("Modifier affiliation",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Annuler'),
                        // prefixIcon: Icons.close,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelText(title: "Etudiant"),
                                  SizedBox(height: 10,),
                                  BsSelectBox(
                                    controller: _selectEtudiant,
                                    hintText: "étudiant",
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelText(title: "Parent"),
                                  SizedBox(height: 10,),
                                  BsSelectBox(
                                    controller: _selectParent,
                                    hintText: "parent",
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            update(context, affil.id_affiliation!);
                          },
                          child: Container(
                            child:
                            Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 13),)),
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
                        ),
                      ],
                    ),

                  ),

                ],
              ),
            )));
  }



  String token = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init state");
    token = context.read<AdminProvider>().admin.token;
    fetchAfilliation();
    //getEtudiant();
    getClient(init: true);
    getParents(init: true);
    //getParent();
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
      title: Text("Afilliation"),
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

  void delete(id) async {
    var token = context.read<AdminProvider>().admin.token;
    final response = await http.delete(Uri.parse(
        HOST+'/api/affiliation/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchAfilliation();
    } else {
      throw Exception('Failed to load data');
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
             // SideBar(postion: 333,msg: "affiliation",),
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
                                child: Center(child: Text("Affiliations", style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.w700,
                                    color: Colors.black)),),
                              ),
                              SizedBox(height: 20,),
                              screenSize.width > 750 ? Row(
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
                                            child: Text("Ajouter Affiliation",
                                                style: TextStyle(
                                                    fontSize: 15
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ) : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text("Affiliation",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey
                                            )),
                                      ),
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
                                                  Text("Ajouter Affiliation",
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
                                  SizedBox(height: 8,),

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
                                              child: Text("aucune Affiliation à afficher")),
                                        )
                                            :
                                        DataTable(
                                            dataRowHeight: DataRowHeight,
                                            headingRowHeight: HeadingRowHeight,
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Parent',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Etudiant',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(fontStyle: FontStyle.italic),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            rows:
                                            data.map<DataRow>((e) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(e.parent.toString())),
                                                DataCell(Text(e.etudiant.toString())),
                                                DataCell(Row(
                                                  children: [

                                                    EditerButton(
                                                        msg: "mettre à jour les informations",
                                                        onPressed: () async {
                                                          modal_update(context, e);
                                                        }
                                                    ),
                                                    SizedBox(width: 10,),
                                                    DeleteButton(
                                                      msg:"supprimer Ctégorie Contrat ",
                                                      onPressed: () async {
                                                        if (await confirm(
                                                          context,
                                                          title: const Text('Confirmation'),
                                                          content: const Text('Souhaitez-vous supprimer ?'),
                                                          textOK: const Text('Oui'),
                                                          textCancel: const Text('Non'),
                                                        )) {

                                                          delete(e.id_affiliation.toString());
                                                        }

                                                      },
                                                    )
                                                  ],
                                                )),
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

