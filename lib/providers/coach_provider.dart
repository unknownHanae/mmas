import 'package:flutter/material.dart';

import '../models/CoachModels.dart';



class CoachProvider extends ChangeNotifier{
  late Coach _coach;

  Coach get coach => _coach;

  void setUser(Coach u){
    _coach = u;
    notifyListeners();
  }

  void clearUser(){

  }
}