import 'dart:async'; // Import Timer
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'joystick_screen.dart'; // Import the second screen
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding

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
  runApp(MyApp());
}

String roboIp = "192.168.4.1";
String roboPort = "80";


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
  Timer? _timer;
  String responseMessage = "Waiting for button press...";
  
  // Define default colors for each button
  Color upButtonColor = Colors.blue;
  Color leftButtonColor = Colors.blue;
  Color rightButtonColor = Colors.blue;
  Color downButtonColor = Colors.blue;

  Future<void> _handleButtonClick(String direction) async {
    print('$direction button clicked');
    String cmd = 'F';
    switch (direction) {
        case 'Up':
          cmd = 'F';
          break;
        case 'Left':
          cmd = 'L';
          break;
        case 'Right':
          cmd = 'R';
          break;
        case 'Down':
          cmd = 'B';
          break;
      }
    try {
      final response = await http.get(Uri.parse('http://$roboIp:$roboPort/?State=$cmd'));

      if (response.statusCode == 200) {
        setState(() {
          responseMessage = "Sent $cmd";
        });
      } else {
        setState(() {
          responseMessage = "Failed to load data for $direction";
        });
      }
    } catch (e) {
      setState(() {
        responseMessage = "Error occurred: $e";
      });
    }
  }
  // Function to handle button clicks
  // void _handleButtonClick(String direction) {
  //   print('$direction button clicked');
  // }

  // Function to handle continuous action on long press
  void _startPressing(String direction) {
    _changeButtonColor(direction, true);
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      print('$direction button long-pressed');
    });
  }

  // Function to stop continuous action when long press ends
  void _stopPressing(String direction) {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _changeButtonColor(direction, false);
  }

  // Function to change the button color when pressed and revert when released
  void _changeButtonColor(String direction, bool isPressed) {
    setState(() {
      switch (direction) {
        case 'Up':
          upButtonColor = isPressed ? Colors.lightBlueAccent : Colors.blue;
          break;
        case 'Left':
          leftButtonColor = isPressed ? Colors.lightBlueAccent : Colors.blue;
          break;
        case 'Right':
          rightButtonColor = isPressed ? Colors.lightBlueAccent : Colors.blue;
          break;
        case 'Down':
          downButtonColor = isPressed ? Colors.lightBlueAccent : Colors.blue;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            // Up Button with GestureDetector for tap and long press support
            GestureDetector(
              onTap: () => _handleButtonClick('Up'),
              onTapDown: (_) => _changeButtonColor('Up', true), // Change color on tap down
              onTapUp: (_) => _changeButtonColor('Up', false),   // Revert color on tap up
              onTapCancel: () => _changeButtonColor('Up', false), // Revert if tap is canceled
              onLongPressStart: (_) => _startPressing('Up'),     // Start pressing action on long press start
              onLongPressEnd: (_) => _stopPressing('Up'),            // Stop pressing action on long press end
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: upButtonColor, // Dynamic color based on state
                  shape: BoxShape.circle, // Makes the container round
                ),
                child: Icon(
                  Icons.arrow_upward,
                  size: 40.0,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30), // Space between Up and Left/Right buttons

            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
              children: [
                // Left Button with GestureDetector for tap and long press support
                GestureDetector(
                  onTap: () => _handleButtonClick('Left'),
                  onTapDown: (_) => _changeButtonColor('Left', true),
                  onTapUp: (_) => _changeButtonColor('Left', false),
                  onTapCancel: () => _changeButtonColor('Left', false),
                  onLongPressStart: (_) => _startPressing('Left'),
                  onLongPressEnd: (_) => _stopPressing('Left'),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: leftButtonColor, // Dynamic color based on state
                      shape: BoxShape.circle, // Makes the container round
                    ),
                    child: Icon(
                      Icons.arrow_back, 
                      size: 40.0,
                      color:Colors.white
                    ),
                   ),
                 ),
                 SizedBox(width: 100), // Space between Left and Right buttons

                 // Right Button with GestureDetector for tap and long press support 
                GestureDetector( 
                  onTap: () => _handleButtonClick('Right'), 
                  onTapDown: (_) => _changeButtonColor('Right', true), 
                  onTapUp: (_) => _changeButtonColor('Right', false), 
                  onTapCancel: () => _changeButtonColor('Right', false), 
                  onLongPressStart: (_) => _startPressing('Right'), 
                  onLongPressEnd: (_) => _stopPressing('Right'), 
                  child: Container( 
                    width: 80, 
                    height: 80, 
                    decoration: BoxDecoration(
                    color:rightButtonColor,
                    shape: BoxShape.circle
                  ),
                  child:
                    Icon(
                    Icons.arrow_forward,
                    size: 40.0,
                    color:Colors.white
                    )
                  ),
                ),
              ],
            ),

          SizedBox(height: 30),

          GestureDetector( 
            onTap: () => _handleButtonClick('Down'), 
            onTapDown: (_) => _changeButtonColor('Down', true), 
            onTapUp: (_) => _changeButtonColor('Down', false), 
            onTapCancel: () => _changeButtonColor('Down', false), 
            onLongPressStart: (_) => _startPressing('Down'), 
            onLongPressEnd: (_) => _stopPressing('Down'), 
            child: Container( 
              width: 80, 
              height: 80, 
              decoration: BoxDecoration(
                color: downButtonColor, 
                shape: BoxShape.circle
              ), 
              child: Icon(
                Icons.arrow_downward, 
                size: 40.0, 
                color: Colors.white
              )
            )
          ),
          
          SizedBox(height: 50), // Space before toggle button

          ElevatedButton( 
            onPressed: () { 
              Navigator.push(
                context, MaterialPageRoute(builder:(context)=>JoystickScreen())
              ); 
             },
            child: Text('Go to Joystick Screen')
          ),
          Text(responseMessage),
        ]
      )
    )
  );
 }
}
