
class Salaire {
  int? id_trans;
  int? periode;
  int? id_contrat;
  String? nom_periode;
  double? salaire_base;
  double? salaire_final;
  double? prime;
  String? staff;
  String? image;
  String? type;
  int? id_admin;


  Salaire({
    this.id_trans,
    this.periode,
    this.id_contrat,
    this.nom_periode,
    this.salaire_base,
    this.prime,
    this.staff,
    this.salaire_final,
    this.image,
    this.type,
    this.id_admin,
  });

  Salaire.fromJson(Map<String, dynamic> json) {
    id_trans = json['id_trans'];
    id_contrat = json['id_contrat'];
    nom_periode = json['nom_periode'];
    salaire_base = json['salaire_base'];
    prime = json["prime"];
    salaire_final = json["salaire_final"];
    staff = "${json['staff']}";
    image = "${json['image']}";
    type = "${json['type']}";
    periode = json['periode'];
    id_admin = json['id_admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_trans'] = id_trans;
    data['id_contrat'] = id_contrat;
    data['salaire_base'] = salaire_base;
    data['prime'] = prime;
    data['salaire_final'] = salaire_final;
    data['id_admin'] = id_admin;

    return data;
  }

}