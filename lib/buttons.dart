// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async'; // Import Timer
import 'package:robo_app/utils.dart';

final ValueNotifier<bool> isUpPressed = ValueNotifier<bool>(false);
final ValueNotifier<bool> isDownPressed = ValueNotifier<bool>(false);
final ValueNotifier<bool> isLeftPressed = ValueNotifier<bool>(false);
final ValueNotifier<bool> isRightPressed = ValueNotifier<bool>(false);
final ValueNotifier<bool> isHornPressed = ValueNotifier<bool>(false);
String currCmd = '';

class CustomGestureButton extends StatefulWidget {
  final String cmd;
  final String icon;
  final bool sendStop;

  const CustomGestureButton({
    super.key,
    required this.cmd,
    required this.icon,
    required this.sendStop,
  });

  @override
  _CustomGestureButtonState createState() => _CustomGestureButtonState();
}

class _CustomGestureButtonState extends State<CustomGestureButton> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
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

  Future<void> _tapDown(String cmd) async {
    _setPressedState(cmd, true);
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      currCmd = getCurrCmd(cmd);

      sendCmdToServer(context: context,cmd: currCmd, retry: 1);
    });
  }

  Future<void> _tapUp(String cmd) async {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    setPressedState(cmd, false);
    if (widget.sendStop) {
        sendCmdToServer(context: context,cmd: 'S', retry: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onTap: () => _handleButtonClick(widget.cmd, widget.sendStop, 1),
      onTapDown: (details) => _tapDown(widget.cmd),
      onTapUp: (details) => _tapUp(widget.cmd),
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