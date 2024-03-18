import 'dart:io';

import 'package:adminmmas/componnents/showButton.dart';
import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/ClientModels.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../models/CoachModels.dart';
import '../models/Ville.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';
import 'dart:html' as html;
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:adminmmas/models/ClientModels.dart';

import 'AddEtablissements.dart';
import 'UpdateEtablissement.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({Key? key}) : super(key: key);

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {

  List<Coach> data = [];
  List<Coach> init_data = [];
  bool loading = false;

  List<Ville> villes = [];


  TextEditingController nom_controller = TextEditingController();
  TextEditingController adresse_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  TextEditingController prenom_controller = TextEditingController();
  TextEditingController tel_controller = TextEditingController();
  TextEditingController mail_controller = TextEditingController();
  TextEditingController cin_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController ville_controller = TextEditingController();
  TextEditingController Date_naissance_controller = TextEditingController();
  TextEditingController Date_Entree_controller = TextEditingController();

  String image_path = "";

  BsSelectBoxController _selectstatut = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 0, text: Text("Actif")),
        BsSelectBoxOption(value: 1, text: Text("Inactif")),
      ]
  );

  BsSelectBoxController _selectCivilite = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: "Madmoiselle", text: Text("Madmoiselle")),
        BsSelectBoxOption(value: "Madame", text: Text("Madame")),
        BsSelectBoxOption(value: "Monsieur", text: Text("Monsieur")),
      ]
  );

  Uint8List? _bytesData;
  List<int>? _selectedFile;

  BsSelectBoxController _selectVilles = BsSelectBoxController();

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";
  Future cameraImage(context, {Coach? coach}) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        // final clientnom = clientName ?? 'default_name'; // Utilisez un nom par défaut si le nom du client n'est pas fourni.
        // final fileName = '$clientnom.jpg'; // Utilisez le nom du client comme nom de fichier.
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,

          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
            WebUiSettings(
              context: context,
              presentStyle: CropperPresentStyle.dialog,
              boundary: const CroppieBoundary(
                width: 350,
                height: 350,
              ),
              viewPort:
              const CroppieViewPort(width: 280, height: 280, type: 'rectangle'),
              enableExif: true,
              enableZoom: true,
              showZoomer: true,

            ),
          ],
        );
        print(pickedFile.path);

        if (croppedFile != null) {
          // Now, you can upload the cropped image and perform other actions as needed.
          final bytesData = await croppedFile.readAsBytes();
          final _selectedFile = Uint8List.fromList(bytesData);

          var url = Uri.parse(HOST+"/api/saveImage/");
          var request = http.MultipartRequest("POST", url);
          request.files.add(await http.MultipartFile.fromBytes('uploadedFile', _selectedFile!,
              contentType: MediaType("application","json"), filename: "image-coach"));
          request.fields["path"] = "coach/";

          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          final body = Map<String, dynamic>.from(json.decode(responseString));
          print(responseString);

          if(response.statusCode == 200){
            setState(() {
              image_path = body['path'];
            });
            if(coach != null){
              Navigator.pop(context);
              modal_update(context, coach, uploadImage: true);
            }else{
              Navigator.pop(context);
              modal_add(context);
            }
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
        }
      }
    } catch (error) {
      print(error);
    }

  }

  // Future _cropImage( _pickedFile) async {
  //   print(_pickedFile);
  //   if (_pickedFile != null) {
  //     final croppedFile = await ImageCropper().cropImage(
  //       sourcePath: _pickedFile,
  //       compressFormat: ImageCompressFormat.jpg,
  //       compressQuality: 100,
  //       uiSettings: [
  //         AndroidUiSettings(
  //             toolbarTitle: 'Cropper',
  //             toolbarColor: Colors.deepOrange,
  //             toolbarWidgetColor: Colors.white,
  //             initAspectRatio: CropAspectRatioPreset.original,
  //             lockAspectRatio: false),
  //         IOSUiSettings(
  //           title: 'Cropper',
  //         ),
  //         WebUiSettings(
  //           context: context,
  //           presentStyle: CropperPresentStyle.dialog,
  //           boundary: const CroppieBoundary(
  //             width: 300,
  //             height: 300,
  //           ),
  //           viewPort:
  //           const CroppieViewPort(width: 200, height: 200, type: 'circle'),
  //           enableExif: true,
  //           enableZoom: true,
  //           showZoomer: true,
  //         ),
  //       ],
  //     );
  //     if (croppedFile != null) {
  //       return croppedFile;
  //     }
  //   }
  //   return null;
  // }
  // Future cameraImage(context, {Coach? coach}) async {
  //   try{
  //     html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  //     uploadInput.multiple = true;
  //     uploadInput.draggable = true;
  //     uploadInput.click();
  //
  //
  //     uploadInput.onChange.listen((event) async {
  //       final files = uploadInput.files;
  //       final file = files![0];
  //       final reader = html.FileReader();
  //       //print(file!.relativePath);
  //       //var res_file = await _cropImage(file!.relativePath);
  //       reader.onLoadEnd.listen((event) async {
  //         _bytesData = Base64Decoder().convert(reader.result
  //             .toString()
  //             .split(",")
  //             .last);
  //         _selectedFile = _bytesData;
  //         var url = Uri.parse(HOST+"/api/saveImage/");
  //         var request = http.MultipartRequest("POST", url);
  //         request.files.add(await http.MultipartFile.fromBytes('uploadedFile', _selectedFile!,
  //             contentType: MediaType("application","json"), filename: "image-coach"));
  //         request.fields["path"] = "coach/";
  //
  //         var response = await request.send();
  //         var responseData = await response.stream.toBytes();
  //         var responseString = String.fromCharCodes(responseData);
  //         final body = Map<String, dynamic>.from(json.decode(responseString));
  //         print(responseString);
  //
  //         if(response.statusCode == 200){
  //           setState(() {
  //             image_path = body['path'];
  //           });
  //           if(coach != null){
  //             Navigator.pop(context);
  //             modal_update(context, coach, uploadImage: true);
  //           }else{
  //             Navigator.pop(context);
  //             modal_add(context);
  //           }
  //         }else{
  //           final snackBar = SnackBar(
  //             content: const Text('Please try again'),
  //             action: SnackBarAction(
  //               label: 'Close',
  //               onPressed: () {
  //                 // Some code to undo the change.
  //               },
  //             ),
  //           );
  //           ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //         }
  //       });
  //       reader.readAsDataUrl(file);
  //       /*if(res_file != null){
  //
  //
  //       }else{
  //         print("not croppeted");
  //       }*/
  //
  //
  //     });
  //
  //   }catch(error){
  //     print(error);
  //   }
  //
  // }

  void getVilles() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/villes/'),
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

        villes = result.map<Ville>((e) => Ville.fromJson(e)).toList();


      });
      print("--data--");
      print(data.length);
      initSelectVilles();
    } else {
      throw Exception('Failed to load villes');
    }
  }

  void initSelectVilles() {
    _selectVilles.options = villes.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
            value: v.id,
            text: Text("${v.nom_ville}")
        )).toList();
  }

  Future<BsSelectBoxResponse> searchVille(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in villes){
      if(v.nom_ville!.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id,
                text: Text("${v.nom_ville}")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }

  /**
   * lister tous les coach qui existe dans Notre base de donnée
   * @return: void
   */
  void fetchCoach() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/coach/'),
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
        data = result.map<Coach>((e) => Coach.fromJson(e)).toList();
        init_data = result.map<Coach>((e) => Coach.fromJson(e)).toList();

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

  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/coach/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchCoach();
    } else {
      throw Exception('Failed to load data');
    }
  }
  /**
   * chercher dans la liste des Coach en utilisants key
   * @param: String Key
   * @return: void
   */
  void search(String key){
    if(key.length > 1){
      final List<Coach> founded = [];
      init_data.forEach((e) {
        if(e.nom_coach!.toLowerCase().contains(key.toLowerCase())
            || e.prenom_coach!.toLowerCase().contains(key.toLowerCase())
            || e.ville!.toLowerCase().contains(key.toLowerCase())
            || e.tel!.toLowerCase().contains(key.toLowerCase())
            || e.date_naissance!.toString().toLowerCase().contains(key.toLowerCase()))
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

  showAlertDialog(BuildContext context, String msg) {
    Widget cancelButton = TextButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Coachs"),
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
  /**
   * initialiser les données
   * @return: void
   */
  void initData() {
    nom_controller.text = "";
    prenom_controller.text = "";
    adresse_controller.text = "";
    tel_controller.text = "";
    mail_controller.text = "";
    ville_controller.text = "";
    cin_controller.text = "";
    Date_naissance_controller.text = "";
    Date_Entree_controller.text = "";
    password_controller.text = "";
   description_controller.text = "";

    //_selectVilles.clear();
    //initSelectVilles();

    _selectCivilite.removeSelected(_selectCivilite.getSelected()!);
    _selectstatut.removeSelected(_selectstatut.getSelected()!);

    _selectVilles.removeSelected(_selectVilles.getSelected()!);

    setState(() {
      image_path = "";
    });
    fetchCoach();
  }
  /**
   * validation de formulaire et la preparation des données pour l'envoyer A l'api
   * @param: BuildContext context
   * @return: void
   */
  void add(context) async {

    if(adresse_controller.text.isNotEmpty
        && mail_controller.text.isNotEmpty
        && nom_controller.text.isNotEmpty
        && tel_controller.text.isNotEmpty
        && password_controller.text.isNotEmpty
        //&& ville_controller.text.isNotEmpty
        && _selectstatut.getSelected()?.getValue() != null
        && _selectCivilite.getSelected()?.getValue() != null
        && _selectVilles.getSelected()?.getValue() != null
       // && image_path.isNotEmpty
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

      var coach = <String, dynamic>{
        "nom_coach": nom_controller.text,
        "prenom_coach": prenom_controller.text,
        "image": image_path,
        "adresse": adresse_controller.text,
        "tel": tel_controller.text,
        "description":description_controller.text,
        "mail": mail_controller.text,
        "cin": cin_controller.text,
        "ville": _selectVilles.getSelected()?.getValue(),
        "civilite": _selectCivilite.getSelected()?.getValue(),
        "password": password_controller.text,
        "date_naissance": Date_naissance_controller.text,
        "date_dentree": Date_Entree_controller.text,
        "statut": _selectstatut.getSelected()?.getValue(),
      };

      print(coach);
      final response = await http.post(Uri.parse(
          HOST+"/api/coach/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode(coach),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          initData();


        }else{
          if(body['errors'].containsKey("mail")){
            showAlertDialog(context, "Cette adresse mail est déjà utilisée");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      } else {
        showAlertDialog(context, "Erreur ajout coach");
        //throw Exception('Failed to load data');
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }
  /**
   * ui{formulaire d'ajout Coach}
   * @param: BuildContext context
   * @return: void
   */
  void modal_add(context){

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
                      Text('Ajouter Coach',
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                LabelText(title: "Civilité *"),
                                BsSelectBox(
                                  hintText: 'Civilité',
                                  controller: _selectCivilite,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "Nom *"),
                                TextField(
                                    controller: nom_controller,
                                    decoration: InputDecoration(
                                      hintText: 'Nom',
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "Prenom *"),
                                TextField(
                                  controller: prenom_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Prenom ',

                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "Adresse *"),
                                TextField(
                                  controller: adresse_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Adresse',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "Numero de telephone *"),
                                TextField(
                                  controller: tel_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Numero de telephone',

                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "Email *"),
                                TextField(
                                  controller: mail_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "CIN *"),
                                Container(
                                  width: double.infinity,
                                  child: TextField(
                                    controller: cin_controller,
                                    decoration: InputDecoration(
                                      hintText: 'CIN',

                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  /*TextField(
                                    controller: ville_controller,
                                    decoration: InputDecoration(
                                      hintText: 'ville',
                                      border: OutlineInputBorder(),
                                    ),
                                    ),
                                  ),*/
                                  LabelText(title: "Villes *"),
                                  BsSelectBox(
                                    hintText: 'Villes',
                                    controller: _selectVilles,
                                    searchable: true,
                                    serverSide: searchVille,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: "Date de naissance *"),
                                  TextField(
                                    controller: Date_naissance_controller,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      hintText: 'Date de naissance',

                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2000),
                                        firstDate: DateTime(1975),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        String formattedDate =
                                        DateFormat("yyyy-MM-dd").format(pickedDate);
                                        setState(() {
                                          Date_naissance_controller.text =
                                              formattedDate.toString();
                                        });
                                      } else {
                                        print('Not selected');
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: "Date de recrutement *"),
                                  TextField(
                                    controller: Date_Entree_controller,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      hintText: 'Date de recrutement',

                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDat = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDat != null) {
                                        String formattedDat =
                                        DateFormat('yyyy-MM-dd').format(pickedDat);
                                        setState(() {
                                          Date_Entree_controller.text =
                                              formattedDat.toString();
                                        });
                                      } else {
                                        print('Not selected');
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: "Statut *"),
                                  BsSelectBox(
                                    hintText: 'Statut',
                                    controller: _selectstatut,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: "Description"),
                                  TextField(
                                      controller: description_controller,
                                      decoration: InputDecoration(
                                        hintText: 'description',
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: "Password *"),
                                  TextField(
                                    controller: password_controller,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      cameraImage(context);
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: Colors.blue),
                                      child: Icon(Icons.camera_alt_outlined,
                                          size: 25, color: Colors.white),
                                    ),
                                  ),
                                  SizedBox( height: 10),
                                  image_path.isNotEmpty ?
                                  SizedBox(
                                    width: 250, //
                                    height: 100,
                                    child: Image.network(
                                        HOST+"/media/"+image_path
                                    ),
                                  ) :Text("select image",textAlign: TextAlign.center,),
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
                        SizedBox(height: 10,),
                        LabelText(title: "* Champs obligatoires",)
                      ],
                    ),

                  ),
                ],
              ),
            )));
  }
  /**
   * validation de formulaire modifier et la preparation des données pour l'envoyer A l'api
   * @param: BuildContext context
   * @param: int id
   * @return: void
   */
  void update(context, int? id) async {

    if(adresse_controller.text.isNotEmpty
        && mail_controller.text.isNotEmpty
        && nom_controller.text.isNotEmpty
        && tel_controller.text.isNotEmpty
        //&& ville_controller.text.isNotEmpty
        && _selectstatut.getSelected()?.getValue() != null
        && _selectCivilite.getSelected()?.getValue() != null
        && _selectVilles.getSelected()?.getValue() != null
        //&& image_path.isNotEmpty
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

      var coach = <String, dynamic>{
        "id_coach": id,
        "nom_coach": nom_controller.text,
        "prenom_coach": prenom_controller.text,
        "image": image_path,
        "description": description_controller.text,
        "adresse": adresse_controller.text,
        "tel": tel_controller.text,
        "mail": mail_controller.text,
        "cin": cin_controller.text,
        "ville": _selectVilles.getSelected()?.getValue(),
        "civilite": _selectCivilite.getSelected()?.getValue(),
        "password": password_controller.text,
        "date_naissance": Date_naissance_controller.text,
        "date_dentree": Date_Entree_controller.text,
        "statut": _selectstatut.getSelected()?.getValue(),
      };

      print(coach);
      final response = await http.put(Uri.parse(
          HOST+"/api/coach/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode(coach),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          initData();

        }else{
          if(body['errors'].containsKey("mail")){
            showAlertDialog(context, "Cette adresse mail est déjà utilisée");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      } else {
        showAlertDialog(context, "Erreur ajout coach");
        //throw Exception('Failed to load data');
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }
  }
  /**
   * ui{formulaire de Modification Coach}
   * @param: BuildContext context
   * @return: void
   */
  void modal_update(context, Coach e, {bool? uploadImage=false}){

    if(!uploadImage!){
      nom_controller.text = e.nom_coach!;
      prenom_controller.text = e.prenom_coach!;
      adresse_controller.text = e.adresse!;
      tel_controller.text = e.tel!;
      mail_controller.text = e.mail!;
      ville_controller.text = e.ville!;
      description_controller.text = e.description == null ? "" : e.description!;
      cin_controller.text = e.cin!;
      Date_naissance_controller.text = e.date_naissance!.toString().split("T")[0];
      Date_Entree_controller.text = e.date_entree!.toString().split("T")[0];

      _selectstatut.setSelected(
          BsSelectBoxOption(value: e.statut, text: Text(e.statut! == 0 ? "actif" : "Inactif"))
      );
      _selectCivilite.setSelected(
          BsSelectBoxOption(value: e.civilite, text: Text(e.civilite!))
      );

      _selectVilles.setSelected(
          BsSelectBoxOption(value: e.id_ville, text: Text(e.ville!))
      );

      setState(() {
        image_path = e.image!;
      });
    }



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
                        Text('Modifier Coach',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        BsButton(
                          style: BsButtonStyle.outlinePrimary,
                          label: Text('Annuler'),
                          //prefixIcon: Icons.close,
                          onPressed: () {
                            initData();
                            Navigator.pop(context);
                          },
                        )
                      ],
                      //closeButton: true,

                  ),
                  BsModalContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                LabelText(title: "Civilite *"),
                                BsSelectBox(
                                  hintText: 'Civilite',
                                  controller: _selectCivilite,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "Nom *"),
                                TextField(
                                    controller: nom_controller,
                                    decoration: InputDecoration(
                                      hintText: 'Nom',
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "Prenom *"),
                                TextField(
                                  controller: prenom_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Prenom',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "Adresse *"),
                                TextField(
                                  controller: adresse_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Adresse',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "Numero de telephone *"),
                                TextField(
                                  controller: tel_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Numero de telephone',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "Email *"),
                                TextField(
                                  controller: mail_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: "CIN *"),
                                Container(
                                  width: double.infinity,
                                  child: TextField(
                                    controller: cin_controller,
                                    decoration: InputDecoration(
                                      hintText: 'CIN',
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  LabelText(title: "Villes *"),
                                  BsSelectBox(
                                    hintText: 'Villes',
                                    controller: _selectVilles,
                                    searchable: true,
                                    serverSide: searchVille,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: "Date de naissance *"),
                                  TextField(
                                    controller: Date_naissance_controller,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      hintText: 'Date de naissance',
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.parse(e.date_naissance!.toString().split("T")[0]),
                                        firstDate: DateTime(1975),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        String formattedDate =
                                        DateFormat("yyyy-MM-dd").format(pickedDate);
                                        setState(() {
                                          Date_naissance_controller.text =
                                              formattedDate.toString();
                                        });
                                      } else {
                                        print('Not selected');
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: "Date de recrutement *"),
                                  TextField(
                                    controller: Date_Entree_controller,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      hintText: 'Date de recrutement',
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDat = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.parse(e.date_entree!.toString().split("T")[0]),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDat != null) {
                                        String formattedDat =
                                        DateFormat('yyyy-MM-dd').format(pickedDat);
                                        setState(() {
                                          Date_Entree_controller.text =
                                              formattedDat.toString();
                                        });
                                      } else {
                                        print('Not selected');
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: "Statut *"),
                                  BsSelectBox(
                                    hintText: 'Statut',
                                    controller: _selectstatut,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: "Description"),
                                  TextField(
                                      controller: description_controller,
                                      decoration: InputDecoration(
                                        hintText: 'Description',
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: "Password *"),
                                  TextField(
                                    controller: password_controller,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      cameraImage(context, coach: e);
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: Colors.blue),
                                      child: Icon(Icons.camera_alt_outlined,
                                          size: 25, color: Colors.white),
                                    ),
                                  ),
                                  SizedBox( height: 10),
                                  image_path.isNotEmpty ?
                                  SizedBox(
                                    width: 250, //
                                    height: 100,
                                    child: Image.network(
                                        HOST+"/media/"+image_path
                                    ),
                                  ) :Text("select image",textAlign: TextAlign.center,),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            update(context, e.id_coach);
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
                        SizedBox(height: 15,),
                        LabelText(title: "nb * champ obligatoire")
                      ],
                    ),

                  ),

                ],
              ),
            )));
  }

  /**
   * Cette méthode est appelée une seule fois lors de la création du widget,( l'initialisation de l'état)
   * @return: void
   */
  var token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state");
    fetchCoach();
    getVilles();

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
              SideBar(postion: 3,msg:"Coach"),
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
                              screenSize.width > 520 ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Liste des Coachs", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
                                  InkWell(
                                    onTap: (){
                                      //
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
                                          child: Text("Ajouter Coach",
                                              style: TextStyle(
                                                  fontSize: 15
                                              )),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Liste des Coachs", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
                                  InkWell(
                                    onTap: (){
                                      //
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
                                          child: Icon(
                                              Icons.add,
                                              size: 18,
                                              color: Colors.white
                                          ),
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
                                              child: Text("aucun Coach à afficher")),
                                        )
                                            :
                                        DataTable(
                                          dataRowHeight: DataRowHeight,
                                          headingRowHeight: HeadingRowHeight,
                                          columnSpacing: 10,
                                          columns: screenSize.width > 800 ?
                                          <DataColumn>[
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Prénom coach',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Nom coach',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Tel',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ]:
                                          <DataColumn>[
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Nom Coach',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows:
                                          data.map<DataRow>((e) => DataRow(

                                            cells: screenSize.width > 800 ?
                                            <DataCell>[
                                              DataCell(Row(
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey[200],
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage('${HOST}/media/${e.image.toString()}')
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(width: 6,),
                                                  Text(e.prenom_coach.toString())
                                                ],
                                              )),
                                              DataCell(Text(e.nom_coach.toString())),
                                              DataCell(Text(e.tel.toString())),

                                              DataCell(Row(
                                                children: [
                                                  ShowButton(
                                                    msg:"•Visualisation des détails Coach",
                                                      onPressed: (){
                                                        showDialog(context: context, builder: (context) =>
                                                            BsModal(
                                                                context: context,
                                                                dialog: BsModalDialog(
                                                                  size: BsModalSize.md,
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
                                                                          Text('${e.nom_coach.toString()} ${e.prenom_coach.toString()}',
                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                          BsButton(
                                                                            style: BsButtonStyle.outlinePrimary,
                                                                            label: Text('Fermer'),
                                                                            //prefixIcon: Icons.close,
                                                                            onPressed: () {

                                                                              Navigator.pop(context);
                                                                              initData();


                                                                            },
                                                                          )
                                                                        ],


                                                                      ),
                                                                      /*BsModalContainer(title: Text('${e.nom_coach.toString()}',style: TextStyle(fontWeight: FontWeight.bold,
                                                                      color: Colors.grey),), closeButton: true),*/
                                                                      BsModalContainer(
                                                                        child: Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                width: 170,
                                                                                height: 120,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                    border: Border.all(color: Colors.grey),
                                                                                    color: Colors.grey[200],
                                                                                    image: DecorationImage(
                                                                                        fit: BoxFit.cover,
                                                                                        image: NetworkImage('${HOST}/media/${e.image.toString()}')
                                                                                    )
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 8,),
                                                                              Expanded(
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Text("Ville:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(width: 9,),
                                                                                          Text("${e.ville.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 4,),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text("Tel:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(width: 9,),
                                                                                          Text("${e.tel.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 4,),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text("Mail:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(width: 9,),
                                                                                          Text("${e.mail.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 4,),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text("Description:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(width: 9,),
                                                                                          Text("${e.description.toString()}"),
                                                                                        ],
                                                                                      ),

                                                                                      SizedBox(height: 4,),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text("Date_Entree:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(width: 9,),
                                                                                          Text("${e.date_entree.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 4,),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text("Date de naissance :" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(width: 9,),
                                                                                          Text(" ${e.date_naissance.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                              )
                                                                            ]
                                                                        ),
                                                                      ),
                                                                      BsModalContainer(
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        actions: [
                                                                          //Navigator.pop(context);
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                )));
                                                      }
                                                  ),
                                                  SizedBox(width: 10,),
                                                  EditerButton(
                                                    msg: "Mettre à jour les informations du Coach",
                                                    onPressed: (){
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //       builder: (context) => UpdateEtablissementScreen(etab: e,),
                                                      //     )).then((val)=>fetchEtabs()
                                                      // );
                                                      modal_update(context, e);
                                                    },
                                                  ),
                                                  SizedBox(width: 10,),
                                                  DeleteButton(
                                                    msg:"Supprimer le Coach ",
                                                    onPressed: () async {
                                                      if (await confirm(
                                                        context,
                                                        title: const Text('Confirmation'),
                                                        content: const Text('Souhaitez-vous supprimer ?'),
                                                        textOK: const Text('Oui'),
                                                        textCancel: const Text('Non'),
                                                      )) {

                                                        delete(e.id_coach.toString());
                                                      }

                                                    },
                                                  ),

                                                ],
                                              ))
                                            ]:
                                            <DataCell>[
                                              DataCell(Row(
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey[200],
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage('${HOST}/media/${e.image.toString()}')
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(width: 6,),
                                                  Expanded(
                                                    child: Text(e.nom_coach.toString(),
                                                    overflow: TextOverflow.ellipsis,),
                                                  )
                                                ],
                                              )),

                                              DataCell(Row(
                                                children: [
                                                  ShowButton(
                                                      msg:"•Visualisation des détails Coach",
                                                      onPressed: (){
                                                        showDialog(context: context, builder: (context) =>
                                                            BsModal(
                                                                context: context,
                                                                dialog: BsModalDialog(
                                                                  size: BsModalSize.md,
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
                                                                          Text('${e.nom_coach.toString()} ${e.prenom_coach.toString()}',
                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                          BsButton(
                                                                            style: BsButtonStyle.outlinePrimary,
                                                                            label: Text('Fermer'),
                                                                            //prefixIcon: Icons.close,
                                                                            onPressed: () {

                                                                              Navigator.pop(context);
                                                                              initData();


                                                                            },
                                                                          )
                                                                        ],


                                                                      ),
                                                                      /*BsModalContainer(title: Text('${e.nom_coach.toString()}',style: TextStyle(fontWeight: FontWeight.bold,
                                                                          color: Colors.grey),), closeButton: true),*/
                                                                      BsModalContainer(
                                                                        child: Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                width: 170,
                                                                                height: 120,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                    border: Border.all(color: Colors.grey),
                                                                                    color: Colors.grey[200],
                                                                                    image: DecorationImage(
                                                                                        fit: BoxFit.cover,
                                                                                        image: NetworkImage('${HOST}/media/${e.image.toString()}')
                                                                                    )
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 8,),
                                                                              Expanded(
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [

                                                                                      Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text("Ville:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(height: 4,),
                                                                                          Text("${e.ville.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 4,),
                                                                                      Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text("Tel:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(height: 4,),
                                                                                          Text("${e.tel.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 4,),
                                                                                      Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text("Mail:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(height: 4,),
                                                                                          Text("${e.mail.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 4,),
                                                                                      Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text("description:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(height: 4,),
                                                                                          Text("${e.description.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 4,),
                                                                                      Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text("Date_Entree:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(height: 4,),
                                                                                          Text("${e.date_entree.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 4,),
                                                                                      Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text("Date de naissance :" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(height: 4,),
                                                                                          Text(" ${e.date_naissance.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                              )
                                                                            ]
                                                                        ),
                                                                      ),
                                                                      BsModalContainer(
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        actions: [
                                                                          //Navigator.pop(context);
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                )));
                                                      }
                                                  ),
                                                  SizedBox(width: 10,),
                                                  EditerButton(
                                                    msg: "Mettre à jour les informations du Coach",
                                                    onPressed: (){
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //       builder: (context) => UpdateEtablissementScreen(etab: e,),
                                                      //     )).then((val)=>fetchEtabs()
                                                      // );
                                                      modal_update(context, e);
                                                    },
                                                  ),
                                                  SizedBox(width: 10,),
                                                  DeleteButton(
                                                    msg:"Supprimer le Coach ",
                                                    onPressed: () async {
                                                      if (await confirm(
                                                        context,
                                                        title: const Text('Confirmation'),
                                                        content: const Text('Souhaitez-vous supprimer ?'),
                                                        textOK: const Text('Oui'),
                                                        textCancel: const Text('Non'),
                                                      )) {

                                                        delete(e.id_coach.toString());
                                                      }

                                                    },
                                                  ),

                                                ],
                                              ))
                                            ],
                                          )).toList(),
                                        ),
                                      ]
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

