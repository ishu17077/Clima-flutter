import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  LocationScreen(this.locationWeather);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  String weatherMessage;
  String condition;
  int temperature;
  String cityName;

  void updateUI(var weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        condition = "Error";
        weatherMessage = "Unable to get weather data.";
        cityName = "";
      } else {
        temperature = weatherData['main']['temp'].round();
        int condition = weatherData['weather'][0]['id'];
        cityName = weatherData['name'];
        this.condition = weather.getWeatherIcon(condition);
        this.weatherMessage = weather.getMessage(temperature);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: MediaQuery.of(context).size.height * 0.06,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CityScreen(), //? cityName will be typed back from Navigator.pop in city_screem
                        ),
                      );
                      if (typedName != null) {
                        var weatherData = await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: MediaQuery.of(context).size.height * 0.06,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle.copyWith(
                          fontSize: MediaQuery.of(context).size.height * 0.1),
                    ),
                    Text(
                      condition,
                      style: kConditionTextStyle.copyWith(
                          fontSize: MediaQuery.of(context).size.height * 0.1),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: 15.0,
                    bottom: MediaQuery.of(context).size.height * 0.10),
                child: Text(
                  "$weatherMessage in $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.055,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
