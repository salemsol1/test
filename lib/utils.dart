// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:robo_app/config.dart';
import 'package:http/http.dart' as http;

void showErrorDialog(BuildContext context, String message) {
  OverlayState overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      left: MediaQuery.of(context).size.width * 0.05,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  overlayEntry.remove(); // Close the overlay
                },
                child: Text("Close"),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Insert the overlay entry
  overlayState.insert(overlayEntry);
}

Future<void> sendJoystickCmdToServer({required BuildContext  context, required String x, required String y}) async {
  int retries = 1;
  while (retries > 0) {
    try {
      final response = await http
        .get(Uri.parse('http://$roboIp:$roboPort/?JX=$x&JY=$y'))
        .timeout(Duration(milliseconds: 600)); // Timeout after 600ms

      if (response.statusCode == 200) {
        print('sent JoystickX $x, JoystcikY $y');
        break; // Exit the loop once cmd sent
      } else {
        showErrorDialog(context, "Error communicating with server");
      }
      retries--;
    } catch (e) {
      print("Connection failed, retrying..."); // Log failure and retry
      await Future.delayed(Duration(milliseconds: 100)); // Wait before retrying
      retries--;
    }
  }
}

Future<void> sendCmdToServer({required BuildContext  context, required String cmd}) async {
  int retries = 1;
  while (retries > 0) {
    try {
      final response = await http
        .get(Uri.parse('http://$roboIp:$roboPort/?State=$cmd'))
        .timeout(Duration(milliseconds: 600)); // Timeout after 600ms

      if (response.statusCode == 200) {
        print('sent $cmd');
        break; // Exit the loop once cmd sent
      } else {
        showErrorDialog(context, "Error communicating with server");
      }
      retries--;
    } catch (e) {
      print("Connection failed, retrying..."); // Log failure and retry
      await Future.delayed(Duration(milliseconds: 100)); // Wait before retrying
      retries--;
    }
  }
}