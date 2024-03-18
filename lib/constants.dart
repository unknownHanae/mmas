import 'package:flutter/material.dart';

// Set your env [dev, prod, local]
const ENV = "dev";

// Server used for dev , prod or local
const HOST = ENV == "dev" ? "https://jyssrmmas.pythonanywhere.com" :
ENV == "prod" ? "https://jyssr.pythonanywhere.com" : "http://127.0.0.1:8000";


const version_Web = "0.1";
const double HeadingRowHeight = 40;
const double DataRowHeight = 35;


const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
// create a constant for this color rgb(240, 165, 0)
const yellowColor = Color.fromRGBO(240, 165, 0, 1.0);
// rgb(207, 117, 0)
const yellowDeColor = Color.fromRGBO(207, 117, 0, 1.0);
// rgb(244, 244, 244)
//const whiteColor = Color.fromRGBO(244, 244, 244, 1.0);
const whiteColor = Colors.white;

// green
const greenColor = Color.fromRGBO(0, 128, 0, 1.0);
const redColor = Color.fromRGBO(255, 0, 0, 1.0);

const defaultPadding = 16.0;

// titreSize
const titreSize = 14.0;
const sousTitreSize = 12.0;
const sousTitreSize2 = 11.0;
const kpiSize = 14.0;

// titreColor
const titreColor = Color.fromRGBO(0, 0, 0, 1.0);
const sousTitreColor = Color.fromRGBO(0, 0, 0, 1.0);
const sousTitreColor2 = Color.fromRGBO(0, 0, 0, 1.0);

// google font, good font
const String fontName = 'Roboto';

