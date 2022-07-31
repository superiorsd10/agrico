import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/SignIn.dart';
import 'pages/home_screen.dart';
import 'pages/todo_list.dart';
import 'package:sign_in_with_google/pages/weather_report.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // MyApp({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {

    Widget example1 = SplashScreenView(
      navigateRoute: const SignInWithG(),
      // navigateRoute: user != null? const HomeScreen() : const SignInWithG(),
      duration: 3000,
      text: "AGRICO",
      textType: TextType.TyperAnimatedText,
      textStyle: const TextStyle(
          color: Colors.lime,
          fontSize: 50.0,
          fontFamily: 'Roboto'
      ),
      backgroundColor: Colors.white,
    );


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login' : (context) => const SignInWithG(),
        '/homepage' : (context) => const HomeScreen(),
        '/todo' : (context) =>  TodoList(),
        '/weather' : (context) => const WeatherReport(),
      },
      home: example1,
    );
  }
}


