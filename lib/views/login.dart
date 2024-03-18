


import 'package:adminmmas/views/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/Admin.dart';
import '../providers/admin_provider.dart';
import 'ClientScreen.dart';
import 'DashboardScreen.dart';
import 'Dashbord.dart';
import 'ResrvationCoach.dart';
import 'SalleCoach.dart';
import 'etablissements.dart';

import 'package:provider/provider.dart';

import 'dart:html';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  Widget _entryField(TextEditingController _controller,String title, {bool isPassword = false}) {
    return Container(
      width: 400,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              controller: _controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  /*Widget _submitButton(BuildContext cnx) {
    return InkWell(
      onTap: (){
        _login(cnx);
      },
      child: Container(
        width: 300,
        //width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }*/

  Widget _divider() {
    return Container(
      width: 350,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }



  Widget _restPasseword() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: ENV == "prod" ? AssetImage("assets/logo_prod.png") :
                AssetImage("assets/logo_dev.png")
                ,
              )
          ),
        ),
        SizedBox(
          height: 10,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'F',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffe46b10)
              ),
              children: [
                TextSpan(
                  text: 'IT',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
                TextSpan(
                  text: 'House',
                  style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
                ),
              ]),
        ),
      ],
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField(controllerEmail, "login",),
        _entryField(controllerPassword, "Mot de passe", isPassword: true),

      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    void _login() async {

      if(controllerEmail.text.length > 0
          && controllerPassword.text.length > 0
      ){
        var data = <String, String>{
          "username": controllerEmail.text,
          "password": controllerPassword.text,
        };

        print(data);
        //final http.Client _client = http.Client();


        final response = await http.post(Uri.parse(
            HOST+"/api/loginAdmin"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          print(response.body);
          final body = json.decode(response.body);

          print(data);

          if(body["success"] == true){
            //document.cookie="jwt=${body["token"]}";
            final data = body["data"][0];
            try {
              final prefs = await SharedPreferences.getInstance();

              prefs.setInt("id", data["id_admin"]);
              prefs.setString("name", "admin");
              prefs.setString("email", data["login"]);
              prefs.setString("token", body["token"]);
              //prefs.setString("image", "image");
              prefs.setString("role", "admin");


              context.read<AdminProvider>()
                  .setUser(
                  Admin(
                    id: data["id_admin"],
                    name: "admin",
                    email: data["login"],
                    token: body["token"],
                      //image: body["image"],
                    role: "admin"
                  )
              );

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) =>
                      ClientScreen()
                  ),
                      (Route<dynamic> route) => false
              );
            } catch (e) {
              print("storage: ${e}");
            }
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EtablissementScreen(),
              ));*/
          }else{
            showAlertDialog(context, "Email ou mot de passe incorrect");
          }

        } else {
          showAlertDialog(context, "Échec de la connexion");
        }
      }else{
        showAlertDialog(context, "Email et mot de passe sont requis !!");
      }

    }


    return Scaffold(
        body: Center(
          child: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .2),
                        _title(),
                        SizedBox(height: 50),
                        _emailPasswordWidget(),
                        SizedBox(height: 20),
                        //_submitButton(context),
                        InkWell(
                          onTap: (){
                            _login();
                          },
                          child: Container(
                            width: 300,
                            //width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: Offset(2, 4),
                                      blurRadius: 5,
                                      spreadRadius: 2)
                                ],
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResetPassword(),
                                ));
                                            },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: Text('Mot de passe oublié ?',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        SizedBox(height: height * .055),
                        //_createAccountLabel(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  showAlertDialog(BuildContext context, String msg) {
    Widget cancelButton = TextButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Login"),
      content: Text(msg),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}