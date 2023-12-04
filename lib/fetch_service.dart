import 'package:http/http.dart';

Future<dynamic> fetchMostagleNotifications() async {
  var res = await get(
    Uri.parse('https://mostaql.com/notifications'),
    headers: <String, String>{},
  );

  print(res.statusCode);
  print(res.headers);
  print(res.body);
}
