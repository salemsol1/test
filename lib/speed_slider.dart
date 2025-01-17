// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:robo_app/utils.dart';

class ValueSlider extends StatefulWidget {
  const ValueSlider({super.key});

  @override
  _ValueSliderState createState() => _ValueSliderState();
}

class _ValueSliderState extends State<ValueSlider> {
  double _currentValue = 0;

  Future<void> _changeSpeed(int speed) async {
    sendCmdToServer(context: context, cmd: speed.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentValue,
      min: 0,
      max: 10,
      divisions: 10, // This ensures increments of 1
      label: _currentValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentValue = value;
          _changeSpeed(value.toInt());
        });
      },
    );
  }
}