import 'package:adminmmas/componnents/deleteButton.dart';
import 'package:adminmmas/componnents/editerButton.dart';
import 'package:adminmmas/componnents/showButton.dart';
import 'package:adminmmas/env.dart';
import 'package:adminmmas/views/CloneNotification.dart';
import 'package:adminmmas/views/UpdateNotification.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mailto/mailto.dart';

import 'package:adminmmas/models/NotificationModel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../componnents/duplicatButton.dart';
import '../componnents/label.dart';
import '../componnents/mailButton.dart';
import '../componnents/responsive.dart';
import '../constants.dart';
import '../models/Admin.dart';
import '../models/ClientModels.dart';
import '../models/ParentModels.dart';
import '../providers/NoticationContr.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';
import 'AddNotification.dart';
import 'UpdateNotif.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _controller = NotificationAdminController();
  late List<NotificationAdmin> _notifications;
  late bool _loading;
  bool _isAscending = true;
  List<Parent> parents = [];
  List<dynamic> sucess = [];
  List<dynamic> errors = [];

  BsSelectBoxController _selectParent = BsSelectBoxController();
  TextEditingController title_controller = TextEditingController();
  TextEditingController body_controller = TextEditingController();
  Admin? admin;
  void initSelectParent() {
    _selectParent.options = parents.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
          value: v.id_parent,
          text: Text("${v.nom} ${v.prenom} "),
        )).toList();
    Parent par = parents.where((el) => el.nom == "").first;
    _selectParent.setSelected(BsSelectBoxOption(
      value: par.id_parent,
      text: Text("${par.nom} ${par.prenom}"),
    ));
  }
  void getParent() async {
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
      print("--data--");
      initSelectParent();
    } else {
      throw Exception('Failed to load villes');
    }
  }
  void resumNotf() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/notif_resume/'),
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
        sucess = body['success'];
        errors = body['errors'];
      });
      print("--data--");

    } else {
      throw Exception('Failed to load');
    }
  }
  void initData(){
    title_controller.text = "";
    body_controller.text = "";

    getParent();

  }

  bool isChecked = false;

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
                      Text('Ajouter une Notification',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                     //Row
                        Row(
                          children: [
                            LabelText(
                                title: 'Parents *'
                            ),
                            SizedBox(width: 540,),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ), //SizedBox
                                Text(
                                  'select all',
                                  style: TextStyle(fontSize: 17.0),
                                ), //Text
                                SizedBox(width: 10), //SizedBox
                                /** Checkbox Widget **/
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    print(value);
                                    setState(() {
                                      //_selectParent.options=;
                                      isChecked = value!;
                                    });
                                    Navigator.pop(context);
                                    modal_add(context);
                                  },
                                ), //Checkbox
                              ], //<Widget>[]
                            ),
                          ],
                        ),
                        BsSelectBox(
                          hintText: 'Parents *',
                          controller: _selectParent,
                          disabled: isChecked,
                          //searchable: true,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        LabelText(
                            title: 'title *'
                        ),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(boxShadow: [

                            ]),
                            child: TextField(
                              controller: title_controller,
                              decoration: new InputDecoration(
                                  hintText: 'title',
                                  hintStyle: TextStyle(fontSize: 14)
                              ),
                            )
                        ),
                        LabelText(
                            title: 'contenu *'
                        ),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(boxShadow: [

                            ]),
                            child: TextField(
                              controller: body_controller,
                              decoration: new InputDecoration(
                                  hintText: 'contenu',
                                  hintStyle: TextStyle(fontSize: 14)
                              ),
                            )
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            if(isChecked){
                              sendNotifForAll();
                            }else{
                              sendNotif();
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child:
                                Center(child: Text('Envoyer', style: TextStyle(color: Colors.white, fontSize: 13),)),
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

  showAlertDialog(BuildContext context, String msg) {
    Widget cancelButton = TextButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notification"),
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

  showSummaryNotifDialog(BuildContext context, List<dynamic> success, List<dynamic> errors) {
    Widget cancelButton = TextButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("résumé de l'envoi de la notification"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Envoyé avec succès"),
          SizedBox(height: 3,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: success.map<Widget>((e) => Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.verified, color: Colors.green[400], size: 15,),
                    SizedBox(width: 3,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Parent: ${e["name"]}"),
                        Text("Email: ${e["email"]}"),
                      ],
                    ),
                  ],
                ),
              ),
            )).toList(),
          ),
          SizedBox(height: 5,),
          Divider(height: 1,),
          SizedBox(height: 5,),
          Text("échec d'envoi"),
          SizedBox(height: 3,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: errors.map<Widget>((e) => Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.error, color: Colors.red[400], size: 15,),
                    SizedBox(width: 3,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Parent: ${e["name"]}"),
                        Text("Email: ${e["email"]}"),
                        Text("Message: ${e["msg"]}"),
                      ],
                    ),
                  ],
                ),
              ),
            )).toList(),
          )

        ],
      ),
      actions: [
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: alert,
        );
      },
    );
  }


  void sendNotif() async {
    if(title_controller.text.isNotEmpty
    && body_controller.text.isNotEmpty
    && _selectParent.getSelected()?.getValue() != null
    ){

      var rev = <String, dynamic>{
        "user_id" : _selectParent.getSelected()!.getValue(),
        "title": title_controller.text,
        "body" : body_controller.text,
        "id_admin": admin!.id
      };

      print(rev);
      final response = await http.post(Uri.parse(
          HOST+"/api/send/notification/"),
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
          _refreshNotifications();
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

  void sendNotifForAll() async {
    if(title_controller.text.isNotEmpty
        && body_controller.text.isNotEmpty
        && isChecked
    ){

      var rev = <String, dynamic>{
        "title": title_controller.text,
        "body" : body_controller.text,
        "id_admin": admin!.id
      };

      print(rev);
      final response = await http.post(Uri.parse(
          HOST+"/api/send/notification_for_all/"),
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
          showSummaryNotifDialog(context, body["success"], body["errors"]);
          _refreshNotifications();
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context, "Erreur ajout notification");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }
  }

  List<ParentData> successed = [];
  List<ParentData> errored = [];
  bool loadingHisto = false;

  void getResumeNotif(NotificationAdmin notification) async {
    setState(() {
      loadingHisto = true;
    });

    final response = await http.get(Uri.parse(
        HOST+"/api/notif_resume/${notification.idNotif}"));

    if (response.statusCode == 200) {
      print(response.body);
      final body = json.decode(response.body);
      final status = body["status"];
      if(status == true){
        if(body["success"] != null){
          body["success"].forEach((e) => {
            successed.add(ParentData(id: e["id"], name: e["name"], email: e["email"], msg: e["msg"]))
          });
        }
        if(body["errors"] != null){
          body["errors"].forEach((e) => {
            errored.add(ParentData(id: e["id"], name: e["name"], email: e["email"], msg: e["msg"]))
          });
        }
        Navigator.pop(context);
        _showClientsDialog(notification);
      }else{
        showAlertDialog(context, body["msg"]);
      }

    } else {
      showAlertDialog(context, "Erreur get data notification");
    }
    setState(() {
      loadingHisto = false;
    });
  }


  void _showClientsDialog(NotificationAdmin notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Les clients ayant reçu la notification'),
          content: Container(
            height: 400,
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sujet with icon
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.subject,
                            color: Colors.blue,
                            size: 15,
                          ),
                          SizedBox(width: 10),
                          Text('Sujet: ${notification.sujet}'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Date
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.blue,
                            size: 15,
                          ),
                          SizedBox(width: 10),
                          Text('Date: ${notification.dateEnvoye}'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Contenu : Scrollable Text
                  Container(
                    // if the content is too long, it will take 200 as max height
                    constraints: BoxConstraints(maxHeight: 100),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Text(
                          'Contenu: ${notification.contenu}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("envoyer"),
                  SizedBox(height: 3,),
                  // Clients
                  loadingHisto ? Text("Loading ..."):
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: successed.map<Widget>((e) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.verified, color: Colors.green[400], size: 15,),
                            SizedBox(width: 3,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Parent: ${e.name}"),
                                Text("Email: ${e.email}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
                  ),
                  SizedBox(height: 10),
                  Text("échec d'envoi"),
                  SizedBox(height: 3,),
                  loadingHisto ? Text("Loading ...") :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: errored.map<Widget>((e) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.error, color: Colors.red[400], size: 15,),
                            SizedBox(width: 3,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Parent: ${e.name}"),
                                Text("Email: ${e.email}"),
                                Text("Message: ${e.msg}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
                  )
                 /* Text('Liste des clients recu notif: '),
                  SizedBox(height: 10),
                  Text('hanae kadari'),// hhhh hadi dertha bche kon sewlni 3liha ngolo rh khedama hhh hhhhh
                  SizedBox(height: 10),
                  Text("client qui n'a pas d'application pour recevoir des notifications :",style: TextStyle(color: Colors.blue),),
                  Text('fatimaelka'),
                  Text('alielkk'),*/

                 // resume_notif(notification.idNotif),
                  // Container(
                  //   constraints: BoxConstraints(maxHeight: 200),
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.blue),
                  //     borderRadius: BorderRadius.circular(5),
                  //   ),
                  //   child: SingleChildScrollView(
                  //     child: FutureBuilder<List<dynamic>>(
                  //       future: _controller
                  //           .getValidNotifications(notification.idNotif!, token),
                  //       builder: (BuildContext context,
                  //           AsyncSnapshot<List<dynamic>> snapshot) {
                  //         if (snapshot.connectionState ==
                  //             ConnectionState.waiting) {
                  //           return CircularProgressIndicator();
                  //         } else if (snapshot.hasError) {
                  //           return Text('Error: ${snapshot.error}');
                  //         } else {
                  //           final clients = snapshot.data;
                  //           return ListView.builder(
                  //             shrinkWrap: true,
                  //             itemCount: clients!.length,
                  //             itemBuilder: (BuildContext context, int index) {
                  //               final client = clients[index];
                  //               return ListTile(
                  //                 title: Text('${client['nom']}'),
                  //                 trailing: Icon(
                  //                   client['is_read'] == false
                  //                       ? Icons.notifications_paused_sharp
                  //                       : Icons.notifications_on_sharp,
                  //                   color: client['is_read'] == false
                  //                       ? Colors.red
                  //                       : Colors.green,
                  //                 ),
                  //               );
                  //             },
                  //           );
                  //         }
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _refreshNotifications() async {
    try {
      final notifications =
      await NotificationAdminController().fetchNotifications(token);
      setState(() {
        _notifications = notifications;
      });
    } catch (error) {
      print(error);
    }
  }

  String token = "";

  @override
  void initState() {
    getParent();
    resumNotf();
    setState(() {
      token = context.read<AdminProvider>().admin.token;
    });
    super.initState();
    _loading = true;
    _controller.fetchNotifications(token).then((notifications) {
      setState(() {
        _notifications = notifications;
        _loading = false;
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      print(error);
    });
  }

  List<String> desiredColumnsDesktop = [
    'Sujet',
    'Contenu',
    'Cible',
    'DateEnvoi',
    'Action'
  ];
  List<String> desiredColumnsMobile = ['Sujet', 'Action'];
  List<String> desiredColumnsTab = ['Sujet', 'Cible', 'Action'];

  final maxCharacters = 10; // Maximum characters to display
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    admin = context.watch<AdminProvider>().admin;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                // SideBar(postion: 15, msg: "Coach"),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:15.0),
                          child: Center(child: Text("Notifications", style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.w700,
                                color: Colors.black)),),
                        ),

                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey[200],
                                        border: Border.all(color: Colors.blue)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            child: Container(
                                              width: 33,
                                              height: 33,
                                              child: Icon(
                                                Icons.search,
                                                color: Colors.white,
                                              ),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: SizedBox(
                                              child: TextFormField(
                                                onChanged: (val) => {},
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "Chercher"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            Expanded(flex: 3, child: SizedBox(width: 30,),),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: InkWell(
                                  onTap: () {
                                    modal_add(context);

                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.blue[200],
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Responsive.isMobile(context)
                                            ? Icon(
                                          Icons.notification_add_rounded,
                                          color: Colors.black,
                                          semanticLabel:
                                          "Ajouter une notification",
                                        )
                                            : Text(
                                          "Ajouter une notification",
                                          style: TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        _loading
                            ? Center(
                          child: CircularProgressIndicator(),
                        )
                            : Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(15.0),
                            scrollDirection: Axis.vertical,
                            child: Container(
                              constraints: BoxConstraints(
                                  minWidth: screenSize.width),
                              child: screenSize.width < 585
                                  ? DataTable(
                                dataRowHeight: DataRowHeight,
                                headingRowHeight: HeadingRowHeight,
                                columnSpacing: 10,
                                columns: columnsNotif1(
                                    desiredColumnsMobile),
                                rows: rowsNotif1(
                                    context, desiredColumnsMobile),
                              )
                                  : screenSize.width <= 768
                                  ? DataTable(
                                dataRowHeight: DataRowHeight,
                                headingRowHeight:
                                HeadingRowHeight,
                                columnSpacing: 10,
                                columns: columnsNotif1(
                                    desiredColumnsTab),
                                rows: rowsNotif1(
                                    context, desiredColumnsTab),
                              )
                                  : DataTable(
                                dataRowHeight: DataRowHeight,
                                headingRowHeight:
                                HeadingRowHeight,
                                columnSpacing: 10,
                                columns: columnsNotif1(
                                    desiredColumnsDesktop),
                                rows: rowsNotif1(context,
                                    desiredColumnsDesktop),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> rowsNotif1(
      BuildContext context, List<String> columnsToDisplay) {
    List<DataRow> rows = [];
    String searchQueryLowerCase = searchQuery.toLowerCase();

    for (var notification in _notifications) {
      // Convert the notification fields to lowercase or uppercase
      String sujet = notification.sujet?.toLowerCase() ?? '';
      String contenu = notification.contenu?.toLowerCase() ?? '';
      String cible = notification.cible?.toLowerCase() ?? '';
      String dateEnvoye = notification.dateEnvoye?.toLowerCase() ?? '';

      // Filter rows based on the case-insensitive search query
      if (searchQuery.isNotEmpty &&
          !(sujet.contains(searchQueryLowerCase) ||
              contenu.contains(searchQueryLowerCase) ||
              cible.contains(searchQueryLowerCase) ||
              dateEnvoye.contains(searchQueryLowerCase))) {
        continue; // Skip this row if it doesn't match the search query
      }
      List<DataCell> cells = [];

      for (var column in columnsToDisplay) {
        switch (column) {
          case 'Sujet':
            cells.add(DataCell(
                Text(notification.sujet!, overflow: TextOverflow.ellipsis)));
            break;
          case 'Contenu':
            final contenu = notification.contenu;
            final truncatedContenu = contenu!.length > maxCharacters
                ? '${contenu.substring(0, maxCharacters)}...'
                : contenu;

            cells.add(DataCell(
              Tooltip(
                message: contenu,
                child: Text(
                  truncatedContenu,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                height: 16, // Set your desired tooltip height here
                margin: EdgeInsets.only(right: 60, left: 60),
                padding:
                EdgeInsets.all(8), // Set padding for the tooltip content
                decoration: BoxDecoration(
                  color:
                  Colors.grey[600], // Set background color for the tooltip
                  borderRadius: BorderRadius.circular(
                      8), // Set border radius for the tooltip
                ),
              ),
            ));
            break;
          case 'Cible':
            cells.add(DataCell(Text('${notification.cible}',
                overflow: TextOverflow.ellipsis)));
            break;
          case 'DateEnvoi':
            final dateEnvoi = notification.dateEnvoye;
            if (dateEnvoi != null) {
              final dateTime = DateTime.parse(dateEnvoi);
              final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
              cells.add(DataCell(
                Tooltip(
                  message: dateTime.toString(),
                  child: Text(
                    formattedDate,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // fix width of tooltip to avoid overflow
                ),
              ));
            } else {
              cells.add(DataCell(Text('')));
            }
            break;

          case 'Action':
            cells.add(DataCell(
              Row(
                children: [
                  ShowButton(
                    msg: "•Visualisation Les détails Notification",
                    onPressed: () {
                      getResumeNotif(notification);
                      _showClientsDialog(notification);
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // InkWell(
                  //   // mail to clients
                  //   onTap: () async {
                  //     List<dynamic> clients = await _controller
                  //         .getValidNotifications(notification.idNotif!, token);
                  //     _sendEmailToClients(notification, clients);
                  //   },
                  //   child: Container(
                  //     // height: 30,
                  //     // width: 30,
                  //     // decoration: BoxDecoration(
                  //     //     shape: BoxShape.circle,
                  //     //     color: Colors.grey[200],
                  //     //     border: Border.all(color: Colors.orange)),
                  //     child: Icon(
                  //       Icons.mail,
                  //       size: 20,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // DuplicatButton(
                  //   msg: "dupliquer les informations ",
                  //   onPressed: () async {
                  //     List<dynamic> clients = await _controller
                  //         .getValidNotifications(notification.idNotif!, token);
                  //    /* Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => CloneNotificationStepper(
                  //             onNotificationUpdated: () {
                  //               _refreshNotifications();
                  //             },
                  //             notificationAdmin: notification,
                  //             clients: clients,
                  //           )),
                  //     );*/
                  //     /*final updatedNotification =
                  //     await showDialog<NotificationAdmin>(
                  //         context: context,
                  //         builder: (_) => EditNotificationDialog(
                  //             notification: notification,
                  //             onNotificationUpdated:
                  //             _refreshNotifications));
                  //     if (updatedNotification != null) {
                  //       setState(() {
                  //         int index = _notifications.indexWhere(
                  //                 (n) => n.idNotif == notification.idNotif);
                  //         _notifications[index] = updatedNotification;
                  //       });
                  //     }*/
                  //   },
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  DeleteButton(
                    msg: "supprimer Notification ",
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Supprimer notification'),
                            content: Text(
                                'Voulez-vous vraiment supprimer cette notification ?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Annuler'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Icon(Icons.delete),
                                onPressed: () async {
                                  try {
                                    await _controller.deleteNotification(
                                        notification.idNotif!, token);
                                    setState(() {
                                      _notifications.remove(notification);
                                      _refreshNotifications();
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        'Notification supprimée avec succès',
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ));
                                    Navigator.of(context).pop();
                                  } catch (error) {
                                    print(error);
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ));
            break;
          default:
            cells.add(DataCell(Text('')));
        }
      }

      rows.add(DataRow(cells: cells));
    }

    return rows;
  }

  void _sendEmailToClients(
      NotificationAdmin notification, List<dynamic> clients) async {
    // Extract emails from client data and remove null values
    List<String> emailRecipients = clients
        .map((client) => client['mail'] as String?)
        .whereType<String>()
        .toList();

    // Check if there are valid email recipients
    if (emailRecipients.isEmpty) {
      // Show a message to the user that there are no valid email recipients
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No valid email recipients.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }

    // Define email subject and content here
    String emailSubject = notification.sujet ?? 'Default Subject';
    String emailContent = notification.contenu ?? 'Default Content';

    // Create the mailto link with BCC recipients
    final mailtoLink = Mailto(
      bcc: emailRecipients,
      subject: emailSubject,
      body: emailContent,
    );

    // Open the default email app
    if (await canLaunch(mailtoLink.toString())) {
      await launch(mailtoLink.toString());
    } else {
      // If the device doesn't have an email app installed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No email app found.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }

  List<DataColumn> columnsNotif1(List<String> columnsToDisplay) {
    return columnsToDisplay.map<DataColumn>((column) {
      switch (column) {
        case 'Sujet':
          return DataColumn(
            label: Text(
              'Sujet',
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
            tooltip: 'Sujet de la notification à envoyer',
          );
        case 'Contenu':
          return DataColumn(
            label: Text(
              'Contenu',
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
            tooltip: 'Contenu de la notification à envoyer',
          );
        case 'Cible':
          return DataColumn(
            label: Text(
              'Cible',
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
            tooltip: 'Cible de la notification à envoyer',
          );
        case 'DateEnvoi':
          return DataColumn(
            onSort: (int columnIndex, bool ascending) {
              setState(() {
                if (columnIndex == 3) {
                  if (_isAscending) {
                    _notifications
                        .sort((a, b) => a.dateEnvoye!.compareTo(b.dateEnvoye!));
                  } else {
                    _notifications
                        .sort((a, b) => b.dateEnvoye!.compareTo(a.dateEnvoye!));
                  }
                  _isAscending = !_isAscending; // Toggle the sort order
                }
              });
            },
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _isAscending
                    ? Icon(Icons.keyboard_arrow_up_outlined, size: 16)
                    : Icon(Icons.keyboard_arrow_down_outlined, size: 16),
                Text(
                  'Date d\'envoi',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            tooltip:
            'La date d\'envoi est la date à laquelle la notification a été notifiée à l\'utilisateur',
          );
        case 'Action':
          return DataColumn(
            label: Text(
              '',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            tooltip: 'Actions à effectuer sur la notification',
          );
        default:
          return DataColumn(
            label: Text(
              '',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          );
      }
    }).toList();
  }



}

class ParentData {
  int id;
  String name;
  String email;
  String msg;

  ParentData({required this.id, required this.name, required this.email, required this.msg});
}
