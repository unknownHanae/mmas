class periode_salaire {
  int? id_periode;
  String? PeriodeSalaire;


  periode_salaire({
    this.id_periode,
    this.PeriodeSalaire,

  });

  periode_salaire.fromJson(Map<String, dynamic> json) {
    id_periode = json['id_periode'];
    PeriodeSalaire = json['PeriodeSalaire'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_periode'] = id_periode;
    data['PeriodeSalaire'] = PeriodeSalaire;
    return data;
  }

}