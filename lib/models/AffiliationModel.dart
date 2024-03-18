class Afilliation {
  int? id_affiliation;
  int? id_etudiant;
  int? id_parent;
  String? parent;
  String? etudiant;



  Afilliation({
    this.id_affiliation,
    this.id_etudiant,
    this.id_parent,
    this.parent,
    this.etudiant,
  });

  Afilliation.fromJson(Map<String, dynamic> json) {
    id_affiliation = json['id_affiliation'];
    id_etudiant = json['id_etudiant'];
    id_parent = json['id_parent'];
    parent = json['parent'];
    etudiant = json['etudiant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_affiliation'] = id_affiliation;
    data['id_etudiant'] = id_etudiant;
    data['id_parent'] = id_parent;
    data['parent'] = parent;
    data['etudiant'] = etudiant;

    return data;
  }

}