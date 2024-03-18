class ValidNotifModel {
  int? idValidNotif;
  int? idNotif;
  int? idAdmin;
  int? idClient;
  int? idCoach;

  ValidNotifModel({
    this.idValidNotif,
    this.idNotif,
    this.idAdmin,
    this.idClient,
    this.idCoach,
  });

  ValidNotifModel copyWith({
    int? idValidNotif,
    int? idNotif,
    int? idAdmin,
    int? idClient,
    int? idCoach,
  }) {
    return ValidNotifModel(
      idValidNotif: idValidNotif ?? this.idValidNotif,
      idNotif: idNotif ?? this.idNotif,
      idAdmin: idAdmin ?? this.idAdmin,
      idClient: idClient ?? this.idClient,
      idCoach: idCoach ?? this.idCoach,
    );
  }

  factory ValidNotifModel.fromJson(Map<String, dynamic> json) {
    return ValidNotifModel(
      idValidNotif: json['id_validNotif'],
      idNotif: json['id_notif'],
      idAdmin: json['id_admin'],
      idClient: json['id_client'],
      idCoach: json['id_coach'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_validNotif'] = this.idValidNotif;
    data['id_notif'] = this.idNotif;
    data['id_admin'] = this.idAdmin;
    data['id_client'] = this.idClient;
    data['id_coach'] = this.idCoach;
    return data;
  }
}
