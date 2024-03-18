import 'package:adminmmas/providers/admin_provider.dart';
import 'package:adminmmas/views/Abonnement.dart';
import 'package:adminmmas/views/Affiliation.dart';
import 'package:adminmmas/views/Apropos2.dart';
import 'package:adminmmas/views/ClasseScreen.dart';
import 'package:adminmmas/views/ClientScreen.dart';
import 'package:adminmmas/views/ContratScreen.dart';
import 'package:adminmmas/views/DashboardScreen.dart';
import 'package:adminmmas/views/NotificationScreen.dart';
import 'package:adminmmas/views/ParentScreen.dart';
import 'package:adminmmas/views/PeriodeScreen.dart';
import 'package:adminmmas/views/ResrvationCoach.dart';
import 'package:adminmmas/views/SalleScreen.dart';
import 'package:adminmmas/views/SeanceScreen.dart';
import 'package:adminmmas/views/StaffScreen.dart';
import 'package:adminmmas/views/TransationScreen.dart';
import 'package:adminmmas/views/contratstaffScreen.dart';
import 'package:adminmmas/views/cours.dart';
import 'package:adminmmas/views/etablissements.dart';
import 'package:adminmmas/views/loginAdminMMAS.dart';
import 'package:adminmmas/views/paiementScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreensView extends StatelessWidget {
  final String menu;
  const ScreensView({Key? key, required this.menu}) : super(key: key);
  void logout(context) async {
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
  }
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (menu) {
      case 'Etablissement':
        page = EtablissementScreen();
        break;
      case 'Dashboard':
        page = RespDashboardView();
        break;
      case 'Notifications':
        page = NotificationsPage();
        break;
      case 'Transactions':
        page = TransactionScreen();
        break;
      case 'Seances':
        page = SeanceScreen();
        break;
      case 'Présence':
        page = Presence();
        break;
      case 'Salles':
        page = SalleScreen();
        break;
      case 'Cours':
        page =  CoursScreen();
        break;
      case 'Abonnements':
        page = AbonnementScreen();
        break;
      case 'étudiants':
        page =  ClientScreen();
        break;
      case 'Parent':
        page = ParentScreen();
        break;
      case 'Afilliation':
        page = AfilliationScreen();
        break;
      case 'classes':
        page = ClasseScreen();
        break;
      case 'Contrats Etudiants':
        page = ContratScreen();
        break;
      case 'Staff':
        page = StaffScreen();
        break;
      case 'Période':
        page = PeriodeScreen();
        break;
      case 'Paiement':
        page = PaiementScreen();
        break;
      case 'Contrats Salariés':
        page = ContratstaffScreen();
        break;
      case 'Se deconnecter':
        logout(context);
        page =  LoginPageMMAS();
        break;
      case 'A propos':
        page = AproposScreen2();
        break;
      default:
        page =  ClientScreen();
    }
    return page;
  }
}