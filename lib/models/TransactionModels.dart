//SELECT `id_tran`, `date`,
// `Type`, `montant`, `Mode_réglement`, `description`, `id_contrat` FROM `transaction` WHERE 1
class Transaction {
  int? id_tran;
  DateTime? date;
  bool? Type;
  String? montant;
  String? Mode_reglement;
  String? description;
  String? contrat;
  int? id_contrat;
  String? client;
  String? image;

  int? id_admin;
  String? mail_admin;


  Transaction({
    this.id_tran,
    this.date,
    this.Type,
    this.montant,
    this.contrat,
    this.Mode_reglement,
    this.description,
    this.id_contrat,
    this.client,
    this.image,
    this.id_admin,

    this.mail_admin,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    id_tran = json['id_tran'];
    date = DateTime.parse(json['date']) ;
    Type = json['Type'];
    montant = "${json['montant']}";
    Mode_reglement = json['Mode_reglement'];
    description = json['description'];
    id_contrat = json['id_contrat'];
    client = json["client"];
    contrat = json["contrat"];
    image = json["image"];
    mail_admin = json["admin"];

    id_admin = json["id_admin"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_tran'] = id_tran;
    data['date'] = date;
    data['Type'] = Type;
    data['montant'] = montant;
    data['contrat'] = contrat;
    data['Mode_reglement'] = Mode_reglement;
    data['description'] = description;
    data['id_contrat'] = id_contrat;

    return data;
  }

}