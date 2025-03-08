import 'package:flutter/material.dart';
import 'package:wheather_app/additional_Info.dart';
import 'package:wheather_app/hourly_Prediction.dart';
import 'package:http/http.dart' as http;

class WheatherScreen extends StatelessWidget {
  const WheatherScreen({super.key});

  Future getCureentWheather() async {
    http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=5527358caa96cd37eee223f1323f6db9"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wheather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              debugPrint("clicked");
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          children: [
            //main card
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        "300°K",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Icon(Icons.cloud, size: 64),
                      SizedBox(height: 15),
                      Text("Rain", style: TextStyle(fontSize: 16)),
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
            //wheather forecast
            SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForecastCard(
                    time: "1:00",
                    temp: "175",
                    icon: Icons.cloud,
                  ),
                  HourlyForecastCard(
                    time: "2:00",
                    temp: "275",
                    icon: Icons.sunny,
                  ),
                  HourlyForecastCard(
                    time: "3:00",
                    temp: "375",
                    icon: Icons.cloud,
                  ),
                  HourlyForecastCard(
                    time: "4:00",
                    temp: "265",
                    icon: Icons.sunny,
                  ),
                  HourlyForecastCard(
                    time: "5:00",
                    temp: "255",
                    icon: Icons.cloud,
                  ),
                  HourlyForecastCard(
                    time: "6:00",
                    temp: "215",
                    icon: Icons.sunny,
                  ),
                ],
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
            //additional information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AdditionalInfo(
                  icon: Icons.water_drop_rounded,
                  label: "Humidity",
                  value: "91",
                ),
                AdditionalInfo(
                  icon: Icons.air,
                  label: "Wind Spedd",
                  value: "7.5",
                ),
                AdditionalInfo(
                  icon: Icons.beach_access,
                  label: "Pressure",
                  value: "1000",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
