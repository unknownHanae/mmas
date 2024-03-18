import 'package:adminmmas/componnents/showButton.dart';
import 'package:adminmmas/constants.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../models/EtablissementModels.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';
import 'dart:html' as html;

import 'package:http_parser/http_parser.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'AddEtablissements.dart';
import 'UpdateEtablissement.dart';

class EtablissementScreen extends StatefulWidget {
  const EtablissementScreen({Key? key}) : super(key: key);

  @override
  State<EtablissementScreen> createState() => _EtablissementState();
}

class _EtablissementState extends State<EtablissementScreen> {

  List<Etablissement> data = [];
  List<Etablissement> init_data = [];
  bool loading = false;

  /*String nom_etablissement = "";
  String adresse_etablissement = "";
  String teletablissement = "";
  String sitewebetablissement = "";
  String mailetablissement = "";
  String description = "";
  String ville = "";*/

  TextEditingController nom_controller = TextEditingController();
  TextEditingController adresse_controller = TextEditingController();
  TextEditingController tel_controller = TextEditingController();
  TextEditingController siteweb_controller = TextEditingController();
  TextEditingController mail_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  TextEditingController ville_controller = TextEditingController();
  TextEditingController facebook_controller = TextEditingController();
  TextEditingController watsapp_controller = TextEditingController();
  TextEditingController instagrame_controller = TextEditingController();

  String image_path = "";

  Uint8List? _bytesData;
  List<int>? _selectedFile;

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";
  Future cameraImage(context) async {
    try{
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.multiple = true;
      uploadInput.draggable = true;
      uploadInput.click();


      uploadInput.onChange.listen((event) {
        final files = uploadInput.files;
        final file = files![0];
        final reader = html.FileReader();

        reader.onLoadEnd.listen((event) async {
          _bytesData = Base64Decoder().convert(reader.result
              .toString()
              .split(",")
              .last);
          _selectedFile = _bytesData;
          var url = Uri.parse(HOST+"/api/saveImage/");
          var request = http.MultipartRequest("POST", url);
          request.files.add(await http.MultipartFile.fromBytes('uploadedFile', _selectedFile!,
              contentType: MediaType("application","json"), filename: "image-etab"));
          request.fields["path"] = "etablissements/";

          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          final body = Map<String, dynamic>.from(json.decode(responseString));
          print(responseString);

          if(response.statusCode == 200){
            setState(() {
              image_path = body['path'];
            });
            Navigator.pop(context);
            modal_add(context);
          }else{
            final snackBar = SnackBar(
              content: const Text('Please try again'),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });
        reader.readAsDataUrl(file);
      });




    }catch(error){
      print(error);
    }

  }
  void fetchEtabs() async {
    // setState(() {
    //   loading = true;
    // });
    // print("loading ...");
    final response = await http.get(Uri.parse(
        HOST+'/api/etablissements/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      print("--result--");
      print(result.length);
      setState(() {
        data = result.map<Etablissement>((e) => Etablissement.fromJson(e)).toList();
        init_data = result.map<Etablissement>((e) => Etablissement.fromJson(e)).toList();
      });
      print("--data--");
      print(data.length);
    } else {
      throw Exception('Failed to load data');
    }

    setState(() {
      loading = false;
    });
  }

  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/etablissements/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchEtabs();
    } else {
      throw Exception('Failed to load data');
    }
  }

  void search(String key){
    if(key.length >= 1){
      final List<Etablissement> founded = [];
      init_data.forEach((e) {
        if(e.nom_etablissement!.toLowerCase().contains(key.toLowerCase())
            || e.ville!.toLowerCase().contains(key.toLowerCase())
            || e.teletablissement!.toLowerCase().contains(key.toLowerCase())
            || e.mailetablissement!.toLowerCase().contains(key.toLowerCase())
            || e.sitewebetablissement!.toLowerCase().contains(key.toLowerCase())
           )
        {
          founded.add(e);
        }
      });
      setState(() {
        data = founded;
      });
    }else {
      setState(() {
        data = init_data;
      });
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
      title: Text("Etablissements"),
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

  void add(context) async {

    if(adresse_controller.text.isNotEmpty
        && mail_controller.text.isNotEmpty
        && nom_controller.text.isNotEmpty
        && tel_controller.text.isNotEmpty
        && ville_controller.text.isNotEmpty
    ){


      final bool emailValid =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(mail_controller.text);

      final bool phoneValid =
      RegExp(r"^(?:[+0]9)?[0-9]{10}$")
          .hasMatch(tel_controller.text);

      if(!emailValid){
        showAlertDialog(context, "Email n'est pas valide");
        return;
      }

      if(!phoneValid){
        showAlertDialog(context, "Telphone n'est pas valide");
        return;
      }

      var etablissement = <String, String>{
        "adresse_etablissement": adresse_controller.text,
        "description": description_controller.text,
        "watsapp": watsapp_controller.text,
        "instagrame": instagrame_controller.text,
        "facebook": facebook_controller.text,
        "image": image_path,
        "mailetablissement": mail_controller.text,
        "nom_etablissement": nom_controller.text,
        "sitewebetablissement": siteweb_controller.text,
        "teletablissement": tel_controller.text,
        "ville": ville_controller.text
      };

      print(etablissement);
      final response = await http.post(Uri.parse(
          HOST+"/api/etablissements/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode(etablissement),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          nom_controller.text = "";
          adresse_controller.text = "";
          tel_controller.text = "";
          siteweb_controller.text = "";
          mail_controller.text = "";
          description_controller.text = "";
          ville_controller.text = "";
          watsapp_controller.text = "";
          facebook_controller.text = "";
          instagrame_controller.text = "";

          setState(() {
            image_path = "";
          });
          fetchEtabs();


        }else{
          showAlertDialog(context, body["msg"]);
        }
      } else {
        showAlertDialog(context, "Erreur ajout etablissements");
        //throw Exception('Failed to load data');
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }


  void modal_add(context){
    showDialog(context: context, builder: (context) =>
        BsModal(
            context: context,

            dialog: BsModalDialog(
              size: BsModalSize.lg,
              crossAxisAlignment: CrossAxisAlignment.center,
              child: BsModalContent(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  BsModalContainer(title: Text('Ajouter Etablissement'), closeButton: true),
                  BsModalContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelText(
                                      title: 'Nom etablissement *'
                                  ),
                                  Container(
                                      decoration: BoxDecoration(boxShadow: [
                                      ]),
                                      child: SizedBox(height: 30,
                                        child: TextField(
                                          autofocus: true,
                                          controller:  nom_controller,
                                          decoration: new InputDecoration(
                                            hintText: 'Nom etablissement ',

                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  LabelText(
                                      title: 'Adresse etablissement *'
                                  ),
                                  Container(
                                      width: 900,
                                      decoration: BoxDecoration(boxShadow: [

                                      ]),

                                      child: SizedBox(height: 30,
                                        child: TextField(
                                          controller: adresse_controller,
                                          decoration: new InputDecoration(
                                            hintText: 'Adresse etablissement ',

                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  LabelText(
                                      title: 'Tel Etablissement  *'
                                  ),
                                  Container(
                                      width: 900,
                                      decoration: BoxDecoration(boxShadow: [

                                      ]),
                                      child: SizedBox(height: 30,
                                        child: TextField(
                                        controller: tel_controller,
                                          decoration: new InputDecoration(
                                            hintText: 'Tel Etablissement ',

                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  LabelText(
                                      title: 'Ville  *'
                                  ),
                                  Container(
                                      width: 900,
                                      decoration: BoxDecoration(boxShadow: [

                                      ]),
                                      child: SizedBox(height: 30,
                                        child: TextField(
                                          controller: ville_controller,
                                          decoration: new InputDecoration(
                                            hintText: 'Ville ',
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  LabelText(
                                      title: 'nb: * designe champ obligatoire '
                                  ),
                                ],
                              )
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Mail Etablissement *'
                                    ),
                                    Container(
                                        width: 900,
                                        decoration: BoxDecoration(boxShadow: [

                                        ]),
                                        child: SizedBox(height: 30,
                                          child: TextField(
                                            controller: mail_controller,
                                            decoration: new InputDecoration(
                                              hintText: 'Mail Etablissement ',

                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    LabelText(
                                        title: 'Site Web Etablissement *'
                                    ),
                                    Container(
                                        width: 900,
                                        decoration: BoxDecoration(boxShadow: [

                                        ]),
                                        child: SizedBox(height: 30,
                                          child: TextField(
                                           controller: siteweb_controller,
                                            decoration: new InputDecoration(
                                              hintText: 'Site Web Etablissement',

                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    LabelText(
                                        title: 'facebook'
                                    ),
                                    Container(
                                        width: 900,
                                        decoration: BoxDecoration(boxShadow: [

                                        ]),
                                        child: SizedBox(height: 30,
                                          child: TextField(
                                            controller: facebook_controller,
                                            decoration: new InputDecoration(
                                              hintText: 'facebook ',
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    LabelText(
                                        title: 'Instagrame'
                                    ),
                                    Container(
                                        width: 900,
                                        decoration: BoxDecoration(boxShadow: [

                                        ]),
                                        child: SizedBox(height: 30,
                                          child: TextField(
                                            controller: instagrame_controller,
                                            decoration: new InputDecoration(
                                              hintText: 'Instagrame ',
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    LabelText(
                                        title: 'watsapp'
                                    ),
                                    Container(
                                        width: 900,
                                        decoration: BoxDecoration(boxShadow: [

                                        ]),
                                        child: SizedBox(height: 30,
                                          child: TextField(
                                            controller: watsapp_controller,
                                            decoration: new InputDecoration(
                                              hintText: 'watsapp ',
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    LabelText(
                                        title: 'Description '
                                    ),
                                    Container(
                                        width: 900,
                                        decoration: BoxDecoration(boxShadow: [

                                        ]),
                                        child: SizedBox(height: 30,
                                          child: TextField(
                                            controller: description_controller,
                                            decoration: new InputDecoration(
                                              hintText: 'Description',
                                            ),
                                            maxLines: 5,
                                            minLines: 1,
                                          ),
                                        )),
                                    SizedBox(
                                      height: 30,
                                    ),

                                    InkWell(
                                      onTap: (){
                                        cameraImage(context);
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            color: Colors.blue
                                        ),
                                        child: Icon(Icons.camera_alt_outlined, size: 25, color: Colors.white),
                                      ),
                                    ),

                                    image_path.isNotEmpty ?
                                    SizedBox(
                                      width: 300, //
                                      height: 150,
                                      child: Image.network(
                                          HOST+"/media/"+image_path
                                      ),
                                    ):Text("select image",textAlign: TextAlign.center,),
                                    SizedBox( height: 10),
                                  ],
                                )

                            ),

                          ],
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            add(context);
                          },
                          child: Container(
                            child:
                            Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 18),)),
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.blue,
                                border: Border.all(
                                    color: Colors.blueAccent
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            )));
  }

 var token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = context.read<AdminProvider>().admin.token;
    print("init state");
    fetchEtabs();

  }


  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200]
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            //  SideBar(postion: 22,msg:"Etablissement"),
              SizedBox(width: 10,),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Center(child: Text("Etablissement", style: TextStyle(
                                      fontSize: 18,
                                     // fontWeight: FontWeight.bold,
                                      color: Colors.black)),)),

                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex:4,
                                      child:Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.grey[200],
                                            border: Border.all(
                                                color: Colors.blue
                                            )
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  width: 33,
                                                  height: 33,
                                                  child: Icon(Icons.search, color: Colors.white,),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.blueAccent
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  child: TextFormField(
                                                    onChanged: (val)=>{
                                                      search(val)
                                                    },
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Chercher"
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(width: 10,),

                                  Container(
                                    width: 700,
                                    height: 40,
                                  )
                                ],
                              ),
                              SizedBox(height: 20,),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     Text("Etablissements", style: TextStyle(
                              //       fontSize: 18,
                              //       fontWeight: FontWeight.w700,
                              //       color: Colors.grey
                              //     )),
                              //     InkWell(
                              //       onTap: (){
                              //         //
                              //         modal_add(context);
                              //       },
                              //       child: Container(
                              //         height: 40,
                              //         decoration: BoxDecoration(
                              //           color: Colors.blue[200],
                              //           borderRadius: BorderRadius.circular(10)
                              //         ),
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Center(
                              //             child: Text("Modifier Etablissement",
                              //                 style: TextStyle(
                              //               fontSize: 15
                              //             )),
                              //           ),
                              //         ),
                              //       ),
                              //     )
                              //   ],
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                flex: 1,
                                  child: ListView(
                                    children:[
                                      data.length == 0 ?
                                      Padding(
                                        padding: const EdgeInsets.all(150.0),
                                        child: Center(
                                            child: Text("aucun établissement à afficher")),
                                      )
                                          :
                                      DataTable(
                                          dataRowHeight: DataRowHeight,
                                      headingRowHeight: HeadingRowHeight,
                                          columnSpacing: 10,
                                      columns: const <DataColumn>[
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              ' Etablissement',
                                              style: TextStyle( fontWeight: FontWeight.bold,),//fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Ville',
                                              style: TextStyle(fontWeight: FontWeight.bold,),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Tel',
                                              style: TextStyle(fontWeight: FontWeight.bold,),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Mail',
                                              style: TextStyle(fontWeight: FontWeight.bold,),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Site Web',
                                              style: TextStyle(fontWeight: FontWeight.bold,),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Nombre des étudiants',
                                              style: TextStyle(fontWeight: FontWeight.bold,),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              '',
                                              style: TextStyle(),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows:
                                        data.map<DataRow>((e) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(Row(
                                              children: [
                                                Container(
                                                  width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey[200],
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                          image: NetworkImage('${HOST}/media/${e.image.toString()}')
                                                      )
                                                    ),
                                                ),
                                                SizedBox(width: 6,),
                                                Text(e.nom_etablissement.toString())
                                              ],
                                            )),
                                            DataCell(Text(e.ville.toString())),
                                            DataCell(Text(e.teletablissement.toString())),
                                            DataCell(Text(e.mailetablissement.toString())),
                                            DataCell(Text(e.sitewebetablissement.toString())),
                                            DataCell(Container(
                                                child: Text(e.nb_clients.toString())
                                            )),
                                            DataCell(Row(
                                              children: [
                                                ShowButton(
                                                    msg:"•Visualisation Les détails du client",
                                                  onPressed: (){
                                                    showDialog(context: context, builder: (context) =>
                                                      BsModal(
                                                        context: context,
                                                        dialog: BsModalDialog(
                                                          size: BsModalSize.xxl,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          child: BsModalContent(
                                                                decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                            ),
                                                            children: [
                                                              BsModalContainer(title: Text('${e.nom_etablissement.toString()}'), closeButton: true),
                                                              BsModalContainer(
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    width: 170,
                                                                    height: 120,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        border: Border.all(color: Colors.grey),
                                                                        color: Colors.grey[200],
                                                                        image: DecorationImage(
                                                                            fit: BoxFit.cover,
                                                                            image: NetworkImage('${HOST}/media/${e.image.toString()}')
                                                                        )
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 8,),
                                                                  Expanded(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text("Nom:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                                                              SizedBox(width: 9,),
                                                                              Text("${e.nom_etablissement.toString()}"),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 4,),
                                                                          Row(
                                                                            children: [
                                                                              Text("Ville:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                                                              SizedBox(width: 9,),
                                                                              Text("${e.ville.toString()}"),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 4,),
                                                                          Row(
                                                                            children: [
                                                                              Text("Tel:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                                                              SizedBox(width: 9,),
                                                                              Text("${e.teletablissement.toString()}"),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 4,),
                                                                          Row(
                                                                            children: [
                                                                              Text("Mail:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                                                              SizedBox(width: 9,),
                                                                              InkWell(
                                                                                  child: Text("${e.mailetablissement.toString()}"),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 4,),
                                                                          Row(
                                                                            children: [
                                                                              Text("Site WEB:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                                                              SizedBox(width: 9,),
                                                                              InkWell(
                                                                                  child: Text("${e.sitewebetablissement.toString()}",style: TextStyle( color:Colors.blue),),
                                                                                onTap: () => launch('${e.sitewebetablissement.toString()}'),)

                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 4,),
                                                                          Row(
                                                                            children: [
                                                                              Text("Facebook:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                                                              SizedBox(width: 9,),
                                                                              InkWell(
                                                                                  child: Text("${e.facebook.toString()}",style: TextStyle( color:Colors.blue),),
                                                                                onTap: () => launch('${e.facebook.toString()}'),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 4,),
                                                                          Row(
                                                                            children: [
                                                                              Text("Instagrame:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                                                              SizedBox(width: 9,),
                                                                              InkWell(
                                                                                  child: Text("${e.instagrame.toString()}",style: TextStyle( color:Colors.blue),),
                                                                                onTap: () => launch('${e.instagrame.toString()}'),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 4,),
                                                                          Row(
                                                                            children: [
                                                                              Text("watsapp:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                                                              SizedBox(width: 9,),
                                                                              Text("${e.watsapp.toString()}"),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 4,),
                                                                          Row(
                                                                            children: [
                                                                              Text("Description:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                                                              SizedBox(width: 9,),
                                                                              Text("${e.description.toString()}"),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 4,),
                                                                          Row(
                                                                            children: [
                                                                              Text("totale des étudiants par établissement:",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey)),
                                                                              SizedBox(width: 9,),
                                                                              Text("${e.nb_clients.toString()}"),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 4,),
                                                                        ],
                                                                      )
                                                                  )
                                                                ]
                                                                ),
                                                              ),
                                                              BsModalContainer(
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                actions: [
                                                                  //Navigator.pop(context);
                                                                ],
                                                              )
                                                            ],
                                                        ),
                                                    )));
                                                  }
                                                ),
                                                SizedBox(width: 10,),
                                                EditerButton(
                                                  msg: "mettre à jour les informations",
                                                  onPressed: (){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => UpdateEtablissementScreen(etab: e,),
                                                        )).then((val)=>fetchEtabs()
                                                    );
                                                  },
                                                ),
                                              ],
                                            ))
                                          ],
                                        )).toList()
                                    ),]
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

