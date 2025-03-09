import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wheather_app/additional_Info.dart';
import 'package:wheather_app/hourly_Prediction.dart';
import 'package:http/http.dart' as http;
import 'package:wheather_app/secrets.dart';

class WheatherScreen extends StatefulWidget {
  const WheatherScreen({super.key});

  @override
  State<WheatherScreen> createState() => _WheatherScreenState();
}

class _WheatherScreenState extends State<WheatherScreen> {
  Future<Map<String, dynamic>>? weatherFuture;
  @override
  void initState() {
    super.initState();
    weatherFuture = getCureentWheather(); // Call API once and store result
  }

  Future<Map<String, dynamic>> getCureentWheather() async {
    try {
      String cityName = "mangalore";

      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey",
        ),
      );

      final data = jsonDecode(res.body);

      if (data["cod"] != "200") {
        throw "Error: ${data["message"] ?? "Something went wrong"}";
      }

      return data;
    } catch (e) {
      throw Exception("Failed to load weather data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weatherFuture = getCureentWheather(); // Refresh data on click
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weatherFuture, // Use stored future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Properly centered loader
          }
          if (snapshot.hasError) {
            return Center(
              // Show only error message
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final data = snapshot.data!;

          final currentWheather = data["list"][0];
          final currentTemp = (currentWheather["main"]["temp"] - 273.15)
              .toStringAsFixed(2);
          final currentSky = currentWheather["weather"][0]["main"];
          final currentPressure = currentWheather["main"]["pressure"];
          final currentWindSpeed = currentWheather["wind"]["speed"];
          final currentHumidity = currentWheather["main"]["humidity"];

          return Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            "$currentTemp °C",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                          Icon(
                            currentSky == "Clouds" || currentSky == "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                            size: 64,
                          ),

                          const SizedBox(height: 15),
                          Text("$currentSky", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Weather Forecast",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       HourlyForecastCard(
                //         time: "1:00",
                //         temp: "175",
                //         icon: Icons.cloud,
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final finalHourlyForecast = data["list"][index + 1];
                      final time = DateTime.parse(finalHourlyForecast["dt_txt"]);
                      return HourlyForecastCard(
                        time: DateFormat.Hm().format(time).toString(),
                        temp: finalHourlyForecast["main"]["temp"].toString(),
                        icon:
                            finalHourlyForecast["weather"][0]["main"] ==
                                        "Clouds" ||
                                    finalHourlyForecast["weather"][0]["main"] ==
                                        "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                      );
                    },
                  ),
                ),

                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Additional Information",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AdditionalInfo(
                      icon: Icons.water_drop_rounded,
                      label: "Humidity",
                      value: "$currentHumidity",
                    ),
                    AdditionalInfo(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: "$currentWindSpeed",
                    ),
                    AdditionalInfo(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: "$currentPressure",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
