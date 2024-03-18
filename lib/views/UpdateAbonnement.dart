

import 'dart:io';

import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

import '../componnents/label.dart';
import '../constants.dart';

import 'dart:html' as html;

import '../models/AbonnementModels.dart';
import '../models/CatContratModels.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';


class UpdateAbonnement extends StatefulWidget {
  UpdateAbonnement({Key? key , required this.abon}) : super(key: key);

  Abonnement abon;
  @override
  State<UpdateAbonnement> createState() => _UpdateAbonnementState();
}



class _UpdateAbonnementState extends State<UpdateAbonnement> {

  PlatformFile? objFile;
  List<category_contrat> category = [];


  TextEditingController type_controller = TextEditingController();
  TextEditingController tarif_controller = TextEditingController();
  BsSelectBoxController _selectCategorycotrat = BsSelectBoxController();


  Uint8List? _bytesData;
  List<int>? _selectedFile;




  void update(context) async {

    if(type_controller.text.isNotEmpty && tarif_controller.text.isNotEmpty
        && _selectCategorycotrat.getSelected()?.getValue() != null
    ){
      var abon = <String, dynamic>{
        "id_abn": widget.abon.id_abn,
        "type_abonnement": type_controller.text,
        "tarif": tarif_controller.text,
        "id_cat_cont": _selectCategorycotrat.getSelected()?.getValue(),
      };

      print(abon);
      final response = await http.put(Uri.parse(
          HOST+"/api/abonnement/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(abon),
      );

      if (response.statusCode == 200) {

        //print("etb added");
        print(response.body);
        Navigator.pop(context,true);
      } else {
        throw Exception('Failed to load data');
      }
    }else{
      showAlertDialog(context);
    }
  }
  void getCategorycontrat() async {
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
        category = result.map<category_contrat>((e) => category_contrat.fromJson(e)).toList();
      });
      _selectCategorycotrat.options = category.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_cat_cont,
              text: Text("${c.type_contrat}")
          )).toList();
      category_contrat cat = category.where((element)
      => element.id_cat_cont == widget.abon.id_cat_cont).first;
      _selectCategorycotrat.setSelected(
          BsSelectBoxOption(
              value: widget.abon.id_cat_cont,
              text: Text("${cat.type_contrat}")
          )
      );
      print("--data--");
      print(category.length);
    } else {
      throw Exception('Failed to load data');
    }
  }
  var token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state clients");
    getCategorycontrat();
    type_controller.text=widget.abon.type_abonnement!;
    tarif_controller.text=widget.abon.tarif!;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200]
          ),
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                  children: [
                    SideBar(postion: 7,msg:"Coach"),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Text("Ajouter Abonnement",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      update(context);
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
                              SizedBox(height: 20,),
                              Expanded(
                                  flex: 1,
                                  child: ListView(
                                      children: [
                                        SizedBox(height: 10,),
                                        Container(
                                            width: 900,
                                            decoration: BoxDecoration(boxShadow: [
                                            ]),
                                            child: TextField(
                                              controller: type_controller,
                                              decoration: new InputDecoration(
                                                hintText: 'type_abonnement',
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            width: 900,
                                            decoration: BoxDecoration(boxShadow: [
                                            ]),
                                            child: TextField(
                                              controller: tarif_controller,
                                              decoration: new InputDecoration(
                                                hintText: 'tarif',
                                              ),
                                            )),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        LabelText(
                                            title: 'Catégorie Contrat'
                                        ),
                                        BsSelectBox(
                                          hintText: 'Catégorie Contrat',
                                          controller: _selectCategorycotrat,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ] //
                                  )
                              )
                            ],
                          ),
                        ),

                      ),
                    ),
                  ]
              )
          )
      ),
    );
  }

  showAlertDialog(BuildContext context) {



    Widget cancelButton = TextButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Ajouter Abonnement"),
      content: Text("Remplir toute Champs"),
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

}
