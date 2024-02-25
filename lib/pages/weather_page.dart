import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/blocs/weather_bloc/weather_bloc.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  TextEditingController city = TextEditingController();
  @override
  void dispose() {
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsetsDirectional.only(start: 20, end: 20, top: 30),
            child: TextField(
              controller: city,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'City',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                context.read<WeatherBloc>()..add(FetchWeatherByCity(city.text));
                city.text = "";
              },
              child: Container(
                child: Text("OK"),
              )),
          BlocBuilder<WeatherBloc, WeatherBlocState>(
            builder: (context, state) {
              if (state is WeatherSuccess) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Country: ${state.weather.country.toString()}",
                      style: TextStyle(fontSize: 25),
                    ),
                    Text("City: ${state.weather.areaName!}",
                        style: TextStyle(fontSize: 25)),
                    Text(
                        "Condition: ${state.weather.weatherDescription!.toString()}",
                        style: TextStyle(fontSize: 25)),
                    Text(
                        "Temperature: ${state.weather.temperature!.celsius!.ceil().toString()}°C",
                        style: TextStyle(fontSize: 25)),
                    Text(
                        "Feels like: ${state.weather.tempFeelsLike!.celsius!.ceil().toString()}°C",
                        style: TextStyle(fontSize: 25)),
                    Text(
                        "Minimum temperature: ${state.weather.tempMin!.celsius!.ceil().toString()} °C",
                        style: TextStyle(fontSize: 25)),
                    Text(
                        "Maximum temperature: ${state.weather.tempMax!.celsius!.ceil().toString()} °C",
                        style: TextStyle(fontSize: 25)),
                    Text(
                        "Windspeed: ${state.weather.windSpeed!.ceil().toString()} mph",
                        style: TextStyle(fontSize: 25)),
                  ],
                );
              } else if (state is WeatherLoading) {
                return CircularProgressIndicator();
              } else if (state is WeatherFail) {
                return Text('Failed');
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }
}
