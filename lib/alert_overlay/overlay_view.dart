import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class OverlayView extends StatefulWidget {
  const OverlayView({super.key});

  @override
  State<OverlayView> createState() => _OverlayViewState();
}

class _OverlayViewState extends State<OverlayView> {
  final Location _location = Location();
  String currentLoc = "Tap to get location";

  Future<void> _updateLocation() async {
    final data = await _location.getLocation();
    setState(() {
      currentLoc =
      "Lat: ${data.latitude?.toStringAsFixed(5)}, Lng: ${data.longitude?.toStringAsFixed(5)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _updateLocation,
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Text(
            currentLoc,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
