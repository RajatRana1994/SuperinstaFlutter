import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/place_picker_google.dart';

const kGoogleApiKey = "AIzaSyBAm6xBQn3Gu6hpjDGtcNY9Od6SMJU6Wnw"; // Replace with your actual API key

class PlacePickerPage extends StatefulWidget {
  const PlacePickerPage({super.key});

  @override
  State<PlacePickerPage> createState() => _PlacePickerPageState();
}

class _PlacePickerPageState extends State<PlacePickerPage> {
  @override
  void initState() {
    super.initState();
    // Wait for build to complete before showing place picker
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openPlacePicker();
    });
  }

  Future<void> _openPlacePicker() async {
    LocationResult? selectedResult;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: kGoogleApiKey,
          initialLocation: const LatLng(28.6139, 77.2090), // Optional
          myLocationEnabled: true,
          onPlacePicked: (result) {
            selectedResult = result;
            Navigator.of(context).pop(); // Close PlacePicker
          },
        ),
      ),
    );

    if (selectedResult != null) {
      final lat = selectedResult!.latLng?.latitude;
      final lng = selectedResult!.latLng?.longitude;
      final country = selectedResult!.country?.longName ?? '';
      final state = selectedResult!.administrativeAreaLevel1?.longName ?? '';

      Navigator.pop(context, {
        'lat': lat,
        'lng': lng,
        'country': country,
        'state': state,
      });
    } else {
      Navigator.pop(context, null); // Cancelled
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // While waiting
    );
  }
}
