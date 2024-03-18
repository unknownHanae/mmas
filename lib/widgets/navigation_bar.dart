import 'package:flutter/material.dart';
import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/Admin.dart';
import 'package:adminmmas/providers/admin_provider.dart';
import 'package:adminmmas/views/ReservationScreen.dart';
import 'package:adminmmas/views/cours.dart';
import 'package:adminmmas/views/login.dart';
import 'package:adminmmas/views/splscreeen.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/Abonnement.dart';
import '../views/Affiliation.dart';
import '../views/Apropos.dart';
import '../views/Apropos2.dart';
import '../views/Cat_contrat.dart';
import '../views/CategorieSalle.dart';
import '../views/ClasseScreen.dart';
import '../views/ClientScreen.dart';
import '../views/CoachScreen.dart';
import '../views/ContratScreen.dart';
import '../views/NotificationScreen.dart';
import '../views/ParentScreen.dart';
import '../views/PeriodeScreen.dart';
import '../views/ReservationPlanningScreen.dart';
import '../views/ReservationScreen2.dart';
import '../views/ResrvationCoach.dart';
import '../views/SalleScreen.dart';
import '../views/SeanceScreen.dart';
import '../views/StaffScreen.dart';
import '../views/TransationScreen.dart';
import '../views/contratstaffScreen.dart';
import '../views/etablissements.dart';
import '../views/loginAdminMMAS.dart';
import '../views/paiementScreen.dart';
import '../views/v_client.dart';
import '../views/v_coach.dart';

import 'package:provider/provider.dart';

import '../views/DashboardScreen.dart';


class SideBar extends StatefulWidget {
  int? postion;
  String msg;
    SideBar({Key? key, required this.postion,required this.msg}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool toggleMenu = false;
   // final ExpansionTileController title_controller1 = ExpansionTileController();
  //
  // static ExpansionTileController of(BuildContext context) {
  //   final _ExpansionTileState? result = context.findAncestorStateOfType<_ExpansionTileState>();
  //   if (result != null) {
  //     return result._tileController;
  //   }
  //   throw FlutterError.fromParts(<DiagnosticsNode>[
  //     ErrorSummary(
  //       'ExpansionTileController.of() called with a context that does not contain a ExpansionTile.',
  //     ),
  //     ErrorDescription(
  //       'No ExpansionTile ancestor could be found starting from the context that was passed to ExpansionTileController.of(). '
  //           'This usually happens when the context provided is from the same StatefulWidget as that '
  //           'whose build function actually creates the ExpansionTile widget being sought.',
  //     ),
  //     ErrorHint(
  //       'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
  //           'context that is "under" the ExpansionTile. For an example of this, please see the '
  //           'documentation for ExpansionTileController.of():\n'
  //           '  https://api.flutter.dev/flutter/material/ExpansionTile/of.html',
  //     ),
  //     ErrorHint(
  //       'A more efficient solution is to split your build function into several widgets. This '
  //           'introduces a new context from which you can obtain the ExpansionTile. In this solution, '
  //           'you would have an outer widget that creates the ExpansionTile populated by instances of '
  //           'your new inner widgets, and then in these inner widgets you would use ExpansionTileController.of().\n'
  //           'An other solution is assign a GlobalKey to the ExpansionTile, '
  //           'then use the key.currentState property to obtain the ExpansionTile rather than '
  //           'using the ExpansionTileController.of() function.',
  //     ),
  //     context.describeElement('The context used was'),
  //   ]);
  // }
  //final
  //ExpansionTileController title_controller1 = ExpansionTileController();
  int _indexTab = 0;
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  @override
  Widget build(BuildContext context) {
    int index = widget.postion!;
    // Admin admin = context.watch<AdminProvider>().admin;

    /*return Container(
      width: 35,
      height: 35,
      child: InkWell(
        onTap: (){},
        child: Icon(Icons.menu, size: 30, color: Colors.orange),
      ),
    );*/

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
                      child: Icon(Icons.menu, size: 30, color: Colors.blueGrey),
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
                                              message: "${context.read<AdminProvider>().admin.email}",
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          'https://cdn-icons-png.flaticon.com/512/219/219969.png'),
                                                    ),
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
                                                      message: "${context.read<AdminProvider>().admin.email}",
                                                      child: Text(
                                                        "${context.read<AdminProvider>().admin.email}",
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
                                          children: <Widget>[
                                            ExpansionTile(
                                              key: key1,
                                              onExpansionChanged: (v) {
                                                if(v){
                                                  setState(() {
                                                    _indexTab = 0;
                                                  });
                                                }
                                            },
                                              initiallyExpanded: _indexTab == 0 ? true : false,
                                              title: Text("G.E",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                              children: <Widget>[
                                                Tooltip(
                                                  message: "Etablissement",
                                                  child: getItem(
                                                      "Etablissement", Icons.house,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EtablissementScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 22;
                                                        });
                                                      }, index == 22 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                Tooltip(
                                                  message: "Dashboard",
                                                  child: getItem(
                                                      "Dashboard", Icons.dashboard,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  RespDashboardView(),
                                                            ));
                                                        setState(() {
                                                          index = 0;
                                                        });
                                                      }, index == 0 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                Tooltip(
                                                  message: "Notifications",
                                                  child: getItem("Notifications", Icons.notifications,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  NotificationsPage(),
                                                            ));
                                                        setState(() {
                                                          index = 15;
                                                        });
                                                      }, index == 15 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                Tooltip(
                                                  message: "Transactions",
                                                  child: getItem("Transactions", Icons.payment_outlined,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TransactionScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 9;
                                                        });
                                                      }, index == 9 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                Tooltip(
                                                  message: "Seances",
                                                  child: getItem("Seances", Icons.access_time_rounded,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SeanceScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 10;
                                                        });
                                                      }, index == 10 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                Tooltip(
                                                  message: "Présence",
                                                  child: getItem("Présence",
                                                      Icons.edit_calendar_outlined,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Presence(),
                                                            ));
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
                                                      Icons.meeting_room_outlined,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SalleScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 5;
                                                        });
                                                      }, index == 5 ? true : false),
                                                ),
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
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CoursScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 6;
                                                        });
                                                      }, index == 6 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                Tooltip(
                                                  message: "Abonnements",
                                                  child: getItem("Abonnements",
                                                      Icons.subscriptions, () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AbonnementScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 7;
                                                        });
                                                      }, index == 7 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 0,
                                            ),
                                            ExpansionTile(
                                              onExpansionChanged: (v) {
                                                if(v){
                                                  setState(() {
                                                    _indexTab = 1;
                                                  });
                                                  //key1.currentState.co
                                                }
                                              },
                                              initiallyExpanded: _indexTab == 1 ? true : false,

                                              title: Text("G.C",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                              children: <Widget>[
                                                Tooltip(
                                                  message: "étudiants",
                                                  child: getItem(
                                                      "étudiants",
                                                      Icons
                                                          .people,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ClientScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 1;
                                                        });
                                                      }, index == 1 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),

                                                Tooltip(
                                                  message: "Parent",
                                                  child: getItem(
                                                      "Parent",
                                                      Icons
                                                          .face,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ParentScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 222;
                                                        });
                                                      }, index == 222? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),

                                                getItem("Afilliation",
                                                    Icons.family_restroom, () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => AfilliationScreen(),
                                                          ));
                                                      setState(() {
                                                        index = 333;
                                                      });
                                                    }, index == 333 ? true : false),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                Tooltip(
                                                  message: "Classe",
                                                  child: getItem(
                                                      "Classe",
                                                      Icons.meeting_room,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ClasseScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 55;
                                                        });
                                                      }, index == 55 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                Tooltip(
                                                  message: "Contacts Etudiants",
                                                  child: getItem("Contacts Etudiants",
                                                      Icons.receipt_long, () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ContratScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 1111;
                                                        });
                                                      }, index == 1111 ? true : false),
                                                ),

                                                SizedBox(
                                                  height: 0,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 0,
                                            ),
                                            ExpansionTile(
                                              onExpansionChanged: (v) {
                                                print("tab 3 $v");
                                                if(v){
                                                  setState(() {
                                                    _indexTab = 2;
                                                  });
                                                }
                                              },
                                                maintainState: _indexTab == 2 ? true : false,
                                              title: Text("G.P",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                              children: <Widget>[
                                                Tooltip(
                                                  message: "Staff",
                                                  child: getItem("Staff",
                                                      Icons.account_circle_outlined,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  StaffScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 20;
                                                        });
                                                      }, index == 20 ? true : false),
                                                ),

                                                SizedBox(
                                                  height: 0,
                                                ),
                                                Tooltip(
                                                  message: "Période",
                                                  child: getItem("Période",
                                                      Icons.timelapse,
                                                          () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      PeriodeScreen(),
                                                                ));
                                                        setState(() {
                                                          index = 42;
                                                        });
                                                      }, index == 42 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                Tooltip(
                                                  message: "Paiement",
                                                  child: getItem("Paiement",
                                                      Icons.people,
                                                          () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => PaiementScreen(),
                                                                ));
                                                        setState(() {
                                                          index = 42;
                                                        });
                                                      }, index == 42 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                // Tooltip(
                                                //   message: "Coachs",
                                                //   child: getItem("Coachs",
                                                //       Icons.sports_martial_arts_sharp,
                                                //           () {
                                                //             Navigator.push(
                                                //                 context,
                                                //                 MaterialPageRoute(
                                                //                   builder: (context) => CoachScreen(),
                                                //                 ));
                                                //         setState(() {
                                                //           index = 42;
                                                //         });
                                                //       }, index == 42 ? true : false),
                                                // ),
                                                // SizedBox(
                                                //   height: 0,
                                                // ),
                                                Tooltip(
                                                  message: "Contrats Salariés",
                                                  child: getItem("Contrats Salariés",
                                                      Icons.receipt_long,
                                                          () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ContratstaffScreen(),
                                                            ));
                                                        setState(() {
                                                          index = 21;
                                                        });
                                                      }, index == 21 ? true : false),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 0,
                                            ),
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
                                                                        LoginPageMMAS()),
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
                        //color: Colors.orange[400],
                      color: Colors.white,
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
                                      "${HOST}/media/assets/logo/logommas.png"),
                                )
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text(
                                "Meet me after school",
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
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
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'https://cdn-icons-png.flaticon.com/512/219/219969.png'),
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey[200]),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${context.read<AdminProvider>().admin.email}",
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
                                children: <Widget>[
                                  ExpansionTile(
                                    title: Text("Gestion de l'établissement",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    children: <Widget>[
                                      getItem("Etablissement", Icons.house, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EtablissementScreen(),
                                            ));
                                        setState(() {
                                          index = 22;
                                        });
                                      }, index == 22 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("Dashboard", Icons.dashboard, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RespDashboardView(),
                                            ));
                                        setState(() {
                                          index = 0;
                                        });
                                      }, index == 0 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("Notifications", Icons.notifications,
                                              () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NotificationsPage(),
                                                ));
                                            setState(() {
                                              index = 15;
                                            });
                                          }, index == 15 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("Transactions", Icons.payment_outlined, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TransactionScreen(),
                                            ));
                                        setState(() {
                                          index = 9;
                                        });
                                      }, index == 9 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("Seances", Icons.access_time_rounded, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SeanceScreen(),
                                            ));
                                        setState(() {
                                          index = 10;
                                        });
                                      }, index == 10 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("Présence",
                                          Icons.edit_calendar_outlined, () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Presence(),
                                                ));
                                            setState(() {
                                              index = 8;
                                            });
                                          }, index == 8 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("Salles", Icons.meeting_room_outlined,
                                              () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SalleScreen(),
                                                ));
                                            setState(() {
                                              index = 5;
                                            });
                                          }, index == 5 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem(
                                          "Cours", Icons.my_library_books_outlined,
                                              () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CoursScreen(),
                                                ));
                                            setState(() {
                                              index = 6;
                                            });
                                          }, index == 6 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("Abonnements", Icons.subscriptions, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AbonnementScreen(),
                                            ));
                                        setState(() {
                                          index = 7;
                                        });
                                      }, index == 7 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),

                                    ],
                  ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                  ExpansionTile(
                                    title: Text("Gestion des étudiants",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    children: <Widget>[
                                      getItem("étudiants",
                                          Icons.people, () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ClientScreen(),
                                                ));
                                            setState(() {
                                              index = 1;
                                            });
                                          }, index == 1 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),

                                      getItem("Parent",
                                          Icons.face, () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ParentScreen(),
                                                ));
                                            setState(() {
                                              index =222;
                                            });
                                          }, index == 222? true : false),

                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("Afilliation",
                                          Icons.family_restroom, () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AfilliationScreen(),
                                                ));
                                            setState(() {
                                              index = 333;
                                            });
                                          }, index == 333 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("classes",
                                          Icons.meeting_room, () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ClasseScreen(),
                                                ));
                                            setState(() {
                                              index = 55;
                                            });
                                          }, index == 55 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("Contacts Etudiants", Icons.receipt_long,
                                              () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ContratScreen(),
                                                ));
                                            setState(() {
                                              index = 1111;
                                            });
                                          }, index == 1111 ? true : false),

                                      SizedBox(
                                        height: 0,
                                      ),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text("Gestion du personnels",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    children: <Widget>[
                                      Tooltip(
                                      message: "Staff",
                                      child: getItem("Staff",
                                          Icons.account_circle_outlined,
                                              () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StaffScreen(),
                                                ));
                                            setState(() {
                                              index = 20;
                                            });
                                          }, index == 20 ? true : false),
                                    ),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("Période", Icons.timelapse, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PeriodeScreen(),
                                            ));
                                        setState(() {
                                          index = 42;
                                        });
                                      }, index == 42 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      getItem("Paiement",
                                          Icons.people, () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PaiementScreen(),
                                                ));
                                            setState(() {
                                              index = 23;
                                            });
                                          }, index == 23 ? true : false),
                                      // getItem("Coachs", Icons.sports_martial_arts_sharp,
                                      //         () {
                                      //       Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //             builder: (context) => CoachScreen(),
                                      //           ));
                                      //
                                      //       setState(() {
                                      //         index = 3;
                                      //       });
                                      //     }, index == 3 ? true : false),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      Tooltip(
                                        message: "Contrats Salariés",
                                        child: getItem("Contrats Salariés",
                                            Icons.receipt_long,
                                                () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ContratstaffScreen(),
                                                  ));
                                              setState(() {
                                                index = 21;
                                              });
                                            }, index == 21 ? true : false),
                                      ),
                                      SizedBox(
                                        height: 0,
                                      ),
                                    ],
                                    ),
                                  // getItem("Catégoie Contrats", Icons.list,(){  Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => CatContratScreen(),
                                  //     ));
                                  //   setState(() {
                                  //     index =  2;
                                  //   });
                                  // },index == 2?true:false),
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
                                  /*SizedBox(
                                    height: 0,
                                  ),
                                  getItem("Notifications", Icons.house,(){  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotificationsPage(),
                                      ));
                                  setState(() {
                                    index =  4;
                                  });
                                  },index == 4?true:false),*/
                                  SizedBox(
                                    height: 0,
                                  ),
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
                                Container(
                                  child: InkWell(
                                    onTap: () async {
                                      try {
                                        final prefs =
                                            await SharedPreferences.getInstance();
                                        final success1 = await prefs.remove('id');
                                        final success2 = await prefs.remove('email');
                                        final success3 = await prefs.remove('name');

                                        print(
                                            "Success: $success1 $success2 $success3");
                                        if (success1 && success2) {
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) => LoginPageMMAS()),
                                              (Route<dynamic> route) => false);
                                          context.read<AdminProvider>().clearUser();
                                        }
                                      } catch (e) {
                                        print("Error ${e}");
                                      }
                                    },
                                    child: MediaQuery.of(context).size.width > 730
                                        ? Row(
                                            children: [
                                              Icon(Icons.logout_outlined,
                                                  size: 18, color: Colors.black),
                                              SizedBox(
                                                width: 10,
                                              ),
                                           Text(
                                                  " Se Déconnecter",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                            ],
                                          )
                                        : Icon(Icons.logout_outlined,
                                            size: 25, color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: 5,),
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


