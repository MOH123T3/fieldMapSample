// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart'; // for date format

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class WeatherInfo extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WeatherInfo> {
  String key = 'fefb1f8b346aaf224046d58933808e7e';
  late WeatherFactory ws;
  List<Weather> _data = [];
  List<Weather> forecast = [];
  AppState _state = AppState.NOT_DOWNLOADED;
  double? lat, lon;

  @override
  void initState() {
    super.initState();
    ws = WeatherFactory(key);
  }

  List<LatLng> latLen = [];
  LatLng _initialPosition = LatLng(22.98609270408351, 72.55394160747528);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: queryWeather(),
            builder: (context, snapshot) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.white,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  const Color.fromARGB(255, 59, 148, 62),
                                  Colors.green,
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30))),
                          height: 200,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 40,
                    child: InkWell(
                      onTap: () {
                        showAlertDialog(context);
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Colors.green,
                              ],
                            )),
                        height: 210,
                        width: 300,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: _data.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: ListTile(
                                          minLeadingWidth: 0,
                                          titleAlignment:
                                              ListTileTitleAlignment.center,
                                          leading: Icon(Icons.location_on),
                                          title: Text((_data[index]
                                              .areaName
                                              .toString())),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: ListTile(
                                          titleAlignment:
                                              ListTileTitleAlignment.center,
                                          title: Text(DateFormat.yMMMMd()
                                              .format(DateTime.parse(
                                                  _data[index]
                                                      .date
                                                      .toString()))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.cloud,
                                          color: Colors.lightBlue,
                                          size: 70,
                                        ),
                                        Icon(
                                          Icons.sunny,
                                          color: Colors.amber,
                                          size: 70,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              _data[index]
                                                  .temperature
                                                  .toString()
                                                  .replaceAll('Celsius', '°'),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text('Temperature')
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            Text('Wind'),
                                            Text(
                                              "${_data[index].windSpeed.toString()} km/h",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text('Humidity'),
                                            Text(
                                              "${_data[index].humidity}%",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromARGB(255, 124, 230, 127),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.cloud_sharp,
                                    color: Colors.lightBlue,
                                  ),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  Text("Date"),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  Text(
                                    'Temperature',
                                  ),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  Text(
                                    'Wind',
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              height: 310,
                              width: 300,
                              child: ListView.builder(
                                  padding: EdgeInsets.all(10),
                                  itemCount: forecast.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: ListTile(
                                            contentPadding:
                                                EdgeInsets.only(left: 10),
                                            minLeadingWidth: 0,
                                            titleAlignment:
                                                ListTileTitleAlignment.center,
                                            leading: Icon(
                                              Icons.cloud_sharp,
                                              color: Colors.lightBlue,
                                            ),
                                            title: Text(DateFormat(" d").format(
                                                DateTime.parse(forecast[index]
                                                    .date
                                                    .toString()))),
                                          ),
                                        ),
                                        Text(
                                          forecast[index]
                                              .temperature
                                              .toString()
                                              .replaceAll('Celsius', '°'),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                            "${forecast[index].windSpeed.toString()} km/h"),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ))
                ],
              );
            }));

    //     body: Container(
    //   decoration: BoxDecoration(
    //       image: DecorationImage(
    //     image: NetworkImage(
    //       'https://images.pexels.com/photos/53594/blue-clouds-day-fluffy-53594.jpeg',
    //     ),
    //     fit: BoxFit.fitHeight,
    //   )),
    //   child: FutureBuilder(
    //       future: queryWeather(),
    //       builder: (context, data) {
    //         return Column(
    //           children: [
    //             Expanded(
    //               flex: 5,
    //               child: ListView.separated(
    //                 itemCount: _data.length,
    //                 itemBuilder: (context, index) {
    //                   return Container(
    //                     margin:
    //                         EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(10),
    //                         color: Colors.blue[100]),
    //                     child: Column(
    //                       children: <Widget>[
    //                         SizedBox(
    //                           height: 10,
    //                         ),
    //                         InkWell(
    //                           onTap: () {
    //                             for (var i = 0; i < forecast.length; i++) {
    //                               print(forecast[i].date);
    //                               print(forecast[i].temperature);
    //                             }
    //                             showAlertDialog(context);
    //                           },
    //                           child: Text(
    //                             "${_data[index].areaName.toString()} , ${_data[index].country.toString()}",
    //                             style: TextStyle(
    //                                 color: Colors.black, fontSize: 40.0),
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 20,
    //                         ),
    //                         Center(
    //                             child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Icon(
    //                               Icons.air,
    //                               size: 30,
    //                               color: Colors.black,
    //                             ),
    //                             SizedBox(
    //                               width: 20,
    //                             ),
    //                             Text(
    //                               "${_data[index].windSpeed}",
    //                               style: TextStyle(
    //                                   color: Colors.black, fontSize: 30.0),
    //                             ),
    //                           ],
    //                         )),
    //                         SizedBox(
    //                           height: 10,
    //                         ),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             SizedBox(
    //                               width: 200,
    //                               child: ListTile(
    //                                 titleAlignment:
    //                                     ListTileTitleAlignment.center,
    //                                 title: Text(
    //                                     "${DateFormat.yMMMMd().format(DateTime.parse(_data[index].date.toString()))}"),
    //                               ),
    //                             ),
    //                             SizedBox(
    //                               width: 10,
    //                             ),
    //                             Text(
    //                               _data[index].temperature.toString(),
    //                               style: TextStyle(
    //                                   fontSize: 15,
    //                                   color: Colors.black,
    //                                   fontWeight: FontWeight.bold),
    //                             ),
    //                           ],
    //                         ),
    //                       ],
    //                     ),
    //                   );
    //                 },
    //                 separatorBuilder: (BuildContext context, int index) {
    //                   return Divider();
    //                 },
    //               ),
    //             ),
    //             Expanded(
    //               flex: 10,
    //               child: ListView.builder(
    //                   itemCount: forecast.length,
    //                   itemBuilder: (context, index) {
    //                     return Container(
    //                       margin: EdgeInsets.all(15),
    //                       decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(10),
    //                           color: Colors.white),
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           ListTile(
    //                             titleAlignment: ListTileTitleAlignment.center,
    //                             title: Text(
    //                                 "${DateFormat.yMMMMd().format(DateTime.parse(forecast[index].date.toString()))}"),
    //                             leading: Text(
    //                               "Date",
    //                               style: TextStyle(
    //                                   fontSize: 20,
    //                                   color: Colors.purple,
    //                                   fontWeight: FontWeight.bold),
    //                             ),
    //                           ),
    //                           ListTile(
    //                             titleAlignment: ListTileTitleAlignment.center,
    //                             title: Text(
    //                                 "${DateFormat.jms().format(DateTime.parse(forecast[index].date.toString()))}"),
    //                             leading: Text(
    //                               "Time",
    //                               style: TextStyle(
    //                                   fontSize: 20,
    //                                   color: Colors.brown,
    //                                   fontWeight: FontWeight.bold),
    //                             ),
    //                           ),
    //                           ListTile(
    //                             titleAlignment: ListTileTitleAlignment.center,
    //                             title: Text(
    //                                 "${forecast[index].temperature.toString()}"),
    //                             leading: Text(
    //                               "Temperature",
    //                               style: TextStyle(
    //                                   fontSize: 20,
    //                                   color: Colors.black,
    //                                   fontWeight: FontWeight.bold),
    //                             ),
    //                           ),
    //                           Row(
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             children: [
    //                               SizedBox(
    //                                 width: 200,
    //                                 child: ListTile(
    //                                     titleAlignment:
    //                                         ListTileTitleAlignment.center,
    //                                     title: Row(
    //                                       children: [
    //                                         Text("Wind Speed"),
    //                                         SizedBox(
    //                                           width: 5,
    //                                         ),
    //                                         Icon(
    //                                           Icons.air_rounded,
    //                                           color: Colors.pink,
    //                                         )
    //                                       ],
    //                                     )),
    //                               ),
    //                               Text(
    //                                 forecast[index].windSpeed.toString(),
    //                                 style: TextStyle(
    //                                     fontSize: 15,
    //                                     color: Colors.black,
    //                                     fontWeight: FontWeight.bold),
    //                               ),
    //                             ],
    //                           ),
    //                           Divider(
    //                             color: Colors.yellowAccent,
    //                             thickness: 1,
    //                           )
    //                         ],
    //                       ),
    //                     );
    //                   }),
    //             )
    //           ],
    //         );
    //       }),
    // ));
  }

  queryWeather() async {
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _state = AppState.DOWNLOADING;
    });

    forecast = await ws.fiveDayForecastByLocation(
        _initialPosition.latitude, _initialPosition.longitude);

    Weather weather = await ws.currentWeatherByLocation(
        _initialPosition.latitude, _initialPosition.longitude);
    setState(() {
      _data = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
    });
    return _data;
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.green,
      title: Text("Choose your location"),
      actions: [
        Column(
          children: [
            SizedBox(
              height: 300,
              child: GoogleMap(
                onTap: (argument) {
                  _initialPosition = argument;
                  print('latLen - ${_initialPosition}');
                  setState(() {});
                  queryWeather();
                },

                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 5,
                ),
                mapType: MapType.hybrid,
                // markers: _markers,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
              ),
            ),
          ],
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
