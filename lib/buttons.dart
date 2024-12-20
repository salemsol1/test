import 'package:flutter/material.dart';
import 'dart:async'; // Import Timer
import 'package:http/http.dart' as http;
import 'config.dart';

final ValueNotifier<bool> isUpPressed = ValueNotifier<bool>(false);
final ValueNotifier<bool> isDownPressed = ValueNotifier<bool>(false);
final ValueNotifier<bool> isLeftPressed = ValueNotifier<bool>(false);
final ValueNotifier<bool> isRightPressed = ValueNotifier<bool>(false);
String currCmd = '';

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

  String getCurrCmd(String cmd) {
    if (isUpPressed.value && isLeftPressed.value) {
      return 'G';
    }
    if (isUpPressed.value && isRightPressed.value) {
      return 'I';
    }
    if (isDownPressed.value && isLeftPressed.value) {
      return 'H';
    }
    if (isDownPressed.value && isRightPressed.value) {
      return 'J';
    }
    return cmd;
  }

  void setPressedState(String cmd, bool val) {
    if (cmd == 'F') {
      isUpPressed.value = val;
    } else if (cmd == 'B') {
      isDownPressed.value = val;
    } else if (cmd == 'L') {
      isLeftPressed.value = val;
    } else if (cmd == 'R') {
      isRightPressed.value = val;
    }
  }

  Future<void> _setPressedState(String cmd, bool val) async {
    setPressedState(cmd, val);
  }
  
  Future<void> _handleButtonClick(String cmd, bool sendStop, int retry) async {
    if (retry > 100) {
      return;
    }
    String currCmd = getCurrCmd(cmd);

    print('$currCmd button clicked');
    try {
      final response = await http.get(Uri.parse('http://$roboIp:$roboPort/?State=$currCmd'));

      if (response.statusCode == 200) {
        if (sendStop) {
          _handleButtonClick('S', false, 1);
        }
        print('sent $currCmd');
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

    setPressedState(cmd, true);
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      currCmd = getCurrCmd(cmd);

      print('$currCmd button long-pressed');
      print(isUpPressed.value);
      _handleButtonClick(currCmd, false, 1);
    });
  }

  // Function to stop continuous action when long press ends
  void _stopPressing(String cmd) {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _handleButtonClick('S', false, 1);
    setPressedState(cmd, false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleButtonClick(widget.cmd, widget.sendStop, 1),
      onTapDown: (details) => _setPressedState(widget.cmd, true),
      onTapUp: (details) => _setPressedState(widget.cmd, false),
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