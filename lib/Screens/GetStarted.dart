import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skycast/Screens/homesc.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  double? lat;
  double? long;

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });
      print('Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _checkPermissionsAndFetchLocation() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      if (await Permission.location.request().isGranted) {
        await getLocation();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    } else {
      await getLocation();
    }

    if (lat != null && long != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(latitude: lat!, longitude: long!),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get location')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop =
        kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isDesktop ? 500 : null,
              height: isDesktop ? 500 : null,
              child: Lottie.asset(
                'assets/lotties/w3.json',
              ),
            ),
            Center(
              child: SizedBox(
                width: 350,
                height: 55,
                child: ElevatedButton(
                  onPressed:
                      _checkPermissionsAndFetchLocation
                  ,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 135, 114, 241)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
