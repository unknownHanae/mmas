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
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Abonnement.dart';
import 'AddCatcontrat.dart';


class CatContratScreen extends StatefulWidget {
  const CatContratScreen({Key? key}) : super(key: key);

  @override
  State<CatContratScreen> createState() => _CatContratState();
}

class _CatContratState extends State<CatContratScreen> {

  List<category_contrat> data = [];
  List<category_contrat> init_data = [];
  bool loading = false;

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";

  BsSelectBoxController _selectDuree = BsSelectBoxController();

  void fetchCatcontrat() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/category_contrat/'),
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
        data = result.map<category_contrat>((e) => category_contrat.fromJson(e)).toList();
        init_data = result.map<category_contrat>((e) => category_contrat.fromJson(e)).toList();
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
      final List<category_contrat> founded = [];
      init_data.forEach((e) {
        if(e.type_contrat!.toLowerCase().contains(key.toLowerCase())
            || e.id_cat_cont == key)
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

  String id_cat_cont = "";
  String type_contrat = "";

  void initDuree(){
    List<BsSelectBoxOption> options = [];
    var listeDuree =[1,3,6,10,12];
    for(var m in listeDuree){
      options.add(BsSelectBoxOption(value: m, text: Text("${m} mois")),);
    }
    _selectDuree.options = options;
  }

  TextEditingController type_contrat_controller = TextEditingController();

  var key_modal_add = new GlobalKey();

  void add(context) async {
    setState(() {
      errors_add = [];
    });
    if( type_contrat_controller.text.isNotEmpty
        && _selectDuree.getSelected()?.getValue() != null
    ){
      if(type_contrat_controller.text.toLowerCase() == "morning"
          || type_contrat_controller.text.toLowerCase() == "relaxing"){

        if(type_contrat_controller.text.toLowerCase() == "morning"){
          var result = init_data.where((el) => el.type_contrat!.toLowerCase() == "morning").toList();

          if(result.length > 0){
            showAlertDialog(context, "Ce type de contrat déja existe");
            return;
          }
        }

        if(type_contrat_controller.text.toLowerCase() == "relaxing"){
          var result = init_data.where((el) => el.type_contrat!.toLowerCase() == "relaxing").toList();

          if(result.length > 0){
            showAlertDialog(context, "Ce type de contrat déja existe");
            return;
          }
        }


      }
      var category_contrat = <String, dynamic>{
        "type_contrat": type_contrat_controller.text,
        "duree_mois": _selectDuree.getSelected()?.getValue()
      };

      print(category_contrat);

      final response = await http.post(Uri.parse(
          HOST+"/api/category_contrat/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(category_contrat),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context,true);

          fetchCatcontrat();
          initData();
        }else{
          showAlertDialog(context, body["msg"]);
        }
        //print("etb added");
        print(response.body);
        //Navigator.pop(context);
        //fetchCatcontrat();
        //key_modal_add.currentWidget.di
        //Navigator.pop(context,true);
      } else {
        showAlertDialog(context, "Erreur ajout");
      }
    }else{
      showAlertDialog(context, "Ajouter une valeur");
    }

  }

  void initData(){
    type_contrat_controller.text = "";
    _selectDuree.removeSelected(_selectDuree.getSelected()!);
  }


  void update(context, int id) async {

    if( type_contrat_controller.text.isNotEmpty
        && _selectDuree.getSelected()?.getValue() != null
    ){
      var category_contrat = <String, dynamic>{
        "type_contrat": type_contrat_controller.text,
        "duree_mois":  _selectDuree.getSelected()?.getValue(),
        "id_categoryContrat": id,
      };

      print(category_contrat);
      final response = await http.put(Uri.parse(
          HOST+"/api/category_contrat/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(category_contrat),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context,true);

          fetchCatcontrat();
          initData();
        }else{
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
                      Text("Ajouter un type d'abonnement",
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
                                  LabelText(title: "Type d'abonnement"),
                                  SizedBox(height: 10,),
                                  Container(
                                      decoration: BoxDecoration(boxShadow: [

                                      ]),
                                      child: TextField(
                                        autofocus: true,
                                        controller: type_contrat_controller,
                                        decoration: new InputDecoration(
                                          hintText: "Type d'abonnement",

                                        ),
                                      )
                                  ),
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
                                  LabelText(title: "Duree en mois"),
                                  SizedBox(height: 10,),
                                  BsSelectBox(
                                    controller: _selectDuree,
                                    hintText: "Duree en mois",
                                  )
                                ],
                              ),
                            )

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
  void modal_update(context , category_contrat cat){

    type_contrat_controller.text = cat.type_contrat!;
    _selectDuree.setSelected(BsSelectBoxOption(value: cat.duree_mois, text: Text("${cat.duree_mois} mois")));

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
                      Text("Modifier type d'abonnement",
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
                                  LabelText(title: "Type d'abonnement"),
                                  SizedBox(height: 10,),
                                  Container(
                                      decoration: BoxDecoration(boxShadow: [

                                      ]),
                                      child: TextField(
                                        autofocus: true,
                                        enabled: cat.type_contrat! == "Morning" ? false :
                                        cat.type_contrat! == "Relaxing" ? false : true,
                                        controller: type_contrat_controller,
                                        decoration: new InputDecoration(
                                          hintText: "Type d'abonnement",

                                        ),
                                      )
                                  ),
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
                                  LabelText(title: "Duree en mois"),
                                  SizedBox(height: 10,),
                                  BsSelectBox(
                                    controller: _selectDuree,
                                    hintText: "Duree en mois",
                                  )
                                ],
                              ),
                            )

                          ],
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            update(context, cat.id_cat_cont!);
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
        HOST+'/api/category_contrat/'+id));

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
    fetchCatcontrat();
    initDuree();
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
      title: Text("Category cotrat"),
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
        HOST+'/api/category_contrat/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchCatcontrat();
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
              SideBar(postion: 7,msg: "cat contrat",),
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
                                  Expanded(
                                      child:Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.grey[200],
                                            border: Border.all(
                                                color: Colors.orange
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
                                                      color: Colors.orange

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
                                  SizedBox(width: 10,),
                                  Container(
                                    child: Icon(Icons.add_alert_outlined, size: 20,),
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
                                  SizedBox(width: 10,),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage('https://cdn-icons-png.flaticon.com/512/219/219969.png'),
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey[200]
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              screenSize.width > 750 ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AbonnementScreen(),
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
                                  /* IconButton(
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AbonnementScreen(),
                                        ));}
                                    ,  icon:Icon(Icons.arrow_back_ios),
                                  ),*/
                                  Text("Liste des categories des contrats", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
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
                                              Text("Ajouter categorie contrat",
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
                                                builder: (context) => AbonnementScreen(),
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
                                      /* IconButton(
                                        onPressed: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AbonnementScreen(),
                                              ));}
                                        ,  icon:Icon(Icons.arrow_back_ios),
                                      ),*/
                                      Expanded(
                                        child: Text("Liste des categories des contrats",
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
                                                  Text("Ajouter categorie contrat",
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
                                                    'Type de contrat',
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
                                                //     Text(e.id_cat_cont.toString())
                                                //   ],
                                                // )),
                                                DataCell(Text(e.type_contrat.toString())),
                                                DataCell(Row(
                                                  children: [
                                                    // ShowButton(
                                                    //     onPressed: (){
                                                    //       showDialog(context: context, builder: (context) =>
                                                    //           BsModal(
                                                    //               context: context,
                                                    //               dialog: BsModalDialog(
                                                    //                 size: BsModalSize.md,
                                                    //                 crossAxisAlignment: CrossAxisAlignment.center,
                                                    //                 child: BsModalContent(
                                                    //                   decoration: BoxDecoration(
                                                    //                     color: Colors.white,
                                                    //                   ),
                                                    //                   children: [
                                                    //                     BsModalContainer(title: Text('${e.type_contrat.toString()}'), closeButton: true),
                                                    //                     BsModalContainer(
                                                    //                       child: Row(
                                                    //                           crossAxisAlignment: CrossAxisAlignment.start,
                                                    //                           children: [
                                                    //                             SizedBox(width: 8,),
                                                    //                             Expanded(
                                                    //                                 child: Column(
                                                    //                                   mainAxisAlignment: MainAxisAlignment.start,
                                                    //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                    //                                   children: [
                                                    //                                     Text("type Contrat: ${e.type_contrat.toString()}"),
                                                    //                                   ],
                                                    //                                 )
                                                    //                             )
                                                    //
                                                    //                           ]
                                                    //                       ),
                                                    //                     ),
                                                    //                     BsModalContainer(
                                                    //                       crossAxisAlignment: CrossAxisAlignment.end,
                                                    //                       actions: [
                                                    //                         //Navigator.pop(context);
                                                    //                       ],
                                                    //                     )
                                                    //                   ],
                                                    //                 ),
                                                    //               )));
                                                    //     }
                                                    // ),
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

                                                          delete(e.id_cat_cont.toString());
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

