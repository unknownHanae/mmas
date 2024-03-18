
class Parent {
  int? id_parent;
  int? id_ville;
  String? nom;
  String? civilite;
  String? prenom;
  String? adresse;
  String? tel;
  String? mail;
  String? password;
  String? cin;
  String? ville;
  String? date_naissance;
  bool? statut;
  String? image;

  Map<String, dynamic>? affiliation;

  Parent({
    this.id_parent,
    this.nom,
    this.civilite,
    this.prenom,
    this.adresse,
    this.tel,
    this.mail,
    this.password,
    this.cin,
    this.ville,
    this.date_naissance,
    this.statut,
    this.image,
    this.id_ville,
    this.affiliation
  });

  Parent.fromJson(Map<String, dynamic> json) {
    id_parent = json['id_parent'];
    nom = json['nom'];
    civilite = json['civilite'];
    prenom = json['prenom'];
    adresse = json['adresse'];
    tel = json['tel'];
    mail = json['mail'];
    password = json['password'];
    cin = json['cin'];
    ville = json['nom_ville'];
    date_naissance = json['date_naissance'];
    statut = json['statut'];
    image = json['image'];
    id_ville = json['ville'];
    affiliation = json["affiliation"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_parent'] = id_parent;
    data['nom'] = nom;
    data['civilite'] = civilite;
    data['prenom'] = prenom;
    data['adresse'] = adresse;
    data['tel'] = tel;
    data['mail'] = mail;
    data['password'] = password;
    data['cin'] = cin;
    data['statut'] = statut;
    data['image'] = image;


    return data;
  }

}