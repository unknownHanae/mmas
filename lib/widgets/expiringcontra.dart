import 'package:adminmmas/env.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../componnents/label.dart';
import '../constants.dart';
import '../models/NotificationModel.dart';
import '../providers/NoticationContr.dart';
import '../providers/admin_provider.dart';

import 'package:intl/intl.dart';

class ContractsScreen extends StatefulWidget {
  @override
  _ContractsScreenState createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  Map<String, List<dynamic>> _expiringContracts = {};
  Map<String, List<dynamic>> _soonExpiringContracts = {};
  bool _showExpiredContracts = true;

  final NotificationAdminController _controller = NotificationAdminController();
  NotificationAdmin _notification = NotificationAdmin();

  TextEditingController subject_controller = TextEditingController();
  TextEditingController message_controller = TextEditingController();


  void sendNotif (int id_client) async {
    if(subject_controller.text.isNotEmpty &&
        message_controller.text.isNotEmpty
    ){
      _notification.cible = _showExpiredContracts ?
      "Contrat experé":
      "Contrat bientôt expiré";
      _notification.sujet = subject_controller.text;
      _notification.contenu = message_controller.text;
      _notification.dateEnvoye = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
      _notification.idAdmin = context.read<AdminProvider>().admin.id;

      var token = context.read<AdminProvider>().admin.token;

      await _controller.createNotification(
          _notification, token);
      await _controller.addClients([id_client], token);

      initData();
    }

  }

  void addNotif(context, clt, name_ctl){

    subject_controller.text =
    _showExpiredContracts ?
    "Contrat experé":
    "Contrat bientôt expiré";
    message_controller.text =
    _showExpiredContracts ?
    "cher client ${name_ctl}, votre contrat est expiré" :
    "cher client ${name_ctl}, votre contrat est bientôt expiré ";

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
                      Text('Notification contrat',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Annuler'),
                        // prefixIcon: Icons.close,
                        onPressed: () {

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
                            title: 'Sujet'
                        ),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(boxShadow: [

                            ]),
                            child: TextField(
                              controller: subject_controller,
                              decoration: new InputDecoration(
                                  hintText: 'Sujet',
                                  hintStyle: TextStyle(fontSize: 14)
                              ),
                            )
                        ),
                        SizedBox(height: 15,),
                        LabelText(
                            title: 'Message'
                        ),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(boxShadow: [

                            ]),
                            child: TextField(
                              controller: message_controller,
                              //minLines: 5,
                              decoration: new InputDecoration(
                                  hintText: 'Message',
                                  hintStyle: TextStyle(fontSize: 14)
                              ),
                            )
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            print(clt);
                            print(clt[0]["id_client"]);
                            sendNotif(clt[0]["id_client"]);
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

  void initData () {
    subject_controller.text = "";
    message_controller.text = "";
    Navigator.pop(context);
  }

  Future<void> _fetchContracts() async {
    var token = context.read<AdminProvider>().admin.token;
    final response = await http.get(Uri.parse(API.CLIENT_CONTRACT_EXPIRING),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    final data = json.decode(response.body);
    setState(() {
      _expiringContracts =
      Map<String, List<dynamic>>.from(data['expiring_contracts']);
      _soonExpiringContracts =
      Map<String, List<dynamic>>.from(data['soon_expiring_contracts']);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchContracts();
  }

  void _toggleContractsDisplay() {
    setState(() {
      _showExpiredContracts = !_showExpiredContracts;
    });
  }

  Future<void> _showDialog(List<dynamic> contracts) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Detaillé de contrats"),
          content: Container(
            width: 320,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: contracts.length,
              itemBuilder: (BuildContext context, int index) {
                final contract = contracts[index];
                return ListTile(
                  title: Text("Numéro de contrat: ${contract['numcontrat']}",
                      style: TextStyle(color: Colors.blue)),
                  subtitle: Text("Date Fin: ${contract['date_fin']}",
                      style: TextStyle(color: Colors.red)),
                  // icon
                  leading: Icon(Icons.account_balance_wallet),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final contracts =
    _showExpiredContracts ? _expiringContracts : _soonExpiringContracts;

    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: Container(
        width: 335,
        height: 472,
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Contrats à échéance",
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 0,
                  child: ToggleButtons(
                    isSelected: [_showExpiredContracts, !_showExpiredContracts],
                    onPressed: (int index) {
                      setState(() {
                        _showExpiredContracts = index == 0;
                      });
                    },
                    // space between buttons

                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Expirés'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text('expire Bientôt'),
                      ),
                    ],
                    color: Colors.black,
                    selectedColor: Colors.white,
                    fillColor: _showExpiredContracts ? Colors.red : primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                    selectedBorderColor:
                    _showExpiredContracts ? Colors.red : primaryColor,
                  ),
                ),
              ],
            ),
            Expanded(
              child:
              // if soon expiring contracts are shown, show a border color yellow, else show a border color red
              _showExpiredContracts
                  ? Container(
                child: _expiringContracts.isEmpty
                    ? Center(child: Text('Aucun contrat expiré'))
                    : ListView.builder(
                  // no padding
                  padding: EdgeInsets.all(0),
                  itemCount: contracts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final client =
                    contracts.keys.elementAt(index);
                    final clientContracts = contracts[client];
                    return ListTile(
                      // no padding
                      contentPadding: EdgeInsets.all(5),
                      leading: Icon(Icons.account_balance_wallet,
                          color: Colors.red.withOpacity(0.6)),
                      title: Text(client,
                          style: TextStyle(
                            fontSize: sousTitreSize,
                          )),
                      subtitle: Text(
                          "Contracts: ${clientContracts!.length}",
                          style: TextStyle(
                            fontSize: sousTitreSize2,
                          )),
                      onTap: () => _showDialog(clientContracts),
                      // if expired contracts are shown, show a border color red, else show a border color yellow
                      tileColor: _showExpiredContracts
                          ? Colors.red.withOpacity(0.4)
                          : primaryColor.withOpacity(0.4),
                      // add icon for expired contracts and another icon for soon expiring contracts
                      trailing: _showExpiredContracts
                          ?  Container(
                        height: 30,
                        width: 65,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                addNotif(context, clientContracts, client);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Icon(Icons.notification_important, color: Colors.orange, size: 15,),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.error,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ) :
                      Container(
                        height: 30,
                        width: 65,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                addNotif(context, clientContracts, client);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Icon(Icons.notification_important, color: Colors.orange, size: 15,),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.warning,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      )
                    );
                  },
                ),
              )
                  : Container(
                child: _soonExpiringContracts.isEmpty
                    ? Center(
                    child: Text('Aucun contrat bientôt expiré'))
                    : ListView.builder(
                  itemCount: contracts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final client =
                    contracts.keys.elementAt(index);
                    final clientContracts = contracts[client];
                    return ListTile(
                      contentPadding: EdgeInsets.all(5),
                      leading: Icon(Icons.account_balance_wallet,
                          color: primaryColor),
                      title: Text(client,
                          style:
                          TextStyle(fontSize: sousTitreSize)),
                      subtitle: Text(
                          "Contracts: ${clientContracts!.length}",
                          style: TextStyle(
                              fontSize: sousTitreSize2)),
                      onTap: () => _showDialog(clientContracts),
                      tileColor: _showExpiredContracts
                          ? Colors.red.withOpacity(0.4)
                          : primaryColor.withOpacity(0.4),
                      trailing: _showExpiredContracts
                          ? Container(
                        height: 30,
                        width: 65,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                addNotif(context, clientContracts, client);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Icon(Icons.notification_important, color: Colors.orange, size: 15,),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.error,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ) :
                      Container(
                        height: 30,
                        width: 65,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                addNotif(context, clientContracts, client);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Icon(Icons.notification_important, color: Colors.orange, size: 15,),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.warning,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}