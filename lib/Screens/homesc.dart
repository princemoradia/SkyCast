import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  final double latitude, longitude;
  const HomeScreen(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    fetchWeatherData(widget.latitude, widget.longitude);
  }

  TextEditingController cityname = TextEditingController();
  bool isLoading = true;
  bool isError = false;
  List<dynamic> forecast = [];
  Map<String, String> data = {
    'name': '',
    'region': '',
    'country': '',
    'weather': '',
    'icon': '',
    'wind_dir': '',
    'temp_c': '',
    'temp_f': '',
    'uv': '',
    'time_zone': '',
    'wind_speed': '',
    'pressure': '',
    'humidity': '',
  };
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 135, 114, 241),
        body: isLoading
            ? Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.white12,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 200,
                        height: 20,
                        color: Colors.white12,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 150,
                        height: 20,
                        color: Colors.white12,
                      ),
                    ],
                  ),
                ),
              )
            : isError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Error fetching weather data',
                          style: TextStyle(fontFamily: 'Gotham'),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              fetchWeatherData(
                                  widget.latitude, widget.longitude);
                            },
                            child: const Text('Retry',
                                style: TextStyle(fontFamily: 'Gotham'))),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const CircleAvatar(
                              radius:20,
                              backgroundColor: Colors.white24,
                              child: Icon(
                                Icons.home_outlined,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(40),
                              onTap: () {
                                _displayRegionInputDialog(context);
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white24,
                                child: Icon(Icons.search,
                                    size: 24, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18),
                        child: Text(
                          '${data['name']}, ${data['region']}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Gotham',
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        '${data['weather']}',
                        style: const TextStyle(
                            fontFamily: 'Gotham',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${data['temp_c']}\u2103 | ${data['temp_f']}\u2109',
                        style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Gotham',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Image.network('https:${data['icon']}'),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 500,
                          height: 55,
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                      '${data['wind_speed']}km/h ${data['wind_dir']}',
                                      style: const TextStyle(
                                          fontFamily: 'Gotham')),
                                  const Text(
                                    'wind',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gotham'),
                                  )
                                ],
                              ),
                              Text(
                                '|',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey.shade600,
                                    fontFamily: 'Gotham'),
                              ),
                              Column(
                                children: [
                                  Text('${data['pressure']}mbar'),
                                  const Text(
                                    'pressure',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gotham'),
                                  )
                                ],
                              ),
                              Text(
                                '|',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey.shade600,
                                    fontFamily: 'Gotham'),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${data['humidity']}%',
                                    style:
                                        const TextStyle(fontFamily: 'Gotham'),
                                  ),
                                  const Text(
                                    'humidity',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gotham'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Today',
                                style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Gotham')),
                            // InkWell(
                            //   borderRadius: BorderRadius.circular(20),
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => days7report(
                            //             region: data['name'].toString(),
                            //           ),
                            //         ));
                            //   },
                            //   child: const SizedBox(
                            //     child: Row(
                            //       children: [
                            //         // Text('3 days '),
                            //         Padding(
                            //           padding: EdgeInsets.all(8.0),
                            //           child: Icon(
                            //             Icons.arrow_forward_ios,
                            //             size: 20,
                            //             color: Colors.black,

                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 8,
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final fdata = forecast[index];
                              final fcondition = fdata['condition']['text'];
                              final ftemp = fdata['temp_c'].toString();
                              final ficon = fdata['condition']['icon'];
                              final fwind = fdata['wind_kph'].toString();
                              final fhumidity = fdata['humidity'].toString();
                              final fpressure = fdata['pressure_mb'].toString();
                              final fcrain = fdata['chance_of_rain'].toString();
                              List<String> fdtime =
                                  fdata['time'].toString().split(' ');
                              return Container(
                                width: 180,
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      fdtime[1],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontFamily: 'Gotham',
                                          color: Color.fromARGB(
                                              245, 255, 255, 255)),
                                    ),
                                    Text(
                                      '$ftemp\u2103',
                                      style: const TextStyle(
                                          fontFamily: 'Gotham',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                          color: Colors.black45),
                                    ),
                                    Image.network('https:$ficon'),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(fcondition,
                                                  style: const TextStyle(
                                                      // fontSize: 10,
                                                      fontFamily: 'Gotham',
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ]),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, left: 4.0, right: 4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  fwind,
                                                  style: const TextStyle(
                                                      fontFamily: 'Gotham'),
                                                ),
                                                const Text(
                                                  'km/h',
                                                  style: TextStyle(
                                                      fontFamily: 'Gotham'),
                                                )
                                              ],
                                            ),
                                            Text(
                                              '|',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                  fontFamily: 'Gotham'),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  fhumidity,
                                                  style: TextStyle(
                                                      fontFamily: 'Gotham'),
                                                ),
                                                const Text(
                                                  '%',
                                                  style: TextStyle(
                                                      fontFamily: 'Gotham'),
                                                )
                                              ],
                                            ),
                                            Text(
                                              '|',
                                              style: TextStyle(
                                                  fontFamily: 'Gotham',
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600),
                                            ),
                                            Column(
                                              children: [
                                                Text(fpressure,
                                                    style: const TextStyle(
                                                        fontFamily: 'Gotham')),
                                                const Text(
                                                  'mbar',
                                                  style: TextStyle(
                                                      fontFamily: 'Gotham'),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        'Rain chances:$fcrain%',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Gotham',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: forecast.length,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
      ),
    );
  }

  void fetchWeatherData(double ulat, double ulong) async {
    try {
      final url = Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=420dc0f4a9374703a54153251240506&q=$ulat,$ulong&days=1&aqi=no&alerts=no');
      final result = await http.get(url);
      final body = result.body;
      final json = jsonDecode(body);

      setState(() {
        data['name'] = json['location']['name'];
        data['region'] = json['location']['region'];
        data['country'] = json['location']['country'];
        data['weather'] = json['current']['condition']['text'];
        data['icon'] = json['current']['condition']['icon'];
        data['wind_dir'] = json['current']['wind_dir'];
        data['temp_c'] = json['current']['temp_c'].toString();
        data['temp_f'] = json['current']['temp_f'].toString();
        data['uv'] = json['current']['uv'].toString();
        data['time_zone'] = json['location']['tz_id'];
        data['wind_speed'] = json['current']['wind_kph'].toString();
        data['pressure'] = json['current']['pressure_mb'].toString();
        data['humidity'] = json['current']['humidity'].toString();
        forecast = json['forecast']['forecastday'][0]['hour'];
      });

      print('---------------------forecast data------------------');
      print(forecast);
      print('---------------------Weather data------------------');
      print(data);
      isLoading = false;
      isError = false;
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        print('Error fetching weather data: $e');
      });
    }
  }

  void fetchWeatherDatabyRegion(String region) async {
    try {
      const apikey = "420dc0f4a9374703a54153251240506";
      final url = Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$region&days=1&aqi=no&alerts=no');
      final result = await http.get(url);
      final body = result.body;
      final json = jsonDecode(body);

      setState(() {
        data['name'] = json['location']['name'];
        data['region'] = json['location']['region'];
        data['country'] = json['location']['country'];
        data['weather'] = json['current']['condition']['text'];
        data['icon'] = json['current']['condition']['icon'];
        data['wind_dir'] = json['current']['wind_dir'];
        data['temp_c'] = json['current']['temp_c'].toString();
        data['temp_f'] = json['current']['temp_f'].toString();
        data['uv'] = json['current']['uv'].toString();
        data['time_zone'] = json['location']['tz_id'];
        data['wind_speed'] = json['current']['wind_kph'].toString();
        data['pressure'] = json['current']['pressure_mb'].toString();
        data['humidity'] = json['current']['humidity'].toString();
        forecast = json['forecast']['forecastday'][0]['hour'];
      });
      print('---------------------forecast data------------------');
      print(forecast);
      print('---------------------Weather data------------------');
      print(data);
      isLoading = false;
      isError = false;
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        print('Error  $e');
      });
    }
  }

  Future<void> _displayRegionInputDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Enter Region',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 135, 114, 241),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: cityname,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '  Enter City Name',
                          hintStyle:
                              TextStyle(fontSize: 16, fontFamily: 'Gotham'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          var cregion = cityname.text.toString();
                          if (cregion.isNotEmpty) {
                            fetchWeatherDatabyRegion(cityname.text.toString());
                          } else {
                            const CircularProgressIndicator(
                              color: Color.fromRGBO(120, 171, 168, 1),
                            );
                          }
                          cityname.clear();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Search',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Gotham'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
