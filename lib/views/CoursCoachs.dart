// import 'dart:convert';
//
// import 'package:adminmmas/constants.dart';
// import 'package:adminmmas/models/CoursModels.dart';
// import 'package:adminmmas/views/AddCour.dart';
// import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
// import 'package:bs_flutter_modal/bs_flutter_modal.dart';
// import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
// import 'package:confirm_dialog/confirm_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
//
// import '../componnents/deleteButton.dart';
// import '../componnents/editerButton.dart';
// import '../componnents/label.dart';
// import '../componnents/showButton.dart';
// import '../providers/admin_provider.dart';
// import '../widgets/navigation_bar.dart';
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:html' as html;
// import 'package:intl/intl.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:flutter/rendering.dart';
//
// import '../widgets/navigation_bar_Coach.dart';
// import 'UpdateCours.dart';
//
// class CoursScreenCoach extends StatefulWidget {
//   const CoursScreenCoach({Key? key}) : super(key: key);
//
//   @override
//   State<CoursScreenCoach> createState() => _CoursState();
// }
//
// class _CoursState extends State<CoursScreenCoach> {
//
//   List<Cours> data = [];
//   List<Cours> init_data = [];
//   bool loading = false;
//
//   //final TextEditingController input_search = TextEditingController();
//   String text_search = "";
//
//   String nom_cour = "";
//   String description = "";
//   String reglement = "";
//   String genre = "";
//
//   Uint8List? _bytesData;
//   List<int>? _selectedFile;
//
//
//   TextEditingController nom_controller = TextEditingController();
//   TextEditingController description_controller = TextEditingController();
//   TextEditingController reglement_controller = TextEditingController();
//
//   String image_path = "";
//
//   BsSelectBoxController _selectGenre = BsSelectBoxController(
//       options: [
//         BsSelectBoxOption(value: "Homme", text: Text("Homme")),
//         BsSelectBoxOption(value: "Femme", text: Text("Femme")),
//         BsSelectBoxOption(value: "Mixte", text: Text("Mixte")),
//         BsSelectBoxOption(value: "Junior", text: Text("Junior")),
//       ]
//   );
//   BsSelectBoxController _selectFilter = BsSelectBoxController(
//       options: [
//         BsSelectBoxOption(value: 3, text: Text("Tous")),
//         BsSelectBoxOption(value: 0, text: Text("Homme")),
//         BsSelectBoxOption(value: 1, text: Text("Femme")),
//         BsSelectBoxOption(value: 2, text: Text("Mixte")),
//       ]
//   );
//   void filterCours(){
//     if(_selectFilter.getSelected()?.getValue() != null){
//       print(_selectFilter.getSelected()?.getValue());
//       setState(() {
//         data = [];
//       });
//       if(_selectFilter.getSelected()?.getValue() == 3){
//         setState(() {
//           data = init_data;
//         });
//
//       }
//       if(_selectFilter.getSelected()?.getValue() == 0){
//         setState(() {
//           data = init_data.where((element) => (element.genre!.toString()) == "Homme").toList();
//         });
//
//       }
//
//       if(_selectFilter.getSelected()?.getValue() == 1){
//         setState(() {
//           data = init_data.where((element) => (element.genre!.toString()) == "Femme").toList();
//         });
//
//       }
//       if(_selectFilter.getSelected()?.getValue() == 2){
//         setState(() {
//           data = init_data.where((element) => (element.genre!.toString()) == "Mixte").toList();
//         });
//
//       }
//     }
//   }
//   void initData() {
//     nom_controller.text = "";
//     description_controller.text = "";
//     reglement_controller.text = "";
//     _selectGenre.removeSelected(_selectGenre.getSelected()!);
//
//     setState(() {
//       image_path = "";
//     });
//     fetchCour();
//   }
//
//   Future cameraImage(context, {Cours? cour}) async {
//     try{
//       html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
//       uploadInput.multiple = true;
//       uploadInput.draggable = true;
//       uploadInput.click();
//
//
//       uploadInput.onChange.listen((event) {
//         final files = uploadInput.files;
//         final file = files![0];
//         final reader = html.FileReader();
//
//         reader.onLoadEnd.listen((event) async {
//           _bytesData = Base64Decoder().convert(reader.result
//               .toString()
//               .split(",")
//               .last);
//           _selectedFile = _bytesData;
//           var url = Uri.parse(HOST+"/api/saveImage/");
//           var request = http.MultipartRequest("POST", url);
//           request.files.add(await http.MultipartFile.fromBytes('uploadedFile', _selectedFile!,
//               contentType: MediaType("application","json"), filename: "image-cour"));
//           request.fields["path"] = "cours/";
//
//           var response = await request.send();
//           var responseData = await response.stream.toBytes();
//           var responseString = String.fromCharCodes(responseData);
//           final body = Map<String, dynamic>.from(json.decode(responseString));
//           print(responseString);
//
//           if(response.statusCode == 200){
//             setState(() {
//               image_path = body['path'];
//             });
//             if(cour != null){
//               Navigator.pop(context);
//               modal_Update(context, cour, uploadImage: true);
//             }else{
//               Navigator.pop(context);
//               modal_add(context);
//             }
//           }else{
//             final snackBar = SnackBar(
//               content: const Text('Please try again'),
//               action: SnackBarAction(
//                 label: 'Close',
//                 onPressed: () {
//                   // Some code to undo the change.
//                 },
//               ),
//             );
//             ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           }
//         });
//         reader.readAsDataUrl(file);
//       });
//
//     }catch(error){
//       print(error);
//     }
//
//   }
//
//   void add(context) async {
//
//     if(nom_controller.text.isNotEmpty && description_controller.text.isNotEmpty
//         && reglement_controller.text.isNotEmpty
//         &&  _selectGenre.getSelected()?.getValue() != null
//     // && image_path.isNotEmpty
//     ){
//       var cour = <String, String>{
//         "nom_cour": nom_controller.text,
//         "description": description_controller.text,
//         "reglement": reglement_controller.text,
//         "genre": _selectGenre.getSelected()?.getValue(),
//         "image": image_path,
//
//       };
//
//       print(cour);
//       final response = await http.post(Uri.parse(
//           HOST+"/api/cours/"),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(cour),
//       );
//
//       if (response.statusCode == 200) {
//
//         //print("etb added");
//         print(response.body);
//         Navigator.pop(context,true);
//         initData();
//       } else {
//         //throw Exception('Failed to load data');
//         showAlertDialog(context, "Erreur ajout cour");
//       }
//     }else{
//       showAlertDialog(context, "Remplir tous les champs");
//     }
//
//   }
//
//
//   void fetchCour() async {
//     // setState(() {
//     //   loading = true;
//     // });
//     // print("loading ...");
//     final response = await http.get(Uri.parse(
//         HOST+'/api/cours/'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         });
//
//     if (response.statusCode == 200) {
//       final body = json.decode(response.body);
//       final List result = body["data"];
//       print("--result--");
//       print(result.length);
//       setState(() {
//         data = result.map<Cours>((e) => Cours.fromJson(e)).toList();
//         init_data = result.map<Cours>((e) => Cours.fromJson(e)).toList();
//       });
//       print("--data--");
//       print(data.length);
//     } else {
//       throw Exception('Failed to load data');
//     }
//
//     setState(() {
//       loading = false;
//     });
//   }
//
//   void search(String key){
//     if(key.length >= 1){
//       final List<Cours> founded = [];
//       init_data.forEach((e) {
//         if(e.nom_cour!.toLowerCase().contains(key.toLowerCase())
//             || e.description!.toLowerCase().contains(key.toLowerCase())
//             || e.reglement!.toLowerCase().contains(key.toLowerCase())
//             || e.genre!.toLowerCase().contains(key.toLowerCase())
//         )
//         {
//           founded.add(e);
//         }
//       });
//       setState(() {
//         data = founded;
//       });
//     }else {
//       setState(() {
//         data = init_data;
//       });
//     }
//
//   }
//
//   showAlertDialog(BuildContext context, String msg) {
//     Widget cancelButton = TextButton(
//       child: Text("OK"),
//       onPressed:  () {
//         Navigator.pop(context);
//       },
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("Abonnement"),
//       content: Text(msg),
//       actions: [
//         cancelButton,
//       ],
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//   void modal_add(context){
//
//     showDialog(context: context, builder: (context) =>
//         BsModal(
//             context: context,
//
//             dialog: BsModalDialog(
//               size: BsModalSize.lg,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               child: BsModalContent(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                 ),
//                 children: [
//                   BsModalContainer(
//                     //title:
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     actions: [
//                       Text('Ajouter un Cours',
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       BsButton(
//                         style: BsButtonStyle.outlinePrimary,
//                         label: Text('Annuler'),
//                         //prefixIcon: Icons.close,
//                         onPressed: () {
//
//                           Navigator.pop(context);
//                           initData();
//                         },
//                       )
//                     ],
//                     //closeButton: true,
//
//                   ),
//                   BsModalContainer(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                                 flex: 1,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     LabelText(
//                                         title: 'Nom du cours *'
//                                     ),
//                                     Container(
//                                         width: 900,
//                                         decoration: BoxDecoration(boxShadow: [
//                                         ]),
//                                         child: TextField(
//                                           autofocus: true,
//                                           controller: nom_controller,
//                                           decoration: new InputDecoration(
//                                             hintText: 'Saisir le nom du cours',
//                                           ),
//                                         )),
//                                   ],
//                                 )
//                             ),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     LabelText(
//                                         title: 'Description *'
//                                     ),
//                                     Container(
//                                         width: 900,
//                                         decoration: BoxDecoration(boxShadow: [
//                                         ]),
//                                         child: TextField(
//                                           controller: description_controller,
//                                           decoration: new InputDecoration(
//                                             hintText: 'Saisir une description',
//                                           ),
//                                         )),
//                                   ],
//                                 )
//                             )
//                           ],
//                         ),
//
//                         SizedBox(
//                           height: 30,
//                         ),
//
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                                 flex: 1,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     LabelText(
//                                         title: 'Réglement *'
//                                     ),
//                                     Container(
//                                         width: 900,
//                                         decoration: BoxDecoration(boxShadow: [
//                                         ]),
//                                         child: TextField(
//                                           controller: reglement_controller,
//                                           decoration: new InputDecoration(
//                                             hintText: 'Réglement interieur du cours',
//                                           ),
//                                         )),
//                                   ],
//                                 )
//                             ),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     LabelText(
//                                         title: 'Genre *'
//                                     ),
//                                     BsSelectBox(
//                                       hintText: 'Genre',
//                                       controller: _selectGenre,
//                                     ),
//                                   ],
//                                 )
//                             )
//                           ],
//                         ),
//
//                         SizedBox(
//                           height: 30,
//                         ),
//
//                         InkWell(
//                           onTap: () {
//                             cameraImage(context);
//                           },
//                           child: Container(
//                             width: 50,
//                             height: 30,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(6),
//                                 color: Colors.blue),
//                             child: Icon(Icons.camera_alt_outlined,
//                                 size: 25, color: Colors.white),
//                           ),
//                         ),
//                         SizedBox( height: 10),
//                         image_path.isNotEmpty ?
//                         SizedBox(
//                           width: 250, //
//                           height: 100,
//                           child: Image.network(
//                               HOST+"/media/"+image_path
//                           ),
//                         ) :Text("select image",textAlign: TextAlign.center,),
//                         SizedBox(height: 15,),
//                         InkWell(
//                           onTap: (){
//                             add(context);
//                           },
//                           child: Container(
//                             child:
//                             Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 13),)),
//                             height: 40,
//                             width: 120,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(6),
//                                 color: Colors.blue,
//                                 border: Border.all(
//                                     color: Colors.blueAccent
//                                 )
//                             ),
//                           ),
//                         ),
//                         LabelText(title: 'nb * champ obligatoire')
//                       ],
//                     ),
//                   ),
//
//                 ],
//               ),
//             )));
//   }
//
//   void modal_Update(context, Cours cour ,{bool? uploadImage=false}){
//
//     if(!uploadImage!){
//       nom_controller.text = cour.nom_cour.toString();
//       description_controller.text = cour.description!;
//       reglement_controller.text = cour.reglement!;
//
//       _selectGenre.setSelected(
//           BsSelectBoxOption(value: cour.genre, text: Text(cour.genre.toString()))
//       );
//
//       setState(() {
//         image_path = cour.image!;
//       });
//     }
//
//
//
//
//     showDialog(context: context, builder: (context) =>
//         BsModal(
//             context: context,
//
//             dialog: BsModalDialog(
//               size: BsModalSize.lg,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               child: BsModalContent(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                 ),
//                 children: [
//                   BsModalContainer(
//                     //title:
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     actions: [
//                       Text('Modifier Cours',
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       BsButton(
//                         style: BsButtonStyle.outlinePrimary,
//                         label: Text('Annuler'),
//                         //prefixIcon: Icons.close,
//                         onPressed: () {
//                           initData();
//                           Navigator.pop(context);
//                         },
//                       )
//                     ],
//                     //closeButton: true,
//
//                   ),
//                   BsModalContainer(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                                 flex: 1,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     LabelText(
//                                         title: 'Nom du cours *'
//                                     ),
//                                     SizedBox(height: 10,),
//                                     Container(
//                                         width: 900,
//                                         decoration: BoxDecoration(boxShadow: [
//                                         ]),
//                                         child: TextField(
//                                           controller: nom_controller,
//                                           decoration: new InputDecoration(
//                                             hintText: 'Saisir le nom du cours',
//                                           ),
//                                         )),
//                                   ],
//                                 )
//                             ),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     LabelText(
//                                         title: 'Description *'
//                                     ),
//                                     SizedBox(height: 10,),
//                                     Container(
//                                         width: 900,
//                                         decoration: BoxDecoration(boxShadow: [
//                                         ]),
//                                         child: TextField(
//                                           controller: description_controller,
//                                           decoration: new InputDecoration(
//                                             hintText: 'Saisir une description',
//                                           ),
//                                         )),
//                                   ],
//                                 )
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                                 flex: 1,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     LabelText(
//                                         title: 'Réglement *'
//                                     ),
//                                     SizedBox(height: 10,),
//                                     Container(
//                                         width: 900,
//                                         decoration: BoxDecoration(boxShadow: [
//                                         ]),
//                                         child: TextField(
//                                           controller: reglement_controller,
//                                           decoration: new InputDecoration(
//                                             hintText: 'Réglement interieur du cours',
//                                           ),
//                                         )),
//                                   ],
//                                 )
//                             ),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     LabelText(
//                                         title: 'Genre *'
//                                     ),
//                                     SizedBox(height: 10,),
//                                     BsSelectBox(
//                                       hintText: 'Genre',
//                                       controller: _selectGenre,
//                                     ),
//                                   ],
//                                 )
//                             )
//                           ],
//                         ),
//
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             InkWell(
//                               onTap: (){
//                                 update(context, cour.id_cour!);
//                               },
//                               child: Container(
//                                 child:
//                                 Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
//                                 height: 40,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(6),
//                                     color: Colors.blue,
//                                     border: Border.all(
//                                         color: Colors.blueAccent
//                                     )
//                                 ),
//                               ),
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     cameraImage(context ,cour: cour);
//                                   },
//                                   child: Container(
//                                     width: 50,
//                                     height: 30,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(6),
//                                         color: Colors.blue),
//                                     child: Icon(Icons.camera_alt_outlined,
//                                         size: 25, color: Colors.white),
//                                   ),
//                                 ),
//
//                                 SizedBox( height: 10),
//                                 image_path.isNotEmpty ?
//                                 SizedBox(
//                                   width: 250, //
//                                   height: 100,
//                                   child: Image.network(
//                                       HOST+"/media/"+image_path
//                                   ),
//                                 ) :Text("select image",textAlign: TextAlign.center,),
//                               ],
//                             )
//
//
//
//                           ],
//                         )
//                         ,
//                         LabelText(title: 'nb * champ obligatoire')
//                       ],
//                     ),
//                   ),
//
//                 ],
//               ),
//             )));
//   }
//   void update(context, int id) async {
//
//     if(nom_controller.text.length > 0 && description_controller.text.length > 0
//         && reglement_controller.text.length > 0 &&  _selectGenre.getSelected()?.getValue() != null
//     //&& image_path.isNotEmpty
//     ){
//       var cour = <String, dynamic>{
//         "id_cour": id,
//         "nom_cour": nom_controller.text,
//         "description": description_controller.text,
//         "reglement": reglement_controller.text,
//         "genre": _selectGenre.getSelected()?.getValue(),
//         "image": image_path,
//       };
//
//       print(cour);
//       final response = await http.put(Uri.parse(
//           HOST+"/api/cours/"),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(cour),
//       );
//
//       if (response.statusCode == 200) {
//
//         //print("etb added");
//         print(response.body);
//         Navigator.pop(context,true);
//         initData();
//
//       } else {
//         showAlertDialog(context,"Failed to update data");
//       }
//     }else{
//       showAlertDialog(context,"remplir tous les champs");
//     }
//
//   }
//   var token = "";
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     token = context.read<AdminProvider>().admin.token;
//     print("init state");
//
//     fetchCour();
//
//   }
//   void delete(id) async {
//     final response = await http.delete(Uri.parse(
//         HOST+'/api/cours/'+id),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         });
//
//     if (response.statusCode == 200) {
//       fetchCour();
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             color: Colors.grey[200]
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Row(
//             children: [
//               SideBarCoachs(postion: 6,msg:"Coach"),
//               SizedBox(width: 10,),
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                       child:Container(
//                                         height: 40,
//                                         decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(20),
//                                             color: Colors.grey[200],
//                                             border: Border.all(
//                                                 color: Colors.orange
//                                             )
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(3.0),
//                                           child: Row(
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               InkWell(
//                                                 child: Container(
//                                                   width: 33,
//                                                   height: 33,
//                                                   child: Icon(Icons.search, color: Colors.white,),
//                                                   decoration: BoxDecoration(
//                                                       shape: BoxShape.circle,
//                                                       color: Colors.orange
//
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(width: 5,),
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: SizedBox(
//                                                   child: TextFormField(
//                                                     onChanged: (val)=>{
//                                                       search(val)
//                                                     },
//                                                     decoration: InputDecoration(
//                                                         border: InputBorder.none,
//                                                         hintText: "Chercher"
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                   ),
//                                   SizedBox(width: 10,),
//                                   Container(
//                                     child: Icon(Icons.add_alert_outlined, size: 20,),
//                                     height: 40,
//                                     width: 40,
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.grey[200],
//                                         border: Border.all(
//                                             color: Colors.orange
//                                         )
//                                     ),
//                                   ),
//                                   SizedBox(width: 10,),
//
//                                   Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.rectangle,
//                                         image: DecorationImage(
//                                           fit: BoxFit.cover,
//                                           image: NetworkImage('https://cdn-icons-png.flaticon.com/512/219/219969.png'),
//                                         ),
//                                         borderRadius: BorderRadius.circular(20),
//                                         color: Colors.grey[200]
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 20,),
//                               screenSize.width > 520 ?
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text("Liste des Cours", style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.grey
//                                   )),
//                                   SizedBox(width: 10,),
//                                   Container(
//                                     width: 180,
//                                     child: BsSelectBox(
//                                       hintText: 'Filtrer',
//                                       controller: _selectFilter,
//                                       onChange: (v){
//                                         filterCours();
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(width: 10,),
//                                   // InkWell(
//                                   //   onTap: (){
//                                   //     /*Navigator.push(
//                                   //         context,
//                                   //         MaterialPageRoute(
//                                   //           builder: (context) => AddCourScreen(),
//                                   //         )).then((val)=>fetchCour()
//                                   //     );*/
//                                   //     modal_add(context);
//                                   //   },
//                                   //   child: Container(
//                                   //     height: 40,
//                                   //     decoration: BoxDecoration(
//                                   //         color: Colors.blue[200],
//                                   //         borderRadius: BorderRadius.circular(10)
//                                   //     ),
//                                   //     child: Padding(
//                                   //       padding: const EdgeInsets.all(8.0),
//                                   //       child: Center(
//                                   //         child: Text("Ajouter un Cours",
//                                   //
//                                   //             style: TextStyle(
//                                   //                 fontSize: 15
//                                   //             )),
//                                   //       ),
//                                   //     ),
//                                   //   ),
//                                   // )
//                                 ],
//                               ):
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(" Cours", style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.grey
//                                   )),
//                                   // InkWell(
//                                   //   onTap: (){
//                                   //     //
//                                   //     modal_add(context);
//                                   //   },
//                                   //   child: Container(
//                                   //     height: 40,
//                                   //     decoration: BoxDecoration(
//                                   //         color: Colors.blue[200],
//                                   //         borderRadius: BorderRadius.circular(10)
//                                   //     ),
//                                   //     child: Padding(
//                                   //       padding: const EdgeInsets.all(8.0),
//                                   //       child: Center(
//                                   //         child: Icon(
//                                   //             Icons.add,
//                                   //             size: 18,
//                                   //             color: Colors.white
//                                   //         ),
//                                   //       ),
//                                   //     ),
//                                   //   ),
//                                   // )
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Expanded(
//                                   flex: 1,
//                                   child: ListView(
//                                       children:[
//                                         DataTable(
//                                             dataRowHeight: DataRowHeight,
//                                             headingRowHeight: HeadingRowHeight,
//                                             columns: screenSize.width > 800 ?
//                                             <DataColumn>[
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     'Nom du cours',
//                                                     style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     'Description',
//                                                     style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     'Distiné pour',
//                                                     style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     '',
//                                                     style: TextStyle(fontStyle: FontStyle.italic),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ]:
//                                             <DataColumn>[
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     'Nom du cours',
//                                                     style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataColumn(
//                                                 label: Expanded(
//                                                   child: Text(
//                                                     '',
//                                                     style: TextStyle(fontStyle: FontStyle.italic),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                             rows:
//                                             data.map<DataRow>((e) => DataRow(
//
//                                               cells: screenSize.width > 800 ?
//                                               <DataCell>[
//                                                 DataCell(Row(
//                                                   children: [
//                                                     SizedBox(width: 10,),
//                                                     Container(
//                                                       width: 20,
//                                                       height: 20,
//                                                       decoration: BoxDecoration(
//                                                           shape: BoxShape.circle,
//                                                           color: Colors.grey[200],
//                                                           image: DecorationImage(
//                                                               fit: BoxFit.cover,
//                                                               image: NetworkImage('${HOST}/media/${e.image.toString()}')
//                                                           )
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 6,),
//                                                     Text(e.nom_cour.toString(), overflow: TextOverflow.ellipsis,)
//                                                   ],
//                                                 )),
//                                                 DataCell(Text(e.description.toString())),
//                                                 DataCell(Text(e.genre.toString())),
//                                                 DataCell(Row(
//                                                   children: [
//                                                     ShowButton(
//                                                         msg:"•Visualisation Les détails du Cours",
//                                                         onPressed: (){
//                                                           showDialog(context: context, builder: (context) =>
//                                                               BsModal(
//                                                                   context: context,
//                                                                   dialog: BsModalDialog(
//                                                                     size: BsModalSize.md,
//                                                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                                                     child: BsModalContent(
//                                                                       decoration: BoxDecoration(
//                                                                         color: Colors.white,
//                                                                       ),
//                                                                       children: [
//                                                                         BsModalContainer(
//                                                                           //title:
//                                                                           crossAxisAlignment: CrossAxisAlignment.center,
//                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                           actions: [
//                                                                             Row(
//                                                                               children: [
//                                                                                 e.genre == "Femme" ?
//                                                                                 Icon(Icons.woman, size: 22, color: Colors.pink,) :
//                                                                                 e.genre == "Homme" ?
//                                                                                 Icon(Icons.man, size: 22, color: Colors.blueAccent,):
//                                                                                 Row(
//                                                                                   children: [
//                                                                                     Icon(Icons.woman, size: 22, color: Colors.pink,),
//                                                                                     SizedBox(width: 5,),
//                                                                                     Icon(Icons.man, size: 22, color: Colors.blueAccent,)
//                                                                                   ],
//                                                                                 ),
//                                                                                 SizedBox(width: 9,),
//                                                                                 Text('${e.nom_cour.toString()}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))                                                                              ],
//                                                                             ),
//                                                                             /*Text('${e.nom_cour.toString()}',
//                                                                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),*/
//                                                                             BsButton(
//                                                                               style: BsButtonStyle.outlinePrimary,
//                                                                               label: Text('Fermer'),
//                                                                               //prefixIcon: Icons.close,
//                                                                               onPressed: () {
//                                                                                 Navigator.pop(context);
//                                                                                 initData();
//                                                                               },
//                                                                             )
//                                                                           ],
//                                                                           //closeButton: true,
//
//                                                                         ),
//
//                                                                         BsModalContainer(
//                                                                           child: Row(
//                                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                                               children: [
//                                                                                 Container(
//                                                                                   width: 170,
//                                                                                   height: 120,
//                                                                                   decoration: BoxDecoration(
//                                                                                       borderRadius: BorderRadius.circular(8),
//                                                                                       border: Border.all(color: Colors.grey),
//                                                                                       color: Colors.grey[200],
//                                                                                       image: DecorationImage(
//                                                                                           fit: BoxFit.cover,
//                                                                                           image: NetworkImage('${HOST}/media/${e.image.toString()}')
//                                                                                       )
//                                                                                   ),
//                                                                                 ),
//                                                                                 SizedBox(width: 8,),
//                                                                                 Expanded(
//                                                                                     child: Column(
//                                                                                       mainAxisAlignment: MainAxisAlignment.start,
//                                                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                       children: [
//                                                                                         /*Row(
//                                                                                           children: [
//                                                                                             Text("Nom: " ,style: TextStyle(
//                                                                                                 fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                             ),),
//                                                                                             SizedBox(width: 9,),
//                                                                                             Text(" ${e.nom_cour.toString()}"),
//                                                                                           ],
//                                                                                         ),*/
//                                                                                         Column(
//                                                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                           children: [
//                                                                                             Text("Description: " ,style: TextStyle(
//                                                                                                 fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                             ),),
//                                                                                             SizedBox(height: 3,),
//                                                                                             Row(
//                                                                                               mainAxisAlignment: MainAxisAlignment.start,
//                                                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                               children: [
//                                                                                                 Expanded(child: Text("${e.description.toString()}")),
//                                                                                               ],
//                                                                                             )
//
//                                                                                           ],
//                                                                                         ),
//                                                                                         SizedBox(height: 4,),
//                                                                                         Column(
//                                                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                           children: [
//                                                                                             Text("Réglement intérieur du cour: " ,style: TextStyle(
//                                                                                                 fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                             ),),
//                                                                                             SizedBox(height: 3,),
//                                                                                             Row(
//                                                                                               mainAxisAlignment: MainAxisAlignment.start,
//                                                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                               children: [
//                                                                                                 Expanded(child: Text("${e.reglement.toString()}")),
//                                                                                               ],
//                                                                                             )
//
//                                                                                           ],
//                                                                                         ),
//                                                                                         SizedBox(height: 4,),
//                                                                                         Column(
//                                                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                           children: [
//                                                                                             Text("Genre: " ,style: TextStyle(
//                                                                                                 fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                             ),),
//                                                                                             SizedBox(height: 3,),
//                                                                                             Text("${e.genre.toString()}"),
//                                                                                           ],
//                                                                                         ),
//                                                                                       ],
//                                                                                     )
//                                                                                 )
//                                                                               ]
//                                                                           ),
//                                                                         ),
//                                                                         BsModalContainer(
//                                                                           crossAxisAlignment: CrossAxisAlignment.end,
//                                                                           actions: [
//                                                                             //Navigator.pop(context);
//                                                                           ],
//                                                                         )
//                                                                       ],
//                                                                     ),
//                                                                   )));
//                                                         }
//                                                     ),
//                                                     SizedBox(width: 10,),
//                                                     // EditerButton(
//                                                     //     msg: "Mettre à jour les informations du Cours",
//                                                     //     onPressed: (){
//                                                     //       modal_Update(context, e);
//                                                     //     }
//                                                     // ),
//                                                     // SizedBox(width: 10,),
//                                                     // DeleteButton(
//                                                     //   msg:"Supprimer le Cours ",
//                                                     //   onPressed: () async {
//                                                     //     if (await confirm(
//                                                     //       context,
//                                                     //       title: const Text('Confirmation'),
//                                                     //       content: const Text('Souhaitez-vous supprimer ?'),
//                                                     //       textOK: const Text('Oui'),
//                                                     //       textCancel: const Text('Non'),
//                                                     //     )) {
//                                                     //
//                                                     //       delete(e.id_cour.toString());
//                                                     //     }
//                                                     //
//                                                     //   },
//                                                     // ),
//                                                   ],
//                                                 )),
//                                               ]:
//                                               <DataCell>[
//                                                 DataCell(Row(
//                                                   children: [
//                                                     SizedBox(width: 10,),
//                                                     Container(
//                                                       width: 20,
//                                                       height: 20,
//                                                       decoration: BoxDecoration(
//                                                           shape: BoxShape.circle,
//                                                           color: Colors.grey[200],
//                                                           image: DecorationImage(
//                                                               fit: BoxFit.cover,
//                                                               image: NetworkImage('${HOST}/media/${e.image.toString()}')
//                                                           )
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 6,),
//                                                     Expanded(
//                                                       child: Text(e.nom_cour.toString(),
//                                                         overflow: TextOverflow.ellipsis,),
//                                                     )
//                                                   ],
//                                                 )),
//                                                 DataCell(Row(
//                                                   children: [
//                                                     ShowButton(
//                                                         msg:"•Visualisation Les détails du Cours",
//                                                         onPressed: (){
//                                                           showDialog(context: context, builder: (context) =>
//                                                               BsModal(
//                                                                   context: context,
//                                                                   dialog: BsModalDialog(
//                                                                     size: BsModalSize.md,
//                                                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                                                     child: BsModalContent(
//                                                                       decoration: BoxDecoration(
//                                                                         color: Colors.white,
//                                                                       ),
//                                                                       children: [
//                                                                         BsModalContainer(
//                                                                           //title:
//                                                                           crossAxisAlignment: CrossAxisAlignment.center,
//                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                           actions: [
//                                                                             /*children: [
//                                                                               e.statut == true ?
//                                                                               Icon(Icons.check_circle_outline, size: 22, color: Colors.green,) :
//                                                                               Icon(Icons.close_rounded, size: 22, color: Colors.red,),
//                                                                               SizedBox(width: 9,),
//                                                                               Container(
//                                                                                 width: 20,
//                                                                                 height: 20,
//                                                                                 decoration: BoxDecoration(
//                                                                                     shape: BoxShape.circle,
//                                                                                     color: Colors.grey[200],
//                                                                                     image: DecorationImage(
//                                                                                         fit: BoxFit.cover,
//                                                                                         image: NetworkImage('${HOST}/media/${e.image.toString()}')
//                                                                                     )
//                                                                                 ),
//                                                                               ),
//                                                                               SizedBox(width: 6,),
//                                                                               Text(e.nom_client.toString())
//                                                                             ],*/
//                                                                             Row(
//                                                                               children: [
//                                                                                 e.genre == "Femme" ?
//                                                                                 Icon(Icons.woman, size: 22, color: Colors.pink,) :
//                                                                                 e.genre == "Homme" ?
//                                                                                 Icon(Icons.man, size: 22, color: Colors.blueAccent,):
//                                                                                 Row(
//                                                                                   children: [
//                                                                                     Icon(Icons.woman, size: 22, color: Colors.pink,),
//                                                                                     SizedBox(width: 5,),
//                                                                                     Icon(Icons.man, size: 22, color: Colors.blueAccent,)
//                                                                                   ],
//                                                                                 ),
//                                                                                 SizedBox(width: 9,),
//                                                                                 Text('${e.nom_cour.toString()}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))                                                                              ],
//                                                                             ),
//                                                                             BsButton(
//                                                                               style: BsButtonStyle.outlinePrimary,
//                                                                               label: Text('Fermer'),
//                                                                               //prefixIcon: Icons.close,
//                                                                               onPressed: () {
//
//                                                                                 Navigator.pop(context);
//                                                                                 initData();
//                                                                               },
//                                                                             )
//                                                                           ],
//                                                                           //closeButton: true,
//
//                                                                         ),
//                                                                         //BsModalContainer(title: Text('${e.nom_cour.toString()}'), closeButton: true),
//                                                                         BsModalContainer(
//                                                                           child: Row(
//                                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                                               children: [
//                                                                                 Container(
//                                                                                   width: 170,
//                                                                                   height: 120,
//                                                                                   decoration: BoxDecoration(
//                                                                                       borderRadius: BorderRadius.circular(8),
//                                                                                       border: Border.all(color: Colors.grey),
//                                                                                       color: Colors.grey[200],
//                                                                                       image: DecorationImage(
//                                                                                           fit: BoxFit.cover,
//                                                                                           image: NetworkImage('${HOST}/media/${e.image.toString()}')
//                                                                                       )
//                                                                                   ),
//                                                                                 ),
//                                                                                 SizedBox(width: 8,),
//                                                                                 Expanded(
//                                                                                     child: Column(
//                                                                                       mainAxisAlignment: MainAxisAlignment.start,
//                                                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                       children: [
//                                                                                         Column(
//                                                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                           children: [
//                                                                                             Text("Nom: " ,style: TextStyle(
//                                                                                                 fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                             ),),
//                                                                                             SizedBox(height: 4,),
//                                                                                             Text(" ${e.nom_cour.toString()}"),
//                                                                                           ],
//                                                                                         ),
//                                                                                         SizedBox(height: 4,),
//                                                                                         Column(
//                                                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                           children: [
//                                                                                             Text("Description: " ,style: TextStyle(
//                                                                                                 fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                             ),),
//                                                                                             SizedBox(height: 4,),
//                                                                                             Text("${e.description.toString()}"),
//                                                                                           ],
//                                                                                         ),
//                                                                                         SizedBox(height: 4,),
//                                                                                         Column(
//                                                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                           children: [
//                                                                                             Text("Réglement intérieur du cours: " ,style: TextStyle(
//                                                                                                 fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                             ),),
//                                                                                             SizedBox(height: 4,),
//                                                                                             Text("${e.reglement.toString()}"),
//                                                                                           ],
//                                                                                         ),
//                                                                                         SizedBox(height: 4,),
//                                                                                         Column(
//                                                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                           children: [
//                                                                                             Text("Genre: " ,style: TextStyle(
//                                                                                                 fontWeight: FontWeight.bold, color:Colors.grey
//                                                                                             ),),
//                                                                                             SizedBox(height: 4,),
//                                                                                             Text("${e.genre.toString()}"),
//                                                                                           ],
//                                                                                         ),
//                                                                                       ],
//                                                                                     )
//                                                                                 )
//                                                                               ]
//                                                                           ),
//                                                                         ),
//                                                                         BsModalContainer(
//                                                                           crossAxisAlignment: CrossAxisAlignment.end,
//                                                                           actions: [
//                                                                             //Navigator.pop(context);
//                                                                           ],
//                                                                         )
//                                                                       ],
//                                                                     ),
//                                                                   )));
//                                                         }
//                                                     ),
//                                                     SizedBox(width: 5,),
//                                                     // EditerButton(
//                                                     //     msg: "Mettre à jour les informations du Cours",
//                                                     //     onPressed: (){
//                                                     //       modal_Update(context, e);
//                                                     //     }
//                                                     // ),
//                                                     // SizedBox(width: 5,),
//                                                     // DeleteButton(
//                                                     //   msg:"Supprimer le Cours ",
//                                                     //   onPressed: () async {
//                                                     //     if (await confirm(
//                                                     //       context,
//                                                     //       title: const Text('Confirmation'),
//                                                     //       content: const Text('Souhaitez-vous supprimer ?'),
//                                                     //       textOK: const Text('Oui'),
//                                                     //       textCancel: const Text('Non'),
//                                                     //     )) {
//                                                     //
//                                                     //       delete(e.id_cour.toString());
//                                                     //     }
//                                                     //
//                                                     //   },
//                                                     // ),
//                                                   ],
//                                                 )),
//                                               ],
//                                             )).toList()
//                                         ),]
//                                   )
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }
//
