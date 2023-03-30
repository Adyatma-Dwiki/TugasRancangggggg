// ignore_for_file: unused_import, deprecated_member_use, no_leading_underscores_for_local_identifiers, unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../util/smart_device_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;
  DatabaseReference? _fanRef;
  DatabaseReference? _lampRef;
  
  bool lampSwitch = false;
  bool fanSwitch = false;

  //list of smart devices
  List<List<dynamic>> mySmartDevices = [
    ["Smart Light", "lib/icons/light-bulb.png", true],
    ["Smart Fan", "lib/icons/fan.png", true]
  ];
  
  get firebaseOptions => null;

  // power button switched
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _fanRef = FirebaseDatabase.instance.reference().child('fan');
    _lampRef = FirebaseDatabase.instance.reference().child('lamp');

    // Initialize Firebase
    // Initialize Firebase
  Firebase.initializeApp(options: firebaseOptions);

_fanRef?.child('Switch').onValue.listen((event) {
  final bool switchValue = event.snapshot.value as bool;
  if (switchValue) {
    setState(() {
      fanSwitch = true;
    });
  } else {
    setState(() {
      fanSwitch = false;
    });
  }
});

_lampRef?.child('Switch').onValue.listen((event) {
  final bool switchValue = event.snapshot.value as bool;
  if (switchValue) {
    setState(() {
      lampSwitch = true;
    });
  } else {
    setState(() {
      lampSwitch = false;
    });
  }
});

}

  @override
  void dispose() {
    // Clean up Firebase listeners
    _lampRef!.child('Switch').onValue.drain();
    _fanRef!.child('Switch').onValue.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'lib/icons/menu.png',
                    height: 45,
                    color: Colors.grey[800],
                  ),

                  //account icon
                  Icon(Icons.person, size: 45, color: Colors.grey[800]),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome Home,",
                        style:
                            TextStyle(fontSize: 20, color: Colors.grey[800])),
                    Text(
                      "John Paquito",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 72,
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Divider(
                color: Colors.grey[400],
                thickness: 1,
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text("Smart Devices",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.grey[800],
                  )),
            ),
            Expanded(
                child: GridView.builder(
              itemCount: mySmartDevices.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(25),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.2,
              ),
              itemBuilder: (context, index) {
                return SmartDeviceBox(
                  smartDeviceName: mySmartDevices[index][0],
                  iconPath: mySmartDevices[index][1],
                  powerOn: mySmartDevices[index][2],
                  powerSwitchChanged: (value) {
                    powerSwitchChanged(value, index);
                  },
                );
              },
            )),
          ],
        )));
  }
}
