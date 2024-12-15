// joystick_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robo_app/main.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:robo_app/misc_controls.dart';
import 'package:robo_app/speed_slider.dart'; // Import joystick package

class JoystickScreen extends StatelessWidget {
  const JoystickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft, // Allow landscape left orientation
      DeviceOrientation.landscapeRight, // Allow landscape right orientation
    ]);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      /*appBar: AppBar(
        title: Text('Joystick Screen'),
      ),*/
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
                    CustomControl(
                      cmd: 'W',
                      icon: 'lib/icons/car-light.png',
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
                    CustomControl(
                      cmd: 'V',
                      icon: 'lib/icons/horn.png',
                    ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, left: screenWidth / 2 - 150),
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