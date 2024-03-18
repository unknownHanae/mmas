import 'package:adminmmas/componnents/deleteButton.dart';
import 'package:adminmmas/componnents/label.dart';
import 'package:adminmmas/constants.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../componnents/editerButton.dart';
import '../componnents/showButton.dart';
import '../models/CatContratModels.dart';
import '../models/NiveauModel.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Abonnement.dart';
import 'AddCatcontrat.dart';
import 'ClasseScreen.dart';


class NiveauScreen extends StatefulWidget {
  const NiveauScreen({Key? key}) : super(key: key);

  @override
  State<NiveauScreen> createState() => _NiveauScreenState();
}

class _NiveauScreenState extends State<NiveauScreen> {

  List<Niveau> data = [];
  List<Niveau> init_data = [];
  bool loading = false;

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";

  BsSelectBoxController _selectDuree = BsSelectBoxController();

  void fetchNiveau() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/niveau/'),
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
        data = result.map<Niveau>((e) => Niveau.fromJson(e)).toList();
        init_data = result.map<Niveau>((e) => Niveau.fromJson(e)).toList();
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
      final List<Niveau> founded = [];
      init_data.forEach((e) {
        if(e.niveau!.toLowerCase().contains(key.toLowerCase())
            || e.id_niveau == key)
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

  String id_niveau = "";
  String niveau = "";


  TextEditingController niveau_controller = TextEditingController();

  var key_modal_add = new GlobalKey();

  void add(context) async {
    if( niveau_controller.text.isNotEmpty

    ){

      var Niveau = <String, dynamic>{
        "niveau": niveau_controller.text,
      };

      print(Niveau);

      final response = await http.post(Uri.parse(
          HOST+"/api/niveau/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(Niveau),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          initData();
        }else{
          if(body['errors'].containsKey("niveau")){
            showAlertDialog(context, "niveay already exists.");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      }else {
        showAlertDialog(context, "Erreur ajout");
      }
    }else{
      showAlertDialog(context, "Ajouter une valeur");
    }

  }

  void initData(){
    niveau_controller.text = "";
    fetchNiveau();

  }


  void update(context, int id) async {

    if( niveau_controller.text.isNotEmpty

    ){
      var Niveau = <String, dynamic>{
        "niveau": niveau_controller.text,
        "id_niveau": id,
      };

      print(Niveau);
      final response = await http.put(Uri.parse(
          HOST+"/api/niveau/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(Niveau),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          initData();
        }else{
          if(body['errors'].containsKey("niveau")){
            showAlertDialog(context, "niveay already exists.");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      }  else {
        showAlertDialog(context, "Failed to update data");
      }
    }else{
      showAlertDialog(context, "Ajouter une valeur");
    }

  }


  List<String> errors_add = [];

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
                      Text("Ajouter un niveau",
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
                  /*  BsModalContainer(title: Text("Ajouter un type d'abonnement"),
                      closeButton: true,
                    onClose: (){
                    Navigator.pop(context);
                    initData();
                    },
                  ),*/
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
                                  LabelText(title: "Niveau"),
                                  SizedBox(height: 10,),
                                  Container(
                                      decoration: BoxDecoration(boxShadow: [

                                      ]),
                                      child: TextField(
                                        autofocus: true,
                                        controller: niveau_controller,
                                        decoration: new InputDecoration(
                                          hintText: "Niveau",

                                        ),
                                      )
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
  void modal_update(context , Niveau cat){

    niveau_controller.text = cat.niveau!;

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
                      Text("Modifier niveau",
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
                  /* BsModalContainer(title: Text("Modifier type d'abonnement" )
                      , closeButton: true ,onClose: (){
                      Navigator.pop(context);
                      initData();
                    },),*/
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
                                  LabelText(title: "Niveau"),
                                  SizedBox(height: 10,),
                                  Container(
                                      decoration: BoxDecoration(boxShadow: [

                                      ]),
                                      child: TextField(
                                        autofocus: true,
                                        controller: niveau_controller,
                                        decoration: new InputDecoration(
                                          hintText: "Niveau",

                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),


                          ],
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            update(context, cat.id_niveau!);
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

  /*void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/Niveau/'+id));

    if (response.statusCode == 200) {
      fetchCatcontrat();
    } else {
      throw Exception('Failed to load data');
    }
  }*/

  String token = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init state");
    token = context.read<AdminProvider>().admin.token;
    fetchNiveau();
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
      title: Text("Niveau"),
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
        HOST+'/api/niveau/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchNiveau();
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
              //SideBar(postion: 7,msg: "niveau",),
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
                              Padding(
                                padding: const EdgeInsets.only(top:15.0),
                                child: Center(child: Text("Niveaux", style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.w700,
                                    color: Colors.black)),),
                              ),
                              SizedBox(height: 20,),
                              // InkWell(
                              //   onTap: (){
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => ClasseScreen(),
                              //         ));
                              //   },
                              //   child: Container(
                              //     height: 40,
                              //     width: 40,
                              //     decoration: BoxDecoration(
                              //         color: Colors.blue[200],
                              //         borderRadius: BorderRadius.circular(10)
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: Center(
                              //         child: Text("< Retour",
                              //             style: TextStyle(
                              //                 fontSize: 15
                              //             )),
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              SizedBox(height: 5,),
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
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                    ),
                                  ),
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
                                          child: Row(
                                            children: [
                                              Icon(Icons.add , size: 18, color: Colors.black,),
                                              Text("Ajouter niveau",
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ],
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
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ClasseScreen(),
                                              ));
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
                                              child: Text("< Retour",
                                                  style: TextStyle(
                                                      fontSize: 9
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: Text("Liste des niveaux",
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
                                          modal_add(context);
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
                                                  Text("Ajouter niveau",
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
                                              child: Text("aucun niveau à afficher")),
                                        )
                                            :
                                        DataTable(
                                            dataRowHeight: DataRowHeight,
                                            headingRowHeight: HeadingRowHeight,
                                            columns: const <DataColumn>[
                                              // DataColumn(
                                              //   label: Expanded(
                                              //     child: Text(
                                              //       'id_category',
                                              //       style: TextStyle(fontStyle: FontStyle.italic),
                                              //     ),
                                              //   ),
                                              // ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'niveau',
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
                                                // DataCell(Row(
                                                //   children: [
                                                //     Container(
                                                //       width: 40,
                                                //       height: 40,
                                                //       decoration: BoxDecoration(
                                                //           shape: BoxShape.circle,
                                                //           color: Colors.grey[200],
                                                //       ),
                                                //     ),
                                                //     SizedBox(width: 10,),
                                                //     Text(e.id_niveau.toString())
                                                //   ],
                                                // )),
                                                DataCell(Text(e.niveau.toString())),
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
                                                      msg:"supprimer Niveau ",
                                                      onPressed: () async {
                                                        if (await confirm(
                                                          context,
                                                          title: const Text('Confirmation'),
                                                          content: const Text('Souhaitez-vous supprimer ?'),
                                                          textOK: const Text('Oui'),
                                                          textCancel: const Text('Non'),
                                                        )) {

                                                          delete(e.id_niveau.toString());
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

