import 'package:flutter/material.dart';
import 'package:flutter_weather_demo/watch_stream_example.dart';
import 'package:flutter_weather_demo/weather_controller.dart';
import 'package:flutter_weather_demo/weather_manager.dart';
import 'package:get_it/get_it.dart';

import 'homepage.dart';

void main() {
  registerManager();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: WatchStreamExample(),
    );
  }
}

void registerManager() {
  GetIt.I.registerSingleton<WeatherController>(WeatherController());
  GetIt.I.registerSingleton<WeatherManager>(WeatherManager());
}
