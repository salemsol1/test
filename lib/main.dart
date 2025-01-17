// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:robo_app/config.dart';
import 'package:http/http.dart' as http;
import 'package:robo_app/internet_connection_manager.dart';
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
  late InternetConnectionManager connectionManager;
  bool isConnected = false; // Tracks whether the connection is established
  bool isLoading = true; // Tracks whether we're still checking the connection

  @override
  void initState() {
    super.initState();
    connectionManager = InternetConnectionManager(context);
    checkServerConnection(); // Start checking the server connection on initialization
  }
  @override
  void dispose() {
    connectionManager.dispose(); // Dispose of resources when widget is destroyed
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
          break; // Exit the loop once connected
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
          child: isConnected ? 
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavScreen()),
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
                "Let's Go",
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 94, 126, 97),
                ),
                ),
            )
            : Text("Loading...", style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 102, 160, 104)),),
        ),
      )
    );
  }
}