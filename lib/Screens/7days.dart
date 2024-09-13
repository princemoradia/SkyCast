// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class days7report extends StatefulWidget {
//   final String region;
//   const days7report({super.key, required this.region});

//   @override
//   State<days7report> createState() => _days7reportState();
// }

// class _days7reportState extends State<days7report> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetch7daysWeatherData(widget.region);
//   }

//   List<dynamic> forcast7days = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }

//   void fetch7daysWeatherData(String region) async {
//     final url = Uri.parse(
//         'http://api.weatherapi.com/v1/forecast.json?key=420dc0f4a9374703a54153251240506&q=$region&days=3&aqi=no&alerts=no');
//     final result = await http.get(url);
//     final body = result.body;
//     final json = jsonDecode(body);

//     setState(() {
//       forcast7days = json['forecast']['forecastday'];
//     });
//     for (int i = 0; i < forcast7days.length; i++) {
//       print('${i + 1}');
//       print(forcast7days[i]['hour']);
//     }
//   }
// }
