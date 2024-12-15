import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class ValueSlider extends StatefulWidget {
  const ValueSlider({super.key});

  @override
  _ValueSliderState createState() => _ValueSliderState();
}

class _ValueSliderState extends State<ValueSlider> {
  double _currentValue = 0;

  Future<void> _changeSpeed(int speed) async {
    print('speed set to $speed');

    try {
      final response = await http.get(Uri.parse('http://$roboIp:$roboPort/?State=$speed'));

      if (response.statusCode == 200) {
        print('speed set to $speed');
      } else {
        print('error setting speed');
      }
    } catch (e) {
      print('fatal error');
    }
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