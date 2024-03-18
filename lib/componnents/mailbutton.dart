import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmailButton extends StatelessWidget {
  final List<String> recipients;
  final String subject;
  final String body;

  SendEmailButton({
    required this.recipients,
    required this.subject,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _sendEmail,
      child: Text('Send Email'),
    );
  }

  void _sendEmail() async {
    String formattedRecipients = recipients.join(',');
    String mailToUrl =
        'mailto:$formattedRecipients?subject=$subject&body=$body';

    if (await canLaunch(mailToUrl)) {
      await launch(mailToUrl);
    } else {
      throw 'Could not launch email app.';
    }
  }
}
