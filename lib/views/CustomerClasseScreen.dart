import 'dart:html';
import 'dart:math';

import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/ClasseModel.dart';
import 'package:adminmmas/models/ContratModels.dart';
import 'package:adminmmas/models/EtablissementModels.dart';
import 'package:adminmmas/models/Ville.dart';
import 'package:adminmmas/views/TransationScreen.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/imprmButton.dart';
import '../componnents/label.dart';
import '../componnents/showButton.dart';
import '../models/AbonnementModels.dart';
import '../models/Admin.dart';
import '../models/ClientModels.dart';
import '../models/CoursModels.dart';
import '../models/SalleModels.dart';
import '../models/SeanceModels.dart';
import '../models/Staff.dart';
import '../models/contratStaffModel.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';

import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


import 'dart:html' as html;


import 'package:confirm_dialog/confirm_dialog.dart';

class CustomerClasseScreen extends StatefulWidget {
  CustomerClasseScreen({Key? key, Classes? this.classe, int? this.classe_id}) : super(key: key);


  Classes? classe;

  int? classe_id;

  @override
  State<CustomerClasseScreen> createState() => _CustomerClasseScreenState();
}

class _CustomerClasseScreenState extends State<CustomerClasseScreen> {

  List<Client> data = [];
  List<Client> init_data = [];
  bool loading = false;

  String text_search = "";

  List<Abonnement> abonnement = [];
  List<Etablissement> Etablissements = [];
  List<Staff> Staffs = [];

  List<Map<String, int>> customers_data = [];

  BsSelectBoxController _selectabonnement = BsSelectBoxController();
  BsSelectBoxController _selectEtablissement = BsSelectBoxController();
  BsSelectBoxController _selectClients = BsSelectBoxController();



  BsSelectBoxController _selectStatus = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 0, text: Text("Impayé")),
        BsSelectBoxOption(value: 1, text: Text("Payé")),
      ]
  );

  BsSelectBoxController _selectFilter = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 2, text: Text("Tous")),
        BsSelectBoxOption(value: 0, text: Text("Payés")),
        BsSelectBoxOption(value: 1, text: Text("Impayés")),
      ]
  );

  TextEditingController date_debut_controller = TextEditingController();
  TextEditingController date_fin_controller = TextEditingController();
  TextEditingController rest_controller = TextEditingController();
  TextEditingController nim_contrat_controller = TextEditingController();
  TextEditingController MontantPaye_controller = TextEditingController();
  TextEditingController tarif_controller = TextEditingController();

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

  BsSelectBoxController _selectCivilite = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: "Madmoiselle", text: Text("Madmoiselle")),
        BsSelectBoxOption(value: "Madame", text: Text("Madame")),
        BsSelectBoxOption(value: "Monsieur", text: Text("Monsieur")),
      ]
  );



  List<Classes> classes = [];
  List<Ville> villes = [];

  //_selectBlacklist.setSelected(BsSelectBoxOption(value: 0, text: Text("Non")));

  BsSelectBoxController _selectVilles = BsSelectBoxController();
  BsSelectBoxController _selectClasse = BsSelectBoxController();


  String image_path = "";
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
  BsSelectBoxController _selectstatut = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 1, text: Text("Actif")),
        BsSelectBoxOption(value: 0, text: Text("Inactif")),
      ]
  );
  TextEditingController Montant_controller = TextEditingController();
  TextEditingController restOld_controller = TextEditingController();
  TextEditingController restNew_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();

  BsSelectBoxController _selectType = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 0, text: Text("Sortie")),
        BsSelectBoxOption(value: 1, text: Text("Entrée")),
      ]
  );

  BsSelectBoxController _selectMode = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: "Chéques", text: Text("Chéques")),
        BsSelectBoxOption(value: "Espéces", text: Text("Espéces")),
        BsSelectBoxOption(value: "Prélèvements", text: Text("Prélèvements")),
        BsSelectBoxOption(value: "Autres", text: Text("Autres")),
      ]
  );

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
        "id_classe": _selectClasse.getSelected()?.getValue()
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
            //contentType: MediaType("application", "json"),
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
              //modal_add(context);
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


      _selectstatut.setSelected(
          BsSelectBoxOption(value: e.statut! ? 1 : 0, text: Text(e.statut! == false ? "Inactif" : "Actif"))
      );

      _selectVilles.setSelected(
          BsSelectBoxOption(value: e.id_ville, text: Text(e.ville!))
      );



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
                                    LabelText(title: 'Adresse *'),
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
                                    LabelText(title: 'Email *'),
                                    TextField(
                                      controller: mail_controller,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
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
                                    // serverSide: searchClasse,
                                  ),

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
  void fetchclientClasse(int classe_id) async {
    // setState(() {
    //   loading = true;
    // });
    // print("loading ...");
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
      for(var r in result){
        if(r["id_classe"] == classe_id){
          data.add(Client.fromJson(r));
          init_data.add(Client.fromJson(r));
        }
      }
      /*data = result.map<Contrat>((e) => Contrat.fromJson(e)).toList();
      init_data = result.map<Contrat>((e) => Contrat.fromJson(e)).toList();
      setState(() {

      });*/
      print("--data--");
      print(data.length);
    } else {
      throw Exception('Failed to load data');
    }

    setState(() {
      loading = false;
    });
  }

  // void search(String key){
  //   if(key.length >= 1){
  //     final List<Contrat> founded = [];
  //     init_data.forEach((e) {
  //       if(e.id_contrat == key
  //           ||e.client!.toLowerCase().contains(key.toLowerCase())
  //           || e.date_debut!.toLowerCase().contains(key.toLowerCase())
  //           || e.date_fin!.toLowerCase().contains(key.toLowerCase())
  //           || e.abonnement!.toLowerCase().contains(key.toLowerCase())
  //       )
  //       {
  //         founded.add(e);
  //       }
  //     });
  //     setState(() {
  //       data = founded;
  //     });
  //   }else {
  //     setState(() {
  //       data = init_data;
  //     });
  //   }
  //
  // }

  // void filterContracts(){
  //   if(_selectFilter.getSelected()?.getValue() != null){
  //     print(_selectFilter.getSelected()?.getValue());
  //     setState(() {
  //       data = [];
  //     });
  //     if(_selectFilter.getSelected()?.getValue() == 2){
  //       setState(() {
  //         data = init_data;
  //       });
  //
  //     }
  //     if(_selectFilter.getSelected()?.getValue() == 0){
  //       setState(() {
  //         data = init_data.where((element) => double.parse(element.reste!) == 0).toList();
  //       });
  //
  //     }
  //
  //     if(_selectFilter.getSelected()?.getValue() == 1){
  //       setState(() {
  //         data = init_data.where((element) => double.parse(element.reste!) > 0).toList();
  //       });
  //
  //     }
  //
  //   }
  // }
  int _index = 0;

  var token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state");
    fetchclientClasse(widget.classe_id!);



  }
  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/etudiants/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchclientClasse(widget.classe_id!);
    } else {
      throw Exception('Failed to load data');
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
      title: Text("Classe"),
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



  void initData(){
    rest_controller.text = "";
    nim_contrat_controller.text = "";
    date_debut_controller.text = "";
    date_fin_controller.text = "";

    tarif_controller.text = "";
    MontantPaye_controller.text = "";

    setState(() {
      _index = 0;
    });

    _selectabonnement.clear();
    _selectClients.clear();
    _selectEtablissement.clear();
    _selectStatus.clear();

    Montant_controller.text = "";
    restNew_controller.text = "";


    if(_selectType.getSelected() != null){
      _selectType.removeSelected(_selectType.getSelected()!);
    }
    if(_selectMode.getSelected()!= null){
      _selectMode.removeSelected(_selectMode.getSelected()!);
    }


    fetchclientClasse(widget.classe_id!);
  }


  Admin? admin;



  bool showAlert = false;
  List<Widget> items = [];



  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    admin = context.watch<AdminProvider>().admin;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200]
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
             // SideBar(postion: 11,msg:"Coach"),
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
                                                      // search(val)
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

                                ],
                              ),
                              SizedBox(height: 20,),
                              screenSize.width < 750 ?
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /*Text("Liste des Contrats", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),*/
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.arrow_back, color: Colors.blueAccent, size: 22),
                                  ),
                                  // SizedBox(height: 8,),
                                  // Container(
                                  //   width: 180,
                                  //   child: BsSelectBox(
                                  //     hintText: 'Filtrer',
                                  //     controller: _selectFilter,
                                  //     onChange: (v){
                                  //       // filterContractsStaff();
                                  //     },
                                  //   ),
                                  // ),
                                  /* SizedBox(height: 8,),
                                  InkWell(
                                    onTap: (){
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
                                          child: Text("Ajouter Contrat",
                                              style: TextStyle(
                                                  fontSize: 15
                                              )),
                                        ),
                                      ),
                                    ),
                                  )*/

                                ],
                              ):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.arrow_back, color: Colors.blueAccent, size: 22),
                                  ),
                                  // Container(
                                  //   width: 180,
                                  //   child: BsSelectBox(
                                  //     hintText: 'Filtrer',
                                  //     controller: _selectFilter,
                                  //     onChange: (v){
                                  //       // filterContracts();
                                  //     },
                                  //   ),
                                  // ),
                                  /* InkWell(
                                    onTap: (){
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
                                          child: Text("Ajouter Contrat",
                                              style: TextStyle(
                                                  fontSize: 15
                                              )),
                                        ),
                                      ),
                                    ),
                                  )*/

                                ],
                              )
                              ,
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
                                              child: Text("aucun étudiant avec cette classe à afficher")),
                                        )
                                            :
                                        DataTable(
                                            dataRowHeight: DataRowHeight,
                                            headingRowHeight: HeadingRowHeight,
                                            columns: screenSize.width < 900 ?
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
                                                    "",
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
                                                    'Ville',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'tél',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Status',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    "",
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),

                                            ] ,
                                            rows:
                                            data.map<DataRow>((r) => DataRow(
                                              cells: screenSize.width < 900 ?
                                              <DataCell>[
                                                DataCell(Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text( "${r.nom}${r.prenom}",
                                                        overflow: TextOverflow.ellipsis,),
                                                    )
                                                  ],
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
                                                        msg:"•Visualisation Les détails du client",
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
                                                                            Text(' ${r.nom.toString()} ${r.prenom.toString()} ',
                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                            BsButton(
                                                                              style: BsButtonStyle.outlinePrimary,
                                                                              label: Text('Fermer'),
                                                                              //prefixIcon: Icons.close,
                                                                              onPressed: () {

                                                                                Navigator.pop(context);


                                                                              },
                                                                            )
                                                                          ],


                                                                        ),

                                                                        BsModalContainer(
                                                                          child: Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
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
                                                                                            Text("civilité:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.civilite.toString()} "),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),

                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("ville:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.ville.toString()} "),
                                                                                          ],
                                                                                        ),

                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("date de naissance:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.date_naissance.toString()} "),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("date d'inscription:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.date_inscription.toString()} "),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("status :" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${r.statut.toString()}"),
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
                                                    // SizedBox(width: 10,),
                                                    // EditerButton(
                                                    //     onPressed: (){
                                                    //       // modal_update(context, r, init: true);
                                                    //     }, msg: 'Editer',
                                                    // ),
                                                    SizedBox(width: 10,),
                                                    DeleteButton(
                                                      onPressed: () async{
                                                        if (await confirm(
                                                          context,
                                                          title: const Text('Confirmation'),
                                                          content: const Text('Souhaitez-vous supprimer ?'),
                                                          textOK: const Text('Oui'),
                                                          textCancel: const Text('Non'),
                                                        )) {

                                                          delete(r.id_etudiant.toString());
                                                        }

                                                      }, msg: 'supprimer',
                                                    ),
                                                    SizedBox(width: 10,),
                                                    // PrintButton(
                                                    //     msg:"Imprimer contrat",
                                                    //     onPressed: (){
                                                    //       print_pdf(r.id_contratStaff!);
                                                    //     }
                                                    // ),
                                                  ],
                                                ))
                                              ]:
                                              <DataCell>[
                                                DataCell(Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text( "${r.nom} ${r.prenom}",
                                                        overflow: TextOverflow.ellipsis,),
                                                    )
                                                  ],
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text( "${r.ville} ",
                                                        overflow: TextOverflow.ellipsis,),
                                                    )
                                                  ],
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text( "${r.tel} ",
                                                        overflow: TextOverflow.ellipsis,),
                                                    )
                                                  ],
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text( "${r.statut}",
                                                        overflow: TextOverflow.ellipsis,),
                                                    )
                                                  ],
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
                                                        msg:"•Visualisation Les détails du client",
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
                                                                            Text(' ${r.nom.toString()} ${r.prenom.toString()} ',
                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                            BsButton(
                                                                              style: BsButtonStyle.outlinePrimary,
                                                                              label: Text('Fermer'),
                                                                              //prefixIcon: Icons.close,
                                                                              onPressed: () {

                                                                                Navigator.pop(context);


                                                                              },
                                                                            )
                                                                          ],


                                                                        ),

                                                                        BsModalContainer(
                                                                          child: Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
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
                                                                                            Text("civilité:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.civilite.toString()} "),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),

                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("ville:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.ville.toString()} "),
                                                                                          ],
                                                                                        ),

                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("date de naissance:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.date_naissance.toString()} "),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("date d'inscription:" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.date_inscription.toString()} "),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("status :" ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${r.statut.toString()}"),
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
                                                    // SizedBox(width: 10,),
                                                    // EditerButton(
                                                    //   onPressed: (){
                                                    //     // modal_update(context, r, init: true);
                                                    //   }, msg: 'Editer',
                                                    // ),
                                                    SizedBox(width: 10,),
                                                    DeleteButton(
                                                      onPressed: () async{
                                                        if (await confirm(
                                                          context,
                                                          title: const Text('Confirmation'),
                                                          content: const Text('Souhaitez-vous supprimer ?'),
                                                          textOK: const Text('Oui'),
                                                          textCancel: const Text('Non'),
                                                        )) {

                                                          delete(r.id_etudiant.toString());
                                                        }

                                                      }, msg: 'supprimer',
                                                    ),
                                                    SizedBox(width: 10,),
                                                    // PrintButton(
                                                    //     msg:"Imprimer contrat",
                                                    //     onPressed: (){
                                                    //       print_pdf(r.id_contratStaff!);
                                                    //     }
                                                    // ),
                                                  ],
                                                ))

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

