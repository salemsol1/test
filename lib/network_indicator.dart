// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class NetworkStatusDot extends StatefulWidget {
  final String serverUrl;
  final Duration timeoutDuration;

  const NetworkStatusDot({
    super.key,
    required this.serverUrl,
    this.timeoutDuration = const Duration(seconds: 5),
  });

  @override
  _NetworkStatusDotState createState() => _NetworkStatusDotState();
}

class _NetworkStatusDotState extends State<NetworkStatusDot> {
  Color dotColor = Colors.red; // Default color is red (disconnected)
  bool isChecking = false; // Prevent multiple concurrent retries

  // Function to check server connection with retry logic
  Future<void> checkServerConnection() async {
    if (isChecking) return; // Prevent multiple retries at the same time
    setState(() {
      isChecking = true;
    });

    try {
      // Retry logic with exponential backoff
      final response = await retry(
        () => http
            .get(Uri.parse(widget.serverUrl))
            .timeout(widget.timeoutDuration), // Set timeout for each attempt

        // Retry on specific exceptions
        retryIf: (e) => e is TimeoutException || e is http.ClientException,
      );

      if (response.statusCode == 200) {
        setState(() {
          dotColor = Colors.green; // Change to green if request succeeds
          isChecking = false; // Stop checking after success
        });
      } else {
        setState(() {
          dotColor = Colors.red; // Keep red for non-200 responses
        });
      }
    } catch (e) {
      print("Retrying... Error: $e");
      setState(() {
        dotColor = Colors.red; // Keep red if all retries fail
        isChecking = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkServerConnection(); // Start checking on initialization
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: checkServerConnection, // Allow manual retry on tap
      child: Container(
        width: 20, // Dot size
        height: 20,
        decoration: BoxDecoration(
          color: dotColor, // Dynamic color based on network status
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
