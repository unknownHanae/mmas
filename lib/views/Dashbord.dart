
import 'package:flutter/material.dart';

import '../widgets/navigation_bar.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



class DashbordScreen extends StatefulWidget {
  const DashbordScreen({Key? key}) : super(key: key);

  @override
  State<DashbordScreen> createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init state");


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200]
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              SideBar(postion: 0,msg:"Coach"),
              SizedBox(width: 10,),

            ],
          ),
        ),
      ),
    );
  }

}

