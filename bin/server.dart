import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:work_helper/fetch_service.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/notifications/<site>', _siteNotifications)
  ..get('/echo/<message>', _echoHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hi, i am helper, how could i can help you, /helpers\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Map<String, List<String>> sitesNotifications = {};

Future<Response> _siteNotifications(Request request) async {
  final siteDomainName = request.params['site'];
  var r = await fetchMostagleNotifications();

  return Response.ok('${sitesNotifications[siteDomainName]}\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);

  await loadTasks();

  // startTasks();

  print('Server listening on port ${server.port}');
}

/// Load the saved tasks on start
Future<void> loadTasks() async {}

/// Start Loaded Tasks
void startTasks() async {
  var r =  await fetchMostagleNotifications();
  sitesNotifications.addAll(r);
}
