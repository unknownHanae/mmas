class Classes {
  int? id_classe;
  int? id_niveau;
  String? groupe;
  String? nombre_etudiant;
  String? niveau;


  Classes({
    this.id_classe,
    this.id_niveau,
    this.niveau,
    this.nombre_etudiant,
    this.groupe,

  });

  Classes.fromJson(Map<String, dynamic> json) {
    id_classe = json['id_classe'];
    id_niveau = json['id_niveau'];
    nombre_etudiant = json['nombre_etudiant'];
    niveau = json['niveau'];
    groupe = json['groupe'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_classe'] = id_classe;
    data['id_niveau'] = id_niveau;
    data['niveau'] = niveau;
    data['nombre_etudiant'] = nombre_etudiant;
    data['groupe'] = groupe;
    return data;
  }

}