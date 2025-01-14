// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:robo_app/config.dart';
import 'package:http/http.dart' as http;

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("OK"),
        ),
      ],
    ),
  );
}

Future<void> sendCmdToServer({required BuildContext  context, required String cmd, required int retry}) async {
  if (retry > 100) {
    return;
  }

  print('$cmd button clicked retry is $retry');
  try {
    final response = await http.get(Uri.parse('http://$roboIp:$roboPort/?State=$cmd')).timeout(
      Duration(milliseconds: 100), 
      onTimeout: () {
        print('timeout for request');
        return http.Response("Request timed out", 408);
        }
      );
    if (response.statusCode == 200) {
      print('sent $cmd');
    } else if (response.statusCode == 408) {
      showErrorDialog(context, "Error communicating with server");
      print('Request timeout');
    } else {
      sendCmdToServer(context: context,cmd: cmd, retry: ++retry);
      print("Failed to send $cmd, try $retry");
    }
  } catch (e) {
    print('Error occurred: $e');
    return;
  }
}