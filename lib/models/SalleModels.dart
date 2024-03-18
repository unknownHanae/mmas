class Salle {
  int? id_salle;
  int? id_etablissement;
  int? id_category;
  int? capacity;
  String? image;
  String? nom_salle;
  String? category;
  String? etablissement;


  Salle({
    this.id_salle,
    this.id_etablissement,
    this.id_category,
    this.capacity,
    this.image,
    this.nom_salle,
  });

  Salle.fromJson(Map<String, dynamic> json) {
    id_salle = json['id_salle'];
    id_etablissement = json['id_etablissement'];
    id_category = json['id_category'];
    capacity = json['capacity'];
    image = json['image'];
    nom_salle = json['nom_salle'];
    category = json['category'] ?? json['category'];
    etablissement = json['etablissemnt'] ?? json['etablissemnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_salle'] = id_salle;
    data['id_etablissement'] = id_etablissement;
    data['id_category'] = id_category;
    data['capacity'] = capacity;
    data['image'] = image;
    data['nom_salle'] = nom_salle;

    return data;
  }

}
