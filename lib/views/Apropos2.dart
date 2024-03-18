
import 'package:adminmmas/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/navigation_bar.dart';

import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:client_information/client_information.dart';
import 'dart:html' as html;
import 'package:flutter/gestures.dart';

import '../widgets/navigation_bar_Coach.dart';

class AproposScreen2 extends StatefulWidget {
  const AproposScreen2({Key? key}) : super(key: key);

  @override
  State<AproposScreen2> createState() => _AproposScreen2State();
}

class _AproposScreen2State extends State<AproposScreen2> {

  ClientInformation? _clientInfo;

  @override
  void initState() {
    super.initState();
    _getClientInformation();
  }

  Future<void> _getClientInformation() async {
    ClientInformation? info;
    try {
      info = await ClientInformation.fetch();
    } on PlatformException {
      print('Failed to get client information');
    }
    if (!mounted) return;

    setState(() {
      _clientInfo = info;
    });
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
         //    SideBar(postion: 17,msg: "A propos",),
              SizedBox(width: 10,),
              Expanded(
                flex: 3,
                child:
                ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child:
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            SizedBox(height: 25,),
                            Text("À propos de MMAS 'Meet me after school'",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                            SizedBox(height: 25,),

                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Bienvenue sur'),
                                  TextSpan(text: " MMAS ", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  TextSpan(text: " l'application développée par "),
                                  TextSpan(text: ' JYSSR-Connect.',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'pour simplifier votre expérience scolaire en dehors des heures de cours.'),
                                ],
                              ),
                            ),
                            SizedBox(height: 9,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Plate-forme:",style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text("Disponible sur iOS et Android ")
                                //Text(version_Web),
                              ],
                            ),
                            SizedBox(height: 3,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mise en production le :",style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text("05/03/2023"),
                                //Expanded(child: Text(_clientInfo?.deviceName ?? '-')),
                              ],
                            ),
                            SizedBox(height: 3,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Version : ",style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(version_Web),
                                // Expanded(child: Text("${_clientInfo?.osName ?? '-'} ${_clientInfo?.osVersion ?? '-'}")),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Text("Notre Mission:",style: TextStyle(decoration: TextDecoration.underline,
                                fontSize: 20,color: Colors.grey,fontWeight: FontWeight.w700),),
                            SizedBox(height: 15,),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Meet me After School est un organisme de soutien scolaire qui s’adresse à tous les élèves… Ceux qui butent dans'),
                                  // TextSpan(text: "MMAS ", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  TextSpan(text: " l’apprentissage d’une matière et ceux qui se heurtent au système scolaire ou aux méthodes de travail proposées. "),
                                  // TextSpan(text: 'JYSSR-Connect.',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'Ou encore ceux qui veulent améliorer leur dossier scolaire pour pouvoir intégrer la filière de leur choix.'),
                                ],
                              ),
                            ),
                            SizedBox(height: 9,),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Et même ceux qui visent l’excellence : grandes écoles ou universités réputées en France ou à l’étranger. À chacun'),
                                  // TextSpan(text: "MMAS ", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  TextSpan(text: "d’eux, nous proposons des solutions pédagogiques personnalisées pour les aider à développer leur potentiel."),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text("Fonctionnalités Principales ",style: TextStyle(decoration: TextDecoration.underline,
                                fontSize: 20,color: Colors.grey,fontWeight: FontWeight.w700),),
                            SizedBox(height: 9,),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: "1- Consultation du planning :",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                                  TextSpan(text: ' Accédez facilement à votre emploi du temps pour rester organisé(e) et ne manquez jamais une séance.'),

                                ],
                              ),
                            ),
                            SizedBox(height: 9,),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: "2- Réservation des cours :",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                                  TextSpan(text: "Planifiez vos sessions d'étude en réservant des créneaux horaires, garantissant ainsi une utilisation efficace de votre temps après l'école."),

                                ],
                              ),
                            ),
                            SizedBox(height: 9,),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: "3- Contacter l'administration : ",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold ,fontSize: 18),),
                                  TextSpan(text: "Besoin d'aide ou de clarifications ? Utilisez notre fonction de messagerie intégrée pour contacter rapidement l'administration. "),
                                ],
                              ),
                            ),

                            SizedBox(height: 20,),
                            Text("L'Équipe JYSSR-Connect ",style: TextStyle(decoration: TextDecoration.underline,
                                fontSize: 20,color: Colors.grey,fontWeight: FontWeight.w700),),
                            SizedBox(height: 15,),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Notre équipe dévouée de développeurs travaille sans relâche pour améliorer constamment MMAS. '),
                                  // TextSpan(text: "MMAS ", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  TextSpan(text: "Nous nous efforçons de créer une application intuitive, sûre et efficace pour répondre à vos besoins. "),

                                ],
                              ),
                            ),
                            SizedBox(height: 9,),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'La sécurité de vos données est notre priorité. MMAS utilise des protocoles de sécurité avancés pour protéger vos'),
                                  // TextSpan(text: "MMAS ", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  TextSpan(text: "informations personnelles et garantir une expérience utilisateur en toute confiance."),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text("Contact ",style: TextStyle(decoration: TextDecoration.underline,
                                fontSize: 20,color: Colors.grey,fontWeight: FontWeight.w700),),
                            SizedBox(height: 15,),

                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: "Nous sommes ouverts à vos commentaires et suggestions ! Si vous avez des idées pour améliorer MMAS ou rencontrez des problèmes techniques, n'hésitez pas à nous contacter à"),
                                  TextSpan(
                                    text: " support@jyssr-connect.com",
                                    style: TextStyle(color: Colors.blueAccent),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        html.window.open(
                                            "mailto:support@jyssr-connect.com",
                                            "Mail To :support@jyssr-connect.com"
                                        );
                                      },

                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Text("Merci de faire partie de la communauté MMAS !."),


                          ],
                        ),
                        ),
                      ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

}

