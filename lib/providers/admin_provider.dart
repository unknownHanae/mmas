import 'package:flutter/material.dart';

import '../models/Admin.dart';

class AdminProvider extends ChangeNotifier{
  late Admin _admin;

  Admin get admin => _admin;

  void setUser(Admin u){
    _admin = u;
    notifyListeners();
  }

  void clearUser(){
    _admin = Admin(id: 0, name: "", email: "", token: "", role: "");
  }
}