/*
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';

const String googleApiKey = 'AIzaSyC5SPn1sGWcpdDoOQftQnOsC4RPAYxBy_g';
final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleApiKey);

class SimplePlacePicker extends StatelessWidget {
  const SimplePlacePicker({super.key});

  void _handlePlace(Prediction prediction, BuildContext context) async {
    final placeId = prediction.placeId;
    if (placeId == null) return;

    final response = await _places.getDetailsByPlaceId(placeId);
    final result = response.result;

    final lat = result.geometry?.location.lat;
    final lng = result.geometry?.location.lng;

    // Parse components
    String? country, state, city;
    for (var component in result.addressComponents) {
      if (component.types.contains('country')) country = component.longName;
      if (component.types.contains('administrative_area_level_1')) state = component.longName;
      if (component.types.contains('locality')) city = component.longName;
      if (city == null && component.types.contains('administrative_area_level_2')) {
        city = component.longName;
      }
    }

    // Show result
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(result.name),
        content: Text(
          '📍 Place: ${result.formattedAddress}\n'
              '🗺 Country: $country\n'
              '🏙 State: $state\n'
              '🏡 City: $city\n'
              '🌐 LatLng: ($lat, $lng)',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick a Place")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final prediction = await PlacesAutocomplete.show(
              context: context,
              apiKey: googleApiKey,
              mode: Mode.overlay,
              language: "en",
            );

            if (prediction != null) {
              _handlePlace(prediction, context);
            }
          },
          child: const Text("Search Place"),
        ),
      ),
    );
  }
}
*/
