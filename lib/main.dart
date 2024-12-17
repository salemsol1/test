import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:robo_app/config.dart';
import 'controls_screen.dart'; // Import the controls screen

// Custom HttpOverrides class to bypass SSL certificate verification
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter bindings are initialized
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Allow landscape left orientation
    DeviceOrientation.portraitDown, // Allow landscape right orientation
  ]).then((_) {
    runApp(MyApp()); // Run your app
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arrow Buttons App',
      home: MainScreen(),
    );
  }
}

// Main Screen with Arrow Buttons and Toggle Button
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
  final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('lib/icons/Untitled-1.jpg'), fit: BoxFit.cover),
        ),
        padding: EdgeInsets.only(top: screenHeight / 2 - 180),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[100],
              shadowColor: Colors.lightGreen[200],
              elevation: 10,
              minimumSize: Size(200,100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Let\'s go',
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 94, 126, 97),
              ),
            ),
          ),
        ),
      ),
    );
  }
}