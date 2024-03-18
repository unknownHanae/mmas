//
// import 'package:flutter/material.dart';
//
//
//
// import 'package:flutter/rendering.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../constants.dart';
// import '../models/Admin.dart';
// import '../providers/admin_provider.dart';
// import 'ClientScreen.dart';
// import 'ResrvationCoach.dart';
// import 'login.dart';
// import 'loginCoach.dart';
//
//
// class splscreen extends StatefulWidget {
//   const splscreen({Key? key}) : super(key: key);
//
//   @override
//   State<splscreen> createState() => _splscreenState();
// }
//
// class _splscreenState extends State<splscreen> {
//
//
//   Widget _title() {
//     return Column(
//       children: [
//         Container(
//           width: 80,
//           height: 60,
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                 fit: BoxFit.contain,
//                 image: ENV == "prod" ? AssetImage("assets/logo_prod.png") :
//                 AssetImage("assets/logo_dev.png")
//                 ,
//               )
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         RichText(
//           textAlign: TextAlign.center,
//           text: TextSpan(
//               text: 'F',
//               style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xffe46b10)
//               ),
//               children: [
//                 TextSpan(
//                   text: 'IT',
//                   style: TextStyle(color: Colors.black, fontSize: 30),
//                 ),
//                 TextSpan(
//                   text: 'House',
//                   style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
//                 ),
//               ]),
//         ),
//       ],
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//
//     Future<void> checkAdmin() async{
//
//       try {
//         final prefs = await SharedPreferences.getInstance();
//
//         final String? email = prefs.getString('email');
//         final int? id = prefs.getInt('id');
//         final String? name = prefs.getString('name');
//         final String? image = prefs.getString('image');
//         final String? role = prefs.getString('role');
//
//         final String? token = prefs.getString('token');
//
//         print("email ${email}");
//         print("id ${id}, token ${token}");
//
//         if(email != null && id != null && name != null  && image != null && token != null && role!= null){
//
//           if(email.isNotEmpty && name.isNotEmpty && token.isNotEmpty && image.isNotEmpty && role.isNotEmpty){
//             context
//                 .read<AdminProvider>()
//                 .setUser(
//                 Admin(
//                     id: id,
//                     name: name,
//                     email: email,
//                     image: "${HOST}/media/${image}",
//                     token: token,
//                   role: role
//                 )
//             );
//
//             Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) =>
//                     role == "admin" ? ClientScreen() : ReservationPlanningScreenCoach()
//                 ),
//                     (Route<dynamic> route) => false
//             );
//           }
//         }
//       } catch (e) {
//         print("storage: ${e}");
//       }
//     }
//
//     checkAdmin();
//     return Scaffold(
//       body: Center(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(height: 100),
//                 _title(),
//                 SizedBox(height: 50),
//                 InkWell(
//                   onTap:  (){
//                     Navigator.of(context)
//                         .push(
//                         MaterialPageRoute(builder: (context) => LoginPage())
//                     );
//                   },
//                   child: Container(
//                     width: 300,
//                     //width: MediaQuery.of(context).size.width,
//                     padding: EdgeInsets.symmetric(vertical: 15),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(5)),
//                         boxShadow: <BoxShadow>[
//                           BoxShadow(
//                               color: Colors.grey.shade200,
//                               offset: Offset(2, 4),
//                               blurRadius: 5,
//                               spreadRadius: 2)
//                         ],
//                         gradient: LinearGradient(
//                             begin: Alignment.centerLeft,
//                             end: Alignment.centerRight,
//                             colors: [Color(0xfffbb448), Color(0xfff7892b)])),
//                     child: Text(
//                       'Admin',
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 InkWell(
//                   onTap:  (){
//                     Navigator.of(context)
//                         .push(
//                         MaterialPageRoute(builder: (context) => LoginCoachPage())
//                     );
//                   },
//                   child: Container(
//                     width: 300,
//                     //width: MediaQuery.of(context).size.width,
//                     padding: EdgeInsets.symmetric(vertical: 15),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(5)),
//                         boxShadow: <BoxShadow>[
//                           BoxShadow(
//                               color: Colors.grey.shade200,
//                               offset: Offset(2, 4),
//                               blurRadius: 5,
//                               spreadRadius: 2)
//                         ],
//                         gradient: LinearGradient(
//                             begin: Alignment.centerLeft,
//                             end: Alignment.centerRight,
//                             colors: [Colors.black, Colors.black26])),
//                     child: Text(
//                       'Coachs testtt',
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 //_createAccountLabel(),
//               ],
//             ),
//           ),
//
//         ),
//       ),
//     );
//   }
//
//
//
// }
//
