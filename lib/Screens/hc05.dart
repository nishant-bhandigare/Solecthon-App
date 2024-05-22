// import 'dart:async';
// import 'package:solecthonApp/Screens/dashboard.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// class HC05Page extends StatefulWidget {
//   @override
//   _HC05PageState createState() => _HC05PageState();
// }

// class _HC05PageState extends State<HC05Page> {

//   connect
//   final bt =  _DashboardState();

//   void _startSendingData() async {
//     bt.connectBluetooth();
//     List<BluetoothDevice> devices = [];

//     try {
//       devices = await FlutterBluetoothSerial.instance.getBondedDevices();
//     } catch (ex) {
//       print(ex);
//     }

//     if (devices.isEmpty) {
//       print('No bonded devices found');
//       return;
//     }

//     // Look for HC-05 module
//     BluetoothDevice hc05;
//     for (BluetoothDevice device in devices) {
//       if (device.name == 'HC-05') {
//         hc05 = device;
//         break;
//       }
//     }

//     if (hc05 == null) {
//       print('HC-05 not found');
//       return;
//     }

//     try {
//       _connection = await BluetoothConnection.toAddress(hc05.address);
//       print('Connected to HC-05');
//       _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//         _connection.output.add(utf8.encode('Hello, HC-05!\n'));
//       });
//     } catch (ex) {
//       print(ex);
//       return;
//     }
//   }

//   void _stopSendingData() {
//     if (_connection != null) {
//       _connection.dispose();
//       _connection = null;
//       _timer.cancel();
//       _timer = null;
//       print('Stopped sending data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('HC-05 Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _startSendingData,
//               child: Text('Start Sending Data'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _stopSendingData,
//               child: Text('Stop Sending Data'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
