// joystick_screen.dart
// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robo_app/buttons.dart';
import 'package:robo_app/main.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:robo_app/speed_slider.dart'; // Import joystick package

class JoystickScreen extends StatefulWidget {
  const JoystickScreen({super.key});

    @override
  _JoystickScreenState createState() => _JoystickScreenState();
}
class _JoystickScreenState extends State<JoystickScreen> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft, // Allow landscape left orientation
      DeviceOrientation.landscapeRight, // Allow landscape right orientation
    ]);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('lib/icons/Untitled-1.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Center horizontally
          children: [
            // Home Button
            Padding(
              padding: const EdgeInsets.only(left: 10, top:30),
              child: IconButton(
                icon: Icon(Icons.home, size: 50, color: Colors.blue),
                onPressed: () {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]).then((_) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                      (route) => false, // Remove all previous routes from the stack                  
                    );
                  });
                },
              ),
            ),
            Row(
              children: [
                // Light Switch
                Padding (
                  padding: EdgeInsets.only(top: 0, left: screenWidth * 0.1),
                  child: 
                    Switch(
                    value: _isSwitched,
                    onChanged: (value) {
                      setState(() {
                        _isSwitched = value;
                      });
                      print("Switch is ${_isSwitched ? "ON" : "OFF"}");
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.grey,
                  ),
                ),
                // Joystick widget
                Padding(
                  padding: EdgeInsets.only(left: screenWidth / 2 - 260),
                  child: SizedBox(
                    width: 170,
                    height: 170,
                    child: Joystick(
                      listener: (details) {
                        print('Stick x: ${details.x}');
                        print('Stick y: ${details.y}');
                      },
                      mode: JoystickMode.all, // Allow movement in all directions
                    ),
                  ),
                ),
                // Horn
                Padding (
                  padding: EdgeInsets.only(left: screenHeight / 2),
                  child: 
                    CustomGestureButton(
                      cmd: 'V',
                      icon: 'lib/icons/horn.png',
                      sendStop: false,
                    ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: screenWidth / 2 - 140),
                child: SizedBox(
                  width: screenWidth * 0.3,
                  child: ValueSlider(),
                ),
            ),
          ],
        ),
      ),
    );
  }
}