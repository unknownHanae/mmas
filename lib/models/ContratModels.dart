class Contrat {
  int? id_contrat;
  int? id_etd;
  String? date_debut;
  String? date_fin;
  String? reste;
  String? montant_paye;
  String? numcontrat;
  int? id_etablissement;
  int? id_abn;
  String? client;
  String? etablissement;
  String? abonnement;
  String? Prenom_client;
  String? image;
  double? tarif;
  String? type_contrat;
  String? type;
  double? reduction;
  String? cat_abn;

  Contrat({
    this.id_contrat,
    this.id_etd,
    this.date_debut,
    this.date_fin,
    this.reste,
    this.numcontrat,
    this.id_etablissement,
    this.id_abn,
    this.client,
    this.etablissement,
    this.abonnement,
    this.Prenom_client,
    this.montant_paye,
    this.image,
    this.tarif,
    this.type_contrat,
    this.type,
    this.reduction,
    this.cat_abn
  });

  Contrat.fromJson(Map<String, dynamic> json) {
    id_contrat = json['id_contrat'];
    id_etd = json['id_etd'];
    date_debut = json['date_debut'];
    date_fin = json['date_fin'];
    montant_paye = json["montant_paye"];
    reste = "${json['reste']}";
    numcontrat = json['numcontrat'];
    id_etablissement = json['id_etablissement'];
    id_abn = json['id_abn'];
    etablissement = json['etablissemnt'];
    client = json['client'];
    abonnement = json['abonnement'];
    Prenom_client = json['Prenom_client'];
    image = json['image'];
    tarif = json['tarif'];
    type_contrat = json["cat_abn"];
    type = json["type"];
    reduction = json["reduction"];
    cat_abn = json["cat_abn"];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_contrat'] = id_contrat;
    data['id_etd'] = id_etd;
    data['date_debut'] = date_debut;
    data['date_fin'] = date_fin;
    data['reste'] = reste;
    data["montant_paye"] = montant_paye;
    data['numcontrat'] = numcontrat;
    data['id_etablissement'] = id_etablissement;
    data['id_abn'] = id_abn;
    data['Prenom_client'] = Prenom_client;
    return data;
  }

}