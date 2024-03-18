import 'dart:convert';

import 'package:adminmmas/constants.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../componnents/showButton.dart';
import '../models/AbonnementModels.dart';
import '../models/CatContratModels.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';


import 'package:http/http.dart' as http;

import 'Addabonnement.dart';
import 'Cat_contrat.dart';
import 'UpdateAbonnement.dart';

class AbonnementScreen extends StatefulWidget {
  const AbonnementScreen({Key? key}) : super(key: key);

  @override
  State<AbonnementScreen> createState() => _AbonnementState();
}

class _AbonnementState extends State<AbonnementScreen> {

  List<Abonnement> data = [];
  List<Abonnement> init_data = [];
  bool loading = false;

  TextEditingController type_controller = TextEditingController();
  TextEditingController tarif_controller = TextEditingController();
  TextEditingController Systeme_controller = TextEditingController();
  TextEditingController Niveau_age_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  BsSelectBoxController _selectCategorycotrat = BsSelectBoxController();

  List<category_contrat> category = [];

  String type_abonnement = "";
  String tarif = "";
  String Systeme = "";
  String description = "";
  String Niveau_age = "";

  Future<BsSelectBoxResponse> searchCategory(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in category){
      var name = "${v.type_contrat}";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_cat_cont,
                text: Text("${v.type_contrat}")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";
  /**
   * initialiser les données
   * @return: void
   */
  void initData() {
    type_controller.text = "" ;
    tarif_controller.text = "" ;
    Niveau_age_controller.text = "" ;
    Systeme_controller.text = "" ;
    description_controller.text = "" ;
    _selectCategorycotrat.removeSelected(_selectCategorycotrat.getSelected()!);
  }
  /**
   * lister tous les abonnements qui existe dans Notre base de donnée
   * @return: void
   */
  void fetchAbonnement() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/abonnement/'),
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
        data = result.map<Abonnement>((e) => Abonnement.fromJson(e)).toList();
        init_data = result.map<Abonnement>((e) => Abonnement.fromJson(e)).toList();
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
  /**
   * chercher dans la liste des abonnements en utilisants key
   * @param: String Key
   * @return: void
   */
  void search(String key){
    if(key.length >= 1){
      final List<Abonnement> founded = [];
      init_data.forEach((e) {
        if(e.type_abonnement!.toLowerCase().contains(key.toLowerCase())
            || e.tarif.toString().toLowerCase().contains(key.toLowerCase())
            || e.Systeme.toString().toLowerCase().contains(key.toLowerCase())
            || e.Niveau_age.toString().toLowerCase().contains(key.toLowerCase())
            || e.namecat_conrat.toString().toLowerCase().contains(key.toLowerCase())
        )
        {
          founded.add(e);
        }
      });
      setState(() {
        data = founded;
      });
    }else{
      setState(() {
        data = init_data;
      });
    }

  }
  /**
   * validation de formulaire et la preparation des données pour l'envoyer A l'api
   * @param: BuildContext context
   * @return: void
   */
  void add(context) async {

    if(type_abonnement.length > 0 && tarif.length > 0 && Niveau_age.length > 0 && Systeme.length > 0
        && description.length > 0&& _selectCategorycotrat.getSelected()?.getValue() != null
    ){
      var abon = <String, dynamic>{
        "type_abonnement": type_abonnement,
        "tarif": tarif,
        "Niveau_age": Niveau_age,
        "Systeme": Systeme,
        "description": description,
        "id_cat_cont": _selectCategorycotrat.getSelected()?.getValue(),
      };

      print(abon);
      final response = await http.post(Uri.parse(
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
        fetchAbonnement();
        Navigator.pop(context,true);

      } else {
        //throw Exception('Failed to load data');
        showAlertDialog(context, "Erreur ajout abonnement");
      }
    }else{
      showAlertDialog(context, "remplir tous les champs");
    }
  }
  /**
   * preparation des données (catégorieContrat) pour l'envoyer A l'api
   * @return: void
   */
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

      print("--data--");
      print(category.length);
    } else {
      throw Exception('Failed to load data');
    }
  }
  /**
   * validation de formulaire modifier et la preparation des données pour l'envoyer A l'api
   * @param: BuildContext context
   * @param: int id
   * @return: void
   */
  void update(context, int id) async {

    if(type_controller.text.isNotEmpty
        && tarif_controller.text.isNotEmpty
        && Niveau_age_controller.text.isNotEmpty
        && Systeme_controller.text.isNotEmpty
        && description_controller.text.isNotEmpty
        && _selectCategorycotrat.getSelected()?.getValue() != null
    ){
      var abon = <String, dynamic>{
        "id_abn": id,
        "type_abonnement": type_controller.text,
        "tarif": tarif_controller.text,
        "Niveau_age": Niveau_age_controller.text,
        "Systeme": Systeme_controller.text,
        "description": description_controller.text,
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
        fetchAbonnement();
      } else {
        showAlertDialog(context,"Failed to update data");
      }
    }else{
      showAlertDialog(context,"erreur");
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
      title: Text("Abonnement"),
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
   * ui{formulaire d'ajout d'abonnement}
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
                      Text('Ajouter Abonnement',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        children: [
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Offre *'
                                    ),
                                    Container(
                                        width: 150,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          autofocus: true,
                                          onChanged: (val) {
                                            type_abonnement = val;
                                          },
                                          decoration: new InputDecoration(
                                            hintText: 'Offre',
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Niveau-age *'
                                    ),
                                    Container(
                                        width: 150,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          autofocus: true,
                                          onChanged: (val) {
                                            Niveau_age = val;
                                          },
                                          decoration: new InputDecoration(
                                            hintText: 'Niveau_age',
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Catégorie Contrat *'
                                    ),
                                    BsSelectBox(
                                      hintText: 'Catégorie Contrat',
                                      controller: _selectCategorycotrat,
                                      searchable: true,
                                      serverSide:searchCategory,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Système *'
                                    ),
                                    Container(
                                        width: 150,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          onChanged: (val) {
                                            Systeme = val;
                                          },
                                          decoration: new InputDecoration(
                                            hintText: 'Système',
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Description *'
                                    ),
                                    Container(
                                        width: 150,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          onChanged: (val) {
                                            description = val;
                                          },

                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(255,),
                                          ],
                                          decoration: new InputDecoration(
                                            counterText: '255 au max caractères',
                                            hintText: 'Description',
                                          ),
                                          maxLines: 5,
                                          minLines: 1,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Tarif *'
                                    ),
                                    Container(
                                        width: 150,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          onChanged: (val) {
                                            tarif = val;
                                          },
                                          decoration: new InputDecoration(
                                            hintText: 'Tarif en DH',
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: (){
                              add(context);
                            },
                            child: Container(
                              child:
                              Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 13),)),
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
                  ),

                ],
              ),
            )));
  }
  /**
   * ui{formulaire de Modification d'abonnement}
   * @param: BuildContext context
   * @return: void
   */
  void modal_Update(context, Abonnement abn){

    tarif_controller.text = abn.tarif.toString();
    type_controller.text = abn.type_abonnement!;
    Niveau_age_controller.text = abn.Niveau_age!;
    Systeme_controller.text = abn.Systeme!;
    description_controller.text = abn.description!;

    _selectCategorycotrat.setSelected(
      BsSelectBoxOption(value: abn.id_cat_cont, text: Text(abn.namecat_conrat.toString()))
    );

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
                      Text('Modifier Abonnement',
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
                  //BsModalContainer(title: Text('Modifier Abonnement'), closeButton: true),
                  BsModalContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelText(
                                      title: 'Offre *'
                                  ),
                                  Container(
                                      width: 150,
                                      decoration: BoxDecoration(boxShadow: [
                                      ]),
                                      child: TextField(
                                        autofocus: true,
                                        onChanged: (val) {
                                          type_abonnement = val;
                                        },
                                        controller: type_controller,
                                        decoration: new InputDecoration(
                                          hintText: 'Offre',
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(width: 4,),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelText(
                                      title: 'Niveau-age *'
                                  ),
                                  Container(
                                      width: 150,
                                      decoration: BoxDecoration(boxShadow: [
                                      ]),
                                      child: TextField(
                                        autofocus: true,
                                        onChanged: (val) {
                                          Niveau_age = val;
                                        },
                                        controller: Niveau_age_controller,
                                        decoration: new InputDecoration(
                                          hintText: 'Niveau_age',
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(width: 4,),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelText(
                                      title: 'Catégorie Contrat *'
                                  ),
                                  BsSelectBox(
                                    hintText: 'Catégorie Contrat',
                                    controller: _selectCategorycotrat,
                                    searchable: true,
                                    serverSide:searchCategory,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelText(
                                      title: 'Système *'
                                  ),
                                  Container(
                                      width: 150,
                                      decoration: BoxDecoration(boxShadow: [
                                      ]),
                                      child: TextField(
                                        onChanged: (val) {
                                          Systeme = val;
                                        },
                                        controller: Systeme_controller,
                                        decoration: new InputDecoration(
                                          hintText: 'Système',
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(width: 4,),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelText(
                                      title: 'Description *'
                                  ),
                                  Container(
                                      width: 150,
                                      decoration: BoxDecoration(boxShadow: [
                                      ]),
                                      child: TextField(
                                        onChanged: (val) {
                                          description = val;
                                        },
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
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelText(
                                      title: 'Tarif *'
                                  ),
                                  Container(
                                      width: 150,
                                      decoration: BoxDecoration(boxShadow: [
                                      ]),
                                      child: TextField(
                                        onChanged: (val) {
                                          tarif = val;
                                        },
                                        controller: tarif_controller,
                                        decoration: new InputDecoration(
                                          hintText: 'Tarif en DH',
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: (){
                            update(context, abn.id_abn!);
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
                  ),

                ],
              ),
            )));
  }
  /**
   * Cette méthode est appelée une seule fois lors de la création du widget,( l'initialisation de l'état)
   * @return: void
   */
  var token= "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state");
    fetchAbonnement();
    getCategorycontrat();
  }
  /**
   * methode de suppression d'abonnement
   * @param: int id
   * @return: void
   */
  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/abonnement/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchAbonnement();
    } else {
      throw Exception('Failed to load data');
    }
  }

  /**
   * interface d'abonnement
   * @param: BuildContext context
   */
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
              //SideBar(postion: 7,msg:"abonnement"),
              SizedBox(width: 8,),
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
                                child: Center(child: Text("Abonnements", style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.w700,
                                    color: Colors.black)),),
                              ),
                              SizedBox(height: 30,),
                              screenSize.width > 750 ?
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
                                  screenSize.width > 1200 ?
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 200,),
                                          SizedBox(width: 200,),
                                          InkWell(
                                            onTap: (){Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CatContratScreen(),
                                                ));
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
                                                  child: Text("Types d'Abonnement",
                                                      style: TextStyle(
                                                          fontSize: 15
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          InkWell(
                                            onTap: (){
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
                                                  child: Text("Ajouter Abonnement",
                                                      style: TextStyle(
                                                          fontSize: 15
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ):
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: (){Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CatContratScreen(),
                                            ));
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
                                              child: Text("Types d'Abonnement",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      InkWell(
                                        onTap: (){

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
                                              child: Text("Ajouter Abonnement",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ) :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Les Abonnements", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
                                  SizedBox(height: 5,),

                                  screenSize.width > 1200 ?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: (){Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CatContratScreen(),
                                            ));
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
                                              child: Text("Types d'Abonnement",
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      InkWell(
                                        onTap: (){

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
                                              child: Text("Ajouter Abonnement",
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ):
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: (){Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CatContratScreen(),
                                            ));
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
                                              child: Text("Types d'Abonnement",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      InkWell(
                                        onTap: (){

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
                                              child: Text("Ajouter Abonnement",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                              child: Text("aucun Abonnement à afficher")),
                                        )
                                            :
                                        DataTable(
                                            dataRowHeight: DataRowHeight,
                                            headingRowHeight: HeadingRowHeight,
                                            columns:
                                                screenSize.width > 900 ?
                                            <DataColumn>[
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Offres',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Niveau_Age',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Système',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Catégorie contrat',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Tarif en DH',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),

                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(fontStyle: FontStyle.italic),
                                                  ),
                                                ),
                                              ),
                                            ] :
                                                <DataColumn>[
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Offres',
                                                        style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        '',
                                                        style: TextStyle(fontStyle: FontStyle.italic),
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                            ,
                                            rows:
                                            data.map<DataRow>((e) =>
                                                DataRow(
                                              cells:
                                                  screenSize.width > 900 ?
                                              <DataCell>[
                                                DataCell(Row(
                                                  children: [
                                                    SizedBox(width: 10,),
                                                    Text(e.type_abonnement.toString())
                                                  ],
                                                )),
                                                DataCell(Text(e.Niveau_age.toString())),
                                                DataCell(Text(e.Systeme.toString())),
                                                DataCell(Text(e.namecat_conrat.toString())),
                                                DataCell(Text(e.tarif.toString())),

                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
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
                                                                        BsModalContainer(title: Text('${e.type_abonnement.toString()}'), closeButton: true),
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
                                                                                        Text("discipline: ${e.type_abonnement.toString()}"),
                                                                                        SizedBox(height: 4,),
                                                                                        Text("Niveau_Age: ${e.Niveau_age.toString()}"),
                                                                                        SizedBox(height: 4,),
                                                                                        Text("Système: ${e.Systeme.toString()}"),
                                                                                        SizedBox(height: 4,),
                                                                                        Text("categorie contrat: ${e.namecat_conrat.toString()}"),
                                                                                        SizedBox(height: 4,),
                                                                                        Text("tarif: ${e.tarif.toString()}"),
                                                                                        SizedBox(height: 4,),
                                                                                        Text("description: ${e.description.toString()}"),

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
                                                        }, msg: 'Détails',
                                                    ),
                                                    SizedBox(width: 10,),
                                                    EditerButton(
                                                        msg: "Mettre à jour les \n informations de \n l'abonnement",
                                                        onPressed: (){
                                                          modal_Update(context, e);
                                                        }
                                                    ),
                                                    SizedBox(width: 10,),
                                                    DeleteButton(
                                                      msg:"Supprimer le client ",
                                                      onPressed: () async {
                                                        if (await confirm(
                                                        context,
                                                        title: const Text('Confirmation'),
                                                        content: const Text('Souhaitez-vous supprimer ?'),
                                                        textOK: const Text('Oui'),
                                                        textCancel: const Text('Non'),
                                                        )) {

                                                        delete(e.id_abn.toString());
                                                        }


                                                      },
                                                    ),

                                                  ],
                                                )),
                                              ]:
                                                  <DataCell>[
                                                    DataCell(Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(e.type_abonnement.toString(),
                                                          overflow: TextOverflow.ellipsis,),
                                                        )
                                                      ],
                                                    )),
                                                    DataCell(Row(
                                                      children: [
                                                        ShowButton(
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
                                                                            BsModalContainer(title: Text('${e.type_abonnement.toString()}'), closeButton: true),
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
                                                                                            Text("Offre: ${e.type_abonnement.toString()}"),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("Niveau_Age: ${e.Niveau_age.toString()}"),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("Système: ${e.Systeme.toString()}"),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("categorie contrat: ${e.namecat_conrat.toString()}"),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("tarif: ${e.tarif.toString()}"),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("Description: ${e.description.toString()}"),
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
                                                            }, msg: 'détails',
                                                        ),
                                                        SizedBox(width: 10,),
                                                        EditerButton(
                                                          msg: "Mettre à jour les \n informations de \n l'abonnement",
                                                            onPressed: (){
                                                              modal_Update(context, e);
                                                            }
                                                        ),
                                                        SizedBox(width: 10,),
                                                        DeleteButton(
                                                          msg:"Supprimer le client ",
                                                          onPressed: () async {
                                                            if (await confirm(
                                                              context,
                                                              title: const Text('Confirmation'),
                                                              content: const Text('Souhaitez-vous supprimer ?'),
                                                              textOK: const Text('Oui'),
                                                              textCancel: const Text('Non'),
                                                            )) {

                                                              delete(e.id_abn.toString());
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    )),
                                                  ],
                                            )
                                            ).toList()
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

