// library imports
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solecthonApp/Utils/constants.dart';

// System imports
import 'Screens/dashboard.dart';

Future<void> main() async {
  try{
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  }catch(e){
    print(e);
  }

  setThemeColour(isDarkTheme);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solecthon App',

      theme: ThemeData(
        primarySwatch: Colors.blue,

        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
            TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
          },
        ),

        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: const Dashboard(),

      debugShowCheckedModeBanner: false,
    );
  }
}