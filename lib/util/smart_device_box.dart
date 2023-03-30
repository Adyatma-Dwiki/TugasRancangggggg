// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, deprecated_member_use, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SmartDeviceBox extends StatefulWidget {
  final String smartDeviceName;
  final String iconPath;
  final bool powerOn;

  const SmartDeviceBox({
    Key? key,
    required this.smartDeviceName,
    required this.iconPath,
    required this.powerOn, required Null Function(dynamic value) powerSwitchChanged,
  });

  @override
  _SmartDeviceBoxState createState() => _SmartDeviceBoxState();
}

class _SmartDeviceBoxState extends State<SmartDeviceBox> {
  late bool _powerOn;

  void _onChanged(bool value) {
    final dbRef = FirebaseDatabase.instance.reference().child('lamp');
    final db = FirebaseDatabase.instance.reference().child('fan');
    db.set({'Switch' : value});
    dbRef.set({'Switch': value});
    setState(() {
      _powerOn = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _powerOn = widget.powerOn;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: _powerOn ? Colors.grey[900] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              widget.iconPath,
              height: 65,
              color: _powerOn ? Colors.white : Colors.black,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      widget.smartDeviceName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: _powerOn ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: pi / 2,
                  child: CupertinoSwitch(
                    value: _powerOn,
                    onChanged: _onChanged,
                    activeColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
