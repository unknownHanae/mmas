

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

import '../constants.dart';

import 'dart:html' as html;

import '../widgets/navigation_bar.dart';


class AddCatcontrat extends StatefulWidget {
  const AddCatcontrat({Key? key}) : super(key: key);

  @override
  State<AddCatcontrat> createState() => _AddCatcontratState();
}



class _AddCatcontratState extends State<AddCatcontrat> {

  PlatformFile? objFile;

  String id_cat_cont = "";
  String type_contrat = "";


  Uint8List? _bytesData;
  List<int>? _selectedFile;




  void add(context) async {

    if( type_contrat.length > 0
    ){
      var category_contrat = <String, String>{
        "type_contrat": type_contrat,
      };

      print(category_contrat);

      final response = await http.post(Uri.parse(
          HOST+"/api/category_contrat/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(category_contrat),
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
                    SideBar(postion: 2,msg: "Categorie contrat",),
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
                                  Text("Ajouter Category contrat",
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
                                      Center(child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 18),)),
                                      height: 40,
                                      width: 80,
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
                                  child:
                                  Container(
                                      width: 900,
                                      decoration: BoxDecoration(boxShadow: [

                                      ]),
                                      child: TextField(
                                        autofocus: true,
                                        onChanged: (val) {
                                          setState(() {
                                            type_contrat = val;
                                          });
                                          },
                                        decoration: new InputDecoration(
                                          hintText: 'type contrat',

                                        ),
                                      )),
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
      title: Text("Ajouter Category cotrat"),
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
