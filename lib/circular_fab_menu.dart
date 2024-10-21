import 'dart:math';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';

class CircularFabMenu extends StatefulWidget {
  const CircularFabMenu({super.key});

  @override
  State<CircularFabMenu> createState() => _CircularFabMenuState();
}

class _CircularFabMenuState extends State<CircularFabMenu> {

    GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();

    
    @override
    Widget build(BuildContext context) {
      return CircularMenu(
        radius: 60,
        alignment: Alignment.centerRight,
        toggleButtonColor: Colors.pink,
        toggleButtonSize: 20,
        toggleButtonMargin: 15,
        key: key,
        items:[

          CircularMenuItem(
            iconSize: 20,
            icon: Icons.home,
            onTap: () {},
            color: Colors.green,
            iconColor: Colors.white,
          ),

          CircularMenuItem(
            iconSize: 20,
            icon: Icons.search,
            onTap: () {},
            color: Colors.orange,
            iconColor: Colors.white,
          ),

          CircularMenuItem(
            iconSize: 20,
            icon: Icons.camera,
            onTap: () {},
            color: Colors.blue,
            iconColor: Colors.white,
          ),

          CircularMenuItem(
            icon: Icons.settings,
            iconSize: 20,
            onTap: () {},
            color: Colors.deepPurple,
            iconColor: Colors.white,
          ),

        ],
      );
    }
  }
