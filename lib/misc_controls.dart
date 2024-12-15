import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class CustomControl extends StatefulWidget {
  final String cmd;
  final String icon;

  const CustomControl({
    super.key,
    required this.cmd,
    required this.icon,
  });

  @override
  _CustomControlState createState() => _CustomControlState();
}

class _CustomControlState extends State<CustomControl> {
  late Color buttonColor;
  bool lightOn = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleButtonClick(String cmd, int retry) async {
    if (retry > 100) {
      return;
    }

    if (cmd == 'W') {
      if (lightOn) {
        cmd = 'w';
      }
      lightOn = !lightOn;
    }

    print('$cmd button clicked');
    try {
      final response = await http.get(Uri.parse('http://$roboIp:$roboPort/?State=$cmd'));

      if (response.statusCode == 200) {
        print('sent $cmd');
      } else {
        _handleButtonClick(cmd, retry++);
        print("Failed to send $cmd, try $retry");
      }
    } catch (e) {
        print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleButtonClick(widget.cmd, 1),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          widget.icon,
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}