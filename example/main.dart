import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:logging/logging.dart';
import 'package:webfinger/webfinger.dart';

main() async {
  var app = Angel();
  var http = AngelHttp(app);
  app.logger = Logger('webfinger')
    ..onRecord.listen((rec) {
      print(rec);
      if (rec.error is AngelHttpException &&
          (rec.error as AngelHttpException).statusCode != 500) return;
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });

  app.get('/.well-known/webfinger', (req, res) {
    var resource = req.queryParameters['resource'];
    var rels = req.uri.queryParametersAll['rel'];

    if (resource == null)
      throw AngelHttpException.badRequest(message: 'Missing "resource".');

    var subject = Uri.parse(resource);

    if (subject.scheme != 'acct')
      throw AngelHttpException.badRequest(
          message: 'Resource must have "acct" scheme.');

    if (subject.hasEmptyPath)
      throw AngelHttpException.badRequest(
          message: 'Resource is missing path component.');

    return JsonResourceDescriptor(
      subject: subject,
      properties: {
        Uri.parse('https://dartlang.org'): 'pub',
      },
      links: rels?.map(
        (rel) {
          return LinkRelation(
            rel: rel,
            type: JsonResourceDescriptor.contentType.toString(),
          );
        },
      ),
    );
  });

  app.fallback((req, res) {
    print('uhhh: ${req.uri}');
    throw AngelHttpException.notFound();
  });

  // Start listening...
  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
}
