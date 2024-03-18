import 'dart:html';

import 'package:adminmmas/componnents/deleteButton.dart';
import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/ClasseModel.dart';
import 'package:adminmmas/models/NiveauModel.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../componnents/classeButton.dart';
import '../componnents/contractButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
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
import 'CustomerClasseScreen.dart';
import 'NiveauScreen.dart';
import 'SalleScreen.dart';


class ClasseScreen extends StatefulWidget {
  const ClasseScreen({Key? key}) : super(key: key);

  @override
  State<ClasseScreen> createState() => _ClasseScreenState();
}

class _ClasseScreenState extends State<ClasseScreen> {

  List<Classes> data = [];
  List<Classes> init_data = [];
  bool loading = false;
  List<Client> clients = [];

  List<Niveau> niveaux = [];

  BsSelectBoxController _selectNiveau = BsSelectBoxController();

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";
  void initSelectNiveau() {
    _selectNiveau.options = niveaux.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
          value: v.id_niveau,
          text: Text("${v.niveau} "),
        )).toList();
    Niveau niv = niveaux.where((el) => el.niveau == "").first;
    _selectNiveau.setSelected(BsSelectBoxOption(
      value: niv.id_niveau,
      text: Text("${niv.niveau}"),
    ));
  }
  void getNiveau() async {
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

        niveaux = result.map<Niveau>((e) => Niveau.fromJson(e)).toList();


      });
      print("--data--");
      print(data.length);
      initSelectNiveau();
    } else {
      throw Exception('Failed to load villes');
    }
  }
  Future<BsSelectBoxResponse> searchNiveau(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in niveaux){
      if(v.niveau!.toLowerCase().contains(params["searchValue"]!.toLowerCase()) ){
        searched.add(
            BsSelectBoxOption(
                value: v.id_niveau,
                text: Text("${v.niveau}")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }
  void fetchClasse() async {
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
        data = result.map<Classes>((e) => Classes.fromJson(e)).toList();
        init_data = result.map<Classes>((e) => Classes.fromJson(e)).toList();
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
      final List<Classes> founded = [];
      init_data.forEach((e) {
        if(e.niveau!.toLowerCase().contains(key.toLowerCase())
            || e.groupe!.toLowerCase().contains(key.toLowerCase())
            || e.id_classe == key)
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

  String id_classe = "";
  String niveau = "";
  String groupe = "";

  TextEditingController niveau_controller = TextEditingController();
  TextEditingController groupe_controller = TextEditingController();

  var key_modal_add = new GlobalKey();


  // void seeClient (Classes e){
  //
  //   Navigator.of(context)
  //       .push(
  //       MaterialPageRoute(builder: (context) => CustomerClasseScreen(customer_id: e.id_classe,) )
  //   );
  // }

  void add(context) async {
    setState(() {
      errors_add = [];
    });
    if( niveau.length > 0  || groupe.length > 0
    ){
      var classe = <String, dynamic>{
        "id_niveau": _selectNiveau.getSelected()?.getValue(),
        "groupe": groupe,
      };

      print(classe);

      final response = await http.post(Uri.parse(
          HOST+"/api/classe/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(classe),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          initData();
        }else{
          if(body['errors'].containsKey("non_field_errors")){
            showAlertDialog(context, "Classe existe déjà pour ce niveau");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      } else {
        showAlertDialog(context, "Erreur ajout");
      }
    }else{
      showAlertDialog(context, "Ajouter une valeur");
    }

  }

  void update(context, int id) async {

    if(  groupe_controller.text.isNotEmpty
    ){
      var classe = <String, dynamic>{
        "id_niveau": _selectNiveau.getSelected()?.getValue(),
        "groupe": groupe_controller.text,
        "id_classe": id,
      };

      print(classe);

      final response = await http.put(Uri.parse(
          HOST+"/api/classe/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(classe),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          initData();
        }else{
          if(body['error'].containsKey("non_field_errors")){
            showAlertDialog(context, "Classe existe déjà pour ce niveau");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
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
                      Text('Ajouter une Classe',
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
                        LabelText(title: "niveau *"),
                        BsSelectBox(
                          hintText: 'niveau',
                          controller: _selectNiveau,
                          searchable: true,
                          serverSide: searchNiveau,
                        ),
                        // Container(
                        //     decoration: BoxDecoration(boxShadow: [
                        //
                        //     ]),
                        //     child: TextField(
                        //       autofocus: true,
                        //       onChanged: (val) {
                        //         setState(() {
                        //           niveau = val;
                        //         });
                        //       },
                        //       decoration: new InputDecoration(
                        //         hintText: 'Niveau',
                        //
                        //       ),
                        //     )
                        // ),
                        SizedBox(height: 10,),
                        Container(
                            decoration: BoxDecoration(boxShadow: [

                            ]),
                            child: TextField(
                              autofocus: true,
                              onChanged: (val) {
                                setState(() {
                                  groupe = val;
                                });
                              },
                              decoration: new InputDecoration(
                                hintText: 'Groupe',

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
  void modal_update(context , Classes cla){

    _selectNiveau.setSelected(
        BsSelectBoxOption(value: cla.id_niveau, text: Text(cla.niveau!))
    );
    groupe_controller.text = cla.groupe!;

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
                      Text('Modifier une Classe',
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
                        LabelText(title: "niveau *"),
                        BsSelectBox(
                          hintText: 'niveau',
                          controller: _selectNiveau,
                          searchable: true,
                          serverSide: searchNiveau,
                        ),
                        // Container(
                        //     decoration: BoxDecoration(boxShadow: [
                        //
                        //     ]),
                        //     child: TextField(
                        //       autofocus: true,
                        //       controller: niveau_controller,
                        //       decoration: new InputDecoration(
                        //         hintText: 'Niveau',
                        //
                        //       ),
                        //     )
                        // ),
                        SizedBox(height: 10,),
                        Container(
                            decoration: BoxDecoration(boxShadow: [

                            ]),
                            child: TextField(
                              autofocus: true,
                              controller: groupe_controller,
                              decoration: new InputDecoration(
                                hintText: 'Groupe',

                              ),
                            )
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            update(context, cla.id_classe!);
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
    fetchClasse();
    getNiveau();

  }

  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/classe/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final status = body["status"];
      if(status == true){
        fetchClasse();
      }else{
        showAlertDialog(context, body["msg"]);
      }

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
      title: Text("Classe"),
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
            // SideBar(postion: 55,msg: "classe",),
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
                                child: Center(child: Text("Classes", style: TextStyle(
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
                                  SizedBox(width: 15,),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                    ),
                                  ),
                                  SizedBox(width: 15,),

                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NiveauScreen(),
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
                                              child: Text("Niveau",
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ),
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
                                              child: Text("Ajouter classe ",
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                      // InkWell(
                                      //   onTap: (){
                                      //     Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //           builder: (context) => SalleScreen(),
                                      //         ));
                                      //   },
                                      //   child: Container(
                                      //     height: 40,
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
                                      // /*IconButton(
                                      //   onPressed: (){Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) => SalleScreen(),
                                      //       ));}
                                      //   ,  icon:Icon(Icons.arrow_back_ios),),*/
                                      Text("Liste des classes ",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey,

                                          )),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NiveauScreen(),
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
                                              child: Text("Niveau",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ),
                                          ),
                                        ),
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
                                              child: Text("Ajouter classe ",
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                              child: Text("aucune Classe à afficher")),
                                        )
                                            :
                                        DataTable(
                                            dataRowHeight: DataRowHeight,
                                            headingRowHeight: HeadingRowHeight,
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Niveau',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Groupe',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'nombre des etudiants',
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
                                                DataCell(Text(e.niveau.toString())),
                                                DataCell(Text(e.groupe.toString())),
                                                DataCell(Text('${e.nombre_etudiant.toString()} étudiants')),
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
                                                      msg:"supprimer Classe",
                                                      onPressed: () async {
                                                        if (await confirm(
                                                          context,
                                                          title: const Text('Confirmation'),
                                                          content: const Text('Souhaitez-vous supprimer ?'),
                                                          textOK: const Text('Oui'),
                                                          textCancel: const Text('Non'),
                                                        )) {
                                                          delete(e.id_classe.toString());
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(width: 10,),
                                                    ClasseButton(
                                                      msg: "•Visualisation les Etudiants",
                                                      onPressed: (){
                                                        Navigator.of(context)
                                                            .push(
                                                            MaterialPageRoute(builder: (context) => CustomerClasseScreen(classe_id: e.id_classe,) )
                                                        );
                                                      },
                                                    ),
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
    _selectNiveau.removeSelected(_selectNiveau.getSelected()!);
    groupe = "";
    fetchClasse();
  }

}

