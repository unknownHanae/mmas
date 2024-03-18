

class Ville {
  int? id;
  String? nom_ville;


  Ville({
    this.id,
    this.nom_ville,
  });

  Ville.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom_ville = json['nom_ville'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom_ville'] = nom_ville;
    return data;
  }

}