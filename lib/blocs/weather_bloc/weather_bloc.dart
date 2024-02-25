import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather/weather.dart'; // useful library to not write models, http requests by hand

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<FetchWeatherByCity>(
      (event, emit) async {
        emit(WeatherLoading());
        try {
          WeatherFactory wf =
              WeatherFactory('77b3e66d8b543fb8f361d3dc2a10fc37');
          Weather weather = await wf.currentWeatherByCityName(event.city);
          emit(WeatherSuccess(weather));
        } catch (e) {
          emit(WeatherFail());
        }
      },
    );
  }
}
