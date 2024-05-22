import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial_example/widget.dart';
// import 'package:solecthonApp/Utils/widgets.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

// import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// import 'package:/screens/homeScreen.dart';

// SetState()

class Autonomous extends StatefulWidget {
  final BluetoothDevice server;

  const Autonomous({required this.server});

  @override
  State<Autonomous> createState() => _AutonomousState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _AutonomousState extends State<Autonomous> {
  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  String val = "";
  double _value = 0.00;

  @override
  void initState() {
    super.initState();
    _value = 0.00;
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: small_text('Autonomous'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            // MaterialPageRoute(builder: (context) => const HomeScreen());
            print("Print back button");
          },
          icon: Icon(Icons.widgets),
          // icon: Icons.width_full_outlined,
        ),
      ),
      body: Container(
          height: h,
          width: w,
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _sendMessage("start");
                      print("Move forward");
                    },
                    child: button_text("Start"),
                  ),
                  IconButton(
                      icon: const Icon(Icons.account_circle),
                      onPressed:
                          isConnected ? () => _sendMessage("ready") : null),
                  ElevatedButton(
                    onPressed: () {
                      _sendMessage("exit");
                      print("Stop Vehicle");
                    },
                    child: button_text("Stop"),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _sendMessage("shutDown");
                      print("system shutting down");
                    },
                    child: small_text("Shut Down"),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       val,
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Slider(
                    min: -60,
                    max: 60,
                    divisions: 24,
                    value: _value,
                    activeColor: Colors.green,
                    inactiveColor: Colors.orange,
                    onChanged: (val) {
                      // print("New value is: " + val.toString());
                      setState(() {
                        _value = val;
                      });

                      _sendMessage((_value.toInt()).toString());

                      setState(() {
                        _value = 0.00;
                      });
                    },
                  )
                ],
              ),
            ],
          ))),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }

    setState(() {
      val = dataString;
    });
    print(dataString);
    print(val);
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}

small_text(String name) {
  return Text(
    name,
    style: TextStyle(
      // fontFamily: ,
      fontSize: 16,
      color: Color.fromRGBO(0, 0, 0, 1),
    )
  );
}
 button_text(String name) {
  return Text(
    name,
    style: TextStyle(
      // fontFamily: ,
      fontSize: 14,
      color: Color.fromRGBO(0, 0, 0, 1),
    )
  );
}




