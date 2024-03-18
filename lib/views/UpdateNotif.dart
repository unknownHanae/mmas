import 'package:provider/provider.dart';

import '../models/NotificationModel.dart';
import '../providers/NoticationContr.dart';
import 'package:flutter/material.dart';

import '../providers/admin_provider.dart';

class EditNotificationDialog extends StatefulWidget {
  final NotificationAdmin notification;
  final Function onNotificationUpdated;

  EditNotificationDialog(
      {required this.notification, required this.onNotificationUpdated});

  @override
  _EditNotificationDialogState createState() => _EditNotificationDialogState();
}

class _EditNotificationDialogState extends State<EditNotificationDialog> {
  final _formKey = GlobalKey<FormState>();
  late NotificationAdmin _updatedNotification;
  ScrollController _scrollController = ScrollController();

  TextEditingController _textEditingController = TextEditingController();
  int _characterCount = 0;

  String token = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      token = context.read<AdminProvider>().admin.token;
    });
    _updatedNotification = widget.notification;
    _characterCount = widget.notification.contenu!.length;
  }

  void updateCharacterCount(String value) {
    setState(() {
      _characterCount = value.length;
    });
  }

  // show date time picker
  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: // parse date
      DateTime.parse(widget.notification.dateEnvoye!),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    // time
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          // parse time
          DateTime.parse(widget.notification.dateEnvoye!),
        ),
      );

      if (time != null) {
        setState(() {
          final dateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );

          _updatedNotification =
              _updatedNotification.copyWith(dateEnvoye: dateTime.toString());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.orange,
        ),
      ),
      scrollable: true,
      title: Text('Modifier une notification'),
      icon: Icon(Icons.edit),
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      iconColor: Colors.orange,
      content: Form(
        key: _formKey,
        // onwillpop

        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: widget.notification.sujet,
                decoration: InputDecoration(
                  labelText: 'Sujet',
                  hintText: 'Sujet de la notification',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gapPadding: 4,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduisez un sujet';
                  }
                  return null;
                },
                onSaved: (value) {
                  _updatedNotification =
                      _updatedNotification.copyWith(sujet: value!);
                },
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.notification.contenu,
                        decoration: InputDecoration(
                          labelText: 'Contenu',
                          hintText: 'Contenu de la notification',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gapPadding: 4,
                          ),
                        ),
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introduisez un contenu';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _updatedNotification =
                              _updatedNotification.copyWith(contenu: value!);
                        },
                        onChanged: (value) {
                          // Scroll to the end of the content whenever the text changes
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
                          updateCharacterCount(value);
                        },
                      ),
                      Container(
                        // no padding
                          padding: EdgeInsets.zero,
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '$_characterCount',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              // dropdown menu for cible de notification
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Cible de notification',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gapPadding: 4,
                  ),
                ),
                value: widget.notification.cible,
                items: [
                  DropdownMenuItem(
                    child: Text('Clients'),
                    value: 'Clients',
                  ),
                  DropdownMenuItem(
                    child: Text('Contrats impayes'),
                    value: 'Contrats Impayes',
                  ),
                  DropdownMenuItem(
                    child: Text('Contrats expires'),
                    value: 'Contrats Expires',
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduisez une cible de notification';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _updatedNotification =
                        _updatedNotification.copyWith(cible: value.toString());
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Date d\'envoie: ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextButton(
                          child: Text(
                            _updatedNotification.dateEnvoye!,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _pickDateTime,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('FERMER'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('MODIFIER'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              try {
                await NotificationAdminController().updateNotification(
                    widget.notification.idNotif!, _updatedNotification, token);
                widget.onNotificationUpdated();
                final snackBar = SnackBar(
                  content: Text('Notification modifiée avec succès'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
