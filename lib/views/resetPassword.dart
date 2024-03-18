
import 'dart:convert';

import 'package:adminmmas/views/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/admin_provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // the current step
  int _currentStep = 0;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _codeController = TextEditingController();

  TextEditingController _newpasswordController = TextEditingController();

  TextEditingController _confirmnewpasswordController = TextEditingController();

  Future<void> sendMail() async {
    if(_emailController.text.isNotEmpty){
      var data = <String, dynamic>{
        "email" : _emailController.text,
        "for": "admin"
      };
      final response = await http.post(Uri.parse(
          HOST+"/api/reset_password/check_email"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print(response.body);
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){

          showAlertDialog(context, body["msg"]);
          setState(() {
            _currentStep = 1;
          });
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context, "une erreur s'est produite réessayez");
      }
    }else{
      showAlertDialog(context, "Ajouter un email");
    }
  }

  Future<void> checkCode() async {
    if(_emailController.text.isNotEmpty
        && _codeController.text.isNotEmpty){
      var data = <String, dynamic>{
        "email" : _emailController.text,
        "code" : _codeController.text,
        "for": "admin"
      };
      final response = await http.post(Uri.parse(
          HOST+"/api/reset_password/check_code"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print(response.body);
        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){

          setState(() {
            _currentStep = 2;
          });
        }else{
          showAlertDialog(context, body["msg"]);
        }

      } else {
        showAlertDialog(context, "une erreur s'est produite réessayez");
      }
    }else{
      showAlertDialog(context, "Ajouter un code");
    }
  }

  Future<void> resetPassword() async {
    if(_emailController.text.isNotEmpty
        && _codeController.text.isNotEmpty
        && _newpasswordController.text.isNotEmpty
      && _confirmnewpasswordController.text.isNotEmpty
    ){
      if (_newpasswordController.text == _confirmnewpasswordController.text) {
        var data = <String, dynamic>{
          "email" : _emailController.text,
          "code" : _codeController.text,
          "password": _newpasswordController.text,
          "confirm_password": _confirmnewpasswordController.text,
          "for": "admin"
        };
        final response = await http.post(Uri.parse(
            HOST+"/api/reset_password/new_password"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          print(response.body);
          final body = json.decode(response.body);
          final status = body["status"];
          if(status == true){

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(

                  title: Text("Récupérer votre compte"),
                  content: Text(body["msg"]),
                  actions: [
                    TextButton(
                      child: Text("Login"),
                      onPressed:  () {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            LoginPage()), (Route<dynamic> route) => false);
                      },
                    )
                  ],
                );
              },
            );

          }else{
            showAlertDialog(context, body["msg"]);
          }

        } else {
          showAlertDialog(context, "une erreur s'est produite réessayez");
        }
      }else{
        showAlertDialog(context, "Mot de passe de confitmation incorrect!!");
      }
    }else{
      showAlertDialog(context, "Ajouter un mot de passe");
    }
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
      title: Text("récupérer votre compte"),
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


  @override
  Widget build(BuildContext context) {
    var scrren_size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: scrren_size.width < 500 ? 300 : 550,
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Récupérer votre compte", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              SizedBox(height: 15,),
              Expanded(
                // the Stepper widget
                child: Stepper(
                  // vertical or horizontial
                  type: StepperType.horizontal,
                  physics: const ScrollPhysics(),
                  currentStep: _currentStep,
                  //onStepTapped: (step) => _stepTapped(step),
                  //onStepContinue: _stepContinue,
                  //onStepCancel: _stepCancel,
                  controlsBuilder: (context, ControlsDetails details) {
                    return SizedBox(width: 0, height: 0,);
                  },
                  steps: [
                    // The first step: Name
                    Step(
                      title: scrren_size.width < 500 ? Text("") : Text('E-mail'),
                      content: Column(
                        children: [
                          TextFormField(
                            decoration:
                            const InputDecoration(labelText: 'Votre adresse mail'),
                            controller: _emailController,
                          ),
                          SizedBox(height: 10,),
                          ElevatedButton(

                              onPressed: (){
                                // send code in mail
                                sendMail();
                              },
                              child: Text("Envoyer le code", style: TextStyle(color: Colors.white),)
                          )
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    // The second step: Phone number
                    Step(
                      title: scrren_size.width < 500 ? Text("") : Text('Code'),
                      content: Column(
                        children: [
                          TextFormField(

                            decoration: const InputDecoration(
                                labelText: 'Votre code de verification'
                            ),

                            controller: _codeController,
                          ),
                          SizedBox(height: 10,),
                          ElevatedButton(

                              onPressed: (){
                                // check code
                                checkCode();
                              },
                              child: Text("Vérifier le code", style: TextStyle(color: Colors.white),)
                          )
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    // The third step: Verify phone number
                    Step(
                      title: scrren_size.width < 500 ? Text("") : Text('Nouveau Mot de passe'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Nouveau mot de passe'),
                            controller: _newpasswordController,
                            obscureText: true,
                          ),
                          SizedBox(height: 5,),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Confirmez le nouveau mot de passe'),
                            controller: _confirmnewpasswordController,
                            obscureText: true,
                          ),
                          SizedBox(height: 10,),
                          ElevatedButton(

                              onPressed: (){
                                // reset password
                                resetPassword();
                              },
                              child: Text("Réinitialiser le mot de passe", style: TextStyle(color: Colors.white),)
                          )
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 2
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Text("Se connecter", style: TextStyle(color: Colors.blueAccent, fontSize: 18),),
              )
            ],
          ),
        ),
      ),
    );
  }
}