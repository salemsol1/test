import 'package:flutter/material.dart';
import 'dart:async'; // Import Timer
import 'package:http/http.dart' as http;
import 'config.dart';

class CustomGestureButton extends StatefulWidget {
  final String cmd;
  final Color color;
  final String icon;
  final bool sendStop;

  const CustomGestureButton({
    super.key,
    required this.cmd,
    required this.color,
    required this.icon,
    required this.sendStop,
  });

  @override
  _CustomGestureButtonState createState() => _CustomGestureButtonState();
}

class _CustomGestureButtonState extends State<CustomGestureButton> {
  late Color buttonColor;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    buttonColor = widget.color;
  }

  Future<void> _handleButtonClick(String cmd, bool sendStop, int retry) async {
    if (retry > 100) {
      return;
    }

    print('$cmd button clicked');
    try {
      final response = await http.get(Uri.parse('http://$roboIp:$roboPort/?State=$cmd'));

      if (response.statusCode == 200) {
        if (sendStop) {
          _handleButtonClick('S', false, 1);
        }
        print('sent $cmd');
      } else {
        _handleButtonClick(cmd, sendStop, retry++);
        print("Failed to send $cmd, try $retry");
      }
    } catch (e) {
        print('Error occurred: $e');
    }
  }
    // Function to handle continuous action on long press
  void _startPressing(String cmd) {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      print('$cmd button long-pressed');
      _handleButtonClick(cmd, false, 1);
    });
  }

  // Function to stop continuous action when long press ends
  void _stopPressing(String cmd) {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _handleButtonClick('S', false, 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleButtonClick(widget.cmd, widget.sendStop, 1),
      onLongPressStart: (_) => _startPressing(widget.cmd),
      onLongPressEnd: (_) => _stopPressing(widget.cmd),
      child: SizedBox(
        width: 70,
        height: 70,
        child: Image.asset(
          widget.icon,
          width: 40.0,
          height: 40,
        ),
      ),
    );
  }
}