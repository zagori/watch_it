import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'json/weather_in_cities.dart';

class WeatherController {
  late List<WeatherEntry> _weatherEntries;

  WeatherController() {
    _getWeatherEntries();
  }

  Future<void> _getWeatherEntries() async {
    const url =
        "https://api.openweathermap.org/data/2.5/box/city?bbox=12,32,15,37,10&appid=27ac337102cc4931c24ba0b50aca6bbd";

    var httpStream =
        http.get(Uri.parse(url)).timeout(const Duration(seconds: 5)).asStream();

    _weatherEntries = await httpStream
        .where(
            (data) => data.statusCode == 200) // only continue if valid response
        .map(
      (data) {
        // convert JSON result into a List of WeatherEntries
        return WeatherInCities.fromJson(
                json.decode(data.body) as Map<String, dynamic>)
            .cities // we are only interested in the Cities part of the response
            .map((weatherInCity) => WeatherEntry(
                weatherInCity)) // Convert City object to WeatherEntry
            .toList(); // aggregate entries to a List
      },
    ).first; // Return result as Future
  }

  /// [watchWeatherInCities] will emit one entry from [_weatherEntries] every 20 seconds
  /// This is mean to mimic emitting WeatherEntry from a source of data, such as DB
  Stream<WeatherEntry?> watchWeatherInCities() async* {
    while (true) {
      final index = Random().nextInt(_weatherEntries.length);
      yield _weatherEntries[index];
      await Future.delayed(const Duration(seconds: 20));
    }
  }
}

class WeatherEntry {
  late String cityName;
  String? iconURL;
  late double wind;
  late double rain;
  late double temperature;
  String? description;

  WeatherEntry(City city) {
    this.cityName = city.name;
    this.iconURL = city.weather[0].icon != null
        ? "https://openweathermap.org/img/w/${city.weather[0].icon}.png"
        : null;
    this.description = city.weather[0].description;
    this.wind = city.wind.speed.toDouble();
    this.rain = city.rain;
    this.temperature = city.main.temp;
  }
}
