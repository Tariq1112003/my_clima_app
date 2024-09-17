import 'package:clima/components/details_widget.dart';
import 'package:clima/components/error_message.dart';
import 'package:clima/components/loading_widget.dart';
import 'package:clima/models/weather_model.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/utilities/weather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

//import 'package:http/http.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDataLoaded = false;
  bool isErrorOccured = false;
  double? latitude, longitude;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;
  Weathermodel? weathermodel;
  int code = 0;
  Weather weather = Weather();
  var weatherData;
  String? title, message;

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  void getPermission() async {
    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      print('permission is denied');
      permission = await geolocatorPlatform.requestPermission();
      if (permission != LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
          print('permission permanently denied');
       setState(() {
         isDataLoaded=true;
         isErrorOccured=true;
         title='permission permanently is denied';
         message='please provide permission to the app fwrom device setting';
       });
        } else {
          print('permission granted');
          updateUI();
        }
      } else {
        print('user denied the permission');
        updateUI(cityName: 'herat');
      }
    } else {
      updateUI();
    }
  }

  void updateUI({String? cityName}) async {
    weatherData = null;
    if (cityName == null || cityName == '') {
      if (!await geolocatorPlatform.isLocationServiceEnabled()) {
        setState(() {
          isDataLoaded = true;
          isErrorOccured = true;
          title = 'Location is turned of';
          message =
              "Please enable the location service to see weather condition for your location";
          return;
        });
      }
      weatherData = await weather.getLocationWeather();
    } else {
      weatherData = await weather.getCityWeather(cityName);
    }

    if(weatherData==null){
      setState(() {
        title='city not found';
        message='please make sure you entered the correct city name';
        isDataLoaded=true;
        isErrorOccured=true;
        return;
      });
    }
    code = weatherData['weather'][0]['id'];

    weathermodel = Weathermodel(
      location: weatherData['name'] + "," + weatherData['sys']['country'],
      temperature: weatherData['main']['temp'],
      description: weatherData['weather'][0]['description'],
      feelsLike: weatherData['name']['feels_like'],
      humidity: weatherData['main']['humidity'],
      wind: weatherData['wind']['speed'],
      icon:
          'images/weather-icons/${getIconPrefix(code)}${kWeatherIcons[code.toString()]!['icon']}.svg',
    );

    setState(() {
      isDataLoaded = true;
      isErrorOccured=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const loadingWidget();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kOverLayColer,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: TextField(
                        decoration: kTextFieldDecoration,
                        onSubmitted: (String tyPedName) {
                          setState(() {
                            isDataLoaded = false;
                            updateUI(cityName: tyPedName);
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isDataLoaded=false;
                              getPermission();
                            });

                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          child: Container(
                            height: 60,
                            child: Row(
                              children: [
                                Text(
                                  'My Location',
                                  style: kTextFieldTextStyle,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.gps_fixed,
                                  color: Colors.white60,
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              isErrorOccured
                  ? ErrorMessage(title: title!, message: message!)
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_city,
                                color: kMidLightColor,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                weathermodel!.location!,
                                style: kLocationTextStyle,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          SvgPicture.asset(
                            weathermodel!.icon!,
                            height: 280,
                            color: kLightColor,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "${weathermodel!.temperature!.round()}degree",
                            style: kTempTextStyle,
                          ),
                          Text(
                            weathermodel!.description!.toUpperCase(),
                            style: kLocationTextStyle,
                          )
                        ],
                      ),
                    ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: kOverLayColer,
                  child: Container(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Details_widget(
                          value:
                              "${weathermodel != null ? weathermodel!.feelsLike!.round() : 0}",
                          title: "Feels Like",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        Details_widget(
                          title: "HUMIDITY",
                          value:
                              "${weathermodel != null ? weathermodel!.humidity! : 0}%",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        Details_widget(
                            title: "WIND",
                            value:
                                "${weathermodel != null ? weathermodel!.wind!.round() : 0}"),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    // child: ElevatedButton(
    //   onPressed: (){
    //     getPermission();
    //   },
    //   child:Text('get location',style: TextStyle(fontSize: 16),),),
  }
}
