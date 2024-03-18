
class Niveau {
  int? 	id_niveau;
  String? niveau;

  Niveau({
    this.id_niveau,
    this.niveau,

  });

  Niveau.fromJson(Map<String, dynamic> json) {
    id_niveau = json['id_niveau'];
    niveau = json['niveau'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_niveau'] = id_niveau;
    data['niveau'] = niveau;
    return data;
  }

}