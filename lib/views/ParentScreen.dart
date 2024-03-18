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
import '../models/ClasseModel.dart';
import '../models/CoachModels.dart';
import '../models/ParentModels.dart';
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
import 'Affiliation.dart';
import 'UpdateEtablissement.dart';

class ParentScreen extends StatefulWidget {
   ParentScreen({Key? key , String? this.from}) : super(key: key);

  String? from;

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {

  List<Parent> data = [];
  List<Parent> init_data = [];
  List<Client> data5 = [];
  List<Client> init_data5 = [];
  bool loading = false;
  List<Classes> classes = [];
  List<Ville> villes = [];

  BsSelectBoxController _selectClasse = BsSelectBoxController();
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
  BsSelectBoxController _selectClasse5 = BsSelectBoxController();
  TextEditingController nom_controller5 = TextEditingController();
  TextEditingController adresse_controller5 = TextEditingController();
  TextEditingController description_controller5 = TextEditingController();
  TextEditingController prenom_controller5 = TextEditingController();
  TextEditingController tel_controller5 = TextEditingController();
  TextEditingController mail_controller5 = TextEditingController();
  TextEditingController cin_controller5 = TextEditingController();
  TextEditingController password_controller5 = TextEditingController();
  TextEditingController ville_controller5 = TextEditingController();
  TextEditingController Date_naissance_controller5 = TextEditingController();
  TextEditingController Date_Entree_controller5 = TextEditingController();
  String image_path = "";
  String image_path5 = "";
  BsSelectBoxController _selectEtudiant = BsSelectBoxController();
  final BsSelectBoxController _selectFilter = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 2, text: Text("Tous")),
        BsSelectBoxOption(value: 0, text: Text("Actifs")),
        BsSelectBoxOption(value: 1, text: Text("Inactifs")),
      ]
  );
  BsSelectBoxController _selectstatut = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 0, text: Text("Actif")),
        BsSelectBoxOption(value: 1, text: Text("Inactif")),
      ]
  );
  BsSelectBoxController _selectstatut5 = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 0, text: Text("Actif")),
        BsSelectBoxOption(value: 1, text: Text("Inactif")),
      ]
  );
  TextEditingController Date_inscription_controller = TextEditingController();
  TextEditingController Date_inscription_controller5 = TextEditingController();
  BsSelectBoxController _selectCivilite = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: "Madmoiselle", text: Text("Madmoiselle")),
        BsSelectBoxOption(value: "Madame", text: Text("Madame")),
        BsSelectBoxOption(value: "Monsieur", text: Text("Monsieur")),
      ]
  );
  BsSelectBoxController _selectCivilite5 = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: "Madmoiselle", text: Text("Madmoiselle")),
        BsSelectBoxOption(value: "Madame", text: Text("Madame")),
        BsSelectBoxOption(value: "Monsieur", text: Text("Monsieur")),
      ]
  );

  Uint8List? _bytesData;
  List<int>? _selectedFile;
  List<Client> etudiants = [];
  List<Client> Clients = [];
  int _index = 0;

  BsSelectBoxController _selectVilles = BsSelectBoxController();
  BsSelectBoxController _selectVilles5 = BsSelectBoxController();
  //final TextEditingController input_search = TextEditingController();
  String text_search = "";
  List<Widget> items = [];

  void fetchClient({bool? init=false, Client? etd}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/etudiants/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      print("--result--");
      print(result.length);
      setState(() {

        data5 = result.map<Client>((e) => Client.fromJson(e)).toList();
        init_data5 = result.map<Client>((e) => Client.fromJson(e)).toList();

        //dataSource = MyDataSource(data: data);
      });

      if(init!){
        _selectEtudiant.options = data5.map<BsSelectBoxOption>((c) =>
            BsSelectBoxOption(
                value: c.id_etudiant,
                text: Text("${c.nom} ${c.prenom}")
            )).toList();


        if(init){
          if(etd != null){
            print("client => ${etd.toJson()}");

            Client c = Clients.where((el) => el.id_etudiant == etd.id_etudiant).first;

            _selectEtudiant.setSelected(
                BsSelectBoxOption(
                    value: c.id_etudiant,
                    text: Text("${c.nom} ${c.prenom}")
                )
            );

          }
        }
      }
      print("--data--");
      print(data.length);
    } else {
      throw Exception('Failed to load data');
    }
    setState(() {
      loading = false;
    });
  }

  void add5(context) async {

    if(prenom_controller5.text.isNotEmpty
        && nom_controller5.text.isNotEmpty
        //&& ville_controller.text.isNotEmpty
        && _selectstatut5.getSelected()?.getValue() != null
        // && _selectVilles.getSelected()?.getValue() != null
        && _selectCivilite5.getSelected()?.getValue() != null
        && _selectClasse.getSelected()?.getValue() != null

    //&& image_path.isNotEmpty
    ){



      var client = <String, dynamic>{
        "nom": nom_controller5.text,
        "prenom": prenom_controller5.text,
        "image": image_path5,
        "adresse": adresse_controller5.text,
        "tel": tel_controller5.text,
        "mail": mail_controller5.text,
        "ville": _selectVilles5.getSelected()?.getValue(),
        "civilite": _selectCivilite5.getSelected()?.getValue(),
        "date_naissance": Date_naissance_controller5.text,
        "date_inscription": Date_inscription_controller5.text,
        "id_classe": _selectClasse.getSelected()?.getValue(),

      };
      if(image_path5.isNotEmpty){
        client["image"] = image_path5;
      }

      print(client);
      final response = await http.post(Uri.parse(
          HOST+"/api/etudiants2/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode(client),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          getEtudiants();
          initDataEtd();


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
  void initSelectClasse() {
    _selectClasse5.options = classes.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
          value: v.id_classe,
          text: Text("${v.niveau} - ${v.groupe} - ${v.nombre_etudiant}étudiants "),
        )).toList();

    /*Classes cla = classes.where((el) => el.niveau == "").first;
    _selectClasse.setSelected(BsSelectBoxOption(
      value: cla.id_classe,
      text: Text("${cla.niveau} - ${cla.groupe} - ${cla.nombre_etudiant}étudiants"),
    ));*/
  }
  void getClasses() async {
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

        classes = result.map<Classes>((e) => Classes.fromJson(e)).toList();


      });
      print("--data--");
      print(data.length);
      initSelectClasse();
    } else {
      throw Exception('Failed to load villes');
    }
  }
  Future<BsSelectBoxResponse> searchClasse(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in classes){
      if(v.niveau!.toLowerCase().contains(params["searchValue"]!.toLowerCase()) || v.groupe!.toLowerCase().contains(params["searchValue"]!.toLowerCase()) ){
        searched.add(
            BsSelectBoxOption(
                value: v.id_classe,
                text: Text("${v.niveau} - ${v.groupe} - ${v.nombre_etudiant} étudiants")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }

  Future cameraImage(context, {Parent? parent}) async {
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
            if(parent != null){
              Navigator.pop(context);
              modal_update(context, parent, uploadImage: true);
            }else{
              Navigator.pop(context);
              modal_add2(context);
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
  void filterParent(){
    if(_selectFilter.getSelected()?.getValue() != null){
      print(_selectFilter.getSelected()?.getValue());
      setState(() {
        data = [];
      });
      if(_selectFilter.getSelected()?.getValue() == 2){
        setState(() {
          data = init_data;
        });

      }
      if(_selectFilter.getSelected()?.getValue() == 0){
        setState(() {
          data = init_data.where((element) => (element.statut!) == true).toList();
        });

      }

      if(_selectFilter.getSelected()?.getValue() == 1){
        setState(() {
          data = init_data.where((element) => (element.statut!) == false).toList();
        });

      }

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

  void getVilles5() async {
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
      initSelectVilles5();
    } else {
      throw Exception('Failed to load villes');
    }
  }

  void initSelectVilles5() {
    _selectVilles5.options = villes.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
            value: v.id,
            text: Text("${v.nom_ville}")
        )).toList();
  }


  /**
   * lister tous les coach qui existe dans Notre base de donnée
   * @return: void
   */
  void fetchParent() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/Parentt/'),
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
        data = result.map<Parent>((e) => Parent.fromJson(e)).toList();
        init_data = result.map<Parent>((e) => Parent.fromJson(e)).toList();

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
        HOST+'/api/Parentt/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchParent();
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
      final List<Parent> founded = [];
      init_data.forEach((e) {
        if(e.nom!.toLowerCase().contains(key.toLowerCase())
            || e.prenom!.toLowerCase().contains(key.toLowerCase())
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
      title: Text("Parents"),
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
    password_controller.text = "";

    //_selectVilles.clear();
    //initSelectVilles();

    _selectCivilite.removeSelected(_selectCivilite.getSelected()!);
    _selectstatut.removeSelected(_selectstatut.getSelected()!);
    if(_selectClasse.getSelected() != null){
      _selectClasse.removeSelected(_selectClasse.getSelected()!);
    }

    _selectVilles.removeSelected(_selectVilles.getSelected()!);

    setState(() {
      image_path = "";
    });
    fetchParent();
  }


  void initDataEtd() {
    nom_controller5.text = "";
    prenom_controller5.text = "";
    adresse_controller5.text = "";
    tel_controller5.text = "";
    mail_controller5.text = "";
    ville_controller5.text = "";
    cin_controller5.text = "";
    Date_naissance_controller5.text = "";
    password_controller5.text = "";

    //_selectVilles.clear();
    //initSelectVilles();

    _selectCivilite5.removeSelected(_selectCivilite5.getSelected()!);
    _selectstatut5.removeSelected(_selectstatut5.getSelected()!);
    if(_selectClasse5.getSelected() != null){
      _selectClasse5.removeSelected(_selectClasse5.getSelected()!);
    }

    _selectVilles5.removeSelected(_selectVilles.getSelected()!);

    setState(() {
      image_path5 = "";
    });
  }
  /**
   * validation de formulaire et la preparation des données pour l'envoyer A l'api
   * @param: BuildContext context
   * @return: void
   */
  void add(context) async {

    if(prenom_controller.text.isNotEmpty
        && nom_controller.text.isNotEmpty
        && password_controller.text.isNotEmpty
        && _selectstatut.getSelected()?.getValue() != null
         && _selectVilles.getSelected()?.getValue() != null
        && _selectCivilite.getSelected()?.getValue() != null

        && _selectEtudiant.getSelected()?.getValue() != null
    //&& image_path.isNotEmpty
    ){



      var client = <String, dynamic>{
        "nom": nom_controller.text,
        "prenom": prenom_controller.text,
        "image": image_path,
        "adresse": adresse_controller.text,
        "tel": tel_controller.text,
        "mail": mail_controller.text,
         //"cin": cin_controller.text,
        "cin": "",
         "ville": _selectVilles.getSelected()?.getValue(),
         "civilite": _selectCivilite.getSelected()?.getValue(),
         "password": password_controller.text,
        // "date_naissance": Date_naissance_controller.text,
        "statut": _selectstatut.getSelected()?.getValue(),
        "etudiant_id": _selectEtudiant.getSelected()?.getValue()
      };
      if(image_path.isNotEmpty){
        client["image"] = image_path;
      }

      print(client);
      final response = await http.post(Uri.parse(
          HOST+"/api/Parentt/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode(client),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          fetchParent();
          initData();
//           if(body["client"] != null){
//             Navigator.pop(context);
//             fetchParent();
//             initData();
//             /*Client client = Client.fromJson(body["client"]);
//
//             //Navigator.pop(context);
//             //initData();
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                         AfilliationScreen(client: client),));
// */
//           }

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
  // void add(context) async {
  //
  //   if(adresse_controller.text.isNotEmpty
  //       && mail_controller.text.isNotEmpty
  //       && nom_controller.text.isNotEmpty
  //       && tel_controller.text.isNotEmpty
  //       && password_controller.text.isNotEmpty
  //       //&& ville_controller.text.isNotEmpty
  //       && _selectstatut.getSelected()?.getValue() != null
  //       && _selectCivilite.getSelected()?.getValue() != null
  //       && _selectVilles.getSelected()?.getValue() != null
  //   // && image_path.isNotEmpty
  //   ){
  //
  //
  //     final bool emailValid =
  //     RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //         .hasMatch(mail_controller.text);
  //
  //     final bool phoneValid =
  //     RegExp(r"^(?:[+0]9)?[0-9]{10}$")
  //         .hasMatch(tel_controller.text);
  //
  //     if(!emailValid){
  //       showAlertDialog(context, "Email n'est pas valide");
  //       return;
  //     }
  //
  //     if(!phoneValid){
  //       showAlertDialog(context, "Telphone n'est pas valide");
  //       return;
  //     }
  //
  //     var coach = <String, dynamic>{
  //       "nom": nom_controller.text,
  //       "prenom": prenom_controller.text,
  //       "image": image_path,
  //       "adresse": adresse_controller.text,
  //       "tel": tel_controller.text,
  //       "mail": mail_controller.text,
  //       //"cin": cin_controller.text,
  //       "cin": "",
  //       "ville": _selectVilles.getSelected()?.getValue(),
  //       "civilite": _selectCivilite.getSelected()?.getValue(),
  //       "password": password_controller.text,
  //      // "date_naissance": Date_naissance_controller.text,
  //       "statut": _selectstatut.getSelected()?.getValue(),
  //     };
  //     if(image_path.isNotEmpty){
  //       coach["image"] = image_path;
  //     }
  //
  //     print(coach);
  //     final response = await http.post(Uri.parse(
  //         HOST+"/api/Parentt/"),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization': 'Bearer $token',
  //       },
  //
  //       body: jsonEncode(coach),
  //     );
  //
  //     if (response.statusCode == 200) {
  //
  //       final body = json.decode(response.body);
  //       final status = body["status"];
  //       if(status == true){
  //         // Navigator.pop(context);
  //         // initData();
  //         if(body["parent"] != null){
  //           Parent parent = Parent.fromJson(body["parent"]);
  //
  //           //Navigator.pop(context);
  //           //initData();
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) =>
  //                     AfilliationScreen(parent: parent),));
  //
  //         }
  //
  //
  //       }else{
  //         if(body['errors'].containsKey("mail")){
  //           showAlertDialog(context, "Cette adresse mail est déjà utilisée");
  //           return;
  //         }
  //         showAlertDialog(context, body["msg"]);
  //       }
  //     } else {
  //       showAlertDialog(context, "Erreur ajout parent");
  //       //throw Exception('Failed to load data');
  //     }
  //   }else{
  //     showAlertDialog(context, "Remplir tous les champs");
  //   }
  //
  // }
  /**
   * ui{formulaire d'ajout Coach}
   * @param: BuildContext context
   * @return: void
   */

  void getEtudiants({bool? init=false}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/etudiants/'),
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
        etudiants = result.map<Client>((e) => Client.fromJson(e)).toList();
      });
      _selectEtudiant.options = etudiants.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_etudiant,
              text: Text("${c.nom} ${c.prenom}")
          )).toList();

      print("--data--");
      print(etudiants.length);

    } else {
      throw Exception('Failed to load data');
    }
  }

  void modal_add(context){

    String formattedDat = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() {
      Date_inscription_controller.text =
          formattedDat.toString();
    });

    _selectstatut5.setSelected(BsSelectBoxOption(value: 1, text: Text("Actif")));

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
                      Text('Ajouter Etudiant',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Annuler'),
                        //prefixIcon: Icons.close,
                        onPressed: () {

                          Navigator.pop(context);
                          initDataEtd();
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

                                    LabelText(title: "Nom *"),
                                    TextField(
                                      decoration: InputDecoration(
                                          hintText: "Nom"
                                      ),
                                      controller: nom_controller5,
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    LabelText(title: "Civilité *"),
                                    BsSelectBox(
                                      hintText: 'Civilité',
                                      controller: _selectCivilite5,
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    LabelText(title: "Email "),
                                    TextField(
                                      controller: mail_controller5,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    LabelText(title: "Date de naissance *"),
                                    TextField(
                                      controller: Date_naissance_controller5,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        hintText: 'Date de naissance',

                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime(2000),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime.now().subtract(Duration(days: 365*4)),
                                          //lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          String formattedDate =
                                          DateFormat("yyyy-MM-dd").format(pickedDate);
                                          setState(() {
                                            Date_naissance_controller5.text =
                                                formattedDate.toString();
                                          });
                                        } else {
                                          print('Not selected');
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    LabelText(title: "Statut *"),
                                    BsSelectBox(
                                      hintText: 'Statut',
                                      controller: _selectstatut5,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),
                                    LabelText(title: "Ville *"),
                                    BsSelectBox(
                                      hintText: 'Ville',
                                      controller: _selectVilles5,
                                      searchable: true,
                                      serverSide: searchVille,
                                    ),

                                  ]),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SizedBox(
                                  //   height: 72,
                                  // ),
                                  LabelText(title: "Prenom *"),
                                  TextField(
                                    controller: prenom_controller5,
                                    decoration: InputDecoration(
                                      hintText: 'Prenom',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),

                                  LabelText(title: "Numéro de téléphone *"),
                                  TextField(
                                    controller: tel_controller5,
                                    decoration: InputDecoration(
                                      hintText: 'Numéro de téléphone',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  LabelText(title: "Date d'nscription *"),
                                  TextField(
                                    controller: Date_inscription_controller5,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      hintText: 'Date d\'nscription',

                                    ),
                                    // enabled: false,
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
                                          Date_inscription_controller5.text =
                                              formattedDat.toString();
                                        });
                                      } else {
                                        print('Not selected');
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  LabelText(title: "classe *"),
                                  BsSelectBox(
                                    hintText: 'classe',
                                    controller: _selectClasse,
                                    searchable: true,
                                    serverSide: searchClasse,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    height:9,
                                  ),
                                  LabelText(title: "Adresse "),
                                  TextField(
                                    controller: adresse_controller5,
                                    decoration: InputDecoration(
                                      hintText: 'Adresse',
                                    ),
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
                                  SizedBox( height: 8),
                                  image_path5.isNotEmpty ?
                                  SizedBox(
                                    width: 250, //
                                    height: 100,
                                    child: Image.network(
                                        HOST+"/media/"+image_path5
                                    ),
                                  ) :Text("select image",textAlign: TextAlign.center,),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [

                            SizedBox(width: 45,),
                            InkWell(
                              onTap: (){

                                add5(context);

                              },
                              child: Container(
                                child:
                                Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
                                height: 30,
                                width: 110,
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
                        SizedBox(height: 4,),
                        LabelText(title: ' nb * champ obligatoire')
                      ],
                    ),

                  ),

                ],
              ),
            )));
  }

  // void modal_add(context, {bool init=false}){
  //
  //   _selectstatut.setSelected(BsSelectBoxOption(value: 0, text: Text("Actif")));
  //
  //   showDialog(context: context, builder: (context) =>
  //       BsModal(
  //           context: context,
  //
  //           dialog: BsModalDialog(
  //             size: BsModalSize.lg,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             child: BsModalContent(
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //               ),
  //               children: [
  //                 BsModalContainer(
  //                   //title:
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   actions: [
  //                     Text('Ajouter Parent',
  //                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //                     BsButton(
  //                       style: BsButtonStyle.outlinePrimary,
  //                       label: Text('Annuler'),
  //                       //prefixIcon: Icons.close,
  //                       onPressed: () {
  //
  //                         Navigator.pop(context);
  //                         initData();
  //                       },
  //                     )
  //                   ],
  //                   //closeButton: true,
  //
  //                 ),
  //                 BsModalContainer(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Expanded(
  //                             flex: 1,
  //                             child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   LabelText(title: "Nom *"),
  //                                   TextField(
  //                                       controller: nom_controller,
  //                                       decoration: InputDecoration(
  //                                         hintText: 'Nom',
  //                                       )),
  //                                   SizedBox(
  //                                     height: 10,
  //                                   ),
  //                                   LabelText(title: "Civilité *"),
  //                                   BsSelectBox(
  //                                     hintText: 'Civilité',
  //                                     controller: _selectCivilite,
  //                                   ),
  //                                   SizedBox(
  //                                     height: 10,
  //                                   ),
  //
  //                                   // LabelText(title: "Prenom *"),
  //                                   // TextField(
  //                                   //   controller: prenom_controller,
  //                                   //   decoration: InputDecoration(
  //                                   //     hintText: 'Prenom ',
  //                                   //
  //                                   //   ),
  //                                   // ),
  //                                   // SizedBox(
  //                                   //   height: 10,
  //                                   // ),
  //                                   LabelText(title: "Adresse *"),
  //                                   TextField(
  //                                     controller: adresse_controller,
  //                                     decoration: InputDecoration(
  //                                       hintText: 'Adresse',
  //                                     ),
  //                                   ),
  //                                   SizedBox(
  //                                     height: 10,
  //                                   ),
  //                                   LabelText(title: "Numero de telephone *"),
  //                                   TextField(
  //                                     controller: tel_controller,
  //                                     decoration: InputDecoration(
  //                                       hintText: 'Numero de telephone',
  //
  //                                     ),
  //                                   ),
  //
  //                                   SizedBox(
  //                                     height: 10,
  //                                   ),
  //                                   LabelText(title: "Password *"),
  //                                   TextField(
  //                                     controller: password_controller,
  //                                     decoration: InputDecoration(
  //                                       hintText: 'Password',
  //                                     ),
  //                                   ),
  //
  //                                 ]),
  //                           ),
  //                           SizedBox(
  //                             width: 10,
  //                           ),
  //
  //                           Expanded(
  //                             flex: 1,
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 LabelText(title: "Prenom *"),
  //                                 TextField(
  //                                   controller: prenom_controller,
  //                                   decoration: InputDecoration(
  //                                     hintText: 'Prenom ',
  //
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10,
  //                                 ),
  //                                 LabelText(title: "Statut *"),
  //                                 BsSelectBox(
  //                                   hintText: 'Statut',
  //                                   controller: _selectstatut,
  //                                 ),
  //
  //                                 SizedBox(
  //                                   height: 10,
  //                                 ),
  //
  //                                 LabelText(title: "Villes *"),
  //                                 BsSelectBox(
  //                                   hintText: 'Villes',
  //                                   controller: _selectVilles,
  //                                   searchable: true,
  //                                   serverSide: searchVille,
  //                                 ),
  //                                 SizedBox(
  //                                   height: 10,
  //                                 ),
  //                                 LabelText(title: "Email *"),
  //                                 TextField(
  //                                   controller: mail_controller,
  //                                   decoration: InputDecoration(
  //                                     hintText: 'Email',
  //                                   ),
  //                                 ),
  //
  //                                 SizedBox(
  //                                   height: 10,
  //                                 ),
  //                                 InkWell(
  //                                   onTap: () {
  //                                     cameraImage(context);
  //                                   },
  //                                   child: Container(
  //                                     width: 50,
  //                                     height: 30,
  //                                     decoration: BoxDecoration(
  //                                         borderRadius: BorderRadius.circular(6),
  //                                         color: Colors.blue),
  //                                     child: Icon(Icons.camera_alt_outlined,
  //                                         size: 25, color: Colors.white),
  //                                   ),
  //                                 ),
  //                                 SizedBox( height: 10),
  //                                 image_path.isNotEmpty ?
  //                                 SizedBox(
  //                                   width: 250, //
  //                                   height: 100,
  //                                   child: Image.network(
  //                                       HOST+"/media/"+image_path
  //                                   ),
  //                                 ) :Text("select image",textAlign: TextAlign.center,),
  //                               ],
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                       SizedBox(height: 15,),
  //                       InkWell(
  //                         onTap: (){
  //                           add(context);
  //                         },
  //                         child: Container(
  //                           child:
  //                           Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
  //                           height: 40,
  //                           width: 120,
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(6),
  //                               color: Colors.blue,
  //                               border: Border.all(
  //                                   color: Colors.blueAccent
  //                               )
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(height: 10,),
  //                       LabelText(title: "* Champs obligatoires",)
  //                     ],
  //                   ),
  //
  //                 ),
  //               ],
  //             ),
  //           )));
  // }

  void modal_add2(context, {bool init=false}){
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    _selectstatut.setSelected(BsSelectBoxOption(value: 0, text: Text("Actif")));

    //var etab = Etablissements.where((element) => element.id_etablissement == _selectEtablissement.getSelected()?.getValue()).first;

    if(init){
      // date_debut_controller.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
      // _selectType.setSelected(BsSelectBoxOption(value: 1, text: Text("Entrée")));
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
                      Text('Ajouter un Parent',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      //Text("${etab.nom_etablissement}"),
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
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(height: 440.0),
                        child: Stepper(
                          currentStep: _index,
                          type: StepperType.horizontal,
                          controlsBuilder: (context, ControlsDetails details) {
                            return Padding(
                              padding:  EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top:40.0),
                                    child: TextButton(
                                      onPressed: details.onStepCancel,
                                      child:Text('Précédant',
                                          style: TextStyle(color:Colors.blue,fontSize:15,fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:40.0),
                                    child: TextButton(
                                      onPressed: details.onStepContinue,
                                      child: _index < 2 ?
                                      Text('Suivant', style: TextStyle(color:Colors.blue,fontSize:15,fontWeight: FontWeight.bold))
                                          : Text('Enregistrer', style: TextStyle(color:Colors.blue,fontSize:15,fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onStepCancel: () {
                            if (_index > 0) {
                              setState(() {
                                _index -= 1;
                              });
                              Navigator.pop(context);
                              modal_add2(context);
                            }
                          },
                          onStepContinue: () {
                            print(_index);
                            if(_index == 0){
                              if(
                              prenom_controller.text.isNotEmpty
                                  && nom_controller.text.isNotEmpty
                                  //&& ville_controller.text.isNotEmpty
                                  && _selectstatut.getSelected()?.getValue() != null
                                   && _selectVilles.getSelected()?.getValue() != null
                                  && _selectCivilite.getSelected()?.getValue() != null


                              ){
                                setState(() {
                                  _index = 1;
                                });
                                Navigator.pop(context);
                                modal_add2(context);
                              }else{
                                showAlertDialog(context,"remplire tous les champs");
                              }

                            }else{
                              if(_index == 1){
                                print("step 2");
                                if(_selectEtudiant.getSelected()?.getValue() != null){
                                  items.clear();
                                  Client parent = etudiants.where((a) => a.id_etudiant == _selectEtudiant.getSelected()?.getValue()).first;
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text("information Parent: ",
                                                style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,color: Colors.blue)),
                                          ),

                                        ],
                                      )
                                  );
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Etudiant: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${nom_controller.text} ${prenom_controller.text}")
                                        ],
                                      )
                                  );

                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(child: Text(" Information Parent: ",
                                              style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,color: Colors.blue))),

                                        ],
                                      )
                                  );
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Etudiant: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${parent.civilite}  ${parent.nom} ${parent.prenom}")
                                        ],
                                      )
                                  );
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Ville: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${parent.ville}")
                                        ],
                                      )
                                  );
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${parent.mail}")
                                        ],
                                      )
                                  );
                                  setState(() {
                                    _index += 1;
                                  });
                                  Navigator.pop(context);
                                  modal_add2(context);
                                }else{
                                  print("alert step 2");
                                  showAlertDialog(context, "Remplir tout les champs");
                                }

                              }else{
                                if(_index == 2){
                                  print("save step");
                                  add(context);
                                }
                              }
                            }
                          },

                          steps: <Step>[
                            Step(
                              title: Text('Informations Parent', style: TextStyle(color: _index == 0 ? Colors.blue : Colors.grey),),
                              content:  Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              LabelText(
                                                  title: 'Nom *'
                                              ),
                                              TextField(
                                                decoration: InputDecoration(
                                                    hintText: "Nom"
                                                ),
                                                controller: nom_controller,
                                              ),
                                            ],
                                          )
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              LabelText(
                                                  title: "Prenom *"
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              TextField(
                                                controller: prenom_controller,
                                                decoration: InputDecoration(
                                                  hintText: 'Prenom',
                                                ),
                                              ),

                                            ],
                                          )
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              LabelText(
                                                  title: "Civilité *"
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              BsSelectBox(
                                                hintText: 'Civilité',
                                                controller: _selectCivilite,
                                              ),

                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
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
                                              LabelText(
                                                  title: 'Staut '
                                              ),
                                              BsSelectBox(
                                                hintText: 'Statut',
                                                controller: _selectstatut,
                                              ),
                                            ],
                                          )
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              LabelText(
                                                  title: "Email "
                                              ),
                                              TextField(
                                                controller: mail_controller,
                                                decoration: InputDecoration(
                                                  hintText: 'Email',
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              LabelText(
                                                  title: "tel "
                                              ),
                                              TextField(
                                                controller: tel_controller,
                                                decoration: InputDecoration(
                                                  hintText: 'Numéro de téléphone',
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              LabelText(
                                                  title: 'Adresse *'
                                              ),
                                              TextField(
                                                controller: adresse_controller,
                                                decoration: InputDecoration(
                                                  hintText: 'Adresse',
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              LabelText(
                                                  title: 'ville '
                                              ),
                                              BsSelectBox(
                                                hintText: 'Ville',
                                                controller: _selectVilles,
                                                searchable: true,
                                                serverSide: searchVille,
                                              ),

                                            ],
                                          )
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              LabelText(title: "Password *"),
                                              TextField(
                                                controller: password_controller,
                                                decoration: InputDecoration(
                                                  hintText: 'Password',
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
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
                                              SizedBox( height: 8),
                                              image_path.isNotEmpty ?
                                              SizedBox(
                                                width: 250, //
                                                height: 100,
                                                child: Image.network(
                                                    HOST+"/media/"+image_path
                                                ),
                                              ) :Text("select image",textAlign: TextAlign.center,),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Step(
                              title: Text('Affiliation', style: TextStyle(color: _index == 1 ? Colors.blue : Colors.grey),),

                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            LabelText(title: "Etudiant"),
                                            SizedBox(height: 10,),
                                            BsSelectBox(
                                              controller: _selectEtudiant,
                                              hintText: "Etudiant",
                                              searchable: true,
                                              //serverSide: searchParent,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 2,),
                                      Padding(
                                        padding: const EdgeInsets.only(top:25.0),
                                        child: Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: InkWell(
                                                  onTap: (){
                                                     modal_add(context);
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //       builder: (context) =>
                                                    //           ParentScreen(from: "etudiant"),));
                                                  },
                                                  child: Tooltip(
                                                    message: "Ajouter Etudiant",
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue, // Couleur de fond du tooltip
                                                      borderRadius: BorderRadius.circular(8.0), // Optionnel : coins arrondis
                                                    ),
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(color: Colors.lightBlue)
                                                      ),
                                                      child: Center(
                                                        child: Icon(Icons.add, size: 15, color: Colors.orange),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Step(
                              title: Text('Vérification', style: TextStyle(color: _index == 2 ? Colors.blue : Colors.grey),),
                              content: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.8,color: Colors.grey),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: items,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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
        "id_parent": id,
        "nom": nom_controller.text,
        "prenom": prenom_controller.text,
        "image": image_path,
        "adresse": adresse_controller.text,
        "tel": tel_controller.text,
        "mail": mail_controller.text,
        "password": password_controller.text,
        //"cin": cin_controller.text,
        "ville": _selectVilles.getSelected()?.getValue(),
        "civilite": _selectCivilite.getSelected()?.getValue(),
        //"date_naissance": Date_naissance_controller.text,
        "statut": _selectstatut.getSelected()?.getValue(),
      };

      print(coach);
      final response = await http.put(Uri.parse(
          HOST+"/api/Parentt/"),
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
        showAlertDialog(context, "Erreur editer Parent");
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
  void modal_update(context, Parent e, {bool? uploadImage=false}){

    if(!uploadImage!){
      nom_controller.text = e.nom!;
      prenom_controller.text = e.prenom!;
      adresse_controller.text = e.adresse!;
      tel_controller.text = e.tel!;
      mail_controller.text = e.mail!;
      ville_controller.text = e.ville!;
      // cin_controller.text = e.cin!;
      // Date_naissance_controller.text = e.date_naissance!.toString().split("T")[0];


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
                      Text('Modifier Parent',
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
                                    LabelText(title: "Nom *"),
                                    TextField(
                                        controller: nom_controller,
                                        decoration: InputDecoration(
                                          hintText: 'Nom',
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    LabelText(title: "Civilité *"),
                                    BsSelectBox(
                                      hintText: 'Civilité',
                                      controller: _selectCivilite,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                    // LabelText(title: "Prenom *"),
                                    // TextField(
                                    //   controller: prenom_controller,
                                    //   decoration: InputDecoration(
                                    //     hintText: 'Prenom ',
                                    //
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
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
                                    LabelText(title: "Password *"),
                                    TextField(
                                      controller: password_controller,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
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
                                  LabelText(title: "Statut *"),
                                  BsSelectBox(
                                    hintText: 'Statut',
                                    controller: _selectstatut,
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

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
                                  InkWell(
                                    onTap: () {
                                      cameraImage(context, parent: e);
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
                            update(context, e.id_parent);
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
    fetchParent();
    getEtudiants();
    getVilles();
    getVilles5();

    getClasses();

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
              //Bar(postion: 222,msg:"Parent"),
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
                                child: Center(child: Text("Parents", style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.w700,
                                    color: Colors.black)),),
                              ),
                              SizedBox(height: 30,),
                              screenSize.width > 520 ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex:4,
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
                                    flex: 2,
                                    child: Container(
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: BsSelectBox(
                                        hintText: 'Filtrer',
                                        controller: _selectFilter,
                                        onChange: (v){
                                          filterParent();
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Expanded(
                                    flex: 2,
                                    child: Container(

                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Expanded(
                                    flex:3,
                                    child: InkWell(
                                      onTap: (){
                                        //
                                        modal_add2(context);
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
                                            child: Text("Ajouter Parent",
                                                style: TextStyle(
                                                    fontSize: 15
                                                )),
                                          ),
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
                                  Text("Liste des Parents", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
                                  InkWell(
                                    onTap: (){
                                      //
                                      modal_add2(context);
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
                                              child: Text("aucun Parent à afficher")),
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
                                                  'Prénom Parent',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Nom Parent',
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
                                                  'Nom Parent',
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
                                                  Text(e.prenom.toString())
                                                ],
                                              )),
                                              DataCell(Text(e.nom.toString())),
                                              DataCell(Text(e.tel.toString())),

                                              DataCell(Row(
                                                children: [
                                                  ShowButton(
                                                      msg:"•Visualisation des détails Parent",
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
                                                                          Text('${e.nom.toString()} ${e.prenom.toString()}',
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
                                                                                          Text("Nom complet:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(width: 9,),
                                                                                          Text("${e.nom.toString()} ${e.prenom.toString()}"),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 4,),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text("Adresse:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(width: 9,),
                                                                                          Text("${e.adresse.toString()}"),
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
                                                    msg: "Mettre à jour les informations du Parent",
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
                                                  // SizedBox(width: 10,),
                                                  // DeleteButton(
                                                  //   msg:"Supprimer le Parent ",
                                                  //   onPressed: () async {
                                                  //     if (await confirm(
                                                  //       context,
                                                  //       title: const Text('Confirmation'),
                                                  //       content: const Text('Souhaitez-vous supprimer ?'),
                                                  //       textOK: const Text('Oui'),
                                                  //       textCancel: const Text('Non'),
                                                  //     )) {
                                                  //       delete(e.id_parent.toString());
                                                  //     }
                                                  //
                                                  //   },
                                                  // ),

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
                                                    child: Text(e.nom.toString(),
                                                      overflow: TextOverflow.ellipsis,),
                                                  )
                                                ],
                                              )),

                                              DataCell(Row(
                                                children: [
                                                  ShowButton(
                                                      msg:"•Visualisation des détails Parent",
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
                                                                          Text('${e.nom.toString()} ${e.prenom.toString()}',
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
                                                                                          Text("nom complet:" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(height: 4,),
                                                                                          Text("${e.nom.toString()} ${e.prenom.toString()}"),
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
                                                                                          Text("Adresse :" ,style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color:Colors.grey
                                                                                          ),),
                                                                                          SizedBox(height: 4,),
                                                                                          Text(" ${e.adresse.toString()}"),
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
                                                    msg: "Mettre à jour les informations du Parent",
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
                                                  // SizedBox(width: 10,),
                                                  // DeleteButton(
                                                  //   msg:"Supprimer le Parent ",
                                                  //   onPressed: () async {
                                                  //     if (await confirm(
                                                  //       context,
                                                  //       title: const Text('Confirmation'),
                                                  //       content: const Text('Souhaitez-vous supprimer ?'),
                                                  //       textOK: const Text('Oui'),
                                                  //       textCancel: const Text('Non'),
                                                  //     )) {
                                                  //
                                                  //       delete(e.id_parent.toString());
                                                  //     }
                                                  //
                                                  //   },
                                                  // ),

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

