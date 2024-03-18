import 'package:adminmmas/constants.dart';
import 'package:adminmmas/env.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

import '../componnents/label.dart';
import '../models/NotificationModel.dart';
import '../providers/NoticationContr.dart';
import '../providers/admin_provider.dart';
import '../widgets/clientStatu.dart';

import 'package:intl/intl.dart';

class ClientBirthdayView extends StatefulWidget {
  @override
  _ClientBirthdayViewState createState() => _ClientBirthdayViewState();
}

class _ClientBirthdayViewState extends State<ClientBirthdayView> {
  // birthdays clients
  List<dynamic> _clients = [];
  bool _isLoading = true;

  final NotificationAdminController _controller = NotificationAdminController();
  NotificationAdmin _notification = NotificationAdmin();

  TextEditingController subject_controller = TextEditingController();
  TextEditingController message_controller = TextEditingController();


  void sendNotif (int id_client) async {
    if(subject_controller.text.isNotEmpty &&
    message_controller.text.isNotEmpty
    ){
      _notification.cible = "Anvr";
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

  void addNotif(context, clt){

    subject_controller.text = "anniv ${clt['nom_client']} ${clt['prenom_client']}";
    message_controller.text = "test msg";

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
                            sendNotif(clt["id_client"]);
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

  Future<void> _fetchDataBirthdaysClients() async {
    setState(() {
      _isLoading = true;
    });

    var token = context.read<AdminProvider>().admin.token;
    final response = await http.get(Uri.parse(API.CLIENT_UPCOMING_BIRTHDAYS),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _clients = data['soon_birthday_clients'];
      });
    } else {
      print('Failed to fetch data');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _fetchDataBirthdaysClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.all(Radius.circular(10)),
        color: whiteColor,
      ),
      child: Column(
        children: [
          // title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Clients à fêter',
                style: TextStyle(
                  fontSize: titreSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // go to
                },
                child: Text('Voir tout'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: defaultPadding),
          Container(
            // padding: EdgeInsets.all(defaultPadding / 2),
            // make container height dynamic
            width: 328,
            height: 400,
            //width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.transparent),
            ),
            child:
            // if loading show progress indicator, if else data is empty show text, else show listview
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _clients.isEmpty
                ? Center(
              child: Text(
                'Aucun client à fêter pour ce 10 jours',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                : ListView.builder(
              itemCount: _clients.length,
              itemBuilder: (context, index) {
                final client = _clients[index];
                return Container(
                  // margin: EdgeInsets.only(bottom: 4),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(10),
                  //   border:
                  //       Border.all(color: Colors.green.withOpacity(0.4)),
                  // ),
                  child: ListTile(
                    // remove the default padding
                    contentPadding: EdgeInsets.all(0),
                    // remove the default margin

                    title: Text(
                      '${client['nom_client']} ${client['prenom_client']}',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: sousTitreSize),
                    ),
                    subtitle:
                    // icon date and text date
                    Row(
                      children: [
                        Icon(
                          Icons.cake,
                          size: 15,
                          color: Colors.green,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${client['date_naissance']}',
                          style: TextStyle(
                            fontSize: sousTitreSize2,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    leading:
                    // if image not loaded show icon
                    client['image'] == null ||
                        client['image'] == ''
                        ? Icon(Icons.person)
                        : Container(
                      width: 40,
                      height: 40,
                      child: ClipOval(
                        child: Image.network(
                          '${API.MEDIA_ENDPOINT}${client['image']}',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    trailing: Container(
                      height: 30,
                      width: 65,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){
                                 addNotif(context, client);
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(Icons.card_giftcard, color: Colors.orange, size: 15,),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '${client['days_left']}',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: sousTitreSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}