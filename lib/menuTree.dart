import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

final menuTree = TreeNode.root()
  ..addAll(
    [

      // TreeNode(key: "Dashboard", data: Icons.dashboard),
      TreeNode(key: "Gestion de l'établissement",data: Icons.house )
        ..addAll([
          TreeNode(key: "Etablissement", data: Icons.house),
          TreeNode(key: "Dashboard", data: Icons.dashboard),
          TreeNode(key: "Notifications", data: Icons.notifications),
          TreeNode(key: "Transactions", data: Icons.payment_outlined),
          TreeNode(key: "Seances", data: Icons.access_time_rounded),
          TreeNode(key: "Présence", data: Icons.edit_calendar_outlined),
          TreeNode(key: "Salles", data: Icons.meeting_room_outlined),
          TreeNode(key: "Cours", data: Icons.my_library_books_outlined),
          TreeNode(key: "Abonnements", data: Icons.subscriptions),
        ]),
      TreeNode(key: "Gestion des étudiants" , data: Icons.people)
        ..addAll([
          TreeNode(key: "étudiants", data: Icons.people),
          TreeNode(key: "Parent", data: Icons.face),
          TreeNode(key: "Afilliation", data: Icons.family_restroom),
          TreeNode(key: "classes", data: Icons.meeting_room),
          TreeNode(key: "Contrats Etudiants", data: Icons.receipt_long),
        ]),
      TreeNode(key: "Gestion du personnels" , data: Icons.collections_bookmark)
        ..addAll([
          TreeNode(key: "Staff", data: Icons.collections_bookmark),
          TreeNode(key: "Période", data: Icons.collections_bookmark),
          TreeNode(key: "Paiement", data: Icons.collections_bookmark),
          TreeNode(key: "Contrats Salariés", data: Icons.collections_bookmark),
        ]),
      TreeNode(key: "Se deconnecter", data: Icons.logout_outlined),
      TreeNode(key: "A propos", data: Icons.info),
    ],
  );