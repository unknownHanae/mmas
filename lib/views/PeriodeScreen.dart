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
import '../models/PeriodeModel.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Abonnement.dart';
import 'AddCatcontrat.dart';


class PeriodeScreen extends StatefulWidget {
  const PeriodeScreen({Key? key}) : super(key: key);

  @override
  State<PeriodeScreen> createState() => _periodeState();
}

class _periodeState extends State<PeriodeScreen> {

  List<periode_salaire> data = [];
  List<periode_salaire> init_data = [];
  bool loading = false;

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";

  BsSelectBoxController _selectDuree = BsSelectBoxController();
  BsSelectBoxController _selectAnnee = BsSelectBoxController();

  void fetchPeriode() async {
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
      setState(() {
        data = result.map<periode_salaire>((e) => periode_salaire.fromJson(e)).toList();
        init_data = result.map<periode_salaire>((e) => periode_salaire.fromJson(e)).toList();
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
      final List<periode_salaire> founded = [];
      init_data.forEach((e) {
        if(e.PeriodeSalaire!.toLowerCase().contains(key.toLowerCase())
            || e.id_periode == key)
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

  String id_periode = "";
  String PeriodeSalaire = "";

  void initDuree(){
    List<BsSelectBoxOption> options = [];
    var listeDuree =["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre ","Décembre"];
    for(var m in listeDuree){
      options.add(BsSelectBoxOption(value: m, text: Text("${m}")),);
    }
    _selectDuree.options = options;
  }

  void initAnnee(){
    List<BsSelectBoxOption> options = [];
    final now = DateTime.now();
    var listeDuree =[now.year,now.year+1,now.year+2,now.year+3,now.year+5];
    for(var m in listeDuree){
      options.add(BsSelectBoxOption(value: m, text: Text("${m}")),);
    }
    _selectAnnee.options = options;
  }

  var key_modal_add = new GlobalKey();


  void initData(){
    _selectDuree.removeSelected(_selectDuree.getSelected()!);
    _selectAnnee.removeSelected(_selectAnnee.getSelected()!);
    fetchPeriode();
  }



  void add(context) async {

    if(_selectAnnee.getSelected()?.getValue() != null
        && _selectDuree.getSelected()?.getValue() != null

    ){
      var duree=_selectDuree.getSelected()?.getValue().toString();
      var Annee=_selectAnnee.getSelected()?.getValue().toString();

      var periode = <String, dynamic>{
        "PeriodeSalaire":duree!+"_"+Annee!
      };

      final response = await http.post(Uri.parse(
          HOST+"/api/periode/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode(periode),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          initData();


        }else{
          if(body['errors'].containsKey("mail")){
            showAlertDialog(context, "Email deja exist");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      } else {
        showAlertDialog(context, "Erreur ajout client");
        //throw Exception('Failed to load data');
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
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
                      Text("Ajouter Période",
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
                                  LabelText(title: "mois"),
                                  SizedBox(height: 10,),
                                  BsSelectBox(
                                    controller: _selectDuree,
                                    hintText: "Mois",
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
                                  LabelText(title: "Année"),
                                  SizedBox(height: 10,),
                                  BsSelectBox(
                                    controller: _selectAnnee,
                                    hintText: "Année",
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
    fetchPeriode();
    initDuree();
    initAnnee();
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
      title: Text("Periode"),
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
        HOST+'/api/periode/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchPeriode();
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
             // SideBar(postion: 7,msg: "cat contrat",),
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
                                child: Center(child: Text("Périodes", style: TextStyle(
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
                                    flex:3,
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
                                            child: Text("Ajouter Periode",
                                                style: TextStyle(
                                                    fontSize: 15
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

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
                                        data.length == 0 ?
                                        Padding(
                                          padding: const EdgeInsets.all(150.0),
                                          child: Center(
                                              child: Text("aucune Période à afficher")),
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
                                                    'periode',
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
                                                DataCell(Text(e.PeriodeSalaire.toString())),
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

                                                          delete(e.id_periode.toString());
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

