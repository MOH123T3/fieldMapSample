// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, constant_identifier_names
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:google_map_demo/weatherInfo/address_model.dart';
import 'package:google_map_demo/weatherInfo/api_response.dart';
import 'package:google_map_demo/weatherInfo/chart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:csc_picker/csc_picker.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class WeatherInfo extends StatefulWidget {
  const WeatherInfo({super.key});

  @override
  WeatherInfoState createState() => WeatherInfoState();
}

class WeatherInfoState extends State<WeatherInfo> {
  String key = '5c6781917790726320ea8bdefcec7911';
  late WeatherFactory ws;

  double? lat, lon;
  LatLng _initialPosition = LatLng(22.98609270408351, 72.55394160747528);
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String address = "";
  List temperature = [];
  List date = [];

  @override
  void initState() {
    super.initState();
    ws = WeatherFactory(key);
  }

  List<LatLng> latLen = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<AddressName>(
            future: getData(),
            builder: (context, AsyncSnapshot<AddressName> snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                                decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/whitebackground.jpg'),
                                  fit: BoxFit.fill),
                            ))),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/background.jpg'),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))),
                          ),
                        ),
                      ],
                    ),
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 5.w),
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        Container(
                            height: 33.h,
                            margin: EdgeInsets.symmetric(horizontal: 5.h),
                            padding: EdgeInsets.symmetric(horizontal: 2.h),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.greenAccent,
                                    Colors.green,
                                  ],
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 2.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    headingTextStyle('Location'),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 12.sp,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                CSCPicker(
                                  showStates: true,
                                  showCities: true,
                                  flagState: CountryFlag.DISABLE,
                                  dropdownDecoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1)),
                                  disabledDropdownDecoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.grey.shade300,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1)),
                                  countrySearchPlaceholder: "Country",
                                  stateSearchPlaceholder: "State",
                                  citySearchPlaceholder: "City",

                                  countryDropdownLabel: "Country",
                                  stateDropdownLabel: "State",
                                  cityDropdownLabel: "City",

                                  //defaultCountry: CscCountry.India,

                                  //disableCountry: true,

                                  countryFilter: [
                                    CscCountry.India,
                                    CscCountry.United_States,
                                    CscCountry.Canada,
                                    CscCountry.Afghanistan
                                  ],

                                  selectedItemStyle: TextStyle(
                                      color: Colors.black, fontSize: 8.sp),

                                  dropdownHeadingStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.bold),

                                  dropdownItemStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8.sp,
                                  ),

                                  dropdownDialogRadius: 10.0,

                                  searchBarRadius: 10.0,

                                  onCountryChanged: (value) {
                                    setState(() {
                                      countryValue = value;
                                    });
                                  },

                                  onStateChanged: (value) {
                                    setState(() {
                                      stateValue = value;
                                    });
                                  },

                                  onCityChanged: (value) {
                                    setState(() {
                                      cityValue = value;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 25.w, right: 25.w),
                                  alignment: Alignment.center,
                                  height: 4.5.h,
                                  decoration: BoxDecoration(
                                      boxShadow: [BoxShadow(blurRadius: 1)],
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: TextButton(
                                      onPressed: () {
                                        ApiPath.address = "";
                                        setState(() {
                                          ApiPath.address =
                                              "${cityValue ?? ""} ${stateValue ?? ""} ${countryValue ?? ""}";
                                        });

                                        getData();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          headingTextStyle('Search'),
                                          SizedBox(
                                            width: 1.w,
                                          ),
                                          Icon(
                                            Icons.search,
                                            color: Colors.white,
                                            size: 12.sp,
                                          )
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 4.h,
                        ),
                        InkWell(
                          onTap: () {
                            // ResponseClass.getApi(ApiPath.forecastUrl);

                            showAlertDialog(context);
                          },
                          child: SizedBox(
                            height: 40.h,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot
                                    .data?.forecast?.forecastday?.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 0.1,
                                              blurStyle: BlurStyle.solid)
                                        ],
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.white,
                                            Colors.green,
                                          ],
                                        )),
                                    height: 32.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.w, vertical: 2.w),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 40.w,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.red,
                                                      size: 15.sp,
                                                    ),
                                                    SizedBox(
                                                      width: 30.w,
                                                      child: headingTextStyle(
                                                          (ApiPath.address)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  width: 15.w,
                                                  child: headingTextStyle(
                                                      snapshot
                                                          .data
                                                          ?.forecast
                                                          ?.forecastday?[index]
                                                          .date
                                                          .toString())),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: SizedBox(
                                              width: 34.w,
                                              child: clouds(60.sp)),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "${snapshot.data?.forecast?.forecastday?[index].day?.maxtempC.toString()} °",
                                                  style: TextStyle(
                                                      fontSize: 3.h,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                headingTextStyle('Temperature')
                                              ],
                                            ),
                                            SizedBox(
                                              width: 1,
                                            ),
                                            Icon(
                                              Icons.thermostat_outlined,
                                              color: Colors.red,
                                              size: 5.h,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(2.w),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 40.w,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        headingTextStyle(
                                                            'Wind Speed'),
                                                        SizedBox(
                                                          height: 1.h,
                                                        ),
                                                        normalTextStyle(
                                                          "${snapshot.data?.forecast?.forecastday?[index].day?.avgvisKm} km/h",
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        width: 7.w,
                                                        child: Icon(
                                                          Icons.air,
                                                          color: Colors.white,
                                                          size: 3.h,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      headingTextStyle(
                                                          'Humidity'),
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      normalTextStyle(
                                                        "${snapshot.data?.forecast?.forecastday?[index].day?.avghumidity}%",
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Icon(
                                                    Icons.water_drop_outlined,
                                                    size: 3.h,
                                                    color: Colors.blue,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        temperatureChart(temperature, date),
                        SizedBox(
                          height: 4.h,
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(bottom: 2, left: 2.w, right: 2.w),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0.1, blurStyle: BlurStyle.solid)
                            ],
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.green,
                                Colors.white,
                              ],
                            ),
                          ),
                          child: SizedBox(
                            height: 52.h,
                            child: GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6),
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.all(8),
                                children: [
                                  gridData("country",
                                      snapshot.data?.location?.country),
                                  gridData(
                                      "Data", snapshot.data?.location?.country),
                                  gridData("lat", snapshot.data?.location?.lat),
                                  gridData("lon", snapshot.data?.location?.lon),
                                  gridData("localtime",
                                      snapshot.data?.location?.localtime),
                                  gridData("localtimeEpoch",
                                      snapshot.data?.location?.localtimeEpoch),
                                  gridData(
                                      "name", snapshot.data?.location?.name),
                                  gridData("region",
                                      snapshot.data?.location?.region),
                                  gridData(
                                      "tzId", snapshot.data?.location?.tzId),
                                  gridData("cloud",
                                      "${snapshot.data?.current?.cloud}%"),
                                  gridData("condition",
                                      snapshot.data?.current?.condition?.text),
                                  gridData("feelslikeC",
                                      snapshot.data?.current?.feelslikeC),
                                  gridData("feelslikeF",
                                      snapshot.data?.current?.feelslikeF),
                                  gridData("gustKph",
                                      snapshot.data?.current?.gustKph),
                                  gridData("gustMph",
                                      snapshot.data?.current?.gustMph),
                                  gridData("humidity",
                                      snapshot.data?.current?.humidity),
                                  gridData(
                                      "isDay", snapshot.data?.current?.isDay),
                                  gridData("lastUpdated",
                                      snapshot.data?.current?.lastUpdated),
                                  gridData("lastUpdatedEpoch",
                                      snapshot.data?.current?.lastUpdatedEpoch),
                                  gridData("precipIn",
                                      snapshot.data?.current?.precipIn),
                                  gridData("precipMm",
                                      snapshot.data?.current?.precipMm),
                                  gridData("pressureIn",
                                      snapshot.data?.current?.pressureIn),
                                  gridData("pressureMb",
                                      snapshot.data?.current?.pressureMb),
                                  gridData(
                                      "tempC", snapshot.data?.current?.tempC),
                                  gridData(
                                      "tempF", snapshot.data?.current?.tempF),
                                  gridData("uv", snapshot.data?.current?.uv),
                                  gridData(
                                      "visKm", snapshot.data?.current?.visKm),
                                  gridData("visMiles",
                                      snapshot.data?.current?.visMiles),
                                  gridData("windDegree",
                                      snapshot.data?.current?.windDegree),
                                  gridData("windDir",
                                      snapshot.data?.current?.windDir),
                                  gridData("windKph",
                                      snapshot.data?.current?.windKph),
                                  gridData("windMph",
                                      snapshot.data?.current?.windMph),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 0.1, blurStyle: BlurStyle.solid)
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white,
                                  Colors.green,
                                ],
                              )),
                          height: 40.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: GoogleMap(
                              onTap: (argument) async {
                                _initialPosition = argument;
                                // setState(() {});

                                List<Placemark> placemarks =
                                    await placemarkFromCoordinates(
                                        argument.latitude, argument.longitude);

                                Placemark place1 = placemarks[0];
                                Placemark place2 = placemarks[1];
                                String _currentAddress =
                                    "${place1.country} ${place2.isoCountryCode} ${place1.locality} ${place1.name} ${place1.postalCode}${place1.street}${place1.subAdministrativeArea}${place1.subLocality}${place1.subThoroughfare}${place1.thoroughfare}";
                                print(
                                    "================================= $_currentAddress");

                                // queryWeather();
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
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20.w, right: 20.w),
                          alignment: Alignment.center,
                          height: 6.h,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black,
                                  Colors.green,
                                ],
                              ),
                              boxShadow: [BoxShadow(blurRadius: 1)],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: TextButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Search',
                                    style: TextStyle(
                                        fontSize: 15.sp, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 15.sp,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (snapshot.error == null) {
                return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.green,
                    ],
                  )),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.green,
                    ],
                  )),
                  child: Center(
                    child: headingTextStyle('Something Went Wrong'),
                  ),
                );
              }
            }));
  }

  static subTextStyle(data) {
    return Text(
      data,
      style: TextStyle(fontSize: 7.sp, color: Colors.black),
      textAlign: TextAlign.left,
    );
  }

  static normalTextStyle(data) {
    return Text(
      data,
      style: TextStyle(fontSize: 8.sp, color: Colors.black),
      textAlign: TextAlign.left,
    );
  }

  static headingTextStyle(data) {
    return Text(
      data,
      style: TextStyle(
          fontSize: 8.sp, color: Colors.black, fontWeight: FontWeight.bold),
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.green,
      title: normalTextStyle("Choose your location"),
      actions: [
        Column(
          children: [
            SizedBox(
              height: 300,
              child: GoogleMap(
                onTap: (argument) async {
                  _initialPosition = argument;
                  // setState(() {});

                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      argument.latitude, argument.longitude);

                  Placemark place1 = placemarks[0];
                  Placemark place2 = placemarks[1];
                  String _currentAddress =
                      "${place1.country} ${place2.isoCountryCode} ${place1.locality} ${place1.name} ${place1.postalCode}${place1.street}${place1.subAdministrativeArea}${place1.subLocality}${place1.subThoroughfare}${place1.thoroughfare}";
                  print("================================= $_currentAddress");

                  // queryWeather();
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

  static clouds(size) {
    return Stack(
      children: [
        Positioned(
          top: 2.h,
          right: 13.w,
          child: Icon(
            Icons.cloud,
            color: Colors.lightBlue,
            size: size,
          ),
        ),
        Icon(
          Icons.sunny,
          color: Colors.amber,
          size: size,
        ),
        Positioned(
          right: 4.w,
          child: Icon(
            Icons.cloud,
            color: Colors.lightBlue,
            size: size,
          ),
        ),
      ],
    );
  }

  Future<AddressName> getData() async {
    print(ApiPath.address);
    var response = await ResponseClass.getApi(ApiPath.forecastUrl);
    AddressName addressName = AddressName.fromJson(jsonDecode(response.body));
    temperature.clear();
    date.clear();
    for (var i = 0; i < addressName.forecast!.forecastday!.length; i++) {
      temperature
          .add(addressName.forecast?.forecastday?[i].day?.maxtempC.toString());
      date.add(addressName.forecast?.forecastday?[i].date);
    }
    return addressName;
  }

  gridData(headingName, data) {
    return Container(
      padding: EdgeInsets.all(8),
      width: 15.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingTextStyle(headingName),
          SizedBox(
            height: 1.h,
          ),
          subTextStyle("${data}")
        ],
      ),
    );
  }
}
