import 'package:webfinger/webfinger.dart';

void main() {
  var jrd = JsonResourceDescriptor(
    subject: Uri.parse('acct:carol@example.com'),
    links: [
      LinkRelation(
        rel: 'http://openid.net/specs/connect/1.0/issuer',
        href: Uri.parse('https://openid.example.com'),
      ),
    ],
  );

  print(jrd.toJson());
}
