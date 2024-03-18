

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

import '../componnents/label.dart';
import '../constants.dart';

import 'dart:html' as html;

import '../widgets/navigation_bar.dart';


class AddCourScreen extends StatefulWidget {
  const AddCourScreen({Key? key}) : super(key: key);

  @override
  State<AddCourScreen> createState() => _AddCourScreenState();
}



class _AddCourScreenState extends State<AddCourScreen> {

  PlatformFile? objFile;

  String nom_cour = "";
  String description = "";
  String reglement = "";
  String genre = "";


  Uint8List? _bytesData;
  List<int>? _selectedFile;

  BsSelectBoxController _selectGenre = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: "Homme", text: Text("Homme")),
        BsSelectBoxOption(value: "Femme", text: Text("Femme")),
        BsSelectBoxOption(value: "Mixte", text: Text("Mixte")),
        BsSelectBoxOption(value: "Junior", text: Text("Junior")),
      ]
  );


  void add(context) async {

    if(nom_cour.length > 0 && description.length > 0
        && reglement.length > 0 &&  _selectGenre.getSelected()?.getValue() != null
    ){
      var cour = <String, String>{
        "nom_cour": nom_cour,
        "description": description,
        "reglement": reglement,
        "genre": _selectGenre.getSelected()?.getValue(),
      };

      print(cour);

      final response = await http.post(Uri.parse(
          HOST+"/api/cours/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(cour),
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
                    SideBar(postion: 6,msg: "Cours",),
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
                                  Text("Ajouter Cours",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
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
                                      autofocus: true,
                                      onChanged: (val) {
                                        nom_cour = val;
                                      },
                                      decoration: new InputDecoration(
                                        hintText: 'Saisir le nom du cours',
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
                                  onChanged: (val) {
                                    description = val;
                                    },
                                  decoration: new InputDecoration(
                                    hintText: 'Saisir une description',
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
                                    onChanged: (val) {
                                      reglement = val;
                                      },
                                    decoration: new InputDecoration(
                                      hintText: 'Réglement interieur du cours',
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                                LabelText(
                                    title: 'Genre *'
                                ),
                                BsSelectBox(
                                  hintText: 'Genre',
                                  controller: _selectGenre,
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
      title: Text("Ajouter Cours"),
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
