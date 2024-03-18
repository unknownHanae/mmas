import 'constants.dart';

class API {
  static const String BASE_URL = '$HOST/api/';
  static const String CATEGORIES_ENDPOINT = BASE_URL + 'category/';
  static const String ETABLISSEMENTS_ENDPOINT = BASE_URL + 'etablissements/';
  static const String CLIENTS_ENDPOINT = BASE_URL + 'clients/';
  static const String COACH_ENDPOINT = BASE_URL + 'coach/';
  static const String SALLE_ENDPOINT = BASE_URL + 'salle/';
  static const String ABONNEMENT_ENDPOINT = BASE_URL + 'abonnement/';
  // media
  static const String MEDIA_ENDPOINT = '$HOST/media/';
  static const String MEDIA_SALLES_ENDPOINT = MEDIA_ENDPOINT + 'salles/';
  // dashboard urls
  static const String CLIENT_STATUT_COUNT = BASE_URL + 'clients/status/';
  static const String CLIENT_UPCOMING_BIRTHDAYS = BASE_URL + 'clients/age/';
  static const String CLIENT_CONTRACT_TYPE =
      BASE_URL + 'clients/contracts/type/';
  static const String Salarie_by_contrat =
      BASE_URL + 'Salarie_by_contrat';
  static const String cours_by_etud =
      BASE_URL + 'cours_by_etud';
  static const String Etudiant_by_niveau =
      BASE_URL + 'Etudiant_by_niveau';
  static const String CLIENT_CONTRACT_UNPAID =
      BASE_URL + 'clients/contracts/unpaidClients/';
  static const String CLIENT_CONTRACT_EXPIRING =
      BASE_URL + 'clients/contracts/expiring/';
  static const String TRANSACTION_DATA = BASE_URL + 'revenue-and-transactions/';
  static const String NUMBER_OF_SESSIONS = BASE_URL + 'number-of-sessions/';
  static const String NUMBER_OF_RESERVATIONS = BASE_URL + 'number-of-reservations/';
  static const String RESERVATIONS_BY_DATE_AND_COURSE =
      BASE_URL + 'reservations/date/course/';

// notifications
  static const String NOTIFICATIONS_ENDPOINT = BASE_URL + 'notifications/';
  static const String NOTIFICATIONS_VALID_ENDPOINT =
      BASE_URL + 'validation/notification/';
  static const String NOTIFICATIONS_ENDPOINTlast_id =
      BASE_URL + 'notification/last/';
  // send notification
  static const String SEND_NOTIFICATION_ENDPOINT = BASE_URL + 'send/notification/';
  // http://127.0.0.1:8000/api/valid-notifications/
  static const String VALID_NOTIFICATIONS_ENDPOINT = BASE_URL + 'valid-notifications/';
// clients
}