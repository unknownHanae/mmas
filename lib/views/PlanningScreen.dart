import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:time_planner/time_planner.dart';

import '../models/SeanceModels.dart';
import 'package:intl/intl.dart';


class PlanningScreen extends StatefulWidget {
  PlanningScreen({Key? key, required this.seances}) : super(key: key);

  List<Seance> seances = [];

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  List<TimePlannerTask>  planning = [];

  String cour_name = "";


  List<Color?> colors = [
    Colors.orangeAccent,
    Colors.orange,
    Colors.grey,
    Colors.lightBlueAccent,
    Colors.blueGrey
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.seances != null){

      if(widget.seances.length > 0){
        setState(() {
          cour_name = widget.seances[0].cour!;
        });
      }

      _future = getData();



    /*  for(var i=0; i<widget.seances.length; i++){
        setState(() {
          cour_name = widget.seances[i].cour!;
        });
          var times = widget.seances[i].heure_debut!.split(":");
          var format = DateFormat("HH:mm:ss");
          var one = format.parse(widget.seances[i].heure_debut!);
          var two = format.parse(widget.seances[i].heure_fin!);
          print("duration ${two.difference(one)}");
          var duration = two.difference(one);

          print("duration im min ${duration.inMinutes}");

          planning.add(TimePlannerTask(
           // background color for task
            color: colors[Random().nextInt(colors.length)],
            // day: Index of header, hour: Task will be begin at this hour
            // minutes: Task will be begin at this minutes
            dateTime: TimePlannerDateTime(day: widget.seances[i].jour!-1, hour: int.parse(times[0]), minutes: int.parse(times[1])),

            // Minutes duration of task
            minutesDuration: duration.inMinutes,
            // Days duration of task (use for multi days task)
            daysDuration: 1,

            onTap: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Cour: ${widget.seances[i].cour!} - Jour: ${widget.seances[i].day_name!}'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Coach: ${widget.seances[i].coach!}'),
                          Text('Heure debut: ${widget.seances[i].heure_debut!}'),
                          Text('Heure fin: ${widget.seances[i].heure_fin!}'),
                          Text('Salle: ${widget.seances[i].salle!}'),
                          Text('Capacite: ${widget.seances[i].capacity!}'),
                          Text('Duree: ${duration.inMinutes} min'),
                          Text('Date reservation: ${widget.seances[i].date_reservation!}'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Selection', style: TextStyle(color: Colors.green),),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop({
                            "selected": true,
                            "seance": widget.seances[i]
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Text(
                    'Cour: ${widget.seances[i].cour!}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  duration.inMinutes > 30 ? Text(
                    'Coach: ${widget.seances[i].coach!}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ):SizedBox(width: 0,),

                ],
              ),
            ),
          ));
      }
*/

    }
  }

  var days = {
    1: "Lundi",
    2: "Mardi",
    3: "Mercredi",
    4: "Jeudi",
    5: "Vendredi",
    6: "Samedi",
    7: "Dimanche"
  };

  var _future;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Planning - cours : ${cour_name}"), leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(
            {
              "selected": false,
              "seance": null
            }
        ),
      ), ),
      body:
      FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            return SafeArea(
              child: Container(
                  child: SfCalendar(

                    view: CalendarView.week,
                    firstDayOfWeek: 1,
                    minDate: DateTime.now(),
                    maxDate: DateTime.now().add(Duration(days: 7)),
                    timeSlotViewSettings: TimeSlotViewSettings(
                      startHour: 6,
                      endHour: 22,
                      dayFormat: 'EEEE',
                      timeFormat: 'HH:mm',

                    ),
                    initialDisplayDate: DateTime(2017, 6, 01, 9, 0, 0),
                    dataSource: MeetingDataSource(snapshot.data),
                    onTap: calendarTapped,
                  )),
            );
          } else {
            return Container(
              child: Center(
                child: Text('Aucune donnée à afficher'),
              ),
            );
          }
        },
      ),

    );
  }

  Future<List<Meeting>> getData() async {

    final List<Meeting> appointmentData = [];
    final Random random = new Random();

    if (widget.seances != null) {

      print("nb seances ${widget.seances.length}");
      print("nb appointmentData ${appointmentData.length}");
      widget.seances.forEach((seance) {
        print("seance id ${seance.id_seance}");
        //var date = DateTime.now();
        try{
          print("date fin ${seance.date_reservation} ${seance.heure_fin}");
          print("date ${DateTime.parse("${seance.date_reservation} ${seance.heure_fin}")}");
          appointmentData.add(
              Meeting(
                seance_id: seance.id_seance!,
                eventName: "${seance.cour!}\n${seance.salle!}",
                from: DateTime.parse("${seance.date_reservation} ${seance.heure_debut}"),
                to: DateTime.parse("${seance.date_reservation} ${seance.heure_fin}"),
                background: (seance.capacity! - seance.nb_reservations!) == 0 ? Colors.black : colors[random.nextInt(5)]!,
                isAllDay: false,

              )
          );
        }catch(e){
          print(e);
        }

      });
      print("nb appointmentData 2 ${appointmentData.length}");
      return appointmentData;

    } else {
      throw Exception('Failed to load data');
    }


  }

  void calendarTapped(CalendarTapDetails details) {

    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Meeting appointmentDetails = details.appointments![0];
      print(appointmentDetails.seance_id);
      Seance seance = widget.seances.where((element) => element.id_seance == appointmentDetails.seance_id).first;
      var format = DateFormat("HH:mm:ss");
      var one = format.parse(seance.heure_debut!);
      var two = format.parse(seance.heure_fin!);

      print("duration ${two.difference(one)}");
      var duration = two.difference(one);

      print(seance.toJson());

      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cours: ${seance.cour!} - Jour: ${seance.day_name!}'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Coach: ${seance.coach!}'),
                  Text('Heure debut: ${seance.heure_debut!}'),
                  Text('Heure fin: ${seance.heure_fin!}'),
                  Text('Salle: ${seance.salle!}'),
                  Text('Capacite: ${seance.capacity!}'),
                  Text('Duree: ${duration.inMinutes} min'),
                  Text('Nombre de reservations: ${seance.nb_reservations!}'),
                  Text('Places disponibles: ${seance.capacity! - seance.nb_reservations!}'),
                ],
              ),
            ),
            actions: <Widget>[
              (seance.capacity! - seance.nb_reservations!) > 0 ? TextButton(
                child: const Text('Reserver', style: TextStyle(color: Colors.orange)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(
                      {
                        "selected": true,
                        "seance": seance
                      });
                },
              ) : Text('vous ne pouvez pas réserver', style: TextStyle(color: Colors.red)),


              TextButton(
                child: const Text('Fermer', style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting({required this.seance_id, required this.eventName, required this.from, required this.to, required this.background, required this.isAllDay});

  int seance_id;
  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}

