// library imports
import 'package:flutter/material.dart';
import 'package:solecthonApp/Screens/autonomous.dart';
import 'package:solecthonApp/Screens/hello.dart';
// import 'package:solecthonApp/screens/hc05.dart';
// Systems imports
import 'package:solecthonApp/Utils/constants.dart';
import 'package:solecthonApp/Utils/widgets.dart';

class DrawerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrawerWidgetState();
  }
}

class DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return SizedBox(
      width: w * 0.85,
      height: h,
      child: Drawer(
        elevation: 8,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: drawerColour,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Container(
                    // padding: const EdgeInsets.fromLTRB(10, 40, 20, 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          // decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: Colors.black,
                          //     border: Border.all(width: 3, color: Colors.black)
                          // ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/blank_profile.png"),
                              radius: MediaQuery.of(context).size.width / 8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        boldText("SOLECTHON"),
                        const SizedBox(
                          height: 36,
                        ),
                        Divider(color: dividerColour, height: 1),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.fromLTRB(10, 16, 20, 16),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                mediumText("Power transmission"),
                              ],
                            ),
                          ),
                        ),
                        Divider(color: dividerColour, height: 1),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.fromLTRB(10, 16, 20, 16),
                            child: Row(
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: () {
                                      // print("ss");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Hello()),
                                      );
                                    },
                                    child: Text("Autonomous")),
                                const SizedBox(
                                  width: 20,
                                ),
                                mediumText("PT")
                              ],
                            ),
                          ),
                        ),
                        Divider(color: dividerColour, height: 1),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.fromLTRB(10, 16, 20, 16),
                            child: Row(
                              children: <Widget>[
                                const SizedBox(
                                  width: 20,
                                ),
                                mediumText("About")
                              ],
                            ),
                          ),
                        ),
                        Divider(color: dividerColour, height: 1),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.fromLTRB(10, 16, 20, 16),
                            child: Row(
                              children: <Widget>[
                                const SizedBox(
                                  width: 20,
                                ),
                                mediumText("Disconnect")
                              ],
                            ),
                          ),
                        ),
                        Divider(color: dividerColour, height: 1),
                      ],
                    ),
                  )),
              Column(
                children: [
                  Divider(color: dividerColour, height: 1),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "2023 \u00a9 Solecthon",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Bold",
                          fontSize: 18.0,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //
  //   var w = MediaQuery.of(context).size.width;
  //   var h = MediaQuery.of(context).size.height;
  //
  //   return Scaffold(
  //       body: Stack(
  //         children: <Widget>[
  //           // Container(
  //           //   color: Colors.black.withOpacity(0.5),
  //           //   height: h,
  //           //   width: w,
  //           // ),
  //           SafeArea(
  //             child: SingleChildScrollView(
  //               child: Container(
  //                 margin: EdgeInsets.only(right: w / 4, top: 30),
  //                 width: w * 0.75,
  //                 height: h - 60,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Container(
  //                       alignment: Alignment.topCenter,
  //                       // padding: EdgeInsets.all(16),
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: <Widget>[
  //                           Container(
  //                             decoration: BoxDecoration(
  //                                 shape: BoxShape.circle,
  //                                 color: Colors.white,
  //                                 border: Border.all(width: 3, color: Colors.blue[600]!)),
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(3.0),
  //                               child: CircleAvatar(
  //                                 backgroundImage:AssetImage("assets/images/logo.png"),
  //                                 radius: w / 9,
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             height: 14,
  //                           ),
  //                           Text(
  //                             "Admin",
  //                             style: TextStyle(
  //                               fontSize: 18
  //                             )
  //                           ),
  //                           SizedBox(
  //                             height: 36,
  //                           ),
  //                           GestureDetector(
  //                             onTap: () async {
  //                               Navigator.pop(context);
  //                             },
  //                             child: Container(
  //                               color: Colors.white,
  //                               padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
  //                               child: Row(
  //                                 children: const <Widget>[
  //                                   SizedBox(width: 20,),
  //                                   Text(
  //                                     "Power Transmission",
  //                                     style: TextStyle(
  //                                       color: Colors.black54,
  //                                       fontFamily: "Medium",
  //                                       fontSize: 18.0,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           const Divider(color: Color(0XFFDADADA), height: 1),
  //                           GestureDetector(
  //                             onTap: () async {
  //                               Navigator.pop(context);
  //                             },
  //                             child: Container(
  //                               color: Colors.white,
  //                               padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
  //                               child: Row(
  //                                 children: const <Widget>[
  //                                   SizedBox(width: 20,),
  //                                   Text(
  //                                     "Autonomous",
  //                                     style: TextStyle(
  //                                       color: Colors.black54,
  //                                       fontFamily: "Medium",
  //                                       fontSize: 18.0,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           const Divider(color: Color(0XFFDADADA), height: 1),
  //                           GestureDetector(
  //                             onTap: () async {
  //                               Navigator.pop(context);
  //                             },
  //                             child: Container(
  //                               color: Colors.white,
  //                               padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
  //                               child: Row(
  //                                 children: const <Widget>[
  //                                   SizedBox(width: 20,),
  //                                   Text(
  //                                     "About",
  //                                     style: TextStyle(
  //                                       color: Colors.black54,
  //                                       fontFamily: "Medium",
  //                                       fontSize: 18.0,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           const Divider(color: Color(0XFFDADADA), height: 1),
  //                           GestureDetector(
  //                             onTap: () async {
  //                               Navigator.pop(context);
  //                             },
  //                             child: Container(
  //                               color: Colors.white,
  //                               padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
  //                               child: Row(
  //                                 children: const <Widget>[
  //                                   SizedBox(width: 20,),
  //                                   Text(
  //                                     "Disconnect",
  //                                     style: TextStyle(
  //                                       color: Colors.black54,
  //                                       fontFamily: "Medium",
  //                                       fontSize: 18.0,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           const Divider(color: Color(0XFFDADADA), height: 1),
  //                         ],
  //                       ),
  //                     ),
  //                     Column(
  //                       children: [
  //                         const Divider(color: Color(0XFFDADADA), height: 1),
  //                         const SizedBox(height: 20),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               "2022 \u00a9 Solecthon",
  //                               style: TextStyle(
  //                                 color: Colors.indigo[500],
  //                                 fontFamily: "Bold",
  //                                 fontSize: 17.0,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                         const SizedBox(height: 20),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           // AnimatedPositioned(
  //           //   duration: duration,
  //           //   top: isCollpased ? 0 : 0.2 * h,
  //           //   bottom: isCollpased ? 0 : 0.2 * h,
  //           //   left: isCollpased ? 0 : 0.8 * w,
  //           //   right: isCollpased ? 0 : -0.2 * w,
  //           //   child: Material(
  //           //     child: Container(
  //           //       alignment: Alignment.topLeft,
  //           //       width: MediaQuery.of(context).size.width,
  //           //       height: MediaQuery.of(context).size.height,
  //           //       child: SafeArea(
  //           //         child: IconButton(
  //           //           icon: Icon(Icons.menu),
  //           //           onPressed: () {
  //           //             setState(() {
  //           //               isCollpased = !isCollpased;
  //           //             });
  //           //           },
  //           //         ),
  //           //       ),
  //           //     ),
  //           //   ),
  //           // )
  //         ],
  //       ));
  // }
}
