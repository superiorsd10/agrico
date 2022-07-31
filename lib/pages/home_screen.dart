import 'dart:convert';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_in_with_google/pages/navigation_drawer.dart';
import 'package:sign_in_with_google/pages/datashare.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';

class Album {
  int? cloud_pct;
  Album({
    this.cloud_pct,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      cloud_pct: json['cloud_pct'],
    );
  }
}

double lat = 26.8098037;
double lon = 81.0124859;
void getLocation() async {
  Position? position = await Geolocator.getLastKnownPosition();
  // List<Address> addresses = geocoder. getFromLocation(lat, lng, 1);
  lat = position!.latitude;
  lon = position.longitude;
}

int? cloud_pct;
Future<Album> fetchAlbum(double lat, double lon) async {
  final response = await http.get(
      Uri.parse(
          'https://weather-by-api-ninjas.p.rapidapi.com/v1/weather?lat=$lat&lon=$lon'),
      headers: {
        'X-RapidAPI-Key': '70e7a8fdc2mshc9e58cefa458646p1e71cbjsncd31fb2c143a',
        'X-RapidAPI-Host': 'weather-by-api-ninjas.p.rapidapi.com',
      });
  cloud_pct = (jsonDecode(response.body)['cloud_pct']);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    return Album.fromJson(jsonDecode(response.body));

  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Album> futureAlbum;
  late int data1;
  late DataShare data;
  List<int> data_list1 = [];
  List<int> data_list2 = [];
  // List<int> data_list3 = [];
  num avg1 = 0;
  num avg2 = 0;
  String? Avg1;
  String? Avg2 ;

  // int avg3 = 0;
  Future getSensorData() async{
    http.Response response=await http.get(Uri.parse('https://script.google.com/macros/s/AKfycbzUrr60PADoAsj3Frb6N-_6rhVepfvqMdSKVeFxEv8GcQdIXduzHApQzyVogcqt0B0q-Q/exec'));
    var result=jsonDecode(response.body);
    setState(() {
      for(var i in result){
        data_list1.add(i['GAS']);
        // data_list2.add(i['LIGHT']);
        data_list2.add(i['SOIL_MOISTURE']);
      }
      num total1 = 0;
      data_list1.forEach((item) => total1 += item);
      num total2 = 0;
      data_list2.forEach((item) => total2 += item);
      // num total3 = 0;
      // data_list3.forEach((item) => total3 += item);
      avg1=(total1/data_list1.length).round();
      avg1 = (avg1/1023)*100;
      Avg1 = avg1.toStringAsFixed(2);
      avg2=(total2/data_list2.length).round();
      avg2 = (avg2/1023)*100;
      Avg2 = avg2.toStringAsFixed(2);
      // avg3=(total3/data_list3.length).round();
    });
  }

  late ConfettiController controllerTopCenter;

  @override
  void initState() {
    super.initState();
    getSensorData();
    getLocation();
    fetchAlbum(lat, lon);
    initController();

  }

  void initController() {
    controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  Align buildConfettiWidget(controller, double blastDirection) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        maximumSize: Size(30, 30),
        shouldLoop: false,
        confettiController: controller,
        blastDirection: blastDirection,
        blastDirectionality: BlastDirectionality.directional,
        maxBlastForce: 20, // set a lower max blast force
        minBlastForce: 8, // set a lower min blast force
        emissionFrequency: 1,
        numberOfParticles: 8, // a lot of particles at once
        gravity: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as DataShare;
    return Scaffold(
      drawer: NavigationDrawerWidget(data: data,),
      appBar: buildAppBar(),
      body: ListView(
        children: [
          CarouselSlider(
            items: [

              //3rd Image of Slider
              Container(
                margin: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InfoCard(title: 'Rain?', num: '${cloud_pct != null? '$cloud_pct%': "Location Unavailale"}\n', iconColor: Colors.yellow, iconPath: 'assets/icons/icons8-umbrella-64.png', weatherTerm: "It's rain!", gifPath: 'assets/icons/icons8-rain-cloud-unscreen.gif', infoCardColor: Colors.yellow,),

              ),

              //4th Image of Slider
              Container(
                margin: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InfoCard(title: 'Gas Data', num: '${Avg1 != null? '$Avg1%': "Fetching Data"}\n', iconColor: Colors.pink, iconPath: 'assets/icons/icons8-wind-64.png', weatherTerm: "Hold on!", gifPath: 'assets/icons/icons8-windy-weather-unscreen.gif', infoCardColor: Colors.pink,),
              ),

              //5th Image of Slider
              Container(
                margin:EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InfoCard(title: 'Soil Moisture', num: '${Avg2 != null? '$Avg2%': "Fetching Data"}\n', iconColor: Colors.green, iconPath: 'assets/icons/icons8-soil-64.png', weatherTerm: "Grow Something!", gifPath: 'assets/icons/icons8-plant-unscreen.gif', infoCardColor: Colors.green,),
              ),

            ],

            //Slider Container properties
            options: CarouselOptions(
              height: 240,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 4 / 1,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 1500),
              viewportFraction: 1.8,
            ),
          ),
        ],
      ),
      // body: Container(
      //   height: 300,
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //     color: Colors.green.shade500.withOpacity(0.03),
      //     borderRadius: const BorderRadius.only(
      //       bottomLeft: Radius.circular(50),
      //       bottomRight: Radius.circular(50),
      //     ),
      //   ),
      //   child: Wrap(
      //     runSpacing: 14,
      //     spacing: 7,
      //     children: [
      //       // InfoCard(title: 'Weather', num: '21°C\n', iconColor: Colors.blue, iconPath: 'assets/icons/icons8-cloud-64.png', weatherTerm: "Nice Weather", gifPath: 'assets/icons/icons8-partly-cloudy-day-unscreen.gif', infoCardColor: Colors.blue,),
      //       InfoCard(title: 'Rain?', num: '${cloud_pct != null? '$cloud_pct%': "Location Unavailale"}\n', iconColor: Colors.yellow, iconPath: 'assets/icons/icons8-umbrella-64.png', weatherTerm: "It's rain!", gifPath: 'assets/icons/icons8-rain-cloud-unscreen.gif', infoCardColor: Colors.yellow,),
      //       InfoCard(title: 'Gas Data', num: '${Avg1 != null? '$Avg1%': "Fetching Data"}\n', iconColor: Colors.pink, iconPath: 'assets/icons/icons8-wind-64.png', weatherTerm: "Hold on!", gifPath: 'assets/icons/icons8-windy-weather-unscreen.gif', infoCardColor: Colors.pink,),
      //       InfoCard(title: 'Soil Moisture', num: '${Avg2 != null? '$Avg2%': "Fetching Data"}\n', iconColor: Colors.green, iconPath: 'assets/icons/icons8-soil-64.png', weatherTerm: "Grow Something!", gifPath: 'assets/icons/icons8-plant-unscreen.gif', infoCardColor: Colors.green,),
      //     ],
      //
      //   ),
      // ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 250, left: 30),
        child: ElevatedButton(
            onPressed: () {
              getSensorData();
              getLocation();
              Fluttertoast.showToast(
                msg: "Fetching Data",
                toastLength: Toast.LENGTH_SHORT,
              );

            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.lime),
              padding: MaterialStateProperty.all(
                const EdgeInsets.all(20),
              ),
            ),
            child: BorderedText(
              strokeWidth: 2.0,
              strokeColor: Colors.black54,
              child: const Text(
                'Fetch Data',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3.0,
                ),
              ),
            )),
      ),
    );
  }
  AppBar buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      title: const Text(
        'AGRICO',
        style: TextStyle(
          color: Colors.black,
          letterSpacing: 2.0,
        ),
      ),
      elevation: 0,
      // leading: IconButton(
      //   icon: Image.asset('assets/icons/icons8-menu-48.png'),
      //   onPressed: () {},
      // ),
      actions: [
        IconButton(
          onPressed: () {
            Fluttertoast.showToast(
              msg: "Made By : "
                  "Anikate Koul\n"
                  "Sachin Dapkara\n"
                  "Abhishek Goenka\n"
                  "Shraddha Gulati",
              toastLength: Toast.LENGTH_SHORT,
            );
            controllerTopCenter.play();
          },
          icon: Image.asset('assets/agrico_appicon.png'),
        )
      ],
    );
  }
}





class InfoCard extends StatelessWidget {
  final String title;
  final String num;
  final Color iconColor;
  final String iconPath;
  final String weatherTerm;
  final String gifPath;
  final Color infoCardColor;
  const InfoCard({
    Key? key, required this.title, required this.num, required this.iconColor, required this.iconPath, required this.weatherTerm, required this.gifPath, required this.infoCardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.only(left: 10, top: 10,),
          width: constraints.maxWidth / 2 - 20,
          decoration: BoxDecoration(
            color: infoCardColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        iconPath,
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.3,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                        text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: num,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: weatherTerm,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 2,
                            // letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    )),
                  ),
                  Expanded(
                    child: Image.asset(
                        gifPath, width: 90, height: 90,),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
