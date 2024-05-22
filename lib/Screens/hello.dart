import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Hello extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AUTONOMUS',
      home: BluetoothPage(),
    );
  }
}

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  late BluetoothConnection connection;
  bool isConnecting = false;

  void _connectToBluetooth() async {
    // Get the Bluetooth device instance
    BluetoothDevice device = await FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((devices) => devices.firstWhere((device) =>
            device.name == 'SOLECTHON')); // Replace with your HC-05 name

    // Connect to the Bluetooth device
    BluetoothConnection.toAddress(device.address).then((conn) {
      connection = conn;
      setState(() {
        isConnecting = false;
      });
    }).catchError((error) {
      print(error);
    });
  }

  void _sendString(String str) {
    if (connection != null) {
      Uint8List bytes = Uint8List.fromList(utf8.encode(str));
      connection.output.add(bytes);
      connection.output.allSent.then((_) {
        print("Sent: $bytes");
      });
    }
    if (str == 'z') {
      // Updating buttons after connection is setup

      connection.finish(); // Closing connection
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AUTOOMOUS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _sendString('a');
              },
              child: Text('Send a'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendString('b');
              },
              child: Text('Send b'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendString('z');
              },
              child: Text('disconnect'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isConnecting = true;
          });
          _connectToBluetooth();
        },
        child: Icon(Icons.bluetooth),
      ),
    );
  }
}
