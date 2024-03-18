
class ContratStaff {
  int? id_contratStaff;
  int? id_employe;
  String? date_debut;
  String? date_fin;
  double? salaire;
  String? type_contrat;
  String? employe;
  String? image;

  ContratStaff({
    this.id_contratStaff,
    this.id_employe,
    this.date_debut,
    this.date_fin,
    this.salaire,
    this.type_contrat,
    this.employe,
    this.image,
  });

  ContratStaff.fromJson(Map<String, dynamic> json) {
    id_contratStaff = json['id_contratStaff'];
    id_employe = json['id_employe'];
    date_debut = json['date_debut'];
    date_fin = json['date_fin'];
    salaire = json["salaire"];
    type_contrat = "${json['type_contrat']}";
    employe = json['employe'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_contratStaff'] = id_contratStaff;
    data['id_employe'] = id_employe;
    data['date_debut'] = date_debut;
    data['date_fin'] = date_fin;
    data['salaire'] = salaire;
    data["type_contrat"] = type_contrat;
    data["image"] = image;
    return data;
  }

}