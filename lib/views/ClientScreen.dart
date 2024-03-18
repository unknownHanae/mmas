import 'package:adminmmas/componnents/showButton.dart';
import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/ClientModels.dart';
import 'package:adminmmas/models/Ville.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:provider/provider.dart';
import '../componnents/contractButton.dart';
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../models/ClasseModel.dart';
import '../models/EtablissementModels.dart';
import '../models/ParentModels.dart';
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
import 'ContratScreen.dart';
import 'CustomerContratScreen.dart';
import 'ParentScreen.dart';
import 'UpdateEtablissement.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {

  List<Client> data = [];
  List<Client> init_data = [];
  bool loading = false;

  List<Ville> villes = [];

  int _index = 0;


  TextEditingController nom_controller2 = TextEditingController();
  TextEditingController adresse_controller2 = TextEditingController();
  TextEditingController description_controller2 = TextEditingController();
  TextEditingController prenom_controller2 = TextEditingController();
  TextEditingController tel_controller2 = TextEditingController();
  TextEditingController mail_controller2 = TextEditingController();
  TextEditingController cin_controller2 = TextEditingController();
  TextEditingController password_controller2 = TextEditingController();
  TextEditingController ville_controller2 = TextEditingController();
  TextEditingController Date_naissance_controller2 = TextEditingController();
  TextEditingController Date_Entree_controller2 = TextEditingController();

  String image_path2 = "";

  TextEditingController nom_controller = TextEditingController();
  TextEditingController adresse_controller = TextEditingController();
  TextEditingController prenom_controller = TextEditingController();
  TextEditingController tel_controller = TextEditingController();
  TextEditingController mail_controller = TextEditingController();
  TextEditingController cin_controller = TextEditingController();
  TextEditingController ville_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController Date_naissance_controller = TextEditingController();
  TextEditingController Date_inscription_controller = TextEditingController();

  String image_path = "";
  BsSelectBoxController _selectstatut2 = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 1, text: Text("Actif")),
        BsSelectBoxOption(value: 0, text: Text("Inactif")),
      ]
  );
  BsSelectBoxController _selectstatut = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 1, text: Text("Actif")),
        BsSelectBoxOption(value: 0, text: Text("Inactif")),
      ]
  );
  List<Widget> items = [];
  BsSelectBoxController _selectCivilite2 = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: "Madmoiselle", text: Text("Madmoiselle")),
        BsSelectBoxOption(value: "Madame", text: Text("Madame")),
        BsSelectBoxOption(value: "Monsieur", text: Text("Monsieur")),
      ]
  );

  BsSelectBoxController _selectCivilite = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: "Madmoiselle", text: Text("Madmoiselle")),
        BsSelectBoxOption(value: "Madame", text: Text("Madame")),
        BsSelectBoxOption(value: "Monsieur", text: Text("Monsieur")),
      ]
  );
  List<Classes> clas = [];
  final BsSelectBoxController _selectFilter = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 2, text: Text("Tous")),
        BsSelectBoxOption(value: 0, text: Text("Actifs")),
        BsSelectBoxOption(value: 1, text: Text("Inactifs")),
      ]
  );

  List<Classes> classes = [];
  List<Etablissement> Etablissements = [];
  BsSelectBoxController _selectEtablissement = BsSelectBoxController();

  //_selectBlacklist.setSelected(BsSelectBoxOption(value: 0, text: Text("Non")));
  BsSelectBoxController _selectVilles2 = BsSelectBoxController();
  BsSelectBoxController _selectVilles = BsSelectBoxController();
  BsSelectBoxController _selectClasse = BsSelectBoxController();

  Uint8List? _bytesData;
  List<int>? _selectedFile;
  List<Parent> parents = [];
  List<Client> etudiants = [];
  List<Client> Clients = [];
  //final TextEditingController input_search = TextEditingController();
  String text_search = "";
  Future<BsSelectBoxResponse> searchParent(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in parents){
      var name = "${v.nom}${v.prenom} ";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_parent,
                text: Text("${v.nom}  ${v.prenom} ")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }

  Future<BsSelectBoxResponse> searchClient(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in init_data){
      var name = "${v.nom}${v.prenom} ";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_etudiant,
                text: Text("${v.nom}  ${v.prenom} ")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }

  String id_affiliation = "";
  String parent = "";


  Future<void> cameraImage(context, {Client? client}) async {

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
          final selectedFile = Uint8List.fromList(bytesData);

          final clientName = client?.nom ?? 'default_name';
          final nom = "$clientName.jpg";
          var url = Uri.parse(HOST + "/api/saveImage/");
          var request = http.MultipartRequest("POST", url);
          request.files.add(await http.MultipartFile.fromBytes(
            'uploadedFile',
            selectedFile,
            contentType: MediaType("application", "json"),
            filename: nom,
            // filename: "image-client",
          ));

          print("-------------------------");
          print(nom);
          request.fields["path"] = "client/" ;

          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          final body = Map<String, dynamic>.from(json.decode(responseString));
          print(responseString);

          if (response.statusCode == 200) {
            setState(() {
              image_path = body['path'];
            });
            if (client != null) {
              Navigator.pop(context);
              modal_ubdate(context, client, uploadImage: true);
            } else {
              Navigator.pop(context);
              modal_add2(context);
            }
          } else {
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

  void add3(context) async {

    if(adresse_controller2.text.isNotEmpty
        && mail_controller2.text.isNotEmpty
        && nom_controller2.text.isNotEmpty
        && tel_controller2.text.isNotEmpty
        && password_controller2.text.isNotEmpty
        //&& ville_controller.text.isNotEmpty
        && _selectstatut2.getSelected()?.getValue() != null
        && _selectCivilite2.getSelected()?.getValue() != null
        && _selectVilles2.getSelected()?.getValue() != null
    // && image_path.isNotEmpty
    ){


      final bool emailValid =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(mail_controller2.text);

      final bool phoneValid =
      RegExp(r"^(?:[+0]9)?[0-9]{10}$")
          .hasMatch(tel_controller2.text);

      if(!emailValid){
        showAlertDialog(context, "Email n'est pas valide");
        return;
      }

      if(!phoneValid){
        showAlertDialog(context, "Telphone n'est pas valide");
        return;
      }

      var coach = <String, dynamic>{
        "nom": nom_controller2.text,
        "prenom": prenom_controller2.text,
        "image": image_path2,
        "adresse": adresse_controller2.text,
        "tel": tel_controller2.text,
        "mail": mail_controller2.text,
        //"cin": cin_controller.text,
        "cin": "",
        "ville": _selectVilles2.getSelected()?.getValue(),
        "civilite": _selectCivilite2.getSelected()?.getValue(),
        "password": password_controller2.text,
        // "date_naissance": Date_naissance_controller.text,
        "statut": _selectstatut2.getSelected()?.getValue(),
      };
      if(image_path2.isNotEmpty){
        coach["image"] = image_path2;
      }

      print(coach);
      final response = await http.post(Uri.parse(
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
          getParents();
          //initData();
          // if(body["parent"] != null){
          //   Parent parent = Parent.fromJson(body["parent"]);
          //
          //   //Navigator.pop(context);
          //   //initData();
          //   // Navigator.push(
          //   //     context,
          //   //     MaterialPageRoute(
          //   //       builder: (context) =>
          //   //           AfilliationScreen(parent: parent),));
          //
          // }


        }else{
          if(body['errors'].containsKey("mail")){
            showAlertDialog(context, "Cette adresse mail est déjà utilisée");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      } else {
        showAlertDialog(context, "Erreur ajout parent");
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
  void modal_add3(context, {bool init=false}){

    _selectstatut2.setSelected(BsSelectBoxOption(value: 0, text: Text("Actif")));

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
                      Text('Ajouter Parent',
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
                                    LabelText(title: "Nom *"),
                                    TextField(
                                        controller: nom_controller2,
                                        decoration: InputDecoration(
                                          hintText: 'Nom',
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    LabelText(title: "Civilité *"),
                                    BsSelectBox(
                                      hintText: 'Civilité',
                                      controller: _selectCivilite2,
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
                                      controller: adresse_controller2,
                                      decoration: InputDecoration(
                                        hintText: 'Adresse',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    LabelText(title: "Numero de telephone *"),
                                    TextField(
                                      controller: tel_controller2,
                                      decoration: InputDecoration(
                                        hintText: 'Numero de telephone',

                                      ),
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),
                                    LabelText(title: "Password *"),
                                    TextField(
                                      controller: password_controller2,
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
                                    controller: prenom_controller2,
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
                                    controller: _selectstatut2,
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  LabelText(title: "Villes *"),
                                  BsSelectBox(
                                    hintText: 'Villes',
                                    controller: _selectVilles2,
                                    searchable: true,
                                    serverSide: searchVille,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: "Email *"),
                                  TextField(
                                    controller: mail_controller2,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
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
                                  image_path2.isNotEmpty ?
                                  SizedBox(
                                    width: 250, //
                                    height: 100,
                                    child: Image.network(
                                        HOST+"/media/"+image_path2
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
                            add3(context);
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
  void initSelectClasse() {
    _selectClasse.options = classes.map<BsSelectBoxOption>((v) =>
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

  BsSelectBoxController _selectParent = BsSelectBoxController();
  BsSelectBoxController _selectEtudiant = BsSelectBoxController();

  /**
   * filtrer les clients selon leur Statut
   * @return: void
   */
  void filterClient(){
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
  /**
   * lister tous les clients qui existe dans Notre base de donnée
   * @return: void
   */
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

        data = result.map<Client>((e) => Client.fromJson(e)).toList();
        init_data = result.map<Client>((e) => Client.fromJson(e)).toList();

        //dataSource = MyDataSource(data: data);
      });

      if(init!){
        _selectEtudiant.options = data.map<BsSelectBoxOption>((c) =>
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
  /**
   * lister les villes qui existe dans Notre base de donnée
   * @return: void
   */
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
            text: Text("${v.nom_ville}"),
        )).toList();

    var searched_villes = villes.where((el) => el.nom_ville == "Tanger").toList();
    if(searched_villes.isNotEmpty){
      Ville ville = searched_villes.first;
      _selectVilles.setSelected(BsSelectBoxOption(
      value: ville.id,
      text: Text("${ville.nom_ville}"),
      ));
    }

  }

  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/etudiants/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );

    if (response.statusCode == 200) {
      fetchClient();
    } else {
      throw Exception('Failed to load data');
    }
  }
  /**
   * chercher dans la liste des clients en utilisants key
   * @param: String Key
   * @return: void
   */
  void search(String key){
    if(key.length >= 1){
      final List<Client> founded = [];
      init_data.forEach((e) {
        if(e.nom!.toLowerCase().contains(key.toLowerCase())
            || e.prenom!.toLowerCase().contains(key.toLowerCase())
            || e.ville!.toLowerCase().contains(key.toLowerCase())
            || e.adresse!.toLowerCase().contains(key.toLowerCase())
            || e.date_inscription!.toIso8601String().toLowerCase().contains(key.toLowerCase()))
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
      title: Text("Clients"),
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

    setState(() {
      _index = 0;
    });

    nom_controller.text = "";
    prenom_controller.text = "";
    adresse_controller.text = "";
    tel_controller.text = "";
    mail_controller.text = "";
    ville_controller.text = "";
    cin_controller.text = "";
    Date_naissance_controller.text = "";
    Date_inscription_controller.text = "";
    password_controller.text = "";

    //_selectCivilite.clear();
    //initSelectVilles();

    if(_selectCivilite.getSelected() != null){
      _selectCivilite.removeSelected(_selectCivilite.getSelected()!);
    }
    if(_selectVilles.getSelected() != null){
      _selectVilles.removeSelected(_selectVilles.getSelected()!);
    }
    if(_selectClasse.getSelected() != null){
      _selectClasse.removeSelected(_selectClasse.getSelected()!);
    }

    if(_selectstatut.getSelected() != null){
      _selectstatut.removeSelected(_selectstatut.getSelected()!);
    }

    if(_selectParent.getSelected() != null){
      _selectParent.removeSelected(_selectParent.getSelected()!);
    }





    setState(() {
      image_path = "";
    });
    fetchClient();
    initSelectVilles();
  }
  /**
   * validation de formulaire et la preparation des données pour l'envoyer A l'api
   * @param: BuildContext context
   * @return: void
   */
  void add(context) async {

    if(prenom_controller.text.isNotEmpty
        && nom_controller.text.isNotEmpty
        //&& ville_controller.text.isNotEmpty
        && _selectstatut.getSelected()?.getValue() != null
       // && _selectVilles.getSelected()?.getValue() != null
        && _selectCivilite.getSelected()?.getValue() != null
        && _selectClasse.getSelected()?.getValue() != null
    && _selectParent.getSelected()?.getValue() != null
        //&& image_path.isNotEmpty
    ){



      var client = <String, dynamic>{
        "nom": nom_controller.text,
        "prenom": prenom_controller.text,
        "image": image_path,
        "adresse": adresse_controller.text,
        "tel": tel_controller.text,
        "mail": mail_controller.text,
        "ville": _selectVilles.getSelected()?.getValue(),
        "civilite": _selectCivilite.getSelected()?.getValue(),
        "date_naissance": Date_naissance_controller.text,
        "date_inscription": Date_inscription_controller.text,
        "id_classe": _selectClasse.getSelected()?.getValue(),
        "parent_id": _selectParent.getSelected()?.getValue()
      };
      if(image_path.isNotEmpty){
        client["image"] = image_path;
      }

      print(client);
      final response = await http.post(Uri.parse(
          HOST+"/api/etudiants/"),
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
          if(body["client"] != null){
            Client client = Client.fromJson(body["client"]);
            Navigator.pop(context);
            fetchClient();
            initData();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ContratScreen(client: client, from: "etudiant"),));
            /*Client client = Client.fromJson(body["client"]);

            //Navigator.pop(context);
            //initData();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                        AfilliationScreen(client: client),));
*/
          }

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
  /**
   * chercher dans la liste des villes en utilisants key
   * @param: Map<String, String> params
   * @return: BsSelectBoxResponse
   */
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
   * ui{formulaire d'ajout Client}
   * @param: BuildContext context
   * @return: void
   */
  void modal_add(context){

    String formattedDat = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() {
      Date_inscription_controller.text =
          formattedDat.toString();
    });

    _selectstatut.setSelected(BsSelectBoxOption(value: 1, text: Text("Actif")));

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
                                      // Container(
                                      //   child: Center(
                                      //     child: Text(
                                      //       "informations personnelles",style: TextStyle(
                                      //       fontWeight: FontWeight.bold,
                                      //       color: Colors.black,
                                      //     ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox( height: 8),
                                      // InkWell(
                                      //   onTap: () {
                                      //     cameraImage(context);
                                      //   },
                                      //   child: Container(
                                      //     width: 50,
                                      //     height: 30,
                                      //     decoration: BoxDecoration(
                                      //         borderRadius: BorderRadius.circular(6),
                                      //         color: Colors.blue),
                                      //     child: Icon(Icons.camera_alt_outlined,
                                      //         size: 25, color: Colors.white),
                                      //   ),
                                      // ),
                                      // SizedBox( height: 5),
                                      // image_path.isNotEmpty ?
                                      // SizedBox(
                                      //   width: 250, //
                                      //   height: 100,
                                      //   child: Image.network(
                                      //       HOST+"/media/"+image_path
                                      //   ),
                                      // ) :Text("select image",textAlign: TextAlign.center,),
                                      // SizedBox(
                                      //   height: 15,
                                      // ),
                                      LabelText(title: "Nom *"),
                                      TextField(
                                        decoration: InputDecoration(
                                            hintText: "Nom"
                                        ),
                                        controller: nom_controller,
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                  LabelText(title: "Civilité *"),
                                  BsSelectBox(
                                    hintText: 'Civilité',
                                    controller: _selectCivilite,
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                      LabelText(title: "Email "),
                                      TextField(
                                        controller: mail_controller,
                                        decoration: InputDecoration(
                                          hintText: 'Email',
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
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
                                            firstDate: DateTime(1950),
                                            lastDate: DateTime.now().subtract(Duration(days: 365*4)),
                                            //lastDate: DateTime(2101),
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
                                        height: 7,
                                      ),
                                      LabelText(title: "Statut *"),
                                      BsSelectBox(
                                        hintText: 'Statut',
                                        controller: _selectstatut,
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
                                        controller: _selectVilles,
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
                                controller: prenom_controller,
                                decoration: InputDecoration(
                                  hintText: 'Prenom',
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                                  // LabelText(title: "CIN *"),
                                  // Container(
                                  //   width: double.infinity,
                                  //   child: TextField(
                                  //     controller: cin_controller,
                                  //     decoration: InputDecoration(
                                  //       hintText: 'CIN',
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 9,
                                  // ),
                                  LabelText(title: "Numéro de téléphone *"),
                                  TextField(
                                    controller: tel_controller,
                                    decoration: InputDecoration(
                                      hintText: 'Numéro de téléphone',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  LabelText(title: "Date d'nscription *"),
                                  TextField(
                                    controller: Date_inscription_controller,
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
                                          Date_inscription_controller.text =
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
                                    controller: adresse_controller,
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
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            // InkWell(
                            //   onTap: (){
                            //
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) =>
                            //               AfilliationScreen(),
                            //         ));
                            //   },
                            //   child: Container(
                            //     child:
                            //     Center(child: Text('Suivant', style: TextStyle(color: Colors.white, fontSize: 18),)),
                            //     height: 30,
                            //     width: 110,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(6),
                            //         color: Colors.blue,
                            //         border: Border.all(
                            //             color: Colors.blueAccent
                            //         )
                            //     ),
                            //   ),
                            // ),
                            SizedBox(width: 45,),
                            InkWell(
                              onTap: (){

                                add(context);

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
  /**
   * validation de formulaire modifier et la preparation des données pour l'envoyer A l'api
   * @param: BuildContext context
   * @param: int id
   * @return: void
   */
  void update(context, int? id) async  {

    if( prenom_controller.text.isNotEmpty
        && nom_controller.text.isNotEmpty
        && _selectVilles.getSelected()?.getValue() != null
        && _selectstatut.getSelected()?.getValue() != null
        && _selectCivilite.getSelected()?.getValue() != null
        && _selectClasse.getSelected()?.getValue() != null

        //&& image_path.isNotEmpty
    ){


      // final bool emailValid =
      // RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      //     .hasMatch(mail_controller.text);
      //
      // final bool phoneValid =
      // RegExp(r"^(?:[+0]9)?[0-9]{10}$")
      //     .hasMatch(tel_controller.text);
      //
      // if(!emailValid){
      //   showAlertDialog(context, "Email n'est pas valide");
      //   return;
      // }
      //
      // if(!phoneValid){
      //   showAlertDialog(context, "Telphone n'est pas valide");
      //   return;
      // }

      var client = <String, dynamic>{
        "id_etudiant": id,
        "nom": nom_controller.text,
        "prenom": prenom_controller.text,
        "image": image_path,
        "adresse": adresse_controller.text,
        "tel": tel_controller.text,
        "mail": mail_controller.text,
        "ville": _selectVilles.getSelected()?.getValue(),
        "civilite": _selectCivilite.getSelected()?.getValue(),
        "date_naissance": Date_naissance_controller.text,
        "date_inscription": Date_inscription_controller.text,
        "statut": _selectstatut.getSelected()?.getValue() == 1 ? true : false,
        "id_classe": _selectClasse.getSelected()?.getValue(),

      };

      print(client);

      final response = await http.put(Uri.parse(
          HOST+"/api/etudiants/"),
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
          initData();
        }else{
          if(body['errors'].containsKey("mail")){
            showAlertDialog(context, "Cette adresse mail est déjà utilisée");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      } else {
        showAlertDialog(context, "Erreur ajout Etudiant");
        //throw Exception('Failed to load data');
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }
 // void update(context, int? id, Client e) async  {
 //
 //   if( prenom_controller.text.isNotEmpty
 //       && nom_controller.text.isNotEmpty
 //       && _selectVilles.getSelected()?.getValue() != null
 //       && _selectstatut.getSelected()?.getValue() != null
 //       && _selectCivilite.getSelected()?.getValue() != null
 //       && _selectClasse.getSelected()?.getValue() != null
 //
 //       //&& image_path.isNotEmpty
 //   ){
 //
 //
 //     // final bool emailValid =
 //     // RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
 //     //     .hasMatch(mail_controller.text);
 //     //
 //     // final bool phoneValid =
 //     // RegExp(r"^(?:[+0]9)?[0-9]{10}$")
 //     //     .hasMatch(tel_controller.text);
 //     //
 //     // if(!emailValid){
 //     //   showAlertDialog(context, "Email n'est pas valide");
 //     //   return;
 //     // }
 //     //
 //     // if(!phoneValid){
 //     //   showAlertDialog(context, "Telphone n'est pas valide");
 //     //   return;
 //     // }
 //
 //     var client = <String, dynamic>{
 //       "id_etudiant": id,
 //       "nom": nom_controller.text,
 //       "prenom": prenom_controller.text,
 //       "image": image_path,
 //       "adresse": adresse_controller.text,
 //       "tel": tel_controller.text,
 //       "mail": mail_controller.text,
 //       "ville": _selectVilles.getSelected()?.getValue(),
 //       "civilite": _selectCivilite.getSelected()?.getValue(),
 //       "date_naissance": Date_naissance_controller.text,
 //       "date_inscription": Date_inscription_controller.text,
 //       "statut": _selectstatut.getSelected()?.getValue() == 1 ? true : false,
 //       "id_classe": _selectClasse.getSelected()?.getValue(),
 //       "id_parent": _selectParent.getSelected()?.getValue(),
 //       "id_affiliation": e.affiliation!["id_affiliation"]
 //     };
 //
 //     print(client);
 //
 //     final response = await http.put(Uri.parse(
 //         HOST+"/api/etudiants/"),
 //       headers: <String, String>{
 //         'Content-Type': 'application/json; charset=UTF-8',
 //         'Authorization': 'Bearer $token',
 //       },
 //
 //       body: jsonEncode(client),
 //     );
 //
 //     if (response.statusCode == 200) {
 //
 //       final body = json.decode(response.body);
 //       final status = body["status"];
 //       if(status == true){
 //         Navigator.pop(context);
 //         initData();
 //       }else{
 //         if(body['errors'].containsKey("mail")){
 //           showAlertDialog(context, "Cette adresse mail est déjà utilisée");
 //           return;
 //         }
 //         showAlertDialog(context, body["msg"]);
 //       }
 //     } else {
 //       showAlertDialog(context, "Erreur ajout Etudiant");
 //       //throw Exception('Failed to load data');
 //     }
 //   }else{
 //     showAlertDialog(context, "Remplir tous les champs");
 //   }
 //
 // }
  /**
   * ui{formulaire de Modification Client}
   * @param: BuildContext context
   * @return: void
   */
  void modal_ubdate(context, Client e, {bool? uploadImage=false}){

    if(!uploadImage!){
      nom_controller.text = e.nom!;
      prenom_controller.text = e.prenom!;
      adresse_controller.text = e.adresse!;
      tel_controller.text = e.tel!;
      mail_controller.text = e.mail!;
      //ville_controller.text = e.ville!;
      Date_naissance_controller.text = e.date_naissance!.toIso8601String().split("T")[0];
      Date_inscription_controller.text = e.date_inscription!.toIso8601String().split("T")[0];

      if(e.affiliation != null && e.affiliation!["id_parent"] != null){
        Parent pr = parents.firstWhere((p) => p.id_parent == e.affiliation!["id_parent"]);
        _selectParent.setSelected(
            BsSelectBoxOption(value: pr != null ? pr.id_parent : "", text: Text(pr != null ? "${pr.prenom} ${pr.nom}" : ""))
        );
      }

      _selectstatut.setSelected(
          BsSelectBoxOption(value: e.statut! ? 1 : 0, text: Text(e.statut! == false ? "Inactif" : "Actif"))
      );


      if(e.id_ville != null){
        _selectVilles.setSelected(
            BsSelectBoxOption(value: e.id_ville, text: Text(e.ville!))
        );
      }



      _selectCivilite.setSelected(
          BsSelectBoxOption(value: e.civilite, text: Text(e.civilite!))
      );
      _selectClasse.setSelected(
          BsSelectBoxOption(value: e.id_classe, text: Text(e.classe!))
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
                      Text('Modifier Etudiant',
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
                                    LabelText(title: 'Civilite *'),
                                BsSelectBox(
                                  hintText: 'Civilite',
                                  controller: _selectCivilite,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                    LabelText(title: 'Nom *'),
                                TextField(
                                    controller: nom_controller,
                                    decoration: InputDecoration(
                                      hintText: 'Nom',
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                    LabelText(title: 'Prenom *'),
                                TextField(
                                  controller: prenom_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Prenom',

                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: 'Adresse '),
                                TextField(
                                  controller: adresse_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Adresse',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: 'Numéro de téléphone'),
                                TextField(
                                  controller: tel_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Numéro de téléphone',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabelText(title: 'Email '),
                                TextField(
                                  controller: mail_controller,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // LabelText(title: 'CIN *'),
                                // Container(
                                //   width: double.infinity,
                                //   child: TextField(
                                //     controller: cin_controller,
                                //     decoration: InputDecoration(
                                //       hintText: 'CIN',
                                //     ),
                                //   ),
                                // ),
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

                                  LabelText(title: 'Ville *'),
                                  BsSelectBox(
                                    hintText: 'Ville ',
                                    controller: _selectVilles,
                                    searchable: true,
                                    serverSide: searchVille,
                                    autoClose: true,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: 'Date de naissance *'),
                                  TextField(
                                    controller: Date_naissance_controller,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      hintText: 'Date de naissance',
                                     
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate:DateTime(2000),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime.now().subtract(Duration(days: 365*4)),
                                        //lastDate: DateTime(2101),
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
                                  LabelText(title: "Date d'inscription *"),
                                  TextField(
                                    controller: Date_inscription_controller,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      hintText: 'Date d\'nscription',
                                      
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
                                          Date_inscription_controller.text =
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
                                  LabelText(title: 'Statut *'),
                                  BsSelectBox(
                                    hintText: 'Statut',
                                    controller: _selectstatut,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LabelText(title: 'Classe *'),
                                  BsSelectBox(
                                    hintText: 'Classe',
                                    controller: _selectClasse,
                                    searchable: true,
                                    serverSide: searchClasse,
                                  ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // LabelText(title: "Parent"),
                                  // BsSelectBox(
                                  //   controller: _selectParent,
                                  //   hintText: "parent",
                                  //   searchable: true,
                                  //   serverSide: searchParent,
                                  // ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      cameraImage(context, client: e);
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
                            update(context, e.id_etudiant);
                            //update(context, e.id_etudiant, e);
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
                        SizedBox(height: 4,),
                        LabelText(title: ' nb * champ obligatoire')
                      ],
                    ),

                  ),

                ],
              ),
            )));
  }

  void modal_add2(context, {bool init=false}){
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);



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
                      Text('Ajouter un Etudiant',
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
                                 // && _selectVilles.getSelected()?.getValue() != null
                                 && _selectCivilite.getSelected()?.getValue() != null
                                 && _selectClasse.getSelected()?.getValue() != null

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
                                if(_selectParent.getSelected()?.getValue() != null){
                                  items.clear();
                                  //Classes cls = clas.where((c) => c.id_classe == _selectClasse.getSelected()?.getValue()).first;
                                 // Client client = Clients.where((c) => c.id_etudiant == _selectEtudiant.getSelected()?.getValue()).first;
                                  Parent parent = parents.where((a) => a.id_parent == _selectParent.getSelected()?.getValue()).first;
                                  items.add(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text("information Etudiant: ",
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
                                          Text("Date de naissance: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 15,),
                                          Text("${DateFormat("dd/MM/yyyy").format(DateTime.parse(Date_naissance_controller.text))} ")
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
                                          Text("Parent: ", style: TextStyle(fontWeight: FontWeight.bold)),
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
                              title: Text('Informations Etudiants', style: TextStyle(color: _index == 0 ? Colors.blue : Colors.grey),),
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
                                                  title: "date naissance *"
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
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
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime.now().subtract(Duration(days: 365*4)),
                                                    //lastDate: DateTime(2101),
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
                                              LabelText(
                                                  title: 'Staut '
                                              ),
                                              BsSelectBox(
                                                hintText: 'Statut',
                                                controller: _selectstatut,
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
                                              LabelText(title: "Date d'nscription *"),
                                              TextField(
                                                controller: Date_inscription_controller,
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
                                                      Date_inscription_controller.text =
                                                          formattedDat.toString();
                                                    });
                                                  } else {
                                                    print('Not selected');
                                                  }
                                                },
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
                                                  title: 'classe * '
                                              ),
                                              BsSelectBox(
                                                hintText: 'classe',
                                                controller: _selectClasse,
                                                searchable: true,
                                               // serverSide: sea,
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
                                  Column(
                                    children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            LabelText(title: "Parent"),
                                            SizedBox(height: 10,),
                                            BsSelectBox(
                                              controller: _selectParent,
                                              hintText: "parent",
                                              searchable: true,
                                              serverSide: searchParent,
                                            )
                                          ],
                                        ),
                                      SizedBox(height: 15,),
                                      InkWell(
                                        onTap: (){
                                          modal_add3(context);
                                        },
                                        child: Container(
                                          child:
                                          Center(child: Text('ajouter parent', style: TextStyle(color: Colors.white, fontSize: 18),)),
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
                                      // SizedBox(width: 2,),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(top:25.0),
                                      //   child: Expanded(
                                      //     flex: 1,
                                      //     child: Column(
                                      //       mainAxisAlignment: MainAxisAlignment.start,
                                      //       crossAxisAlignment: CrossAxisAlignment.start,
                                      //       children: [
                                      //         Padding(
                                      //           padding: const EdgeInsets.all(10.0),
                                      //           child: InkWell(
                                      //             onTap: (){
                                      //               modal_add3(context);
                                      //               // Navigator.push(
                                      //               //     context,
                                      //               //     MaterialPageRoute(
                                      //               //       builder: (context) =>
                                      //               //           ParentScreen(from: "etudiant"),));
                                      //             },
                                      //             child: Tooltip(
                                      //               message: "Ajouter Parent",
                                      //               decoration: BoxDecoration(
                                      //                 color: Colors.blue, // Couleur de fond du tooltip
                                      //                 borderRadius: BorderRadius.circular(8.0), // Optionnel : coins arrondis
                                      //               ),
                                      //               child: Container(
                                      //                 height: 30,
                                      //                 width: 30,
                                      //                 decoration: BoxDecoration(
                                      //                     borderRadius: BorderRadius.circular(8),
                                      //                     border: Border.all(color: Colors.lightBlue)
                                      //                 ),
                                      //                 child: Center(
                                      //                   child: Icon(Icons.add, size: 15, color: Colors.orange),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // )
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
    fetchClient();
    getVilles();
    getClasses();

    getParents();
    _selectstatut.setSelected(BsSelectBoxOption(value: 1, text: Text("Actif")));

    Date_inscription_controller.text = DateFormat("yyyy-MM-dd").format(DateTime.now());

  }

  void getParents({bool? init=false}) async {
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
        parents = result.map<Parent>((e) => Parent.fromJson(e)).toList();
      });
      _selectParent.options = parents.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_parent,
              text: Text("${c.nom} ${c.prenom}")
          )).toList();

      print("--data--");
      print(parents.length);

    } else {
      throw Exception('Failed to load data');
    }
  }

  void seeContract (Client e){

    Navigator.of(context)
        .push(
        MaterialPageRoute(builder: (context) => CustomerContratScreen(customer_id: e.id_etudiant,) )
    );
  }

  void seeDetail(Client e){
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
                      Text('${e.nom.toString()} ${e.prenom.toString()}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Fermer'),
                        //prefixIcon: Icons.close,
                        onPressed: () {
                          // initData();
                          Navigator.pop(context);

                        },
                      )
                    ],
                    //closeButton: true,

                  ),
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
                                      Text("Ville:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                      SizedBox(width: 9,),
                                      Text("${e.ville.toString()}"),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Text("téléphone:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                      SizedBox(width: 9,),
                                      Text("${e.tel.toString()}"),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Text("Mail: ",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                      SizedBox(width: 9,),
                                      Text(" ${e.mail.toString()}"),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Text("Date d'inscription:" ,style: TextStyle(
                                          fontWeight: FontWeight.bold, color:Colors.grey
                                      ),),
                                      SizedBox(width: 9,),
                                      Text(" ${DateFormat('dd/MM/yyyy').format(e.date_inscription!)}"),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Text("Date de naissance :" ,style: TextStyle(
                                          fontWeight: FontWeight.bold, color:Colors.grey
                                      ),),
                                      SizedBox(width: 9,),
                                      Text(" ${DateFormat('dd/MM/yyyy').format(e.date_naissance!)}"),
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


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    DataTableSource dataSource = MyDataSource(
        data: data ,
        context: context,
      modal_ubdate: modal_ubdate,
      seeContract: seeContract,
      seeDetail: seeDetail,
      isMobile: screenSize.width > 800 ? false : true
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200]
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              //SideBar(postion: 1,msg:"Etudiant"),
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
                                child: Center(child: Text("Etudiants", style: TextStyle(
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
                                          filterClient();
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
                                    flex: 3,
                                    child: InkWell(
                                      onTap: (){
                                        //
                                        modal_add2(context, init: true);
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
                                            child: Text("Ajouter Etudiant",
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Etudiant", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 180,
                                        child: BsSelectBox(
                                          hintText: 'Filtrer',
                                          controller: _selectFilter,
                                          onChange: (v){
                                            filterClient();
                                          },
                                        ),
                                      ),
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

                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: ListView(
                                      children:[
                                        // ignore: unnecessary_null_comparison
                                        dataSource != null ?
                                        data.length > 0 ?
                                        PaginatedDataTable(
                                          dataRowHeight: DataRowHeight,
                                          headingRowHeight: HeadingRowHeight,
                                          columns: screenSize.width > 800 ?
                                          <DataColumn>[
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Etudiant',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Ville',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Classe',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Statut',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Actions',
                                                  style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ] :
                                          <DataColumn>[
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Etudiant',
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
                                          source: dataSource,
                                          rowsPerPage: 50,
                                        ) : Padding(
                                          padding: const EdgeInsets.all(200.0),
                                          child: Center(child: Text("aucun étudiants à afficher.")),
                                        )
                                            : Text("Chargement des données ...")

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

class MyDataSource extends DataTableSource {
  MyDataSource({required this.data, required this.context
    , required this.modal_ubdate, required this.seeContract,
    required this.seeDetail,
    required this.isMobile
  });

  List<Client> data = [];
  BuildContext context;
  bool isMobile;


  Function modal_ubdate;
  Function seeContract;
  Function seeDetail;

  @override
  int get rowCount => data.length;

  @override
  DataRow? getRow(int index) {
    Client e = data[index];
    return DataRow(
      cells: !isMobile ?
      <DataCell>[
        DataCell(Row(
          children: [
            e.statut == true ?
            Icon(Icons.check_circle_outline, size: 22, color: Colors.green,) :
            Icon(Icons.close_rounded, size: 22, color: Colors.red,),
            SizedBox(width: 9,),
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
            Text("${e.nom.toString()} - ${e.prenom.toString()}",
              overflow: TextOverflow.ellipsis,
            )
          ],
        )),
        DataCell(

            Text(e.ville.toString())),
        DataCell(Text(e.classe.toString())),
        //DataCell(Text(e.mail.toString())),
        DataCell(Text(e.statut! == true ? "Actif" :"Inactif")),

        DataCell(Row(
          children: [
            ShowButton(
                msg: "•Visualisation des détails du client",
                onPressed: (){
                  seeDetail(e);
                }

            ),
            SizedBox(width: 10,),
            EditerButton(
              msg: "Mettre à jour les informations du Client",
              onPressed: (){
                modal_ubdate(context, e);
              },
            ),
            SizedBox(width: 10,),
            ContractButton(
              msg: "•Visualisation les Contrat du client",
              onPressed: (){
                seeContract(e);
              },
            ),


          ],
        ))
      ]:
      <DataCell>[
        DataCell(Row(
          children: [
            e.statut == true ?
            Icon(Icons.check_circle_outline, size: 22, color: Colors.green,) :
            Icon(Icons.close_rounded, size: 22, color: Colors.red,),
            SizedBox(width: 9,),
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
            Text("${e.nom.toString()} - ${e.prenom.toString()}",
              overflow: TextOverflow.ellipsis,
            )
          ],
        )),
        DataCell(Row(
          children: [
            ShowButton(
                msg: "•Visualisation des détails du client",
                onPressed: (){
                  seeDetail(e);
                }

            ),
            SizedBox(width: 10,),
            EditerButton(
              msg: "Mettre à jour les informations du Client",
              onPressed: (){
                modal_ubdate(context, e);
              },
            ),
            SizedBox(width: 10,),
            ContractButton(
              msg: "•Visualisation les Contrat du client",
              onPressed: (){
                seeContract(e);
              },
            ),
          ],
        ))
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

