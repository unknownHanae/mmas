
class Etablissement {
  int? id_etablissement;
  String? nom_etablissement;
  String? adresse_etablissement;
  String? ville;
  String? teletablissement;
  String? sitewebetablissement;
  String? mailetablissement;
  String? description;
  String? image;
  String? facebook;
  String? instagrame;
  String? watsapp;
  int? nb_clients;

  Etablissement({
    this.id_etablissement,
    this.nom_etablissement,
    this.adresse_etablissement,
    this.mailetablissement,
    this.ville,
    this.teletablissement,
    this.sitewebetablissement,
    this.description,
    this.image,
    this.facebook,
    this.instagrame,
    this.watsapp,
    this.nb_clients
  });

  Etablissement.fromJson(Map<String, dynamic> json) {
    id_etablissement = json['id_etablissement'];
    nom_etablissement = json['nom_etablissement'];
    adresse_etablissement = json['adresse_etablissement'];
    mailetablissement = json['mailetablissement'];
    ville = json['ville'];
    teletablissement = json['teletablissement'];
    sitewebetablissement = json['sitewebetablissement'];
    description = json['description'];
    image = json['image'];
    facebook = json['facebook'];
    instagrame = json['instagrame'];
    watsapp = json['watsapp'];
    nb_clients = json['nb_clients'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_etablissement'] = id_etablissement;
    data['nom_etablissement'] = nom_etablissement;
    data['adresse_etablissement'] = adresse_etablissement;
    data['mailetablissement'] = mailetablissement;
    data['ville'] = ville;
    data['teletablissement'] = teletablissement;
    data['sitewebetablissement'] = sitewebetablissement;
    data['description'] = description;
    data['image'] = image;
    data['facebook'] = facebook;
    data['instagrame'] = instagrame;
    data['watsapp'] = watsapp;
    data['nb_clients'] = nb_clients;
    return data;
  }

}