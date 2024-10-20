import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

void main() {
  runApp(const MyApp());
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
 
  final _key = GlobalKey<ExpandableFabState>();
  

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
          onPressed: (){},
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue
          ),
          child: const Text(
            "Overlay Window",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        //distance: 70,
        type: ExpandableFabType.fan,
        pos: ExpandableFabPos.center,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.search,color: Colors.white,),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
          backgroundColor: Colors.blue
        ),

        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.close_sharp,color: Colors.white,),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
          backgroundColor: Colors.blue
        ),
       
        children: [
         
          FloatingActionButton(
            onPressed: (){},
            shape: const CircleBorder(),
            backgroundColor: Colors.green,
            child: const Icon(Icons.camera_enhance,color: Colors.white,),
  
          ),


          FloatingActionButton(
            onPressed: (){},
            shape: const CircleBorder(),
            backgroundColor: Colors.red,
            child: const Icon(Icons.document_scanner,color: Colors.white,),
          ),

          FloatingActionButton(
            onPressed: (){},
            shape: const CircleBorder(),
            backgroundColor: Colors.purple,
            child: const Icon(Icons.translate_rounded,color: Colors.white,),
          ),



        ],
      ),
    );
  }
}