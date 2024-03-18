
class Client{
  int? id_etudiant;
  int? id_ville;
  String? nom;
  String? civilite;
  String? prenom;
  String? adresse;
  String? tel;
  String? mail;
  String? password;
  String? ville;
  DateTime? date_naissance;
  DateTime? date_inscription;
  bool? statut;
  int? id_classe;
  String? classe;
  String? image;

  Map<String, dynamic>? affiliation;

  Client({
    this.id_etudiant,
    this.civilite,
    this.nom,
    this.prenom,
    this.adresse,
    this.tel,
    this.mail,
    this.password,
    this.ville,
    this.date_naissance,
    this.date_inscription,
    this.statut,
    this.id_classe,
    this.classe,
    this.image,
    this.id_ville,

    this.affiliation
  });

  Client.fromJson(Map<String, dynamic> json) {
    id_etudiant = json['id_etudiant'];
    civilite = json['civilite'];
    id_classe = json['id_classe'];
    nom = json['nom'];
    prenom = json['prenom'];
    adresse = json['adresse'];
    tel = json['tel'];
    mail = json['mail'];
    password = json['password'];
    ville = json['nom_ville'];
    date_naissance = DateTime.parse(json['date_naissance']);
    date_inscription = DateTime.parse(json['date_inscription']);
    statut = json['statut'];
    classe = json['classe'];
    image = json['image'];
    id_ville = json['ville'];

    affiliation = json["affiliation"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_etudiant'] = id_etudiant;
    data['nom'] = nom;
    data['id_classe'] = id_classe;
    data['civilite'] = civilite;
    data['prenom'] = prenom;
    data['adresse'] = adresse;
    data['tel'] = tel;
    data['mail'] = mail;
    data['password'] = password;
    data['date_inscription'] = date_inscription;
    data['statut'] = statut;
    data['classe'] = classe;
    data['image'] = image;

    return data;
  }

}