import 'dart:convert';

import 'package:http/http.dart' as http;

class GooglePlacesRepository {
  GooglePlacesRepository(this._apiKey);

  final String _apiKey;

  static const _autocompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const _detailsUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';

  Future<List<({String description, String placeId})>> autocomplete(String input,
      {int limit = 5}) async {
    if (input.isEmpty) return [];

    final uri = Uri.parse(
        '$_autocompleteUrl?key=$_apiKey&input=${Uri.encodeComponent(input)}&components=country:in');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Google Autocomplete error: ${resp.body}');
    }
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final preds = (json['predictions'] as List?) ?? [];

    return preds.take(limit).map((p) {
      return (
        description: p['description'] as String? ?? '',
        placeId: p['place_id'] as String? ?? '',
      );
    }).toList();
  }

  /// Returns (formattedAddress, lat, lng)
  Future<({String address, double lat, double lng})> getDetails(String placeId) async {
    final uri = Uri.parse(
        '$_detailsUrl?key=$_apiKey&place_id=$placeId&fields=formatted_address,geometry');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Google Place Details error: ${resp.body}');
    }
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final result = json['result'] as Map<String, dynamic>? ?? {};
    final geom = result['geometry'] as Map<String, dynamic>?;
    final loc = geom?['location'] as Map<String, dynamic>?;
    final lat = (loc?['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (loc?['lng'] as num?)?.toDouble() ?? 0.0;
    return (
      address: result['formatted_address'] as String? ?? '',
      lat: lat,
      lng: lng,
    );
  }
} 