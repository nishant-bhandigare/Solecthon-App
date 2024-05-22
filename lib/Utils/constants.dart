import 'package:flutter/material.dart';

var isDarkTheme = true;

Color dividerColour = Color(0XFFDADADA);
late Color bgColour;
late Color textColour;
late Color iconColour;
late Color drawerColour;
late Color cardColour;

void setThemeColour(bool isDarkTheme){

  if(isDarkTheme){
    bgColour = Colors.black;
    textColour = Colors.white;
    iconColour = Colors.white;
    cardColour = const Color(0XFF313030);
    drawerColour = Colors.black.withOpacity(0.9);
  }else{
    bgColour = Colors.purple;
    textColour = Colors.white;
    iconColour = Colors.white;
    cardColour = Colors.purpleAccent;
    drawerColour = Colors.purple.withOpacity(0.9);
  }
}
