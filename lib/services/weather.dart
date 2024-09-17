import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/utilities/constants.dart';

class Weather {
  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        "$openWeatherAppURL?units=metric&lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey");
    var WeatherData = await networkHelper.getData();
    return WeatherData;
  }

  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherAppURL?q=$cityName&appid$apiKey&units=metric');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }
}
