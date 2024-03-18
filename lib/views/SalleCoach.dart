import 'dart:math';

import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/EtablissementModels.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../componnents/showButton.dart';
import '../models/CatContratModels.dart';
import '../models/CategoriSalModels.dart';
import '../models/SalleModels.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';

import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:html' as html;

import 'package:http_parser/http_parser.dart';

import 'package:confirm_dialog/confirm_dialog.dart';

import '../widgets/navigation_bar_Coach.dart';
import 'CategorieSalle.dart';

class SalleScreenCoach extends StatefulWidget {
  const SalleScreenCoach({Key? key}) : super(key: key);

  @override
  State<SalleScreenCoach> createState() => _SalleScreenState();
}

class _SalleScreenState extends State<SalleScreenCoach> {

  List<Salle> data = [];
  List<Salle> init_data = [];
  bool loading = false;

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";

  List<category_contrat> category = [];

  List<Etablissement> Etablissements = [];
  List<category_salle> category_salles = [];
  String capacity = "";
  String name = "";



  BsSelectBoxController _selectEtablissement = BsSelectBoxController();
  BsSelectBoxController _selectCategory = BsSelectBoxController();

  TextEditingController capacity_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();

  String image_path = "";

  Uint8List? _bytesData;
  List<int>? _selectedFile;

  Future cameraImage(context, {Salle? salle}) async {
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
          request.fields["path"] = "salles/";

          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          final body = Map<String, dynamic>.from(json.decode(responseString));
          print(responseString);

          if(response.statusCode == 200){
            setState(() {
              image_path = body['path'];
            });
            Navigator.pop(context);
            if(salle != null){
              modal_update(context, salle, uploadmage: true);
            }else{
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
        });
        reader.readAsDataUrl(file);
      });




    }catch(error){
      print(error);
    }

  }

  void fetchSalle() async {
    // setState(() {
    //   loading = true;
    // });
    // print("loading ...");
    final response = await http.get(Uri.parse(
        HOST+'/api/salles/'),
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
        data = result.map<Salle>((e) => Salle.fromJson(e)).toList();
        init_data = result.map<Salle>((e) => Salle.fromJson(e)).toList();
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
    if(key.length > 0){
      final List<Salle> founded = [];
      init_data.forEach((e) {
        if( e.capacity == key
            || e.etablissement!.toLowerCase().contains(key.toLowerCase())
            || e.nom_salle!.toLowerCase().contains(key.toLowerCase())
            || e.category!.toLowerCase().contains(key.toLowerCase())
        )
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

  var token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state");
    fetchSalle();
    getEtablissement();
    getCategory();

  }
  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/salles/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchSalle();
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<BsSelectBoxResponse> searchCategorie(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in category_salles){
      var name = "${v.nom_category} ";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_category,
                text: Text("${v.nom_category} ")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
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
      title: Text("Salle"),
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

  void getEtablissement({int? etab_id}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/etablissements/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      print("--result--");
      print(result.length);
      setState(() {
        Etablissements = result.map<Etablissement>((e) => Etablissement.fromJson(e)).toList();
      });
      _selectEtablissement.options = Etablissements.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_etablissement,
              text: Text("${c.nom_etablissement}")
          )).toList();
      _selectEtablissement.setSelected(BsSelectBoxOption(
          value: Etablissements[0].id_etablissement,
          text: Text("${Etablissements[0].nom_etablissement}")
      ));
      print("etab id ${etab_id}");
      if(etab_id != null) {
        Etablissement etab = Etablissements.where((element) =>
        element.id_etablissement == etab_id).first;
        _selectEtablissement.setSelected(
            BsSelectBoxOption(
                value: etab.id_etablissement,
                text: Text("${etab.nom_etablissement}")
            )
        );
      }

      print("--data--");
      print(Etablissements.length);
    } else {
      throw Exception('Failed to load data');
    }
  }
  void getCategory({int? category_id}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/category/'),
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
        category_salles = result.map<category_salle>((e) => category_salle.fromJson(e)).toList();
      });
      _selectCategory.options = category_salles.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_category,
              text: Text("${c.nom_category}")
          )).toList();

      print("--data--");
      print(category_salles.length);
      if(category_id != null) {
        category_salle category = category_salles.where((element) =>
        element.id_category == category_id).first;
        _selectCategory.setSelected(
            BsSelectBoxOption(
                value: category.id_category,
                text: Text("${category.nom_category}")
            )
        );
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void getCategoryById({int? category_id}) async {
    final response = await http.get(Uri.parse(
        HOST+'/api/category/'),
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
        category_salles = result.map<category_salle>((e) => category_salle.fromJson(e)).toList();
      });
      _selectCategory.options = category_salles.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_category,
              text: Text("${c.nom_category}")
          )).toList();

      print("--data--");
      print(category_salles.length);
      if(category_id != null) {
        category_salle category = category_salles.where((element) =>
        element.id_category == category_id).first;
        _selectCategory.setSelected(
            BsSelectBoxOption(
                value: category.id_category,
                text: Text("${category.nom_category}")
            )
        );
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void initData(){
    name_controller.text = "";
    capacity_controller.text = "";
    image_path = "";
    _selectEtablissement.clear();
    _selectCategory.clear();

    getCategory();
    getEtablissement();

  }

  void add(context) async {

    if(name_controller.text.isNotEmpty && capacity_controller.text.isNotEmpty
        && _selectCategory.getSelected()?.getValue() != null
        && _selectEtablissement.getSelected()?.getValue() != null
    // && image_path.isNotEmpty
    ){

      var rev = <String, dynamic>{
        "id_etablissement": _selectEtablissement.getSelected()?.getValue(),
        "id_category": _selectCategory.getSelected()?.getValue(),
        "nom_salle": name_controller.text,
        "capacity": capacity_controller.text,
        "image" : image_path
      };

      print(rev);
      final response = await http.post(Uri.parse(
          HOST+"/api/salles/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(rev),
      );

      if (response.statusCode == 200) {

        //print("etb added");
        print(response.body);
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context,true);
          initData();
          fetchSalle();
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context, "Erreur ajout reservation");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }
  void update(context, int id) async {

    if(name_controller.text.isNotEmpty && capacity_controller.text.isNotEmpty
        && _selectCategory.getSelected()?.getValue() != null
        && _selectEtablissement.getSelected()?.getValue() != null
    //&& image_path.isNotEmpty
    ){

      var rev = <String, dynamic>{
        "id_salle" : id,
        "id_etablissement": _selectEtablissement.getSelected()?.getValue(),
        "id_category": _selectCategory.getSelected()?.getValue(),
        "nom_salle": name_controller.text,
        "capacity": capacity_controller.text,
        "image" : image_path
      };

      print(rev);
      final response = await http.put(Uri.parse(
          HOST+"/api/salles/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(rev),
      );

      if (response.statusCode == 200) {

        //print("etb added");
        print(response.body);
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context,true);
          initData();
          fetchSalle();
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context, "Erreur ajout reservation");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }
  void modal_add(context){
    var etab = Etablissements.where((element) => element.id_etablissement == _selectEtablissement.getSelected()?.getValue()).first;
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
                      Text('Ajouter une Salle',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("${etab.nom_etablissement}", style: TextStyle(fontSize: 16,)),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(
                            title: 'Salle *'
                        ),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(boxShadow: [

                            ]),
                            child: TextField(
                              controller: name_controller,
                              decoration: new InputDecoration(
                                  hintText: 'Nom de la salle',
                                  hintStyle: TextStyle(fontSize: 14)
                              ),
                            )
                        ),
                        SizedBox(height: 15,),
                        /* LabelText(
                            title: 'Etablissement *'
                        ),
                        BsSelectBox(
                          hintText: 'Etablissement',
                          controller: _selectEtablissement,
                          disabled: true,
                        ),
                        SizedBox(
                          height: 15,
                        ),*/

                        LabelText(
                            title: 'Catégorie *'
                        ),
                        BsSelectBox(
                          hintText: 'Catégorie',
                          controller: _selectCategory,
                          searchable: true,
                          serverSide:searchCategorie,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        LabelText(
                            title: 'Capacité'
                        ),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(boxShadow: [

                            ]),
                            child: TextField(
                              controller: capacity_controller,
                              decoration: new InputDecoration(
                                  hintText: 'capacité',
                                  hintStyle: TextStyle(fontSize: 14)
                              ),
                            )
                        ),
                        SizedBox(height: 15,),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                    title: 'Image'
                                ),
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

                                image_path.isNotEmpty ?
                                SizedBox(
                                  width: 300, //
                                  height: 150,
                                  child: Image.network(
                                      HOST+"/media/"+image_path
                                  ),
                                ) :Text("select image",textAlign: TextAlign.center,),
                              ],
                            ),
                          ],
                        ),
                        SizedBox( height: 10),
                        InkWell(
                          onTap: (){
                            add(context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child:
                                Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 13),)),
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.blue,
                                    border: Border.all(
                                        color: Colors.blueAccent
                                    )
                                ),
                              ),
                              SizedBox(height: 6,),
                              LabelText(
                                  title: 'Nb: *  un champ obligatoire'
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  void modal_update(context, Salle s, {bool uploadmage = false}){
    var etab = Etablissements.where((element) => element.id_etablissement == _selectEtablissement.getSelected()?.getValue()).first;
    if(!uploadmage){
      name_controller.text = s.nom_salle!;
      capacity_controller.text = s.capacity.toString();

      image_path = s.image!;

      //_selectCategory.clear();
      _selectEtablissement.clear();
      category_salle category = category_salles.where((element) =>
      element.id_category == s.id_category).first;
      _selectCategory.setSelected(
          BsSelectBoxOption(
              value: category.id_category,
              text: Text("${category.nom_category}")
          )
      );

      //getCategory(category_id: s.id_category);
      print("id etab : ${s.id_etablissement}");
      getEtablissement(etab_id: s.id_etablissement);
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
                      Text('Modifier une Salle',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("${etab.nom_etablissement}", style: TextStyle(fontSize: 16,)),
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
                        LabelText(
                            title: 'Salle'
                        ),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(boxShadow: [

                            ]),
                            child: TextField(
                              controller: name_controller,
                              decoration: new InputDecoration(
                                  hintText: 'Nom de la salle',
                                  hintStyle: TextStyle(fontSize: 14)
                              ),
                            )
                        ),
                        SizedBox(
                          height: 15,
                        ),

                        LabelText(
                            title: 'Catégorie *'
                        ),
                        BsSelectBox(
                          hintText: 'Catégorie',
                          controller: _selectCategory,
                          searchable: true,
                          serverSide:searchCategorie,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        LabelText(
                            title: 'Capacité'
                        ),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(boxShadow: [

                            ]),
                            child: TextField(
                              controller: capacity_controller,
                              decoration: new InputDecoration(
                                  hintText: 'capacité',
                                  hintStyle: TextStyle(fontSize: 14)
                              ),
                            )
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                    title: 'Image'
                                ),
                                SizedBox(
                                  height: 8,
                                ),

                                InkWell(
                                  onTap: (){
                                    cameraImage(context, salle: s);
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

                                image_path.isNotEmpty ?
                                SizedBox(
                                  width: 300, //
                                  height: 150,
                                  child: Image.network(
                                      HOST+"/media/"+image_path
                                  ),
                                ) :Text("select image",textAlign: TextAlign.center,),
                              ],
                            ),
                          ],
                        ),
                        SizedBox( height: 10),
                        InkWell(
                          onTap: (){
                            update(context, s.id_salle!);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child:
                                Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 13),)),
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.blue,
                                    border: Border.all(
                                        color: Colors.blueAccent
                                    )
                                ),
                              ),
                              SizedBox(height: 6,),
                              LabelText(
                                  title: 'Nb: * designe un champ obligatoire'
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
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
              SideBarCoachs(postion: 5,msg:"Coach"),
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
                                  Text("Les Salles", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),

                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     InkWell(
                                  //       onTap: (){Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //             builder: (context) => CatSalleScreen(),
                                  //           ));
                                  //       },
                                  //       child: Container(
                                  //         height: 40,
                                  //         decoration: BoxDecoration(
                                  //             color: Colors.blue[200],
                                  //             borderRadius: BorderRadius.circular(10)
                                  //         ),
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(8.0),
                                  //           child: Center(
                                  //             child: Text("Catégorie Salle",
                                  //                 style: TextStyle(
                                  //                     fontSize: 15
                                  //                 )),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     SizedBox(width: 5,),
                                  //     InkWell(
                                  //       onTap: (){
                                  //         /*Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //               builder: (context) => AddReservation(),
                                  //             )).then((val)=>fetchReservation()
                                  //         );*/
                                  //         modal_add(context);
                                  //       },
                                  //       child: Container(
                                  //         height: 40,
                                  //         decoration: BoxDecoration(
                                  //             color: Colors.blue[200],
                                  //             borderRadius: BorderRadius.circular(10)
                                  //         ),
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(8.0),
                                  //           child: Center(
                                  //             child: Text("Ajouter une Salle",
                                  //                 style: TextStyle(
                                  //                     fontSize: 15
                                  //                 )),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // )
                                ],
                              ):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Salles", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
                                  // Column(
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   crossAxisAlignment: CrossAxisAlignment.end,
                                  //   children: [
                                  //     InkWell(
                                  //       onTap: (){Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //             builder: (context) => CatSalleScreen(),
                                  //           ));
                                  //       },
                                  //       child: Container(
                                  //         height: 40,
                                  //         decoration: BoxDecoration(
                                  //             color: Colors.blue[200],
                                  //             borderRadius: BorderRadius.circular(10)
                                  //         ),
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(8.0),
                                  //           child: Center(
                                  //             child: Text("Catégorie Salle",
                                  //                 style: TextStyle(
                                  //                     fontSize: 15
                                  //                 )),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     SizedBox(height: 5,),
                                  //     InkWell(
                                  //       onTap: (){
                                  //         //
                                  //         modal_add(context);
                                  //       },
                                  //       child: Container(
                                  //         height: 40,
                                  //         decoration: BoxDecoration(
                                  //             color: Colors.blue[200],
                                  //             borderRadius: BorderRadius.circular(10)
                                  //         ),
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(8.0),
                                  //           child: Center(
                                  //             child: Icon(
                                  //                 Icons.add,
                                  //                 size: 18,
                                  //                 color: Colors.white
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // )
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
                                              child: Text("aucun Salle à afficher")),
                                        )
                                            :
                                        DataTable(
                                            dataRowHeight: DataRowHeight,
                                            headingRowHeight: HeadingRowHeight,
                                            columns: screenSize.width > 800 ?
                                            <DataColumn>[
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Salle',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Catégorie',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Capacité',
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

                                            ]:
                                            <DataColumn>[
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    ' Nom Salle',
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

                                            ],
                                            rows:
                                            data.map<DataRow>((r) => DataRow(
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
                                                              image: NetworkImage('${HOST}/media/${r.image}')
                                                          )
                                                      ),
                                                    ),
                                                    SizedBox(width: 6,),
                                                    Text(r.nom_salle.toString())
                                                  ],
                                                )),
                                                //DataCell(Text(r.etablissement.toString())),
                                                // DataCell(
                                                //     Text(
                                                //       "${r.datereservation.toString()}"
                                                //     )),
                                                DataCell(
                                                    Text(
                                                        "${r.category}"
                                                    )),
                                                DataCell(Text(r.capacity.toString())),
                                                // DataCell(Text(r.motif_annulation == null ? "-" : r.motif_annulation.toString())),
                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
                                                        msg:"•Visualisation Les détails de la salle",
                                                        onPressed: (){
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
                                                                            Text('${r.nom_salle.toString()}',
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
                                                                          //closeButton: true,

                                                                        ),
                                                                        //BsModalContainer(title: Text('${r.nom_salle.toString()}', style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.grey),), closeButton: true),
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
                                                                                          image: NetworkImage('${HOST}/media/${r.image.toString()}')
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 8,),
                                                                                Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(height: 4,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text("Nom etablissement: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text(" ${r.etablissement.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text("Catégorie: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text("  ${r.category.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text("Capacité: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text("  ${r.capacity.toString()}"),
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
                                                    // EditerButton(
                                                    //     msg: "Mettre à jour les informations de la Salle",
                                                    //     onPressed: (){
                                                    //       modal_update(context, r);
                                                    //     }
                                                    // ),
                                                    // SizedBox(width: 10,),
                                                    // DeleteButton(
                                                    //   msg:"Supprimer La Salle",
                                                    //   onPressed: () async{
                                                    //     if (await confirm(
                                                    //       context,
                                                    //       title: const Text('Confirmation'),
                                                    //       content: const Text('Souhaitez-vous supprimer ?'),
                                                    //       textOK: const Text('Oui'),
                                                    //       textCancel: const Text('Non'),
                                                    //     )) {
                                                    //
                                                    //       delete(r.id_salle.toString());
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
                                                    Expanded(
                                                      child: Text(r.nom_salle.toString(),
                                                        overflow: TextOverflow.ellipsis,),
                                                    )
                                                  ],
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
                                                        msg:"•Visualisation Les détails de la salle",
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
                                                                            Text('${r.nom_salle.toString()}',
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
                                                                          //closeButton: true,

                                                                        ),
                                                                        // BsModalContainer(title: Text('${r.nom_salle.toString()}', style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.grey),), closeButton: true),
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
                                                                                          image: NetworkImage('${HOST}/media/${r.image.toString()}')
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 8,),
                                                                                Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Nom etablissement: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${r.etablissement.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Catégorie: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("  ${r.category.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Capacité: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("  ${r.capacity.toString()}"),
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
                                                    SizedBox(width: 6,),
                                                    // EditerButton(
                                                    //     msg: "Mettre à jour les informations de la Salle",
                                                    //     onPressed: (){
                                                    //       modal_update(context, r);
                                                    //     }
                                                    // ),
                                                    // SizedBox(width: 6,),
                                                    // DeleteButton(
                                                    //   msg:"Supprimer La Salle",
                                                    //   onPressed: () async{
                                                    //     if (await confirm(
                                                    //       context,
                                                    //       title: const Text('Confirmation'),
                                                    //       content: const Text('Souhaitez-vous supprimer ?'),
                                                    //       textOK: const Text('Oui'),
                                                    //       textCancel: const Text('Non'),
                                                    //     )) {
                                                    //
                                                    //       delete(r.id_salle.toString());
                                                    //     }
                                                    //
                                                    //   },
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

