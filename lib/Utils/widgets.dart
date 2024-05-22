// library imports
import 'package:flutter/material.dart';

// Systems imports
import 'package:solecthonApp/Utils/constants.dart';

Widget regularText(String text) {
  return Text(text,
      style: TextStyle(fontSize: 16, fontFamily: "Regular", color: textColour));
}

Widget mediumText(String text) {
  return Text(text,
      style: TextStyle(fontSize: 17, fontFamily: "Medium", color: textColour));
}

Widget connectionMediumText(String text) {
  return Text(text,
      style: TextStyle(
          fontSize: 17,
          fontFamily: "Medium",
          color: text == "Bluetooth Connected" || text == "Connect"
              ? Colors.green
              : text == "Bluetooth Disconnected" || text == "Disconnect"
                  ? Colors.red
                  : textColour));
}

Widget boldText(String text) {
  return Text(text,
      style: TextStyle(fontSize: 22, fontFamily: "Bold", color: textColour));
}

Widget largeText(String text) {
  return Text(text,
      style: TextStyle(fontSize: 28, fontFamily: "Medium", color: textColour));
}
