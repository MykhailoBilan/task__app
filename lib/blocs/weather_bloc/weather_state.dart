part of 'weather_bloc.dart';

@immutable
sealed class WeatherBlocState {}

class WeatherInitial extends WeatherBlocState {}

class WeatherSuccess extends WeatherBlocState {
  Weather weather;
  WeatherSuccess(this.weather);
}

class WeatherLoading extends WeatherBlocState {}

class WeatherFail extends WeatherBlocState {}
