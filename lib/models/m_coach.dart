class Coach {
  int idCoach;
  String nomCoach;
  String prenomCoach;
  String adresse;
  String tel;
  String mail;
  String cin;
  DateTime? dateNaissance;
  DateTime? datedentree;
  bool statut;
  String password;
  String image;
  String ville;
  Coach({
    this.idCoach = 0,
    this.nomCoach = '',
    this.prenomCoach = '',
    this.adresse = '',
    this.tel = '',
    this.mail = '',
    this.cin = '',
    this.dateNaissance,
    this.datedentree,
    this.statut = true,
    this.password = '',
    this.image = '',
    this.ville = '',
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      idCoach: json['id_coach'],
      nomCoach: json['nom_coach'],
      prenomCoach: json['prenom_coach'],
      adresse: json['adresse'],
      tel: json['tel'],
      mail: json['mail'],
      cin: json['cin'],
      dateNaissance: json['date_naissance'] != null
          ? DateTime.parse(json['date_naissance'])
          : null,
      datedentree: json['date_dentree'] != null
          ? DateTime.parse(json['date_dentree'])
          : null,
      statut: json['statut'],
      password: json['password'],
      image: json['image'],
      ville: json['ville'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_coach'] = this.idCoach ?? 0;
    data['nom_coach'] = this.nomCoach ?? '';
    data['prenom_coach'] = this.prenomCoach ?? '';
    data['adresse'] = this.adresse ?? '';
    data['tel'] = this.tel ?? '';
    data['mail'] = this.mail ?? '';
    data['cin'] = this.cin ?? '';
    data['date_naissance'] = this.dateNaissance?.toIso8601String();
    data['date_dentree'] = this.datedentree?.toIso8601String();
    data['statut'] = this.statut ?? true;
    data['password'] = this.password ?? '';
    data['image'] = this.image ?? '';
    data['ville'] = this.ville ?? '';
    return data;
  }
}
