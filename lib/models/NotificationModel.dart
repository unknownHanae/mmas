class NotificationAdmin {
  int? idNotif;
  int? idAdmin;
  String? sujet;
  String? contenu;
  String? cible;
  String? dateEnvoye;

  NotificationAdmin({
    this.idNotif,
    this.idAdmin,
    this.sujet,
    this.contenu,
    this.cible,
    this.dateEnvoye,
  });

  NotificationAdmin copyWith({
    int? idNotif,
    int? idAdmin,
    String? sujet,
    String? contenu,
    String? cible,
    String? dateEnvoye,
  }) {
    return NotificationAdmin(
      idNotif: idNotif ?? this.idNotif,
      idAdmin: idAdmin ?? this.idAdmin,
      sujet: sujet ?? this.sujet,
      contenu: contenu ?? this.contenu,
      cible: cible ?? this.cible,
      dateEnvoye: dateEnvoye ?? this.dateEnvoye,
    );
  }

  factory NotificationAdmin.fromJson(Map<String, dynamic> json) {
    return NotificationAdmin(
      idNotif: json['id_notif'],
      idAdmin: json['id_admin'],
      sujet: json['sujet'],
      contenu: json['contenu'],
      cible: json['cible'],
      dateEnvoye: json['date_envoye'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_notif'] = this.idNotif;
    data['id_admin'] = this.idAdmin;
    data['sujet'] = this.sujet;
    data['contenu'] = this.contenu;
    data['cible'] = this.cible;
    data['date_envoye'] = this.dateEnvoye;
    return data;
  }
}
