
class category_contrat {
  int? id_cat_cont;
  String? type_contrat;
  int? duree_mois;

  category_contrat({
    this.id_cat_cont,
    this.type_contrat,
    this.duree_mois,
  });

  category_contrat.fromJson(Map<String, dynamic> json) {
    id_cat_cont = json['id_cat_cont'];
    type_contrat = json['type_contrat'];
    duree_mois = json['duree_mois'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_cat_cont'] = id_cat_cont;
    data['type_contrat'] = type_contrat;
    data['duree_mois'] = duree_mois;
    return data;
  }

}