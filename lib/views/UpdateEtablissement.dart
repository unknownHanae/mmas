

import 'dart:io';

import 'package:adminmmas/models/ClientModels.dart';
import 'package:adminmmas/models/EtablissementModels.dart';
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
import 'package:provider/provider.dart';

import '../componnents/label.dart';
import '../constants.dart';

import 'dart:html' as html;

import '../models/SeanceModels.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';


class UpdateEtablissementScreen extends StatefulWidget {
  UpdateEtablissementScreen({Key? key, required this.etab}) : super(key: key);

  Etablissement etab;

  @override
  State<UpdateEtablissementScreen> createState() => _UpdateEtablissementScreenScreenState();
}


class _UpdateEtablissementScreenScreenState extends State<UpdateEtablissementScreen> {

  PlatformFile? objFile;

  String image_path = "";

  TextEditingController nom_controller = TextEditingController();
  TextEditingController adresse_controller = TextEditingController();
  TextEditingController tel_controller = TextEditingController();
  TextEditingController siteweb_controller = TextEditingController();
  TextEditingController mail_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  TextEditingController ville_controller = TextEditingController();
  TextEditingController facebook_controller = TextEditingController();
  TextEditingController watsapp_controller = TextEditingController();
  TextEditingController instagrame_controller = TextEditingController();



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


  void update(context) async {

    if(adresse_controller.text.isNotEmpty
        && mail_controller.text.isNotEmpty
        && nom_controller.text.isNotEmpty
        && tel_controller.text.isNotEmpty
        && ville_controller.text.isNotEmpty
    ){


      final bool emailValid =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(mail_controller.text);

      final bool phoneValid =
      RegExp(r"^(?:[+0]9)?[0-9]{10}$")
          .hasMatch(tel_controller.text);

      if(!emailValid){
        showAlertDialog(context, "Email n'est pas valide");
        return;
      }

      if(!phoneValid){
        showAlertDialog(context, "Telphone n'est pas valide");
        return;
      }

      var etablissement = <String, dynamic>{
        "adresse_etablissement": adresse_controller.text,
        "description": description_controller.text,
        "image": image_path,
        "mailetablissement": mail_controller.text,
        "nom_etablissement": nom_controller.text,
        "sitewebetablissement": siteweb_controller.text,
        "teletablissement": tel_controller.text,
        "watsapp": watsapp_controller.text,
        "instagrame": instagrame_controller.text,
        "facebook": facebook_controller.text,
        "ville": ville_controller.text,
        "id_etablissement": widget.etab.id_etablissement!
      };

      print(etablissement);
      final response = await http.put(Uri.parse(
          HOST+"/api/etablissements/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
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
  var token ="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    nom_controller.text = widget.etab.nom_etablissement!;
    adresse_controller.text = widget.etab.adresse_etablissement!;
    tel_controller.text = widget.etab.teletablissement!;
    mail_controller.text = widget.etab.mailetablissement!;
    siteweb_controller.text = widget.etab.sitewebetablissement!;
    ville_controller.text = widget.etab.ville!;
    description_controller.text = widget.etab.description!;
    watsapp_controller.text = widget.etab.watsapp == null ?  "" : widget.etab.watsapp!;
    instagrame_controller.text = widget.etab.instagrame == null ?  "" : widget.etab.instagrame!;
    facebook_controller.text = widget.etab.facebook == null ?  "" : widget.etab.facebook!;

    setState(() {
      image_path = widget.etab.image!;
    });


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
                    SideBar(postion: 4,msg:"Coach"),
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
                                  Text("Modifier Etablissements",
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
                                //flex: 1,
                                  child: ListView(
                                      children: [
                                        SizedBox(height: 10,),
                                        LabelText(
                                            title: 'Nom etablissement *'
                                        ),
                                        Container(

                                            decoration: BoxDecoration(boxShadow: [

                                            ]),
                                            child: SizedBox(height: 30,
                                              child: TextField(
                                                autofocus: true,
                                                controller: nom_controller,
                                                decoration: new InputDecoration(
                                                  hintText: 'Nom etablissement *',

                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabelText(
                                            title: 'Adresse etablissement *'
                                        ),
                                        Container(
                                            width: 900,
                                            decoration: BoxDecoration(boxShadow: [

                                            ]),
                                            child: SizedBox(height: 30,
                                              child: TextField(
                                                controller: adresse_controller,
                                                decoration: new InputDecoration(
                                                  hintText: 'Adresse etablissement *',
                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabelText(
                                            title: 'Tel etablissement *'
                                        ),
                                        Container(
                                            width: 900,
                                            decoration: BoxDecoration(boxShadow: [

                                            ]),
                                            child: SizedBox(height: 30,
                                              child: TextField(
                                               controller: tel_controller,
                                                decoration: new InputDecoration(
                                                  hintText: 'Tel Etablissement *',

                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabelText(
                                            title: 'Ville etablissement *'
                                        ),
                                        Container(
                                            width: 900,
                                            decoration: BoxDecoration(boxShadow: [

                                            ]),
                                            child: SizedBox(height: 30,
                                              child: TextField(
                                                controller: ville_controller,
                                                decoration: new InputDecoration(
                                                  hintText: 'Ville *',
                                                ),
                                              ),
                                            )),
                                        SizedBox(height: 10,),
                                        LabelText(
                                            title: 'Watsapp'
                                        ),
                                        Container(

                                            decoration: BoxDecoration(boxShadow: [

                                            ]),
                                            child: SizedBox(height: 30,
                                              child: TextField(
                                                autofocus: true,
                                                controller: watsapp_controller,
                                                decoration: new InputDecoration(
                                                  hintText: 'Watsapp',

                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabelText(
                                            title: 'Facebook'
                                        ),
                                        Container(

                                            decoration: BoxDecoration(boxShadow: [

                                            ]),
                                            child: SizedBox(height: 30,
                                              child: TextField(
                                                autofocus: true,
                                                controller: facebook_controller,
                                                decoration: new InputDecoration(
                                                  hintText: 'Facebook',

                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabelText(
                                            title: 'instagrame'
                                        ),
                                        Container(

                                            decoration: BoxDecoration(boxShadow: [

                                            ]),
                                            child: SizedBox(height: 30,
                                              child: TextField(
                                                autofocus: true,
                                                controller: instagrame_controller,
                                                decoration: new InputDecoration(
                                                  hintText: 'instagrame',

                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabelText(
                                            title: 'Mail etablissement *'
                                        ),
                                        Container(
                                            width: 900,
                                            decoration: BoxDecoration(boxShadow: [

                                            ]),
                                            child: SizedBox(height: 30,
                                              child: TextField(
                                                controller: mail_controller,
                                                decoration: new InputDecoration(
                                                  hintText: 'Mail Etablissement *',

                                                ),
                                              ),
                                            )),
                                        SizedBox(height: 10,),
                                        LabelText(
                                            title: 'Site Web etablissement *'
                                        ),
                                        Container(
                                            width: 900,
                                            decoration: BoxDecoration(boxShadow: [

                                            ]),
                                            child: SizedBox(height: 30,
                                              child: TextField(
                                                controller: siteweb_controller,
                                                decoration: new InputDecoration(
                                                  hintText: 'Site Web Etablissement',

                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabelText(
                                            title: 'Description etablissement *'
                                        ),
                                        Container(
                                            width: 900,
                                            decoration: BoxDecoration(boxShadow: [

                                            ]),
                                            child: SizedBox(height: 80,
                                              child: TextField(
                                                controller: description_controller,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(255,),
                                                ],
                                                decoration: new InputDecoration(
                                                  counterText: '255 au max caractères',
                                                  hintText: 'Description',
                                                ),
                                                maxLines: 5,
                                                minLines: 1,
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
                                          child: SizedBox(
                                            width: 50,
                                            height: 30,
                                            child: Container(

                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  color: Colors.blue
                                              ),
                                              child: Icon(Icons.camera_alt_outlined, size: 25, color: Colors.white),
                                            ),
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
