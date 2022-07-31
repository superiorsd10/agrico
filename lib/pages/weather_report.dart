import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  int? temp;
  int? feels_like;
  int? humidity;
  Album({
    this.temp,
    this.feels_like,
    this.humidity,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      temp: json['temp'],
      feels_like: json['feels_like'],
      humidity: json['humidity'],
    );
  }
}

int? tempVal;
int? humidityVal;
int? feelsLikeVal;
Future<Album> fetchAlbum(String location) async {
  final response = await http.get(
      Uri.parse(
          'https://weather-by-api-ninjas.p.rapidapi.com/v1/weather?city=$location&country=India'),
      headers: {
        'X-RapidAPI-Key': '70e7a8fdc2mshc9e58cefa458646p1e71cbjsncd31fb2c143a',
        'X-RapidAPI-Host': 'weather-by-api-ninjas.p.rapidapi.com',
      });
  tempVal = (jsonDecode(response.body)['temp']);
  humidityVal = (jsonDecode(response.body)['humidity']);
  feelsLikeVal = (jsonDecode(response.body)['feels_like']);
  print(jsonDecode(response.body)['temp']);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    return Album.fromJson(jsonDecode(response.body));
    throw Exception('Failed to load album');
  }
}

class WeatherReport extends StatefulWidget {
  const WeatherReport({Key? key}) : super(key: key);

  @override
  _WeatherReportState createState() => _WeatherReportState();
}

class _WeatherReportState extends State<WeatherReport> {
  late Future<Album> futureAlbum;
  TextEditingController _placeName = TextEditingController(text: "Lucknow");
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum("Lucknow");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    double topMargin = height * 0.038;
    double leftMargin = width * 0.076;
    double bigSizedBox = height * 0.35;
    double containerHeight = height * 0.14;
    double containerWidth = width * 0.84;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Report"),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade400,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/scenery.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                margin: EdgeInsets.fromLTRB(leftMargin, topMargin, 0.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 230,
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: "City Name",
                                hintStyle: TextStyle(
                                  fontFamily: 'Roboto-Light',
                                ),
                              ),
                              controller: _placeName,
                            ),
                          ),
                          TextButton.icon(
                              onPressed: () async {
                                FocusScopeNode currentFocus = FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                await fetchAlbum(_placeName.text);
                                setState(() {});
                              },
                              icon: const Icon(Icons.search),
                              label: Text("Search"))
                        ],
                      ),
                      SizedBox(height: 20,),
                      titleText(
                        title: _placeName.text.toUpperCase(),
                        // title: "$tempVal",
                        fontSize: 36,
                      ),
                      SizedBox(
                        height: topMargin,
                      ),
                      titleText(
                        key: UniqueKey(),
                        // title: "${snapshot.data!.temp}°c",
                        title: tempVal != null
                            ? "$tempVal°c"
                            : "This place does not exist",
                        fontSize: tempVal != null ? 96 : 40,
                      ),
                      SizedBox(
                        height: bigSizedBox,
                      ),
                      Container(
                        height: containerHeight,
                        width: containerWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white.withOpacity(.15),
                          border: Border(
                            left: buildBorderSide(),
                            right: buildBorderSide(),
                            top: buildBorderSide(),
                            bottom: buildBorderSide(),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            key: UniqueKey(),
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              containerContent(
                                height: height,
                                title: 'Humidity',
                                titleValue:
                                    humidityVal != null ? "$humidityVal%" : "-",
                              ),
                              Container(
                                color: Colors.white,
                                height: 65,
                                width: 2,
                              ),
                              containerContent(
                                height: height,
                                title: 'Feels like',
                                titleValue: feelsLikeVal != null
                                    ? "$feelsLikeVal°c"
                                    : "-",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  BorderSide buildBorderSide() {
    return const BorderSide(
      color: Colors.white,
      width: 1.5,
    );
  }
}

class containerContent extends StatelessWidget {
  const containerContent({
    Key? key,
    required this.height,
    required this.title,
    required this.titleValue,
  }) : super(key: key);

  final double height;
  final String title;
  final String titleValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'Roboto-Light',
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: height * 0.012,
        ),
        Text(
          titleValue,
          style: const TextStyle(
            fontSize: 42,
            fontFamily: 'Roboto-Light',
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class titleText extends StatelessWidget {
  const titleText({
    Key? key,
    required this.title,
    required this.fontSize,
  }) : super(key: key);

  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'Roboto-Regular',
        color: Colors.indigo.shade400,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Text("${snapshot.data!.temp}"),
// Text("${snapshot.data!.feels_like}"),
// Text("${snapshot.data!.humidity}"),
