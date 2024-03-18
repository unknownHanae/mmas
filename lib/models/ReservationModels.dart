
import 'SeanceModels.dart';

class Reservation {
  int? id_reservation;
  int? id_etd;
  int? id_seance;
  String? date_operation;
  String? date_presence;
  bool? status;
  bool? presence;
  String? motif_annulation;
  String? client;
  String? cour;
  String? coach;
  String? heur_debut;
  String? heure_fin;
  String? salle;
  String? day_name;

  Seance? seance;

  Reservation({
    this.id_reservation,
    this.id_etd,
    this.id_seance,
    this.date_operation,
    this.date_presence,
    this.status,
    this.presence,
    this.motif_annulation,
    this.client,
    this.cour,
    this.coach,
    this.heur_debut,
    this.heure_fin,
    this.salle,
    this.day_name,
    this.seance
  });

  Reservation.fromJson(Map<String, dynamic> json) {
    id_reservation = json['id_reservation'];
    id_etd = json['id_etd'];
    id_seance = json['id_seance'];
    date_operation = json['date_operation'];
    date_presence = json['date_presence'];
    status = json['status'];
    presence = json['presence'];
    motif_annulation = json['motif_annulation'];
    client = json['client'] ?? "";
    cour = json['cour']?? "";
    coach = json['coach']?? "";
    heur_debut = json['heur_debut']?? "";
    heure_fin = json['heure_fin']?? "";
    salle = json['salle']?? "";
    day_name = json['day_name']?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_reservation'] = id_reservation;
    data['id_etd'] = id_etd;
    data['id_seance'] = id_seance;
    data['date_operation'] = date_operation;
    data['status'] = status;
    data['presence'] = presence;
    data['motif_annulation'] = motif_annulation;
    data['heur_debut'] = heur_debut;
    data['heure_fin'] = heure_fin;
    return data;
  }

}