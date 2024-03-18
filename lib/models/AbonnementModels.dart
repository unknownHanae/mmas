
class Abonnement {
  int? id_abn;
  String? type_abonnement;
  String? tarif;
  String? Niveau_age;
  String? Systeme;
  String? description;
  int? id_cat_cont;
  String? namecat_conrat;
  int? duree_mois;


  Abonnement({
    this.id_abn,
    this.type_abonnement,
    this.tarif,
    this.Niveau_age,
    this.Systeme,
    this.description,
    this.id_cat_cont,
    this.namecat_conrat,
    this.duree_mois,
  });

  Abonnement.fromJson(Map<String, dynamic> json) {
    id_abn = json['id_abn'];
    type_abonnement = json['type_abonnement'];
    tarif = "${json['tarif']}";
    Niveau_age = json['Niveau_age'];
    description = json['description'];
    Systeme = json['Systeme'];
    id_cat_cont = json['id_cat_cont'];
    namecat_conrat = json['namecat_conrat'] ?? "";
    duree_mois = json['duree_mois'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_abn'] = id_abn;
    data['type_abonnement'] = type_abonnement;
    data['tarif'] = tarif;
    data['id_cat_cont'] = id_cat_cont;
    data['description'] = description;
    data['Systeme'] = Systeme;
    data['Niveau_age'] = Niveau_age;

    return data;
  }

}