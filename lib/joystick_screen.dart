// joystick_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart'; // Import joystick package

class JoystickScreen extends StatelessWidget {
  const JoystickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joystick Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Text(
              'Use the Joystick below:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // Space before joystick

            // Joystick widget
            Joystick(
              listener: (details) {
                print('Stick x: ${details.x}');
                print('Stick y: ${details.y}');
              },
              mode: JoystickMode.all, // Allow movement in all directions
            ),
            
            SizedBox(height: 40), // Space between joystick and button

            // Button to go back to the main screen
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to Main Screen
              },
              child: Text('Back to Main Screen'),
            ),
          ],
        ),
      ),
    );
  }
}