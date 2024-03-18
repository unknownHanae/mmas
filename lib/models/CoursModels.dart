
import 'dart:ui';

class Cours {
  int? id_cour;
  String? nom_cour;
  String? description;
  String? Programme;
  String? niveau;
  String? code_couleur;
  int? id_niveau;
  String? image;
  Color? color;

  Cours({
    this.id_cour,
    this.nom_cour,
    this.code_couleur,
    this.description,
    this.Programme,
    this.niveau,
    this.id_niveau,
    this.image,
    this.color,

  });

  Cours.fromJson(Map<String, dynamic> json) {
    id_cour = json['id_cour'];
    nom_cour = json['nom_cour'];
    description = json['description'];
    code_couleur = json['code_couleur'];
    niveau = json['niveau'];
    Programme = json['Programme'];
    id_niveau = json['id_niveau'];
    image = json['image'];
    if(json['code_couleur'] != null && json['code_couleur'].toString().isNotEmpty){
      String stringcolor = json['code_couleur'].split('(0x')[1].split(')')[0];
      int value = int.parse(stringcolor, radix: 16);
      color = new Color(value);
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_cour'] = id_cour;
    data['nom_cour'] = nom_cour;
    data['description'] = description;
    data['code_couleur'] = code_couleur;
    data['niveau'] = niveau;
    data['Programme'] = Programme;
    data['id_niveau'] = id_niveau;
    data['image'] = image;

    return data;
  }

}