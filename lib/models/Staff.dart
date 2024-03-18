//SELECT `id_coach`, `nom_coach`, `prenom_coach`, `adresse`, `tel`,
//`mail`, `cin`, `date_naissance`, `date_dentree`, `statut`, `password`, `image`, `ville` FROM `coach` WHERE 1
class Staff {
  int? id_employe;
  int? id_ville;
  String? nom;
  String? civilite;
  String? prenom;
  String? adresse;
  String? tel;
  String? mail;
  String? cin;
  String? ville;
  String? date_naissance;
  String? date_recrutement;
  bool? statut;
  String? image;
  String? fonction;
  String? Description;
  String? validite_CIN;

  Staff({
    this.id_employe,
    this.nom,
    this.civilite,
    this.prenom,
    this.adresse,
    this.tel,
    this.mail,
    this.cin,
    this.ville,
    this.date_naissance,
    this.date_recrutement,
    this.statut,
    this.image,
    this.id_ville,
    this.fonction,
    this.Description,
    this.validite_CIN,
  });

  Staff.fromJson(Map<String, dynamic> json) {
    id_employe = json['id_employe'];
    nom = json['nom'];
    civilite = json['civilite'];
    prenom= json['prenom'];
    adresse = json['adresse'];
    tel = json['tel'];
    mail = json['mail'];
    cin = json['cin'];
    ville = json['ville'];
    date_naissance = json['date_naissance'];
    date_recrutement = json['date_recrutement'];
    statut = json['statut'];
    image = json['image'];
    id_ville = json['id_ville'];
    fonction = json['fonction'];
    Description = json['Description'];
    validite_CIN = json['validite_CIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_employe'] = id_employe;
    data['nom'] = nom;
    data['civilite'] = civilite;
    data['prenom'] = prenom;
    data['adresse'] = adresse;
    data['tel'] = tel;
    data['mail'] = mail;
    data['cin'] = cin;
    data['Description'] = Description;
    data['date_recrutement'] = date_recrutement;
    data['statut'] = statut;
    data['image'] = image;
    data['fonction'] = fonction;
    data['validite_CIN'] = validite_CIN;

    return data;
  }

}