import 'package:adminmmas/models/Admin.dart';
import 'package:adminmmas/providers/admin_provider.dart';
import 'package:adminmmas/views/ClientScreen.dart';
import 'package:adminmmas/views/etablissements.dart';
import 'package:adminmmas/views/login.dart';
import 'package:adminmmas/views/loginAdminMMAS.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SidebarMenu.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<void> checkAdmin() async{

      try {
        final prefs = await SharedPreferences.getInstance();

        final String? email = prefs.getString('email');
        final int? id = prefs.getInt('id');
        final String? name = prefs.getString('name');
        // final String? image = prefs.getString('image');
        final String? role = prefs.getString('role');

        final String? token = prefs.getString('token');

        print("email ${email}");
        print("id ${id}, token ${token}");

        if(email != null && id != null && name != null && token != null  && role != null){

          if(email.isNotEmpty && name.isNotEmpty  && token.isNotEmpty){
            context
                .read<AdminProvider>()
                .setUser(
                Admin(
                    id: id,
                    name: name,
                    email: email,
                   // image: image,
                    token: token,
                  role: role
                )
            );

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) =>
                    SidebarMenu()
                ),
                    (Route<dynamic> route) => false
            );
          }
        }
      } catch (e) {
        print("storage: ${e}");
      }
    }

    checkAdmin();

    return Container(
      width: double.infinity,
        height: double.infinity,
        child: Center(
            child: LoginPageMMAS()
        )
    );

    // return Container(
    //   width: double.infinity,
    //   height: double.infinity,
    //   child: Center(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Container(
    //           width: 129,
    //           height: 80,
    //           child: Image.asset(
    //             "assets/img.png",
    //           ),
    //         ),
    //         SizedBox(height: 20,),
    //         /*InkWell(
    //           onTap: (){
    //             Navigator.of(context).pushAndRemoveUntil(
    //                 MaterialPageRoute(builder: (context) =>
    //                     LoginPage()
    //                 ),
    //                     (Route<dynamic> route) => false
    //             );
    //           },
    //           child:*/
    //           Container(
    //             height: 40,
    //             width: 160,
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(8),
    //                 border: Border.all(color: Colors.orangeAccent)
    //             ),
    //             child: GestureDetector(
    //               onTap: (){
    //                 Navigator.of(context).pushAndRemoveUntil(
    //                     MaterialPageRoute(builder: (context) =>
    //                         LoginPage()
    //                     ),
    //                         (Route<dynamic> route) => false
    //                 );
    //               },
    //               child: Center(
    //                 child: Row(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Text("Commencer", style: TextStyle(fontSize: 16, color: Colors.orangeAccent),),
    //                     SizedBox(width: 8,),
    //                     Icon(Icons.arrow_forward_ios_sharp, size: 15, color: Colors.orangeAccent),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //
    //           ),
    //         //)
    //       ],
    //     ),
    //   ),
    // );
  }
}
