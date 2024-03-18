
import 'SeanceModels.dart';

class PresenceProf {
  int? id_reservation;
  int? id_prof;
  int? id_seance;
  String? date_pres;
  bool? presence;
  String? motif_abs;
  String? client;
  String? cour;
  String? coach;
  String? heur_debut;
  String? heure_fin;
  String? salle;
  String? day_name;

  Seance? seance;

  PresenceProf({
    this.id_reservation,
    this.id_prof,
    this.id_seance,
    this.date_pres,
    this.presence,
    this.motif_abs,
    this.client,
    this.cour,
    this.coach,
    this.heur_debut,
    this.heure_fin,
    this.salle,
    this.day_name,
    this.seance
  });

  PresenceProf.fromJson(Map<String, dynamic> json) {
    id_reservation = json['id_reservation'];
    id_prof = json['id_prof'];
    id_seance = json['id_seance'];
    date_pres = json['date_pres'];
    presence = json['presence'];
    motif_abs = json['motif_abs'];
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
    data['id_prof'] = id_prof;
    data['id_seance'] = id_seance;
    data['presence'] = presence;
    data['motif_abs'] = motif_abs;
    data['heur_debut'] = heur_debut;
    data['heure_fin'] = heure_fin;
    return data;
  }

}