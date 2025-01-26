// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:robo_app/config.dart';
import 'package:http/http.dart' as http;

Future<void> showErrorDialog(BuildContext context, String message) async {
  bool isConnected = false;
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        title: Text("Error communicating with robot"),
        content: Text(message),
      ),
    );
    while (!isConnected) {
      try {
        final response = await http
            .get(Uri.parse('http://$roboIp:$roboPort/?State=S')) // Replace with your server URL
            .timeout(Duration(milliseconds: 500)); // Timeout after 5 seconds

        if (response.statusCode == 200) {
          isConnected = true; // Connection successful
          Navigator.of(context).pop();
        }
      } catch (e) {
        print("Connection failed, retrying..."); // Log failure and retry
        await Future.delayed(Duration(milliseconds: 100)); // Wait before retrying
      }
    }
}

Future<void> sendJoystickCmdToServer({required BuildContext  context, required String x, required String y}) async {
  String message = "";
  int retries = 1;
  while (retries > 0) {
    retries--;
    try {
      final response = await http
        .get(Uri.parse('http://$roboIp:$roboPort/?JX=$x&JY=$y'))
        .timeout(Duration(milliseconds: 500)); // Timeout after 600ms

      if (response.statusCode == 200) {
        print('sent JoystickX $x, JoystcikY $y');
        return; // Exit the loop once cmd sent
      }
    }on SocketException {
      message = "No Internet Connection. Please check your network.";
    } on TimeoutException {
      message = "Request timed out. Check robot connection";
    } on HttpException catch (e) {
      message = "HTTP Error: ${e.message}";
    } catch (e) {
      print("Connection failed, retrying..."); // Log failure and retry
      await Future.delayed(Duration(milliseconds: 100)); // Wait before retrying
      message = "An unknown error occurred: $e";
    }
  }
  showErrorDialog(context, message);
}

Future<void> sendCmdToServer({required BuildContext  context, required String cmd}) async {
  String message = "";
  int retries = 1;
  while (retries > 0) {
    retries--;
    try {
      final response = await http
        .get(Uri.parse('http://$roboIp:$roboPort/?State=$cmd'))
        .timeout(Duration(milliseconds: 500)); // Timeout after 600ms

      if (response.statusCode == 200) {
        print('sent $cmd');
        return; // Exit the loop once cmd sent
      }
    } on SocketException {
      message = "No Internet Connection. Please check your network.";
    } on TimeoutException {
      message = "Request timed out. Check robot connection";
    } on HttpException catch (e) {
      message = "HTTP Error: ${e.message}";
    } catch (e) {
      print("Connection failed, retrying..."); // Log failure and retry
      await Future.delayed(Duration(milliseconds: 100)); // Wait before retrying
      message = "An unknown error occurred: $e";
    }
  }
  showErrorDialog(context, message);
}