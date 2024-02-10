import 'package:url_launcher/url_launcher.dart' as l;

Future<bool> launchUrl(Uri uri) {
  return l.launchUrl(uri, mode: l.LaunchMode.externalApplication);
}

Future<bool> launchEmail(
  String email, {
  String? subject,
}) {
  Map<String, String>? query = {};
  if (subject != null) {
    query.addAll({'subject': subject});
  }
  final emailUri = Uri(
    scheme: 'mailto',
    path: email,
    query: encodeQueryParameters(query),
  );
  return launchUrl(emailUri);
}

String? encodeQueryParameters(Map<String, String>? params) {
  if (params == null) null;

  return params!.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
