import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Location'),
      ),
      body: Center(
        child: _currentPosition != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Latitude: ${_currentPosition!.latitude}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Longitude: ${_currentPosition!.longitude}',
                    style: TextStyle(fontSize: 20),
                  ),
                  // Display map here using retrieved location
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
