//SELECT `id_coach`, `nom_coach`, `prenom_coach`, `adresse`, `tel`,
//`mail`, `cin`, `date_naissance`, `date_dentree`, `statut`, `password`, `image`, `ville` FROM `coach` WHERE 1
class Coach {
  int? id_coach;
  int? id_ville;
  String? nom_coach;
  String? civilite;
  String? prenom_coach;
  String? adresse;
  String? tel;
  String? mail;
  String? password;
  String? cin;
  String? ville;
  String? date_naissance;
  String? date_entree;
  bool? statut;
  String? image;
  String? description;

  Coach({
    this.id_coach,
    this.nom_coach,
    this.civilite,
    this.prenom_coach,
    this.adresse,
    this.tel,
    this.mail,
    this.password,
    this.cin,
    this.ville,
    this.date_naissance,
    this.date_entree,
    this.statut,
    this.image,
    this.id_ville,
    this.description,
  });

  Coach.fromJson(Map<String, dynamic> json) {
    id_coach = json['id_coach'];
    nom_coach = json['nom_coach'];
    civilite = json['civilite'];
    prenom_coach = json['prenom_coach'];
    adresse = json['adresse'];
    tel = json['tel'];
    mail = json['mail'];
    password = json['password'];
    cin = json['cin'];
    ville = json['ville'];
    date_naissance = json['date_naissance'];
    date_entree = json['date_dentree'];
    statut = json['statut'];
    image = json['image'];
    id_ville = json['id_ville'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_coach'] = id_coach;
    data['nom_coach'] = nom_coach;
    data['civilite'] = civilite;
    data['prenom_coach'] = prenom_coach;
    data['adresse'] = adresse;
    data['tel'] = tel;
    data['mail'] = mail;
    data['password'] = password;
    data['cin'] = cin;
    data['date_entree'] = date_entree;
    data['statut'] = statut;
    data['image'] = image;
    data['description'] = description;

    return data;
  }

}