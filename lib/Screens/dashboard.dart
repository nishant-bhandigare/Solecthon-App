// library imports
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:solecthonApp/Utils/constants.dart';
import 'package:solecthonApp/Utils/widgets.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// Systems imports
import 'drawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Get the instance of the Bluetooth
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  late BluetoothConnection connection;
  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection.isConnected;

  static const title = 'Dashboard';
  String buttonTitle = "Connect";
  String connectionTitle = "Bluetooth Disconnected";
  bool connected = false;
  bool connected_display = false;

  double _value = 0.00;
  int battery = 100;
  double batteryV = 60.0;
  double batteryAmps = 0.0;
  double distance = 3.1;
  double batteryTemp = 30.0;
  double motorTemp = 35.0;
  double controllerTemp = 25.0;

  void labelCreated(AxisLabelCreatedArgs args) {
    if (args.text == '0') {
      args.text = 'N';
      args.labelStyle = GaugeTextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14);
    } else if (args.text == '10')
      args.text = '';
    else if (args.text == '20')
      args.text = 'E';
    else if (args.text == '30')
      args.text = '';
    else if (args.text == '40')
      args.text = 'S';
    else if (args.text == '50')
      args.text = '';
    else if (args.text == '60')
      args.text = 'W';
    else if (args.text == '70') args.text = '';
  }

  void setToConnected() {
    setState(() {
      connected_display = true;
      buttonTitle = "Disconnect";
      connectionTitle = "Bluetooth Connected";
    });
  }

  void resetToDisconnected() {
    setState(() {
      connected_display = false;
      connected = false;
      buttonTitle = "Connect";
      connectionTitle = "Bluetooth Disconnected";
      _value = 0.00;
      battery = 100;
      batteryV = 0.0;
      batteryAmps = 0.0;
      distance = 0.0;
      batteryTemp = 0.0;
      motorTemp = 0.0;
      controllerTemp = 0.0;
    });
  }

  Future<bool> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    print("state of bt: " + _bluetoothState.stringValue);
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      return true;
    }
    return false;
  }

  void connectBluetooth() async {
    String bluetoothAddress =
        "00:20:08:00:44:C8"; // Example address, replace with HC-05 address

    print("Let's begin");
    await FlutterBluetoothSerial.instance.state.then((state) async {
      setState(() {
        _bluetoothState = state;
      });

      print("entering enable bt");
      await enableBluetooth();
      print("Bluetooth is on");

      var bluetoothConnectStatus =
          await Permission.bluetoothConnect.request().isGranted;

      if (bluetoothConnectStatus) {
        await BluetoothConnection.toAddress(bluetoothAddress)
            .then((_connection) {
          print('Connected to the device 14 march');

          // Updating buttons after connection is setup
          setState(() {
            connectionTitle = "Bluetooth Connected";
            buttonTitle = "Disconnect";
          });

          if (connected == false) {
            // Updating buttons after connection is setup
            setState(() {
              connectionTitle = "Bluetoot Disconnected";
              buttonTitle = "Connect";
            });

            print('Disconnecting by local host');
            resetToDisconnected();
            _connection.finish(); // Closing connection
          }

          _connection.input?.listen((Uint8List data) {
            // Collect input data
            var decodedData = ascii.decode(data);
            List d = decodedData.split(" ");

            setState(() {
              _value = double.parse(d[1].replaceAll(RegExp(r'[^0-9.]'), ''));
              battery = int.parse(d[3]);
              batteryV = double.parse(d[5].replaceAll(RegExp(r'[^0-9.]'), ''));
              batteryAmps =
                  double.parse(d[7].replaceAll(RegExp(r'[^0-9.]'), ''));
              distance = double.parse(d[9].replaceAll(RegExp(r'[^0-9.]'), ''));
              batteryTemp =
                  double.parse(d[11].replaceAll(RegExp(r'[^0-9.]'), ''));
              motorTemp =
                  double.parse(d[13].replaceAll(RegExp(r'[^0-9.]'), ''));
              controllerTemp =
                  double.parse(d[15].replaceAll(RegExp(r'[^0-9.]'), ''));
            });

            // print('Data incoming: ${ascii.decode(data)}');
            // connection.output.add(data); // Sending data

            // Disconnect Bluetooth
            if (connected == false) {
              // Updating buttons after connection is setup
              setState(() {
                connectionTitle = "Bluetoot Disconnected";
                buttonTitle = "Connect";
              });

              print('Disconnecting by local host');
              resetToDisconnected();
              _connection.finish(); // Closing connection
            }
          }).onDone(() {
            print('Disconnected by remote request');
            resetToDisconnected();
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
      }
    });

    print("bluetooth done");
  }

  void speedometer() async {
    bool check = false;
    setToConnected();

    for (int i = 0; i < 1000; i++) {
      if (connected == false) {
        resetToDisconnected();
        break;
      }

      await Future.delayed(const Duration(seconds: 1), () {
        if (_value <= 0) {
          setState(() {
            _value = 65.0;
          });
        }
        if (_value >= 60.0) {
          setState(() {
            _value -= 10.0;
          });
        } else if (_value >= 50.0) {
          setState(() {
            _value -= 20.0;
          });
        } else {
          setState(() {
            _value += 10.0;
          });
        }

        if (batteryV >= 65.0) {
          setState(() {
            batteryV -= 5.0;
          });
        } else {
          setState(() {
            batteryV += 1.0;
          });
        }

        setState(() {
          battery -= 1;
        });

        if (check == false) {
          batteryTemp -= 2.0;
          check = true;
        } else {
          batteryTemp += 3.0;
          check = false;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    print(h);
    print(w);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColour,
      body: Container(
        height: h,
        width: w,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: SafeArea(
                      child: Container(
                    height: 60,
                    width: w,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.menu_rounded,
                                    color: iconColour,
                                    size: 32.0,
                                  ),
                                  onPressed: () {
                                    _scaffoldKey.currentState?.openDrawer();
                                  }),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 2.0),
                                child: boldText(title),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: cardColour,
                                elevation: 8.0,
                                shadowColor: Colors.grey[600]),
                            onPressed: () {
                              if (connected == false) {
                                setState(() {
                                  connected = true;
                                  connectBluetooth();
                                  // speedometer();
                                });
                              } else {
                                setState(() {
                                  connected = false;
                                });
                              }
                            },
                            // child: connectionMediumText(buttonTitle),
                            child: Text(buttonTitle,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Medium",
                                    color: buttonTitle ==
                                                "Bluetooth Connected" ||
                                            buttonTitle == "Connect"
                                        ? Colors.green
                                        : buttonTitle ==
                                                    "Bluetooth Disconnected" ||
                                                buttonTitle == "Disconnect"
                                            ? Colors.red
                                            : textColour)),
                          )
                        ],
                      ),
                    ),
                  ))),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    largeText("Welcome Nishant!"),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 10.0,
              // ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      child: Container(
                          width: 75,
                          height: 75,
                          child: Image.asset("assets/images/power.png")),
                      onPressed: () {},
                    ),
                    const SizedBox(
                      height: 8.0,
                      width: 50,
                    ),
                    OutlinedButton(
                      child: Container(
                          width: 70,
                          height: 70,
                          child: Image.asset("assets/images/headlight.png")),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Container(
                  height: h / 2.6,
                  width: w * 0.9,
                  color: Colors.transparent,
                  child: SfRadialGauge(axes: <RadialAxis>[
                    // RadialAxis(startAngle: 270, endAngle: 270,minimum: 0,maximum: 80,interval: 10,radiusFactor: 0.4,
                    //   showAxisLine: false, showLastLabel: false, minorTicksPerInterval: 4,
                    //   majorTickStyle: MajorTickStyle(length: 8,thickness: 3,color: Colors.white),
                    //   minorTickStyle: MinorTickStyle(length: 3,thickness: 1.5,color: Colors.white),
                    //   axisLabelStyle: GaugeTextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14 ),
                    //   onLabelCreated: labelCreated
                    // ),
                    RadialAxis(
                      minimum: 0,
                      maximum: 120,
                      labelOffset: 30,
                      axisLineStyle: const AxisLineStyle(
                          thicknessUnit: GaugeSizeUnit.factor, thickness: 0.03),
                      majorTickStyle: MajorTickStyle(
                          length: 6, thickness: 4, color: Colors.white),
                      minorTickStyle: MinorTickStyle(
                          length: 3, thickness: 3, color: Colors.white),
                      axisLabelStyle: GaugeTextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      ranges: <GaugeRange>[
                        GaugeRange(
                          startValue: 0,
                          endValue: 120,
                          sizeUnit: GaugeSizeUnit.factor,
                          startWidth: 0.03,
                          endWidth: 0.03,
                          gradient: SweepGradient(colors: const <Color>[
                            Colors.green,
                            Colors.yellow,
                            Colors.red
                          ], stops: const <double>[
                            0.0,
                            0.5,
                            1
                          ]),
                        )
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Container(
                                child: Column(children: <Widget>[
                              Text(_value.toString(),
                                  style: TextStyle(
                                      color: textColour,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              Text('Km/h',
                                  style: TextStyle(
                                      color: textColour,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold))
                            ])),
                            angle: 90,
                            positionFactor: 1.6)
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                            value: _value,
                            needleLength: 0.95,
                            animationType: AnimationType.ease,
                            needleStartWidth: 1.5,
                            needleEndWidth: 6,
                            needleColor: Colors.red,
                            knobStyle: const KnobStyle(
                                knobRadius: 0.09, color: Colors.red))
                      ],
                    )
                  ])),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // children: [connectionMediumText(connectionTitle)],
                children: [
                  Text(connectionTitle,
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: "Medium",
                          color: connectionTitle == "Bluetooth Connected" ||
                                  connectionTitle == "Connect"
                              ? Colors.green
                              : connectionTitle == "Bluetooth Disconnected" ||
                                      connectionTitle == "Disconnect"
                                  ? Colors.red
                                  : textColour))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: h / 6.5,
                          width: w * 0.466,
                          child: Card(
                            color: cardColour,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                regularText("Controller"),
                                const SizedBox(height: 5.0),
                                Icon(
                                  // Icons.battery_alert,
                                  Icons.device_thermostat_outlined,
                                  size: 40.0,
                                  color: iconColour,
                                ),
                                const SizedBox(height: 8.0),
                                mediumText(
                                    controllerTemp.toString() + " \u2103")
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: h / 6.5,
                          width: w * 0.466,
                          child: Card(
                            color: cardColour,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.airport_shuttle_rounded,
                                  size: 40.0,
                                  color: iconColour,
                                ),
                                const SizedBox(height: 10.0),
                                mediumText(distance.toString() + " kms")
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: h / 6.5,
                          width: w * 0.3,
                          child: Card(
                            color: cardColour,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bolt_outlined,
                                  size: 40.0,
                                  color: iconColour,
                                ),
                                const SizedBox(height: 8.0),
                                mediumText(batteryV.toString() + " V"),
                                const SizedBox(height: 2.0),
                                mediumText(batteryAmps.toString() + " A")
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: h / 6.5,
                          width: w * 0.3,
                          child: Card(
                            color: cardColour,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                regularText("Motor"),
                                const SizedBox(height: 5.0),
                                Icon(
                                  Icons.device_thermostat_outlined,
                                  size: 40.0,
                                  color: iconColour,
                                ),
                                const SizedBox(height: 8.0),
                                mediumText(motorTemp.toString() + " \u2103")
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: h / 6.5,
                          width: w * 0.3,
                          child: Card(
                            color: cardColour,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.battery_alert,
                                  size: 40.0,
                                  color: iconColour,
                                ),
                                const SizedBox(height: 10.0),
                                mediumText(battery.toString() + "%")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: h / 6.5,
                          width: w * 0.3,
                          child: Card(
                            color: cardColour,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bolt_outlined,
                                  size: 40.0,
                                  color: iconColour,
                                ),
                                const SizedBox(height: 8.0),
                                mediumText(batteryV.toString() + " V"),
                                const SizedBox(height: 2.0),
                                mediumText(batteryAmps.toString() + " A")
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: h / 6.5,
                          width: w * 0.3,
                          child: Card(
                            color: cardColour,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                regularText("Motor"),
                                const SizedBox(height: 5.0),
                                Icon(
                                  Icons.device_thermostat_outlined,
                                  size: 40.0,
                                  color: iconColour,
                                ),
                                const SizedBox(height: 8.0),
                                mediumText(motorTemp.toString() + " \u2103")
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: h / 6.5,
                          width: w * 0.3,
                          child: Card(
                            color: cardColour,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.battery_alert,
                                  size: 40.0,
                                  color: iconColour,
                                ),
                                const SizedBox(height: 10.0),
                                mediumText(battery.toString() + "%")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
