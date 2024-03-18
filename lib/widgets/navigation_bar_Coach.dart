import 'package:adminmmas/models/Admin.dart';
import 'package:adminmmas/providers/admin_provider.dart';
import 'package:adminmmas/views/ReservationScreen.dart';
import 'package:adminmmas/views/cours.dart';
import 'package:adminmmas/views/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../views/Abonnement.dart';
import '../views/Apropos.dart';
import '../views/Apropos2.dart';
import '../views/Cat_contrat.dart';
import '../views/CategorieSalle.dart';
import '../views/ClientScreen.dart';
import '../views/CoachScreen.dart';
import '../views/ContratScreen.dart';
import '../views/CoursCoachs.dart';
import '../views/NotificationScreen.dart';
import '../views/ReservationPlanningScreen.dart';
import '../views/ReservationScreen2.dart';
import '../views/ResrvationCoach.dart';
import '../views/SalleCoach.dart';
import '../views/SalleScreen.dart';
import '../views/SeanceScreen.dart';
import '../views/TransationScreen.dart';
import '../views/etablissements.dart';
import '../views/seanceCoach.dart';
import '../views/splscreeen.dart';
import '../views/v_client.dart';
import '../views/v_coach.dart';

import 'package:provider/provider.dart';

import '../views/DashboardScreen.dart';

class SideBarCoachs extends StatefulWidget {
  int? postion;
  String msg;
  SideBarCoachs({Key? key, required this.postion,required this.msg}) : super(key: key);

  @override
  State<SideBarCoachs> createState() => _SideBarState();
}

class _SideBarState extends State<SideBarCoachs> {
  bool toggleMenu = false;


  @override
  Widget build(BuildContext context) {
    int index = widget.postion!;

    var screenSize = MediaQuery.of(context).size;

    return screenSize.width <= 920
        ? Expanded(
      flex: toggleMenu ? 1 : 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
            message: "menu",
            child: Container(
              width: 35,
              height: 35,
              child: InkWell(
                onTap: () {
                  setState(() {
                    toggleMenu = !toggleMenu;
                  });
                },
                child: Icon(Icons.menu, size: 30, color: Colors.orangeAccent),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          toggleMenu
              ? Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[

                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Tooltip(
                                  message: "${context.read<AdminProvider>().admin.name}",
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        // image: DecorationImage(
                                        //   fit: BoxFit.cover,
                                        //   image: NetworkImage(
                                        //       "${context.read<AdminProvider>().admin.image}"),
                                        // ),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        color: Colors.grey[200]),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                screenSize.width > 750
                                    ? Expanded(
                                  child: Tooltip(
                                    message: "${context.read<AdminProvider>().admin.name}",
                                    child: Text(
                                      "${context.read<AdminProvider>().admin.name}",
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                  ),
                                )
                                    : SizedBox(
                                  width: 0,
                                  height: 0,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200]),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListView(
                              children: [

                                Tooltip(
                                  message: "Réservations",
                                  child: getItem("Réservations",
                                      Icons.edit_calendar_outlined,
                                          () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           ReservationPlanningScreenCoach(),
                                        //     ));
                                        setState(() {
                                          index = 8;
                                        });
                                      }, index == 8 ? true : false),
                                ),
                                SizedBox(
                                  height: 0,
                                ),

                                Tooltip(
                                  message: "Salles",
                                  child: getItem("Salles",
                                      Icons.add_business_outlined,
                                          () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SalleScreenCoach(),
                                            ));
                                        setState(() {
                                          index = 5;
                                        });
                                      }, index == 5 ? true : false),
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                                // getItem("Categorie salle", Icons.list,(){
                                //    Navigator.push(
                                //        context,
                                //        MaterialPageRoute(
                                //          builder: (context) => CatSalleScreen(),
                                //     ));
                                //   setState(() {
                                //     index =  9;
                                //   });
                                // },index == 9?true:false),
                                SizedBox(
                                  height: 0,
                                ),
                                Tooltip(
                                  message: "cours",
                                  child: getItem(
                                      "Cours",
                                      Icons
                                          .my_library_books_outlined,
                                          () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           CoursScreenCoach(),
                                        //     ));
                                        setState(() {
                                          index = 6;
                                        });
                                      }, index == 6 ? true : false),
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                                // Tooltip(
                                //   message: "Seances",
                                //   child: getItem("Seances", Icons.access_time_rounded,
                                //           () {
                                //         Navigator.push(
                                //             context,
                                //             MaterialPageRoute(
                                //               builder: (context) =>
                                //                   SeanceScreenCoach(),
                                //             ));
                                //         setState(() {
                                //           index = 10;
                                //         });
                                //       }, index == 10 ? true : false),
                                // ),


                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200]),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        try {
                                          final prefs =
                                          await SharedPreferences
                                              .getInstance();
                                          final success1 =
                                          await prefs.remove('id');
                                          final success2 =
                                          await prefs.remove('email');
                                          final success3 =
                                          await prefs.remove('name');

                                          print(
                                              "Success: $success1 $success2 $success3");
                                          if (success1 && success2) {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()),
                                                    (Route<dynamic>
                                                route) =>
                                                false);
                                            context
                                                .read<AdminProvider>()
                                                .clearUser();
                                          }
                                        } catch (e) {
                                          print("Error ${e}");
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.logout_outlined,
                                              size: 18,
                                              color: Colors.black),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          screenSize.width > 750
                                              ? Tooltip(
                                            message: "Se Déconnecter",
                                            child: Text(" Se Déconnecter",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          )
                                              : SizedBox(
                                            width: 0,
                                            height: 0,
                                          ),

                                        ],

                                      ),
                                    ),

                                  ),

                                ],
                              ),
                              SizedBox(height: 5,),
                              Tooltip(
                                message: "A propos",
                                child: getItem("A propos", Icons.info,
                                        () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AproposScreen2(),
                                          ));
                                      setState(() {
                                        index = 17;
                                      });
                                    }, index == 17 ? true : false),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
              : Container(
            width: 10,
            height: 10,
          )
        ],
      ),
    )
        : /*Container(
          width: 200,
          height: double.infinity,
          child: */
    Expanded(
      flex: 1,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.orange[400],
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(
                              "${HOST}/media/assets/logo/logo.jpg"),
                        )
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "FIT HOUSE Coachs",
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                // image: DecorationImage(
                                //   fit: BoxFit.cover,
                                //   image: NetworkImage(
                                //       "${context.read<AdminProvider>().admin.image}"),
                                // ),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[200]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "${context.read<AdminProvider>().admin.name}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        height: 1,
                        decoration:
                        BoxDecoration(color: Colors.grey[200]),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView(
                        children: [
                          getItem("Réservations",
                              Icons.edit_calendar_outlined, () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //           ReservationPlanningScreenCoach(),
                                //     ));
                                setState(() {
                                  index = 8;
                                });
                              }, index == 8 ? true : false),
                          SizedBox(
                            height: 0,
                          ),
                          getItem(
                              "Cours", Icons.my_library_books_outlined,
                                  () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => CoursScreenCoach(),
                                //     ));
                                // setState(() {
                                //   index = 6;
                                // });
                              }, index == 6 ? true : false),
                          SizedBox(
                            height: 0,
                          ),
                          // getItem("Seances", Icons.access_time_rounded, () {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => SeanceScreenCoach(),
                          //       ));
                          //   setState(() {
                          //     index = 10;
                          //   });
                          // }, index == 10 ? true : false),

                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: 1,
                        decoration:
                        BoxDecoration(color: Colors.grey[200]),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Container(
                        //   child: InkWell(
                        //     onTap: () async {
                        //       try {
                        //         final prefs =
                        //         await SharedPreferences.getInstance();
                        //         final success1 = await prefs.remove('id');
                        //         final success2 = await prefs.remove('email');
                        //         final success3 = await prefs.remove('name');
                        //
                        //         print(
                        //             "Success: $success1 $success2 $success3");
                        //         if (success1 && success2) {
                        //           Navigator.of(context).pushAndRemoveUntil(
                        //               MaterialPageRoute(
                        //                   builder: (context) => splscreen()),
                        //                   (Route<dynamic> route) => false);
                        //           context.read<AdminProvider>().clearUser();
                        //         }
                        //       } catch (e) {
                        //         print("Error ${e}");
                        //       }
                        //     },
                        //     child: MediaQuery.of(context).size.width > 730
                        //         ? Row(
                        //       children: [
                        //         Icon(Icons.logout_outlined,
                        //             size: 18, color: Colors.black),
                        //         SizedBox(
                        //           width: 10,
                        //         ),
                        //         Text(
                        //           " Se Déconnecter",
                        //           style: TextStyle(
                        //               fontSize: 12,
                        //               color: Colors.black),
                        //         ),
                        //       ],
                        //     )
                        //         : Icon(Icons.logout_outlined,
                        //         size: 25, color: Colors.black),
                        //   ),
                        // ),
                        // SizedBox(height: 5,),
                        getItem("A propos", Icons.info,
                                () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AproposScreen2(),
                                  ));
                              setState(() {
                                index = 17;
                              });
                            }, index == 17 ? true : false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
    //);
  }

  Widget getItem(
      String title, IconData icon, VoidCallback onPressed, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
              color: isActive ? Colors.grey[200] : Colors.white,
              borderRadius: BorderRadius.circular(80)),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: MediaQuery.of(context).size.width > 730
                ? Row(
              children: [
                Icon(icon,
                    size: 18,
                    color: isActive ? Colors.orange[400] : Colors.black),
                SizedBox(
                  width: 10,
                ),
                Text(title,
                    style: TextStyle(
                        color:
                        isActive ? Colors.orange[400] : Colors.black,
                        fontSize: 12))
              ],
            )
                : Icon(icon,
                size: 25,
                color: isActive ? Colors.orange[400] : Colors.black),
          ),
        ),
      ),
    );
  }
}
