
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../componnents/showButton.dart';
import '../constants.dart';
import '../models/Admin.dart';
import '../models/ClientModels.dart';
import '../models/ContratModels.dart';
import '../models/TransactionModels.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'ContratScreen.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({Key? key, Contrat? this.contrat, bool? this.showCancelBtn}) : super(key: key);

  Contrat? contrat;

  bool? showCancelBtn = true;

  @override
  State<TransactionScreen> createState() => _TransactionState();
}

class _TransactionState extends State<TransactionScreen> {

  List<Transaction> transations = [];
  List<Transaction> init_data = [];
  List<Transaction> data = [];
  List<Client> clients = [];
  List<Contrat> contracts = [];

  Admin? admin;
  bool showAlert = false;

  Contrat? contrat;

  void search(String key){
    if(key.length > 0){
      final List<Transaction> founded = [];
      print(key);
      init_data.forEach((e) {
        if( e.id_tran == key
            || e.client!.toLowerCase().contains(key.toLowerCase())
            || e.montant!.toLowerCase().contains(key.toLowerCase())
            || e.mail_admin!.toLowerCase().contains(key.toLowerCase())
        )
        {
          founded.add(e);
        }
      });
      print(founded.length);
      setState(() {
        transations = founded;
      });
    }else {
      setState(() {
        transations = init_data;
      });
    }

  }
  void seeDetail(Transaction t){
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
                      Text('Transaction N°: ${t.id_tran}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Fermer'),
                        // prefixIcon: Icons.close,
                        onPressed: () {
                          initData();
                          Navigator.pop(context);
                        },
                      )
                    ],
                    //closeButton: true,

                  ),
                  /*BsModalContainer(title: Text('Transaction N°: ${t.id_tran}',style: TextStyle(
                                                    fontWeight: FontWeight.bold, color: Colors.grey
                                                ),), closeButton: true),*/
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
                                    image: NetworkImage('${HOST}/media/${t.image.toString()}')
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
                                      Text("Date:" ,style: TextStyle(
                                          fontWeight: FontWeight.bold, color:Colors.grey
                                      ),),
                                      SizedBox(width: 9,),
                                      Text(" ${DateFormat('dd/MM/yyyy').format(t.date!)}"),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Text("Type Transaction:" ,style: TextStyle(
                                          fontWeight: FontWeight.bold, color:Colors.grey
                                      ),),
                                      SizedBox(width: 9,),
                                      Text(" ${t.Type == true ? "Entrée" : "Sortie"}"),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Text("Montant:" ,style: TextStyle(
                                          fontWeight: FontWeight.bold, color:Colors.grey
                                      ),),
                                      SizedBox(width: 9,),
                                      Text(" ${t.montant} "),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Text("Mode reglement:" ,style: TextStyle(
                                          fontWeight: FontWeight.bold, color:Colors.grey
                                      ),),
                                      SizedBox(width: 9,),
                                      Text(" ${t.Mode_reglement} "),
                                    ],
                                  ),

                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Text("Client:" ,style: TextStyle(
                                          fontWeight: FontWeight.bold, color:Colors.grey
                                      ),),
                                      SizedBox(width: 9,),
                                      Text("${t.client} "),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Text("Contrat:" ,style: TextStyle(
                                          fontWeight: FontWeight.bold, color:Colors.grey
                                      ),),
                                      SizedBox(width: 9,),
                                      Text("${t.contrat
                                      } "),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Text("Description:" ,style: TextStyle(
                                          fontWeight: FontWeight.bold, color:Colors.grey
                                      ),),
                                      SizedBox(width: 9,),
                                      Text(" ${t.description}  "),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Text("Acteur:" ,style: TextStyle(
                                          fontWeight: FontWeight.bold, color:Colors.grey
                                      ),),
                                      SizedBox(width: 9,),
                                      Text("${t.mail_admin} ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black
                                        ),
                                      ),
                                    ],
                                  )
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

  Future<BsSelectBoxResponse> searchClient(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in clients){
      var name = "${v.nom} ${v.prenom}";
      if(name.toLowerCase().contains(params["searchValue"]!.toLowerCase())){
        searched.add(
            BsSelectBoxOption(
                value: v.id_etudiant,
                text: Text("${v.nom} ${v.prenom}")
            )
        );
      }
    }
    return BsSelectBoxResponse(options: searched);
  }

  BsSelectBoxController _selectClients = BsSelectBoxController();
  TextEditingController Montant_controller = TextEditingController();
  TextEditingController restOld_controller = TextEditingController();
  TextEditingController restNew_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();

  BsSelectBoxController _selectContract = BsSelectBoxController();

  BsSelectBoxController _selectType = BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 0, text: Text("Sortie")),
        BsSelectBoxOption(value: 1, text: Text("Entréee")),
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

  BsSelectBoxController _selectTypeTransaction= BsSelectBoxController(
      options: [
        BsSelectBoxOption(value: 2, text: Text("Tout")),
        BsSelectBoxOption(value: 1, text: Text("Entrée")),
        BsSelectBoxOption(value: 0, text: Text("Sortie")),
      ]
  );

  Future<BsSelectBoxResponse> searchcontrat(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in contracts){
      if(v.abonnement!.toLowerCase().contains(params["searchValue"]!.toLowerCase())
        && v.id_etd! == _selectClients.getSelected()?.getValue()
      ){
        searched.add(
            BsSelectBoxOption(
                value: v.id_contrat,
                text: Text("${v.abonnement}-${v.type_contrat}")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
  }
  void filterTransaction(){
    if(_selectTypeTransaction.getSelected()?.getValue() != null){
      setState(() {
        transations = [];
      });
      print("filtering...");
      if(_selectTypeTransaction.getSelected()?.getValue() == 2){
        setState(() {
          transations = init_data;
        });
        print("tout...");
      }
      if(_selectTypeTransaction.getSelected()?.getValue() == 1){
        setState(() {
          transations = init_data.where((element) => element.Type == true).toList();
        });
        print("entre...");

      }

      if(_selectTypeTransaction.getSelected()?.getValue() == 0){
        print("sortie...");
        setState(() {
          transations = init_data.where((element) => element.Type == false).toList();
        });

      }

    }else{
      print("selected is null...");
      setState(() {
        transations = init_data;
      });
    }
  }

  void add(context) async {

    if( _selectType.getSelected()?.getValue() != null
        && Montant_controller.text.isNotEmpty
        && _selectMode.getSelected()?.getValue() != null
        && _selectContract.getSelected()?.getValue() != null
    ){

      var rev = <String, dynamic>{
        "id_contrat" : _selectContract.getSelected()!.getValue(),
        "Type": _selectType.getSelected()!.getValue(),
        "Mode_reglement": _selectMode.getSelected()!.getValue(),
        "description" : description_controller.text,
        "montant" : Montant_controller.text,
        "id_admin": admin!.id
      };

      print(rev);
      final response = await http.post(Uri.parse(
          HOST+"/api/transactions/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(rev),
      );

      if (response.statusCode == 200) {
        print(response.body);
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context,true);
          initData();
          fetchTransactions();
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context, "Erreur ajout transaction");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }

  void modal_add(context, {bool? cancelBtn = true}){

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    _selectMode.setSelected(BsSelectBoxOption(value: "Espéces", text: Text("Espéces")));

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
                      Text("Ajouter une Transaction",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                      cancelBtn! ? BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Annuler'),
                        //prefixIcon: Icons.close,
                        onPressed: () {

                          Navigator.pop(context);
                          initData();
                        },
                      ): SizedBox(width: 0,)
                    ],
                    //closeButton: true,

                  ),
                  /*BsModalContainer(
                    title: Text('Ajouter une Transaction' ),
                    closeButton: true,
                    onClose: (){
                      Navigator.pop(context);
                      initData();

                    },
                  ),*/
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
                                    LabelText(
                                        title: 'Etudiants *'
                                    ),

                                    BsSelectBox(
                                      hintText: 'Etudiants',
                                      controller: _selectClients,
                                      searchable: true,
                                      serverSide: searchClient,
                                      onChange: (v) {
                                        int id_etudiant = _selectClients.getSelected()?.getValue();
                                        try{
                                          restOld_controller.text = "" ;
                                          contrat = null ;
                                          _selectContract.clear();
                                          /*if(_selectContract.getSelected()?.getValue() != null){
                                            _selectContract.removeSelected(_selectContract.getSelected()!);
                                          }*/

                                        }catch(e){
                                          print(e);
                                        }

                                        getContractsForClient(id_etudiant, context);

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
                                        title: "Contrat *"
                                    ),
                                    BsSelectBox(
                                      hintText: 'Contrat',
                                      controller: _selectContract,
                                      searchable: true,
                                      serverSide: searchcontrat,
                                      onChange: (valeur){
                                        int id = _selectContract.getSelected()?.getValue();
                                        getContratById(id);
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
                                        title: "Le reste Precedent "
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          controller: restOld_controller,
                                          enabled: false,
                                          decoration: InputDecoration(
                                              hintText: "Le reste Precedent",
                                              hintStyle: TextStyle(fontSize: 14)
                                          ),
                                        )
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
                                        title: "Montant * "
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          autofocus: true,
                                          controller: Montant_controller,
                                          decoration: InputDecoration(
                                              hintText: "Montant",
                                              hintStyle: TextStyle(fontSize: 14)
                                          ),


                                         /* onChanged: (value){
                                            String s_montant = "0.0";
                                            String s_tarif = "0.0";

                                            if(Montant_controller.text.contains(".")){
                                              s_montant = Montant_controller.text;
                                            }else {
                                              s_montant = "${Montant_controller.text}.0";
                                            }

                                            if(tarif_controller.text.contains(".")){
                                              s_tarif = tarif_controller.text;
                                            }else {
                                              s_tarif = "${tarif_controller.text}.0";
                                            }

                                            try{
                                              double montant = double.parse(s_montant);
                                              double tarif = double.parse(s_tarif) ;
                                              if(montant>0 && montant<=tarif){
                                                double reslt = tarif - montant ;
                                                restNew_controller.text = reslt.toString();
                                                if(showAlert){
                                                  setState(() {
                                                    showAlert = false;
                                                  });
                                                  Navigator.pop(context);
                                                  modal_add2(context);
                                                }

                                              }
                                              else{
                                                restNew_controller.text="";
                                                setState(() {
                                                  showAlert = true;
                                                });
                                                Navigator.pop(context);
                                                modal_add2(context);
                                              }
                                            }catch(e){
                                              restNew_controller.text="";
                                              setState(() {
                                                showAlert = true;
                                              });
                                              Navigator.pop(context);
                                              modal_add2(context);
                                            }
                                            *//* Navigator.pop(context);
                                            modal_add(context);*//*

                                          },*/
                                          onChanged: (value){
                                            String s_montant = "0.0";
                                            String s_tarif = "0.0";
                                            if(Montant_controller.text.contains(".")){
                                              s_montant = Montant_controller.text;
                                            }else {
                                              s_montant = "${Montant_controller.text}.0";
                                            }

                                            if(restOld_controller.text.contains(".")){
                                              s_tarif = restOld_controller.text;
                                            }else {
                                              s_tarif = "${restOld_controller.text}.0";
                                            }
                                            try{
                                              double montant = double.parse(s_montant);
                                              double tarif = double.parse(s_tarif) ;
                                              if(montant>0 && montant<=tarif){
                                                double reslt = tarif - montant ;
                                                restNew_controller.text = reslt.toString();
                                                if(showAlert){
                                                  setState(() {
                                                    showAlert = false;
                                                  });
                                                  Navigator.pop(context);
                                                  modal_add(context);
                                                }

                                              }
                                              else{
                                                restNew_controller.text="";
                                                setState(() {
                                                  showAlert = true;
                                                });
                                                Navigator.pop(context);
                                                modal_add(context);
                                              }
                                            }catch(e){
                                              restNew_controller.text="";
                                              /*setState(() {
                                                showAlert = true;
                                              });*/
                                              Navigator.pop(context);
                                              modal_add(context);
                                            }
                                           /* double montant = double.parse(s_montant);
                                            double reslt = double.parse(s_tarif) - montant ;
                                            restNew_controller.text = reslt.toString();*/
                                            /* Navigator.pop(context);
                                            modal_add(context);*/

                                          },
                                        )
                                    ),
                                    showAlert ? Text("Le montant saisier n'est pas valide",
                                        style: TextStyle(color: Colors.red)) : SizedBox(width: 0,)
                                  ],
                                )
                            ),
                            SizedBox(width: 15,),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: "Le reste actuel "
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          controller: restNew_controller,
                                          enabled: false,
                                          decoration: InputDecoration(
                                              hintText: "Le reste actuel",
                                              hintStyle: TextStyle(fontSize: 14)
                                          ),
                                        )
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(width: 15,),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: "Description "
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          controller: description_controller,
                                          decoration: InputDecoration(
                                              hintText: "Description",
                                              hintStyle: TextStyle(fontSize: 14)
                                          ),
                                        )
                                    ),
                                  ],
                                )
                            )
                          ]
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
                                        title: "Mode de Réglement *"
                                    ),
                                    BsSelectBox(
                                      hintText: 'mode de réglement',
                                      controller: _selectMode,
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
                                        title: "Type *"
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    BsSelectBox(
                                      hintText: 'Type',
                                      controller: _selectType,
                                    ),
                                  ],
                                )
                            ),

                          ],
                        ),

                        SizedBox(
                          height: 25,
                        ),

                        InkWell(
                          onTap: (){
                            add(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                              SizedBox(height: 8,),
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

  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/transactions/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchTransactions();
    } else {
      throw Exception('Failed to load data');
    }
  }

  void getClient({bool? init=false}) async {
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
        clients = result.map<Client>((e) => Client.fromJson(e)).toList();
      });
      _selectClients.options = clients.map<BsSelectBoxOption>((c) =>
          BsSelectBoxOption(
              value: c.id_etudiant,
              text: Text("${c.nom} ${c.prenom}")
          )).toList();

      print("--data--");
      print(clients.length);

      if(init!){
        if(widget.contrat != null){
          print("contrat => ${widget.contrat!.toJson()}");
          Montant_controller.text = widget.contrat!.montant_paye!;
          restOld_controller.text = widget.contrat!.reste!;
          restNew_controller.text = widget.contrat!.reste!;

          Client c = clients.where((el) => el.id_etudiant == widget.contrat!.id_etd).first;

          _selectClients.setSelected(BsSelectBoxOption(value: c.id_etudiant, text: Text("${c.nom!} ${c.prenom!}")));
          _selectContract.setSelected(BsSelectBoxOption(value: widget.contrat!.id_contrat!, text: Text("Contrat ID ${widget.contrat!.id_contrat!} - n° ${widget.contrat!.numcontrat!}")));

          modal_add(context, cancelBtn: widget.showCancelBtn);
        }
      }

    } else {
      throw Exception('Failed to load data');
    }
  }

  void getContrat() async {
    print("loading ...");
    final response = await http.get(Uri.parse(
        HOST+'/api/contrat/'),
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
        contracts = result.map<Contrat>((e) => Contrat.fromJson(e)).toList();
      });


    } else {
      throw Exception('Failed to load data');
    }

  }

  void fetchTransactions() async {

    print("loading ...");
    final response = await http.get(Uri.parse(
        HOST+'/api/transactions/'),
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
        transations = result.map<Transaction>((e) => Transaction.fromJson(e)).toList();
        init_data = result.map<Transaction>((e) => Transaction.fromJson(e)).toList();
      });

      print("--data--");
    } else {
      throw Exception('Failed to load data');
    }

  }

  void getContratById(int id_contrat) async{
    final response = await http.get(Uri.parse(
        HOST+'/api/contrat/${id_contrat}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      contrat = Contrat.fromJson(body["data"]);

      restOld_controller.text = contrat!.reste!;


    } else {
      throw Exception('Failed to load data');
    }
  }
  var token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state");
    fetchTransactions();
    getClient(init: true);
    getContrat();

    _selectType.setSelected(BsSelectBoxOption(value: 1, text: Text("Entréee")));



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
      title: Text("Transaction"),
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

  void getContractsForClient(int client_id, context) {
    List<BsSelectBoxOption> options = [];
    var client = clients.where((el) => el.id_etudiant == client_id).first;
    contracts.forEach((c) {
      if(c.id_etd == client_id){
        options.add(BsSelectBoxOption(
            value: c.id_contrat,
            text: Text(" ${c.abonnement}-${c.type_contrat}")
        ));
      }
    });
    if(options.length == 0){
      showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Transaction'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Ce client n'a pas de contrat"),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Créer un contrat", style: TextStyle(color: Colors.orange)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ContratScreen(client: client),
                        ));
                  },
                ),

                TextButton(
                  child: const Text('Fermer', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),


              ],
            );
          });

    }else{
      print("nb contrat ${options.length}");
      Navigator.pop(context);
      modal_add(context);
    }

    _selectContract.options = options;
  }

  void initData(){
    Montant_controller.text = "";
    restOld_controller.text = "";
    restNew_controller.text = "";
    if(_selectClients.getSelected()!= null){
      _selectClients.removeSelected(_selectClients.getSelected()!);
    }

    if(_selectType.getSelected() != null){
      _selectType.removeSelected(_selectType.getSelected()!);
    }
    if(_selectMode.getSelected()!= null){
      _selectMode.removeSelected(_selectMode.getSelected()!);
    }
    if(_selectContract.getSelected()!= null){
      _selectContract.removeSelected(_selectContract.getSelected()!);
    }

  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    admin = context.watch<AdminProvider>().admin;
    DataTableSource dataSource = MyDataSource(
        data: transations ,
        context: context,
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
              //SideBar(postion: 9,msg:"transaction"),
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
                                child: Center(child: Text("Transactions", style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.w700,
                                    color: Colors.black)),),
                              ),
                              SizedBox(
                                height: 30,
                              ),
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
                                        controller: _selectTypeTransaction,
                                        onChange: (v){
                                          filterTransaction();
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
                                            child: Text("Ajouter Transactions",
                                                style: TextStyle(
                                                    fontSize: 15
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ) :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Les Transactions", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
                                  SizedBox(height: 8,),
                                  Container(
                                    width: 180,
                                    child: BsSelectBox(
                                      hintText: 'Filtrer',
                                      controller: _selectTypeTransaction,
                                      onChange: (v){
                                        filterTransaction();
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 8,),
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
                                          child: Text("Ajouter Transactions",
                                              style: TextStyle(
                                                  fontSize: 15
                                              )),
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
                                  // ignore: unnecessary_null_comparison
                                  dataSource != null ?
                                  transations.length > 0 ? PaginatedDataTable(
                                    dataRowHeight: DataRowHeight,
                                    headingRowHeight: HeadingRowHeight,
                                    columns: screenSize.width > 800 ?
                                    <DataColumn>[
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Client',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Date de transaction',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Type',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                      // DataColumn(
                                      //   label: Expanded(
                                      //     child: Text(
                                      //       'Client',
                                      //       style: TextStyle(
                                      //           fontStyle: FontStyle.italic,
                                      //           fontWeight: FontWeight.bold
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            "Actions",
                                            style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ]:
                                    <DataColumn>[
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Client',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            "Actions",
                                            style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                    source: dataSource,
                                    rowsPerPage: 20,
                                  )
                                      : Padding(
                                    padding: const EdgeInsets.all(200.0),
                                    child: Center(child: Text("aucune Transaction à afficher.")),
                                  ): Text("Chargement des données ...")
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
  MyDataSource({required this.data, required this.context,
    required this.seeDetail,
    required this.isMobile
  });

  List<Transaction> data = [];
  BuildContext context;
  bool isMobile;



  Function seeDetail;

  @override
  int get rowCount => data.length;

  @override
  DataRow? getRow(int index) {
    Transaction t = data[index];
    return DataRow(
      cells: !isMobile ?
        <DataCell>[
          DataCell(Row(
            children: [
              t.Type == true ?
              Icon(Icons.arrow_circle_right_outlined, size: 22, color: Colors.green,) :
              Icon(Icons.arrow_circle_left_outlined, size: 22, color: Colors.red,),
              SizedBox(width: 9,),
              Text( "${t.client}")
            ],
          )),
          DataCell(Text(DateFormat('dd/MM/yyyy').format(t.date!))),
          DataCell(
              Text(
                  t.Type == true ? "Entrée" : "Sortie"
              )
          ),
          //DataCell(Text(t.client!)),
          // DataCell(Text(r.motif_annulation == null ? "-" : r.motif_annulation.toString())),
          DataCell(Row(
            children: [
              ShowButton(
                  msg: "•Visualisation des détails du client",
                  onPressed: (){
                    seeDetail(t);
                  }

              ),
              SizedBox(width: 10,),
            ],
          ))
        ]:
        <DataCell>[
          DataCell(Row(
            children: [
              t.Type == true ?
              Icon(Icons.arrow_circle_right_outlined, size: 22, color: Colors.green,) :
              Icon(Icons.arrow_circle_left_outlined, size: 22, color: Colors.red,),
              SizedBox(width: 9,),
              Text( "${t.client}")
            ],
          )),
          DataCell(Row(
            children: [
              ShowButton(
                  msg: "•Visualisation des détails du client",
                  onPressed: (){
                    seeDetail(t);
                  }

              ),
              SizedBox(width: 10,),


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

