import 'dart:convert';

import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyC9hmZcrOR5EsN4NR9bxe_5djslIvkymqo';

class LocationService {
  static Future<String> getAddressFromLatLng(
      double latitude, double longitude) async {
    final String path =
        '/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY';
    final _result = await http.get(Uri.https('maps.googleapis.com', path));
    final Map<String, dynamic> _jsonResult = jsonDecode(_result.body);

    return _jsonResult['results'][0]['formatted_address'];
  }
}
