import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_google/pages/datashare.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawerWidget extends StatefulWidget {
  // const NavigationDrawerWidget({Key? key}) : super(key: key);
  late DataShare data;
  NavigationDrawerWidget({required this.data});
  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState(data1: data);
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  late DataShare data1;
  _NavigationDrawerWidgetState({required this.data1});
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Widget returnProfileImage() {
      if (data1.imageURL == null) {
        return const Icon(
          Icons.account_circle,
          size: 100,
        );
      } else {
        return CircleAvatar(
          backgroundColor: Colors.lightBlue,
          radius: 100.0,
          child: ClipRRect(
            child: Image.network(data1.imageURL!),
            borderRadius: BorderRadius.circular(50.0),
          ),
        );
      }
    }
    return Drawer(
      backgroundColor: Colors.blue[600],
      child: ListView(
        padding: padding,
        children: [
          const SizedBox(
            height: 48,
          ),
          returnProfileImage(),
          const SizedBox(
            height: 18,
          ),
          Center(
            child: Text(
              "${data1.name}\n"
                  "${data1.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          buildMenuItem(
            text: 'Todo List',
            icon: Icons.checklist_rounded,
            onClicked: () {
              Navigator.pushNamed(context, '/todo');
            }
          ),
          const SizedBox(
            height: 18,
          ),
          buildMenuItem(
              text: 'Weather Report',
              icon: Icons.sunny_snowing,
              onClicked: () {
                Navigator.pushNamed(context, '/weather');
              }
          ),
          const SizedBox(
            height: 18,
          ),
          buildMenuItem(
              text: 'Sensor Data',
              icon: Icons.sensors_sharp,
          onClicked: () {
                Uri url = Uri.parse("https://docs.google.com/spreadsheets/d/e/2PACX-1vSI1IN2b7SkkJFB9YpgTsE2yL2vRhOlM1t4Nabsn5CEhsCaVR6FP9sUwhOEgEb8MIqVB7sNepMbU3D4/pubhtml?gid=0&single=true");
                launchUrl(url);
                // Navigator.pushNamed(context, '/api');
          }),
          const SizedBox(
            height: 24,
          ),
          const Divider(
            color: Colors.white70,
          ),
          const SizedBox(
            height: 18,
          ),
          buildMenuItem(text: 'Sign Out', icon: Icons.logout_rounded,
            onClicked: () async {
              Fluttertoast.showToast(
                msg: "Signed Out Successfully",
                toastLength: Toast.LENGTH_SHORT,
              );
              await FirebaseAuth.instance.signOut();
              // userEmail = "";
              // userImageURL = null;
              // userName = "Login";
              // // returnProfileImage();
              // showFlutterToast();
              await GoogleSignIn().signOut();
              setState(() {});
              Navigator.pushReplacementNamed(context, '/login');
            },),
        ],
      ),
    );
  }
}


  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: const TextStyle(color: color),
      ),
      onTap: onClicked,
    );
  }

