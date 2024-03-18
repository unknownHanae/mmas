

import 'dart:io';

import 'package:adminmmas/models/ClientModels.dart';
import 'package:adminmmas/models/ReservationModels.dart';
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

import '../models/SeanceModels.dart';
import '../widgets/navigation_bar.dart';


class AddEtabScreen extends StatefulWidget {
  const AddEtabScreen({Key? key}) : super(key: key);

  @override
  State<AddEtabScreen> createState() => _AddEtabScreenState();
}


 class _AddEtabScreenState extends State<AddEtabScreen> {

   PlatformFile? objFile;
   String nom_etablissement = "";
   String adresse_etablissement = "";
   String teletablissement = "";
   String sitewebetablissement = "";
   String mailetablissement = "";
   String description = "";
   String ville = "";
   String image_path = "";

   Uint8List? _bytesData;
   List<int>? _selectedFile;

   Future cameraImage(context) async {
     try{
       html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
       uploadInput.multiple = true;
       uploadInput.draggable = true;
       uploadInput.click();


       uploadInput.onChange.listen((event) {
         final files = uploadInput.files;
         final file = files![0];
         final reader = html.FileReader();

         reader.onLoadEnd.listen((event) async {
           _bytesData = Base64Decoder().convert(reader.result
               .toString()
               .split(",")
               .last);
           _selectedFile = _bytesData;
           var url = Uri.parse(HOST+"/api/saveImage/");
           var request = http.MultipartRequest("POST", url);
           request.files.add(await http.MultipartFile.fromBytes('uploadedFile', _selectedFile!,
               contentType: MediaType("application","json"), filename: "image-etab"));
           request.fields["path"] = "etablissements/";

           var response = await request.send();
           var responseData = await response.stream.toBytes();
           var responseString = String.fromCharCodes(responseData);
           final body = Map<String, dynamic>.from(json.decode(responseString));
           print(responseString);

           if(response.statusCode == 200){
           setState(() {
           image_path = body['path'];
           });
           }else{
           final snackBar = SnackBar(
           content: const Text('Please try again'),
           action: SnackBarAction(
           label: 'Close',
           onPressed: () {
           // Some code to undo the change.
           },
           ),
           );
           ScaffoldMessenger.of(context).showSnackBar(snackBar);
           }
         });
           reader.readAsDataUrl(file);
       });




     }catch(error){
       print(error);
     }

   }


   void add(context) async {

     if(adresse_etablissement.length > 0
         && mailetablissement.length > 0
         && nom_etablissement.length > 0
        && teletablissement.length > 0 && ville.length > 0
    ){


       final bool emailValid =
       RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
           .hasMatch(mailetablissement);

       final bool phoneValid =
       RegExp(r"^(?:[+0]9)?[0-9]{10}$")
           .hasMatch(teletablissement);

       if(!emailValid){
         showAlertDialog(context, "Email n'est pas valide");
         return;
       }

       if(!phoneValid){
         showAlertDialog(context, "Telphone n'est pas valide");
         return;
       }

       var etablissement = <String, String>{
         "adresse_etablissement": adresse_etablissement,
         "description": description,
         "image": image_path,
         "mailetablissement": mailetablissement,
         "nom_etablissement": nom_etablissement,
         "sitewebetablissement": sitewebetablissement,
         "teletablissement": teletablissement,
         "ville": ville
       };

      print(etablissement);

       final response = await http.post(Uri.parse(
           HOST+"/api/etablissements/"),
         headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
         },

         body: jsonEncode(etablissement),
       );

       if (response.statusCode == 200) {

         final body = json.decode(response.body);
         final status = body["status"];
         if(status == true){
           Navigator.pop(context,true);
         }else{
           showAlertDialog(context, body["msg"]);
         }
       } else {
         throw Exception('Failed to load data');
       }
     }else{
       showAlertDialog(context, "Remplir tous les champs");
     }

   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    SideBar(postion: 4,msg: "Etablissement",),
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
                                  Text("Ajouter Etablissements",
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
                                  //flex: 1,
                                  child: ListView(
                                    children: [
                                    SizedBox(height: 10,),
                                    Container(

                                         decoration: BoxDecoration(boxShadow: [

                                         ]),
                                         child: SizedBox(height: 30,
                                           child: TextField(
                                             autofocus: true,
                                             onChanged: (val) {
                                               setState(() {
                                                 nom_etablissement = val;
                                               });
                                             },
                                             decoration: new InputDecoration(
                                               hintText: 'Nom etablissement *',

                                            ),
                                           ),
                                         )),
                                     SizedBox(
                                       height: 10,
                                     ),
                                     Container(
                                         width: 900,
                                         decoration: BoxDecoration(boxShadow: [

                                         ]),
                                         child: SizedBox(height: 30,
                                           child: TextField(
                                             onChanged: (val) {
                                               adresse_etablissement = val;
                                             },
                                            decoration: new InputDecoration(
                                               hintText: 'Adresse etablissement *',

                                             ),
                                           ),
                                         )),
                                     SizedBox(
                                       height: 10,
                                     ),
                                     Container(
                                         width: 900,
                                         decoration: BoxDecoration(boxShadow: [

                                         ]),
                                         child: SizedBox(height: 30,
                                           child: TextField(
                                             onChanged: (val) {
                                               teletablissement = val;
                                             },
                                             decoration: new InputDecoration(
                                               hintText: 'Tel Etablissement *',

                                             ),
                                           ),
                                         )),
                                     SizedBox(
                                       height: 10,
                                     ),
                                      Container(
                                          width: 900,
                                          decoration: BoxDecoration(boxShadow: [

                                          ]),
                                          child: SizedBox(height: 30,
                                            child: TextField(

                                              onChanged: (val) {
                                                ville = val;
                                              },
                                              decoration: new InputDecoration(
                                                hintText: 'Ville *',
                                              ),
                                            ),
                                          )),
                                      Container(
                                          width: 900,
                                          decoration: BoxDecoration(boxShadow: [

                                          ]),
                                          child: SizedBox(height: 30,
                                            child: TextField(
                                              onChanged: (val) {
                                                mailetablissement = val;
                                              },
                                              decoration: new InputDecoration(
                                                hintText: 'Mail Etablissement *',

                                              ),
                                            ),
                                          )),
                                     Container(
                                         width: 900,
                                         decoration: BoxDecoration(boxShadow: [

                                         ]),
                                         child: SizedBox(height: 30,
                                           child: TextField(
                                             onChanged: (val) {
                                               sitewebetablissement = val;
                                             },
                                             decoration: new InputDecoration(
                                               hintText: 'Site Web Etablissement',

                                             ),
                                           ),
                                         )),
                                     SizedBox(
                                       height: 10,
                                     ),
                                     Container(
                                         width: 900,
                                         decoration: BoxDecoration(boxShadow: [

                                         ]),
                                         child: SizedBox(height: 30,
                                           child: TextField(
                                             onChanged: (val) {
                                               description = val;
                                             },
                                            decoration: new InputDecoration(
                                               hintText: 'Description',

                                             ),
                                           ),
                                         )),
                                     SizedBox(
                                       height: 10,
                                     ),
                                     SizedBox(height: 20,),
                                     InkWell(
                                       onTap: (){
                                         cameraImage(context);
                                       },
                                       child: Container(
                                         width: 50,
                                         height: 30,
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(6),
                                           color: Colors.blue
                                         ),
                                         child: Icon(Icons.camera_alt_outlined, size: 25, color: Colors.white),
                                       ),
                                     ),
                                     image_path.length > 0 ?
                                     SizedBox(
                                       width: 300, //
                                       height: 100,
                                       child: Image.network(
                                           HOST+"/media/"+image_path
                                       ),
                                     ):Text("select image",textAlign: TextAlign.center,),
                                     SizedBox( height: 10),
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

  showAlertDialog(BuildContext context, String msg) {
    Widget cancelButton = TextButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Ajouter Etablissements"),
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
}
