import 'package:flutter/material.dart';
import 'package:flutter_weather_demo/weather_controller.dart';
import 'package:watch_it/watch_it.dart';

class WatchStreamExample extends WatchingWidget {
  const WatchStreamExample({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherEntry? weatherEntry =
        watchStream<WeatherController, WeatherEntry?>(
      (controller) => controller.watchWeatherInCities(),
    ).data;

    print('++++> new weather entry: ${weatherEntry?.cityName}');

    return Scaffold(
      appBar: AppBar(title: Text("WeatherDemo")),
      body: Column(
        children: [
          weatherEntry == null
              ? Center(child: Text('Waiting for data...'))
              : ListTile(
                  title: Text(weatherEntry.cityName),
                  subtitle: Text(weatherEntry.description ?? ''),
                  leading: weatherEntry.iconURL != null
                      ? Image.network(
                          weatherEntry.iconURL!,
                          frameBuilder: (BuildContext context, Widget child,
                              int? frame, bool wasSynchronouslyLoaded) {
                            return child;
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return CircularProgressIndicator();
                          },
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.error,
                            size: 40,
                          ),
                        )
                      : SizedBox(),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${weatherEntry.temperature}°C'),
                      Text('${weatherEntry.wind}km/h'),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
