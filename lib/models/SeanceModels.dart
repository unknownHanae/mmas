
import 'dart:ui';

class Seance {
  int? id_seance;
  int? id_cour;
  int? id_prof;
  int? id_salle;
  int? capacity;
  int? jour;
  String? heure_debut;
  String? heure_fin;
  String? cour;
  String? color;
  Color? colorfinal;
  String? coach;
  String? salle;
  String? Nivea;
  String? classe;
  String? day_name;
  int? nb_reservations;
  int? id_classe;


  String? date_reservation;

  List<dynamic>? reservations;

  Seance({
    this.id_seance,
    this.id_cour,
    this.id_prof,
    this.id_salle,
    this.capacity,
    this.jour,
    this.heure_debut,
    this.heure_fin,
    this.color,
    this.colorfinal,
    this.cour,
    this.coach,
    this.salle,
    this.Nivea,
    this.day_name,
    this.date_reservation,
    this.nb_reservations,
    this.reservations,
    this.id_classe,

    this.classe,
  });

  Seance.fromJson(Map<String, dynamic> json) {
    id_seance = json['id_seance'];
    id_cour = json['id_cour'];
    id_prof = json['id_prof'];
    id_salle = json['id_salle'];
    capacity = json['capacity'];
    jour = json['jour'];
    heure_debut = json['heure_debut'];
    heure_fin = json['heure_fin'];
    cour = json['cour'];
    coach = json['coach'];
    salle = json['salle'];
    color = json['color'];
    Nivea = json['Nivea'];
    day_name = json['day_name'];

    classe = json['classe'];
    id_classe = json['id_classe'];
    date_reservation = json["date_reservation"] ?? json["date_reservation"];
    nb_reservations = json["nb_reservations"] ?? json["nb_reservations"];
    reservations = json["reservations"] ?? json["reservations"];
    if(json['color'] != null && json['color'].toString().isNotEmpty){
      String stringcolor = json['color'].split('(0x')[1].split(')')[0];
      int value = int.parse(stringcolor, radix: 16);
      colorfinal = new Color(value) ;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_seance'] = id_seance;
    data['id_cour'] = id_cour;
    data['id_prof'] = id_prof;
    data['id_salle'] = id_salle;
    data['capacity'] = capacity;
    data['jour'] = jour;
    data['heure_debut'] = heure_debut;
    data['classe'] = classe;
    data['heure_fin'] = heure_fin;
    data['cour'] = cour;
    data['id_classe'] = id_classe;
    data['coach'] = coach;
    data['salle'] = salle;
    data['color'] = color;
    data['day_name'] = day_name;
    data['nb_reservations'] = nb_reservations;
    return data;
  }

}