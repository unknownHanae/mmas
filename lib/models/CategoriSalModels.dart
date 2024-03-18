
class category_salle {
  int? id_category;
  String? nom_category;

  category_salle({
    this.id_category,
    this.nom_category,
  });

  category_salle.fromJson(Map<String, dynamic> json) {
    id_category = json['id_category'];
    nom_category = json['nom_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_category'] = id_category;
    data['nom_category'] = nom_category;
    return data;
  }

}