import 'package:flutter/material.dart';

const apiKey = "8b8a4b9ed2a4508a26ba4bb0b0fc77a1";
const openWeatherAppURL = 'https://api.openweathermap.org/data/2.5/weather';

const kDarkColor = Colors.white24;
const kLightColor = Colors.white;
const kMidLightColor = Colors.white60;
const kOverLayColer = Colors.white10;
const kTextFieldTextStyle = TextStyle(fontSize: 16, color: kMidLightColor);
const kLocationTextStyle = TextStyle(fontSize: 20, color: kMidLightColor);
const kTempTextStyle = TextStyle(fontSize: 80);
const kDetailsTextStyles =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kMidLightColor);
const kDetailsTitleTextStyle = TextStyle(fontSize: 16, color: kDarkColor);
const kDetailsSuffexTextStyle = TextStyle(fontSize: 12, color: kMidLightColor);
const kTextFieldDecoration = InputDecoration(
  fillColor: kOverLayColer,
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    borderSide: BorderSide.none,
  ),
  hintText: 'Enter the city name',
  hintStyle: kTextFieldTextStyle,
  prefixIcon: Icon(Icons.search),
);
