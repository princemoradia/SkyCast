import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  TextEditingController cityname = TextEditingController();
  Map<String, String> data = {
    'name': '',
    'region': '',
    'country': '',
    'weather': '',
    'icon': '',
    'wind_dir': '',
    'temp_c': '',
    'temp_d': '',
    'uv': '',
    'time_zone': '',
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: TextField(
                    controller: cityname,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter region',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ElevatedButton(
                onPressed: () {
                  final iweather = cityname.text.toString();
                  fetchWeatherData(iweather);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.black),
                child: const Text(
                  'Check',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text('${data['country']}'),
            Text('${data['weather']}'),
            if(cityname.text.isEmpty)...[
              const CircularProgressIndicator(color: Colors.black,),
            ]else
             Image.network('https:${data['icon']}'),
          ],
        ),
      ),
    );
  }

  void fetchWeatherData(String region) async {
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=420dc0f4a9374703a54153251240506&q=$region&aqi=no');
    final result = await http.get(url);
    final body = result.body;
    final json = jsonDecode(body);
    // print(json);
    setState(() {
      data['name'] = json['location']['name'];
      data['region'] = json['location']['region'];
      data['country'] = json['location']['country'];
      data['weather'] = json['current']['condition']['text'];
      data['icon'] = json['current']['condition']['icon'];
      data['wind_dir'] = json['current']['wind_dir'];
      data['temp_c'] = json['current']['temp_c'].toString();
      data['temp_d'] = json['current']['temp_d'].toString();
      data['uv'] = json['current']['uv'].toString();
      data['time_zone'] = json['location']['tz_id'];
    });
    print(data);
  }
}
