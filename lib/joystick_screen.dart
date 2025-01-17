// joystick_screen.dart
// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robo_app/buttons.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:robo_app/internet_connection_manager.dart';
import 'package:robo_app/speed_slider.dart';
import 'package:robo_app/utils.dart';

class JoystickScreen extends StatefulWidget {
  const JoystickScreen({super.key});

    @override
  _JoystickScreenState createState() => _JoystickScreenState();
}
class _JoystickScreenState extends State<JoystickScreen> {
  late InternetConnectionManager connectionManager;
  bool _isSwitched = false;
  
  @override
  void initState() {
    super.initState();
    connectionManager = InternetConnectionManager(context);
  }

  @override
  void dispose() {
    connectionManager.dispose();
    super.dispose();
  }

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
            Row(
              children: [
                // Light Switch
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding (
                      padding: EdgeInsets.only(top: screenWidth * 0.17, left: screenHeight * 0.2),
                      child: Icon(_isSwitched ? Icons.light_mode : Icons.light_mode_outlined, color: _isSwitched ? Colors.green : Colors.red),
                    ),
                    Padding (
                      padding: EdgeInsets.only(top:0, left: screenHeight * 0.15),
                      child: Switch(
                        value: _isSwitched,
                        onChanged: (value) {
                          setState(() {
                            _isSwitched = value;
                          });
                          print("Switch is ${_isSwitched ? "ON" : "OFF"}");
                          sendCmdToServer(context: context, cmd: _isSwitched ? "W" : "w");
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
                // Joystick widget
                Padding(
                  padding: EdgeInsets.only(top: screenWidth / 10, left: screenHeight / 2 - 30),
                  child: SizedBox(
                    width: 170,
                    height: 170,
                    child: Joystick(
                      listener: (details) {
                        print('Stick x: ${details.x}');
                        print('Stick y: ${details.y}');
                        double x = 100 + details.x * 100;
                        double y = 100 - details.y * 100;
                        sendJoystickCmdToServer(context: context, x: x.toString(), y: y.toString());
                      },
                      mode: JoystickMode.all, // Allow movement in all directions
                    ),
                  ),
                ),
                // Horn
                Padding (
                  padding: EdgeInsets.only(top: screenWidth / 6, left: screenHeight / 2 - screenHeight * 0.1),
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
              padding: EdgeInsets.only(top: screenWidth * 0.02, left: (screenHeight / 2) + screenWidth * 0.1),
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