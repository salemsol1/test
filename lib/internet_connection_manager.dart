import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectionManager {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isDialogOpen = false; // To track if the dialog is already shown
  BuildContext? _context; // Store the context for showing dialogs

  // Constructor to initialize the manager with a context
  InternetConnectionManager(BuildContext context) {
    _context = context;
    _monitorInternetConnection(); // Start monitoring connectivity
  }

  // Monitor internet connection status
  void _monitorInternetConnection() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        // No network connection
        _showNoConnectionDialog();
      } else {
        // Close dialog if internet is restored
        if (_isDialogOpen) {
          Navigator.of(_context!).pop(); // Close the dialog
          _isDialogOpen = false;
        }
      }
    });
  }

  // Show no internet connection dialog
  void _showNoConnectionDialog() {
    if (!_isDialogOpen && _context != null) {
      _isDialogOpen = true; // Mark dialog as open
      showDialog(
        context: _context!,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (context) => AlertDialog(
          title: Text("No Internet Connection"),
          content: Text("Please check your WiFi"),
          /*actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _isDialogOpen = false;
              },
              child: Text("OK"),
            ),
          ],*/
        ),
      );
    }
  }

  // Dispose method to clean up resources
  void dispose() {
    _connectivitySubscription.cancel(); // Cancel subscription when no longer needed
  }
}
