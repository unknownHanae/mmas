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
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../widgets/navigation_bar.dart';
import 'dart:html' as html;
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:adminmmas/models/ClientModels.dart';

import 'AddEtablissements.dart';
import 'UpdateEtablissement.dart';

class AproposScreen extends StatefulWidget {
  const AproposScreen({Key? key}) : super(key: key);

  @override
  State<AproposScreen> createState() => _AproposScreenState();
}

class _AproposScreenState extends State<AproposScreen> {

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
              SideBar(postion: 17,msg: "A propos",),
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
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text("À propos de FIT-HOUSE",style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
                                SizedBox(height: 12,),
                                Row(
                                  children: [
                                    Text("FIT-HOUSE",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    SizedBox(width:1,),
                                    Text("est une application Web développée par"),
                                    SizedBox(width:1,),
                                    Text("JYSSR-Connect.",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    SizedBox(width:1,),
                                    Text("Notre application vise à faciliter votre expérience dans notre salle de "),
                                  ],
                                ),
                                Text("sport en vous offrant des fonctionnalités pratiques et intuitives pour gérer votre emploi du temps et vos réservations de cours."),
                                SizedBox(height: 9,),
                                Text("Caractéristiques principales :",style: TextStyle(decoration: TextDecoration.underline,
                                    fontSize: 16,color: Colors.grey,fontWeight: FontWeight.w700),),
                                SizedBox(height: 9,),
                                Row(
                                  children: [
                                    Text("1-",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    SizedBox(width:1,),
                                    Text("Consultation du planning :Vous pouvez facilement consulter le planning des cours disponibles, avec les horaires, les types  "),
                                  ],
                                ),
                                Text("de cours et les instructeurs associés. Vous serez toujours informé des dernières mises à jour du planning pour planifier vos entraînements en conséquence."),
                                SizedBox(height: 9,),
                                Row(
                                  children: [
                                    Text("2-",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    SizedBox(width:2,),
                                    Text("Réservation des cours: Grâce à notre fonctionnalité de réservation, vous pouvez réserver vos places pour les cours qui vous intéressent."),
                                  ],
                                ),
                                Text(" Cela vous permet de garantir votre participation et de vous assurer une place dans les cours les plus populaires. Vous pouvez également annuler vos réservations si nécessaire."),
                                SizedBox(height: 9,),
                                Row(
                                  children: [
                                    Text("3-",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    SizedBox(width:2,),
                                    Text("Contacter l'administration: Si vous avez des questions, des préoccupations ou des demandes spécifiques, notre fonction de contact "),
                                  ],
                                ),
                                Text("avec l'administration vous permet d'entrer en communication directe avec notre équipe. Vous pouvez nous faire part de vos commentaires, suggestions ou demandes d'assistance, et nous serons ravis de vous aider."),
                                SizedBox(height: 9,),
                                Row(
                                  children: [
                                    Text("L'application"),
                                    SizedBox(width:1,),
                                    Text("FIT-HOUSE-",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    SizedBox(width:1,),
                                    Text("est disponible sur les plateformes iOS et Android, offrant une compatibilité maximale avec les appareils "),
                                  ],
                                ),
                                Text("mobiles populaires. Nous travaillons constamment à l'amélioration de l'application et nous prévoyons de lancer de nouvelles fonctionnalités passionnantes dans les futures mises à jour."),
                                SizedBox(height: 9,),
                                Row(
                                  children: [
                                    Text("Notre équipe chez "),
                                    SizedBox(width:1,),
                                    Text("JYSSR-Connect ",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    SizedBox(width:1,),
                                    Text("est dévouée à créer une expérience utilisateur exceptionnelle pour nos utilisateurs de FIT-HOUSE. "),
                                  ],
                                ),
                                Text("Nous attachons une grande importance à la sécurité de vos données personnelles et utilisons des mesures de sécurité avancées pour protéger vos informations."),
                                SizedBox(height: 9,),
                                Text("Nous apprécions énormément vos commentaires, suggestions et questions. Si vous avez des idées pour améliorer l'application ou si vous rencontrez des problèmes techniques, n'hésitez pas à nous contacter à l'adresse support@fit-house.com"),
                                SizedBox(height: 9,),
                                Text("Merci d'utiliser FIT-HOUSE ! Nous espérons que notre application vous aidera à atteindre vos objectifs de remise en forme et à profiter pleinement de votre expérience à la salle de sport."),
                                SizedBox(height: 9,),
                                Text("En cas de problème ou d’anomalie, les informations ci-dessous seront à communiquer aux équipes FIT-HOUSE"),
                                SizedBox(height: 12,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Version de l'application :",style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold),),
                                    SizedBox(width: 5,),
                                    Text(version_Web),
                                  ],
                                ),

                              ],
                            ),
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

