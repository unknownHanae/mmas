import 'dart:convert';

import 'package:adminmmas/constants.dart';
import 'package:adminmmas/models/ClasseModel.dart';
import 'package:adminmmas/models/CoursModels.dart';
import 'package:adminmmas/models/NiveauModel.dart';
import 'package:adminmmas/views/AddCour.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../componnents/deleteButton.dart';
import '../componnents/editerButton.dart';
import '../componnents/label.dart';
import '../componnents/showButton.dart';
import '../providers/admin_provider.dart';
import '../widgets/navigation_bar.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'UpdateCours.dart';

class CoursScreen extends StatefulWidget {
  const CoursScreen({Key? key}) : super(key: key);

  @override
  State<CoursScreen> createState() => _CoursState();
}

class _CoursState extends State<CoursScreen> {


  List<Cours> data = [];
  List<Cours> init_data = [];
  bool loading = false;

  //final TextEditingController input_search = TextEditingController();
  String text_search = "";

  String nom_cour = "";
  String description = "";
  String reglement = "";

  List<Niveau> niveaux = [];
  List<Niveau> niveaux1 = [];
  List<Classes> classes = [];

  Uint8List? _bytesData;
  List<int>? _selectedFile;


  TextEditingController nom_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  TextEditingController reglement_controller = TextEditingController();
  TextEditingController code_couleur_controller = TextEditingController();

  String image_path = "";

  BsSelectBoxController _selectNiveau = BsSelectBoxController();

  BsSelectBoxController _selectClasses = BsSelectBoxController();

  late Color screenPickerColor;

  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
  <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

    // void filterCours(){
  //   if(_selectFilter.getSelected()?.getValue() != null){
  //     print(_selectFilter.getSelected()?.getValue());
  //     setState(() {
  //       data = [];
  //     });
  //     if(_selectFilter.getSelected()?.getValue() == 3){
  //       setState(() {
  //         data = init_data;
  //       });
  //
  //     }
  //     if(_selectFilter.getSelected()?.getValue() == 0){
  //       setState(() {
  //         data = init_data.where((element) => (element.genre!.toString()) == "Homme").toList();
  //       });
  //
  //     }
  //
  //     if(_selectFilter.getSelected()?.getValue() == 1){
  //       setState(() {
  //         data = init_data.where((element) => (element.genre!.toString()) == "Femme").toList();
  //       });
  //
  //     }
  //     if(_selectFilter.getSelected()?.getValue() == 2){
  //       setState(() {
  //         data = init_data.where((element) => (element.genre!.toString()) == "Mixte").toList();
  //       });
  //
  //     }
  //   }
  // }



  void initData() {
    nom_controller.text = "";
    description_controller.text = "";
    reglement_controller.text = "";
    _selectNiveau.removeSelected(_selectNiveau.getSelected()!);
    _selectClasses.clear();

    setState(() {
      image_path = "";
    });

    if(_selectClasses.getSelected()!= null){
      _selectClasses.removeSelected(_selectClasses.getSelected()!);
    }
    fetchCour();
    initSelectClasses();
  }



  Future cameraImage(context, {Cours? cour}) async {

    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,

          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
            WebUiSettings(
              context: context,
              presentStyle: CropperPresentStyle.dialog,
              boundary: const CroppieBoundary(
                width: 350,
                height: 350,
              ),
              viewPort:
              const CroppieViewPort(width: 280, height: 280, type: 'rectangle'),
              enableExif: true,
              enableZoom: true,
              showZoomer: true,

            ),
          ],
        );
        print(pickedFile.path);


        if (croppedFile != null) {
          // Now, you can upload the cropped image and perform other actions as needed.
          final bytesData = await croppedFile.readAsBytes();
          final _selectedFile = Uint8List.fromList(bytesData);

          var url = Uri.parse(HOST+"/api/saveImage/");
          var request = http.MultipartRequest("POST", url);
          request.files.add(await http.MultipartFile.fromBytes('uploadedFile', _selectedFile!,
              contentType: MediaType("application","json"), filename: "image-cour"));
          request.fields["path"] = "cours/";

          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          final body = Map<String, dynamic>.from(json.decode(responseString));
          print(responseString);

          if(response.statusCode == 200){
            setState(() {
              image_path = body['path'];
            });
            if(cour != null){
              Navigator.pop(context);
              modal_Update(context, cour, uploadImage: true);
            }else{
              Navigator.pop(context);
              modal_add(context);
            }
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
        }
      }
    } catch (error) {
      print(error);
    }

  }

  // Future cameraImage(context, {Cours? cour}) async {
  //   try{
  //     html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  //     uploadInput.multiple = true;
  //     uploadInput.draggable = true;
  //     uploadInput.click();
  //
  //
  //     uploadInput.onChange.listen((event) {
  //       final files = uploadInput.files;
  //       final file = files![0];
  //       final reader = html.FileReader();
  //
  //       reader.onLoadEnd.listen((event) async {
  //         _bytesData = Base64Decoder().convert(reader.result
  //             .toString()
  //             .split(",")
  //             .last);
  //         _selectedFile = _bytesData;
  //         var url = Uri.parse(HOST+"/api/saveImage/");
  //         var request = http.MultipartRequest("POST", url);
  //         request.files.add(await http.MultipartFile.fromBytes('uploadedFile', _selectedFile!,
  //             contentType: MediaType("application","json"), filename: "image-cour"));
  //         request.fields["path"] = "cours/";
  //
  //         var response = await request.send();
  //         var responseData = await response.stream.toBytes();
  //         var responseString = String.fromCharCodes(responseData);
  //         final body = Map<String, dynamic>.from(json.decode(responseString));
  //         print(responseString);
  //
  //         if(response.statusCode == 200){
  //           setState(() {
  //             image_path = body['path'];
  //           });
  //           if(cour != null){
  //             Navigator.pop(context);
  //             modal_Update(context, cour, uploadImage: true);
  //           }else{
  //             Navigator.pop(context);
  //             modal_add(context);
  //           }
  //         }else{
  //           final snackBar = SnackBar(
  //             content: const Text('Please try again'),
  //             action: SnackBarAction(
  //               label: 'Close',
  //               onPressed: () {
  //                 // Some code to undo the change.
  //               },
  //             ),
  //           );
  //           ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //         }
  //       });
  //       reader.readAsDataUrl(file);
  //     });
  //
  //   }catch(error){
  //     print(error);
  //   }
  //
  // }

  void add(context) async {

    if(nom_controller.text.isNotEmpty && description_controller.text.isNotEmpty
        && reglement_controller.text.isNotEmpty
        &&  _selectNiveau.getSelected()?.getValue() != null
        //&&  code_couleur_controller.text.isNotEmpty
    //&& screenPickerColor != null
       // && image_path.isNotEmpty
    ){
      String color_cour = screenPickerColor.toString();
      var cour = <String, dynamic>{
        "nom_cour": nom_controller.text,
        "description": description_controller.text,
        "Programme": reglement_controller.text,
        "code_couleur": color_cour,
        "id_niveau": _selectNiveau.getSelected()?.getValue(),
      };

      /**
       * notice
       * string to color
       * String stringcolor = dbColor.split('(0x)')[1].split(')')[0]
       * value = int.parse(stringcolor, radix: 16)
       * Color _color = new Color(value)
       */

      if(image_path.isNotEmpty){
        cour["image"] = image_path;
      }

      print(cour);
      final response = await http.post(Uri.parse(
          HOST+"/api/cours/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(cour),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          initData();
        }else{
          if(body['error'].containsKey("non_field_errors")){
            showAlertDialog(context, "cours existe déjà pour ce niveau.");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      } else {

        //throw Exception('Failed to load data');
        showAlertDialog(context, "Erreur ajout cour");
      }
    }else{
      showAlertDialog(context, "Remplir tous les champs");
    }

  }

  void filterNiveau(String key) {
    if(key != null){
      if(key == "0"){
        data = init_data;
      }else{
        data = init_data.where((e) => e.id_niveau.toString() == key).toList();
      }

      setState(() {
        data = data;
      });
    }
  }

  void fetchCour() async {
    // setState(() {
    //   loading = true;
    // });
    // print("loading ...");
    final response = await http.get(Uri.parse(
        HOST+'/api/cours/'),
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
        data = result.map<Cours>((e) => Cours.fromJson(e)).toList();
        init_data = result.map<Cours>((e) => Cours.fromJson(e)).toList();
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

  void search(String key){
    if(key.length >= 1){
      final List<Cours> founded = [];
      init_data.forEach((e) {
        if(e.nom_cour!.toLowerCase().contains(key.toLowerCase())
            || e.description!.toLowerCase().contains(key.toLowerCase())
            || e.Programme!.toLowerCase().contains(key.toLowerCase())

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

  void initSelectNiveau() {
    _selectNiveau.options = niveaux.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
          value: v.id_niveau,
          text: Text("${v.niveau} "),
        )).toList();
    Niveau niv = niveaux.where((el) => el.niveau == "").first;
    _selectNiveau.setSelected(BsSelectBoxOption(
      value: niv.id_niveau,
      text: Text("${niv.niveau}"),
    ));
  }

  void getNiveau() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/niveau/'),
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

        niveaux = result.map<Niveau>((e) => Niveau.fromJson(e)).toList();

      });
      print("--data--");
      print(data.length);
      initSelectNiveau();
    } else {
      throw Exception('Failed to load villes');
    }
  }

  Future<BsSelectBoxResponse> searchClasse(Map<String, String> params) async {
    List<BsSelectBoxOption> searched = [];
    print(params);
    for(var v in niveaux){
      if(v.niveau!.toLowerCase().contains(params["searchValue"]!.toLowerCase()) ){
        searched.add(
            BsSelectBoxOption(
                value: v.id_niveau,
                text: Text("${v.niveau}")
            )
        );
      }
    }

    return BsSelectBoxResponse(options: searched);
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
      title: Text("Cours"),
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
                  BsModalContainer(
                    //title:
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    actions: [
                      Text('Ajouter un Cours',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Annuler'),
                        //prefixIcon: Icons.close,
                        onPressed: () {

                          Navigator.pop(context);
                          initData();
                        },
                      )
                    ],
                    //closeButton: true,

                  ),
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
                                        title: 'Nom du cours *'
                                    ),
                                    Container(
                                        width: 900,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          autofocus: true,
                                          controller: nom_controller,
                                          decoration: new InputDecoration(
                                            hintText: 'Saisir le nom du cours',
                                          ),
                                        )),
                                  ],
                                )
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Description *'
                                    ),
                                    Container(
                                        width: 900,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          controller: description_controller,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(255,),
                                          ],
                                          decoration: new InputDecoration(
                                            counterText: '255 au max caractères',
                                            hintText: 'Saisir une description',
                                          ),
                                          maxLines: 5,
                                          minLines: 1,
                                        )),
                                  ],
                                )
                            )
                          ],
                        ),

                        SizedBox(
                          height: 30,
                        ),

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
                                        title: 'Programme *'
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          controller: reglement_controller,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(255,),
                                          ],
                                          decoration: new InputDecoration(
                                            counterText: '255 au max caractères',
                                            hintText: 'Programme',
                                          ),
                                          maxLines: 5,
                                          minLines: 1,
                                        )),
                                  ],
                                )
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(title: "niveau *"),
                                    BsSelectBox(
                                      hintText: 'niveau',
                                      controller: _selectNiveau,
                                      searchable: true,
                                      serverSide: searchClasse,
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),

                        SizedBox(
                          height: 30,
                        ),
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
                                        title: 'code_couleur *'
                                    ),
                                    ColorIndicator(
                                      // Use the screenPickerColor as start color.
                                      color: screenPickerColor,
                                      onSelect: () async {
                                        // Store current color before we open the dialog.
                                        final Color colorBeforeDialog = screenPickerColor;
                                        // Wait for the picker to close, if dialog was dismissed,
                                        // then restore the color we had before it was opened.
                                        if (!(await colorPickerDialog())) {
                                          setState(() {
                                            screenPickerColor = colorBeforeDialog;
                                          });
                                        }
                                        Navigator.pop(context);
                                        modal_add(context);
                                      },
                                      width: 44,
                                      height: 44,
                                      borderRadius: 22,
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            cameraImage(context);
                          },
                          child: Container(
                            width: 50,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.blue),
                            child: Icon(Icons.camera_alt_outlined,
                                size: 25, color: Colors.white),
                          ),
                        ),
                        SizedBox( height: 10),
                        image_path.isNotEmpty ?
                        SizedBox(
                          width: 250, //
                          height: 100,
                          child: Image.network(
                              HOST+"/media/"+image_path
                          ),
                        ) :Text("select image",textAlign: TextAlign.center,),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            add(context);
                          },
                          child: Container(
                            child:
                            Center(child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 13),)),
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
                        LabelText(title: 'nb * champ obligatoire')
                      ],
                    ),
                  ),

                ],
              ),
            )));
  }

  void modal_Update(context, Cours cour ,{bool? uploadImage=false}){

    if(!uploadImage!){
      nom_controller.text = cour.nom_cour.toString();
      description_controller.text = cour.description!;
      reglement_controller.text = cour.Programme!;
      if (cour.color != null){
       screenPickerColor = cour.color!;
      }
      //code_couleur_controller.text = cour.code_couleur!;


      _selectNiveau.setSelected(
          BsSelectBoxOption(value: cour.id_niveau, text: Text(cour.niveau.toString()))
      );


      setState(() {
        image_path = cour.image!;
      });
    }





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
                  BsModalContainer(
                    //title:
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    actions: [
                      Text('Modifier Cours',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      BsButton(
                        style: BsButtonStyle.outlinePrimary,
                        label: Text('Annuler'),
                        //prefixIcon: Icons.close,
                        onPressed: () {
                          initData();
                          Navigator.pop(context);
                        },
                      )
                    ],
                    //closeButton: true,

                  ),
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
                                        title: 'Nom du cours *'
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                        width: 900,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          controller: nom_controller,
                                          decoration: new InputDecoration(
                                            hintText: 'Saisir le nom du cours',
                                          ),
                                        )),
                                  ],
                                )
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'Description *'
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                        width: 900,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          controller: description_controller,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(255,),
                                          ],
                                          decoration: new InputDecoration(
                                            counterText: '255 au max caractères',
                                            hintText: 'Saisir une description',
                                          ),
                                          maxLines: 5,
                                          minLines: 1,
                                        )),
                                  ],
                                )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
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
                                        title: 'Programme *'
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                        width: 900,
                                        decoration: BoxDecoration(boxShadow: [
                                        ]),
                                        child: TextField(
                                          controller: reglement_controller,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(255,),
                                          ],
                                          decoration: new InputDecoration(
                                            counterText: '255 au max caractères',
                                            hintText: 'Programme',
                                          ),
                                          maxLines: 5,
                                          minLines: 1,
                                        )),
                                  ],
                                )
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText(
                                        title: 'niveau *'
                                    ),
                                    SizedBox(height: 10,),
                                    BsSelectBox(
                                      hintText: 'niveau',
                                      controller: _selectNiveau,
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),

                        SizedBox(
                          height: 30,
                        ),
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
                                        title: 'code_couleur *'
                                    ),
                                    ColorIndicator(
                                      // Use the screenPickerColor as start color.
                                      color: screenPickerColor,
                                      onSelect: () async {
                                        // Store current color before we open the dialog.
                                        final Color colorBeforeDialog = screenPickerColor;
                                        // Wait for the picker to close, if dialog was dismissed,
                                        // then restore the color we had before it was opened.
                                        if (!(await colorPickerDialog())) {
                                          setState(() {
                                            screenPickerColor = colorBeforeDialog;
                                          });
                                        }
                                        Navigator.pop(context);
                                        modal_Update(context,cour,uploadImage: true);
                                      },
                                      width: 44,
                                      height: 44,
                                      borderRadius: 22,
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: (){
                                update(context, cour.id_cour!);
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    cameraImage(context ,cour: cour);
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.blue),
                                    child: Icon(Icons.camera_alt_outlined,
                                        size: 25, color: Colors.white),
                                  ),
                                ),

                                SizedBox( height: 10),
                                image_path.isNotEmpty ?
                                SizedBox(
                                  width: 250, //
                                  height: 100,
                                  child: Image.network(
                                      HOST+"/media/"+image_path
                                  ),
                                ) :Text("select image",textAlign: TextAlign.center,),
                              ],
                            )



                          ],
                        )
                        ,
                        LabelText(title: 'nb * champ obligatoire')
                      ],
                    ),
                  ),

                ],
              ),
            )));
  }
  void update(context, int id) async {

    if(nom_controller.text.length > 0 && description_controller.text.length > 0
        && reglement_controller.text.length > 0
        &&  _selectNiveau.getSelected()?.getValue() != null
        //&& code_couleur_controller.text.length > 0
    //&& image_path.isNotEmpty
    ){
      String color_cour = screenPickerColor.toString();
      var cour = <String, dynamic>{
        "id_cour": id,
        "nom_cour": nom_controller.text,
        "description": description_controller.text,
        "Programme": reglement_controller.text,
        "code_couleur":  color_cour ,
        "id_niveau": _selectNiveau.getSelected()?.getValue(),
        "image": image_path,
      };

      print(cour);
      final response = await http.put(Uri.parse(
          HOST+"/api/cours/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(cour),
      );

      if (response.statusCode == 200) {

        final body = json.decode(response.body);
        final status = body["status"];
        if(status == true){
          Navigator.pop(context);
          initData();
        }else{
          if(body['error'].containsKey("non_field_errors")){
            showAlertDialog(context, " Ce cours existe déjà pour ce niveau.");
            return;
          }
          showAlertDialog(context, body["msg"]);
        }
      } else {
        showAlertDialog(context,"Failed to update data");
      }
    }else{
      showAlertDialog(context,"Merci de remplir tous les champs");
    }

  }
  var token = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screenPickerColor = Colors.blue;
    token = context.read<AdminProvider>().admin.token;
    print("init state");

    fetchCour();
    getNiveau();
    getClasses();


  }
  void initSelectClasses() {
    _selectClasses.options = niveaux1.map<BsSelectBoxOption>((v) =>
        BsSelectBoxOption(
          value: v.id_niveau,
          text: Text("${v.niveau}"),
        )).toList();
    Niveau niv = niveaux1.where((el) => el.niveau == "").first;
    _selectClasses.setSelected(BsSelectBoxOption(
      value: niv.id_niveau,
      text: Text("${niv.niveau}"),
    ));
  }

  void getClasses() async {
    final response = await http.get(Uri.parse(
        HOST+'/api/niveau/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      print("--result--");
      print(result.length);
      result.insert(0, {"id_niveau" : 0,"niveau": "Tout"});
      setState(() {
        niveaux1 = result.map<Niveau>((e) => Niveau.fromJson(e)).toList();
      });
      print("--data--");
      print(data.length);
      initSelectClasses();
    } else {
      throw Exception('Failed to load periodes');
    }
  }

  void delete(id) async {
    final response = await http.delete(Uri.parse(
        HOST+'/api/cours/'+id),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      fetchCour();
    } else {
      throw Exception('Failed to load data');
    }
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
            children: [
             // SideBar(postion: 6,msg:"Cours"),
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
                                padding: const EdgeInsets.only(top:15.0),
                                child: Center(child: Text("Cours", style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.w700,
                                    color: Colors.black)),),
                              ),

                              SizedBox(
                                height: 30,
                              ),
                              screenSize.width > 520 ?
                              Row(

                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                                      color: Colors.blue

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
                                  SizedBox(width: 15,),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Expanded(flex: 3,
                                    child: Container(
                                    width: 100,
                                    child: BsSelectBox(
                                      hintText: 'Filtrer',
                                      controller: _selectClasses,
                                      onChange: (v){
                                        print("selected value ${ v.getValueAsString()}");
                                        filterNiveau(v.getValueAsString());
                                      },
                                    ),
                                  ),),
                                  SizedBox(width: 15,),
                                  Expanded(
                                    flex: 2,
                                    child: Container(

                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Expanded(
                                    flex:3,
                                    child: InkWell(
                                      onTap: (){
                                        /*Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddCourScreen(),
                                            )).then((val)=>fetchCour()
                                        );*/
                                        modal_add(context);
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.blue[200],
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text("Ajouter un Cours",

                                                style: TextStyle(
                                                    fontSize: 15
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(" Cours", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey
                                  )),
                                  InkWell(
                                    onTap: (){
                                      //
                                      modal_add(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.blue[200],
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Icon(
                                              Icons.add,
                                              size: 18,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: ListView(
                                      children:[
                                        data.length == 0 ?
                                        Padding(
                                          padding: const EdgeInsets.all(150.0),
                                          child: Center(
                                              child: Text("aucun Cours à afficher")),
                                        )
                                            :
                                        DataTable(
                                            dataRowHeight: DataRowHeight,
                                            headingRowHeight: HeadingRowHeight,
                                            columns: screenSize.width > 800 ?
                                            <DataColumn>[
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Nom du cours',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Description',
                                                    style: TextStyle(fontStyle: FontStyle.italic,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Distiné pour',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(fontStyle: FontStyle.italic),
                                                  ),
                                                ),
                                              ),
                                            ]:
                                            <DataColumn>[
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    'Nom du cours',
                                                    style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(fontStyle: FontStyle.italic),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            rows:
                                            data.map<DataRow>((e) => DataRow(

                                              cells: screenSize.width > 800 ?
                                              <DataCell>[
                                                DataCell(Row(
                                                  children: [
                                                    SizedBox(width: 10,),
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
                                                    Text(e.nom_cour.toString(), overflow: TextOverflow.ellipsis,)
                                                  ],
                                                )),
                                                DataCell(Text(e.description.toString())),
                                                DataCell(Text(e.niveau.toString())),
                                                DataCell(Row(
                                                  children: [

                                                    ShowButton(
                                                        msg:"•Visualisation Les détails du Cours",
                                                        onPressed: (){
                                                          showDialog(context: context, builder: (context) =>
                                                              BsModal(
                                                                  context: context,
                                                                  dialog: BsModalDialog(
                                                                    size: BsModalSize.md,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    child: BsModalContent(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                      ),
                                                                      children: [
                                                                        BsModalContainer(
                                                                          //title:
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          actions: [
                                                                            Row(
                                                                              children: [
                                                                                SizedBox(width: 9,),
                                                                                Text('${e.nom_cour.toString()}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))                                                                              ],
                                                                            ),
                                                                            /*Text('${e.nom_cour.toString()}',
                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),*/
                                                                            BsButton(
                                                                              style: BsButtonStyle.outlinePrimary,
                                                                              label: Text('Fermer'),
                                                                              //prefixIcon: Icons.close,
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                initData();
                                                                              },
                                                                            )
                                                                          ],
                                                                          //closeButton: true,

                                                                        ),

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
                                                                                        /*Row(
                                                                                          children: [
                                                                                            Text("Nom: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(width: 9,),
                                                                                            Text(" ${e.nom_cour.toString()}"),
                                                                                          ],
                                                                                        ),*/
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Description: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 3,),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Expanded(child: Text("${e.description.toString()}")),
                                                                                              ],
                                                                                            )

                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Programme: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 3,),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Expanded(child: Text("${e.Programme.toString()}")),
                                                                                              ],
                                                                                            )

                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("niveau: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 3,),
                                                                                            Text("${e.niveau.toString()}"),
                                                                                          ],
                                                                                        ),
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
                                                        msg: "Mettre à jour les informations du Cours",
                                                        onPressed: (){
                                                         modal_Update(context, e);
                                                        }
                                                    ),
                                                    SizedBox(width: 10,),
                                                    DeleteButton(
                                                      msg:"Supprimer le Cours ",
                                                      onPressed: () async {
                                                        if (await confirm(
                                                        context,
                                                        title: const Text('Confirmation'),
                                                        content: const Text('Souhaitez-vous supprimer ?'),
                                                        textOK: const Text('Oui'),
                                                        textCancel: const Text('Non'),
                                                        )) {

                                                        delete(e.id_cour.toString());
                                                        }

                                                      },
                                                    ),
                                                    SizedBox(width: 10,),
                                                    e.color != null ? Icon(
                                                      Icons.article_rounded,
                                                      color: e.color!,
                                                      size: 19,
                                                    ):SizedBox(width: 0,),
                                                  ],
                                                )),
                                              ]:
                                              <DataCell>[
                                                DataCell(Row(
                                                  children: [
                                                    SizedBox(width: 10,),
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
                                                    Expanded(
                                                      child: Text(e.nom_cour.toString(),
                                                      overflow: TextOverflow.ellipsis,),
                                                    )
                                                  ],
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    ShowButton(
                                                        msg:"•Visualisation Les détails du Cours",
                                                        onPressed: (){
                                                          showDialog(context: context, builder: (context) =>
                                                              BsModal(
                                                                  context: context,
                                                                  dialog: BsModalDialog(
                                                                    size: BsModalSize.md,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    child: BsModalContent(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                      ),
                                                                      children: [
                                                                        BsModalContainer(
                                                                          //title:
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          actions: [

                                                                            Row(
                                                                              children: [

                                                                                SizedBox(width: 9,),
                                                                                Text('${e.nom_cour.toString()}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))                                                                              ],
                                                                            ),
                                                                            BsButton(
                                                                              style: BsButtonStyle.outlinePrimary,
                                                                              label: Text('Fermer'),
                                                                              //prefixIcon: Icons.close,
                                                                              onPressed: () {

                                                                                Navigator.pop(context);
                                                                                initData();
                                                                              },
                                                                            )
                                                                          ],
                                                                          //closeButton: true,

                                                                        ),
                                                                        //BsModalContainer(title: Text('${e.nom_cour.toString()}'), closeButton: true),
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
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Nom: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text(" ${e.nom_cour.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Description: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${e.description.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("Programme: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${e.Programme.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 4,),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("niveau: " ,style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color:Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 4,),
                                                                                            Text("${e.niveau.toString()}"),
                                                                                          ],
                                                                                        ),
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
                                                    SizedBox(width: 5,),
                                                    EditerButton(
                                                        msg: "Mettre à jour les informations du Cours",
                                                        onPressed: (){
                                                          modal_Update(context, e);
                                                        }
                                                    ),
                                                    SizedBox(width: 5,),
                                                    DeleteButton(
                                                      msg:"Supprimer le Cours ",
                                                      onPressed: () async {
                                                        if (await confirm(
                                                          context,
                                                          title: const Text('Confirmation'),
                                                          content: const Text('Souhaitez-vous supprimer ?'),
                                                          textOK: const Text('Oui'),
                                                          textCancel: const Text('Non'),
                                                        )) {

                                                          delete(e.id_cour.toString());
                                                        }

                                                      },
                                                    ),
                                                  ],
                                                )),
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
  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: screenPickerColor,
      onColorChanged: (Color color) =>
          setState(() => screenPickerColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints:
      const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }
}

