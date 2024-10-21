
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:overlay_widget/circular_fab_menu.dart';

void main() {
  runApp(const MyApp());
}


// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CircularFabMenu()
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {


  Future<void> showOverlayWindow()async{
    final bool status = await FlutterOverlayWindow.isPermissionGranted();
    if(status){
      await FlutterOverlayWindow.showOverlay();
    }else{
      await FlutterOverlayWindow.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Overlay Window",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: ()=> showOverlayWindow(),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue
            ),
            child: const Text(
              "Overlay Window",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
  }
}