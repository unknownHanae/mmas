import 'package:adminmmas/componnents/deleteButton.dart';
import 'package:adminmmas/constants.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../componnents/editerButton.dart';
import '../componnents/showButton.dart';
import '../models/CatContratModels.dart';
import '../models/CategoriSalModels.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'AddCatcontrat.dart';
import 'SalleScreen.dart';


class CatSalleScreen extends StatefulWidget {
  const CatSalleScreen({Key? key}) : super(key: key);

  @override
  State<CatSalleScreen> createState() => _CatSalleScreenState();
}

class _CatSalleScreenState extends State<CatSalleScreen> {

  List<category_salle> data = [];
  List<category_salle> init_data = [];
  bool loading = false;

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";

  void fetchCatsalle() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/category/'),
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
        data = result.map<category_salle>((e) => category_salle.fromJson(e)).toList();
        init_data = result.map<category_salle>((e) => category_salle.fromJson(e)).toList();
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
      final List<category_salle> founded = [];
      init_data.forEach((e) {
        if(e.nom_category!.toLowerCase().contains(key.toLowerCase())
            || e.id_category == key)
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

  String id_cat_salle = "";
  String nom_category = "";

  TextEditingController nom_category_controller = TextEditingController();

  var key_modal_add = new GlobalKey();

  void add(context) async {
    setState(() {
      errors_add = [];
    });
    if( nom_category.length > 0
    ){
      var category_contrat = <String, String>{
        "nom_category": nom_category,
      };

      print(category_salle);

      final response = await http.post(Uri.parse(
          HOST+"/api/category/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(category_contrat),
      );

      if (response.statusCode == 200) {

        //print("etb added");
        print(response.body);
        Navigator.pop(context);
        fetchCatsalle();
        //key_modal_add.currentWidget.di
        //Navigator.pop(context,true);
      } else {
        showAlertDialog(context, "Erreur ajout");
      }
    }else{
      showAlertDialog(context, "Ajouter une valeur");
    }

  }

  void update(context, int id) async {

    if( nom_category_controller.text.isNotEmpty
    ){
      var category_contrat = <String, dynamic>{
        "nom_category": nom_category_controller.text,
        "id_category": id,
      };

      print(category_salle);

      final response = await http.put(Uri.parse(
          HOST+"/api/category/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(category_contrat),
      );

      if (response.statusCode == 200) {

        //print("etb added");
        print(response.body);
        Navigator.pop(context,true);
        fetchCatsalle();
      } else {
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
                      Text('Ajouter une Categorie',
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
                    child:
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for(var item in errors_add ) Text(item, style: TextStyle(
                              color: Colors.red
                          ),),
                          SizedBox(height: 10,),
                          Container(
                              decoration: BoxDecoration(boxShadow: [

                              ]),
                              child: TextField(
                                autofocus: true,
                                onChanged: (val) {
                                  setState(() {
                                    nom_category = val;
                                  });
                                },
                                decoration: new InputDecoration(
                                  hintText: 'Nom Catégorie',

                                ),
                              )
                          ),
                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              add(context);
                            },
                            child: Container(
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
                          ),
                        ],
                      ),

                  ),

                ],
              ),
            )));
  }
  void modal_update(context , category_salle cat){

    nom_category_controller.text = cat.nom_category!;

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
                      Text('Modifier une Catégorie',
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
                    child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Container(
                              decoration: BoxDecoration(boxShadow: [

                              ]),
                              child: TextField(
                                autofocus: true,
                                controller: nom_category_controller,
                                decoration: new InputDecoration(
                                  hintText: 'Nom Catégorie',

                                ),
                              )
                          ),
                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              update(context, cat.id_category!);
                            },
                            child: Container(
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
                          ),
                        ],
                      ),

                  ),

                ],
              ),
            )));
  }
  var token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state");
    fetchCatsalle();

  }

  void delete(id) async {

    final response = await http.delete(Uri.parse(
        HOST+'/api/category/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchCatsalle();
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
      title: Text("Catégorie"),
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
             // SideBar(postion: 5,msg: "cat salle",),
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
                                child: Center(child: Text("Liste des categories", style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.w700,
                                    color: Colors.black)),),
                              ),
                              SizedBox(height: 20,),
                              screenSize.width > 750 ?
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
                                          child: Text("Ajouter categorie ",
                                              style: TextStyle(
                                                  fontSize: 15
                                              )),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ) :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                builder: (context) => SalleScreen(),
                                              ));
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
                                              child: Text("< Retour",
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      /*IconButton(
                                        onPressed: (){Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SalleScreen(),
                                            ));}
                                        ,  icon:Icon(Icons.arrow_back_ios),),*/
                                      Text("Liste des categories ",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey,

                                      )),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
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
                                          child: Text("Ajouter categorie ",
                                              style: TextStyle(
                                                  fontSize: 15
                                              )),
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
                                              child: Text("aucune Catégorie Salle à afficher")),
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
                                                    'Nom Catégorie',
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
                                              cells: <DataCell>[ //
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
                                                //     Text(e.id_cat_cont.toString())
                                                //   ],
                                                // )),
                                                DataCell(Text(e.nom_category.toString())),
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
                                                      msg:"supprimer Catégorie Salle",
                                                      onPressed: () async {
                                                        if (await confirm(
                                                          context,
                                                          title: const Text('Confirmation'),
                                                          content: const Text('Souhaitez-vous supprimer ?'),
                                                          textOK: const Text('Oui'),
                                                          textCancel: const Text('Non'),
                                                        )) {
                                                          delete(e.id_category.toString());
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


  void initData() {
    nom_category = "";
  }

}

