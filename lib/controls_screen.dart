// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robo_app/utils.dart';
import 'joystick_screen.dart'; // Import the second screen
import 'buttons.dart'; 
import 'speed_slider.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0; // Tracks the selected tab index

  // List of widgets for each screen
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize screens with passed data
    _screens = [
      ControlsScreen(),
      JoystickScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current index when a tab is tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        backgroundColor: const Color.fromARGB(255, 178, 216, 195),
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: const Color.fromARGB(255, 168, 163, 163),

        currentIndex: _currentIndex, // Highlight the selected tab
        onTap: _onItemTapped, // Handle tab selection
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('lib/icons/console.png')),
            label: 'Controls',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('lib/icons/joystick.png')),
            label: 'Joystick',
          ),
        ],
      ),
    );
  }
}

class ControlsScreen extends StatefulWidget {
  const ControlsScreen({super.key});

  @override
  _ControlsScreen createState() => _ControlsScreen();
}

class _ControlsScreen extends State<ControlsScreen> {
  bool _isSwitched = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
          mainAxisAlignment: MainAxisAlignment.start, 
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            SizedBox(height: screenWidth * 0.1),
            Row (
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Up Down buttons
                Column(
                  children: [
                    Padding (
                      padding: EdgeInsets.only(left: screenHeight * 0.15),
                      child: 
                        CustomGestureButton(
                          cmd: 'F',
                          icon: 'lib/icons/up.png',
                          sendStop: true,
                        ),
                    ),
                    SizedBox(height: screenWidth * 0.06),
                    Padding (
                      padding: EdgeInsets.only(left: screenHeight * 0.15),
                      child:
                        CustomGestureButton(
                          cmd: 'B',
                          icon: 'lib/icons/down.png',
                          sendStop: true,
                        ),
                    ),
                  ],
                ),
                // Light switch button
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding (
                      padding: EdgeInsets.only(top: screenWidth * 0.06, left: screenHeight * 0.09),
                      child: Icon(_isSwitched ? Icons.light_mode : Icons.light_mode_outlined, color: _isSwitched ? Colors.green : Colors.red),
                    ),
                    Padding (
                      padding: EdgeInsets.only(top:0, left: screenHeight * 0.05),
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
                // Speed Slider 
                Padding (
                  padding: EdgeInsets.only(top: screenWidth * 0.15, left: screenHeight * 0.1),
                  child: 
                    SizedBox (
                      width: screenWidth * 0.3,
                      child: ValueSlider(),
                    ),
                ),
                Column (
                  children: [
                    // Horn
                    Padding (
                      padding: EdgeInsets.only(top: screenWidth * 0.03, left: screenHeight * 0.1),
                      child: 
                        CustomGestureButton(
                          cmd: 'V',
                          icon: 'lib/icons/horn.png',
                          sendStop: false,
                        ),
                    ),
                    // Left Right buttons
                    Row (
                      children: [
                        Padding (
                          padding: EdgeInsets.only(top: screenHeight * 0.5 - 170 , left: screenHeight * 0.1),
                          child: 
                            CustomGestureButton(
                              cmd: 'L',
                              icon: 'lib/icons/left.png',
                              sendStop: true,
                            ),
                        ),
                        SizedBox(width: screenWidth * 0.06),
                        Padding (
                          padding: EdgeInsets.only(top: screenHeight * 0.5 - 170),
                          child: 
                            CustomGestureButton(
                              cmd: 'R',
                              icon: 'lib/icons/right.png',
                              sendStop: true,
                            ),
                        ),
                      ],
                    ),       
                  ],
                ),
              ]
            ), 
          ]
        ),
      )
    );
  }  
}