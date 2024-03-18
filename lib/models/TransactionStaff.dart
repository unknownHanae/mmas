//SELECT `id_tran`, `date`,
// `Type`, `montant`, `Mode_réglement`, `description`, `id_contrat` FROM `transaction` WHERE 1
class Transactionstaff {
  int? id_tran;
  DateTime? date;
  String? salaire;
  int? id_contrat_staff;
  String? staff;
  String? image;

  int? id_admin;
  String? mail_admin;


  Transactionstaff({
    this.id_tran,
    this.date,
    this.salaire,
    this.id_contrat_staff,
    this.staff,
    this.image,
    this.id_admin,

    this.mail_admin,
  });

  Transactionstaff.fromJson(Map<String, dynamic> json) {
    id_tran = json['id_tran'];
    date = DateTime.parse(json['date']) ;
    salaire = "${json['salaire']}";

    id_contrat_staff = json['id_contrat_staff'];
    staff = json["staff"];
    image = json["image"];
    mail_admin = json["admin"];

    id_admin = json["id_admin"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_tran'] = id_tran;
    data['date'] = date;
    data['id_admin'] = id_admin;
    data['id_contrat_staff'] = id_contrat_staff;

    return data;
  }

}
