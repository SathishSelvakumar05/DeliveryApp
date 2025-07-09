import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class WalkTrackerScreen extends StatefulWidget {
  @override
  _WalkTrackerScreenState createState() => _WalkTrackerScreenState();
}

class _WalkTrackerScreenState extends State<WalkTrackerScreen> {
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  StreamSubscription<Position>? positionStream;
  Position? lastPosition;
  double totalDistance = 0.0;

  String get formattedDuration {
    final duration = stopwatch.elapsed;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always && permission != LocationPermission.whileInUse) {
        return;
      }
    }

    stopwatch.start();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {});
    });

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Minimum movement in meters to trigger update
      ),
    ).listen((Position position) {
      if (lastPosition != null) {
        final distance = Geolocator.distanceBetween(
          lastPosition!.latitude,
          lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        setState(() {
          totalDistance += distance;
        });
      }
      lastPosition = position;
    });
  }

  void stopTracking() {
    stopwatch.stop();
    timer?.cancel();
    positionStream?.cancel();
  }

  void resetTracking() {
    stopTracking();
    setState(() {
      stopwatch.reset();
      totalDistance = 0.0;
      lastPosition = null;
    });
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final distanceInKm = (totalDistance / 1000).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(title: Text('Walk Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Time Walked:', style: TextStyle(fontSize: 20)),
            Text(formattedDuration, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            Text('Distance Walked:', style: TextStyle(fontSize: 20)),
            Text('$distanceInKm km', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: startTracking, child: Text('Start')),
                ElevatedButton(onPressed: stopTracking, child: Text('Stop')),
                ElevatedButton(onPressed: resetTracking, child: Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
