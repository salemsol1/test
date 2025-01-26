// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:robo_app/config.dart';
import 'package:http/http.dart' as http;
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
  bool isConnected = false; // Tracks whether the connection is established

  @override
  void initState() {
    super.initState();
    checkServerConnection(); // Start checking the server connection on initialization
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkServerConnection() async {
    while (!isConnected) {
      try {
        final response = await http
            .get(Uri.parse('http://$roboIp:$roboPort/?State=S')) // Replace with your server URL
            .timeout(Duration(seconds: 5)); // Timeout after 5 seconds

        if (response.statusCode == 200) {
          setState(() {
            isConnected = true; // Connection successful
          });
          Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (context) => BottomNavScreen()),
          ); // Exit the loop once connected
        }
      } catch (e) {
        print("Connection failed, retrying..."); // Log failure and retry
        await Future.delayed(Duration(seconds: 2)); // Wait before retrying
      }
    }
  }

  @override
  Widget build(BuildContext context) {
  final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('lib/icons/main.jpg'), fit: BoxFit.cover),
        ),
        padding: EdgeInsets.only(top: screenHeight / 2 - 180),
        child: Center(
          child: !isConnected ? Text("Waiting for robot...", style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 102, 160, 104)),) :
            Text("Connected!", style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 102, 160, 104)),),
        ),
      )
    );
  }
}