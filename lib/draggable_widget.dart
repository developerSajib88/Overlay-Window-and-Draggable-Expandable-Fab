import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:overlay_widget/circular_fab_menu.dart';

class DraggableWidget extends StatelessWidget {
  const DraggableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingDraggableWidget(
      floatingWidgetHeight: 100,
      floatingWidgetWidth: 100,
      autoAlign: true,
      dx: 310,
      dy: 400,
      autoAlignType: AlignmentType.onlyRight,
      deleteWidget: const Icon(Icons.close),
      deleteWidgetAlignment: Alignment.bottomCenter,
      mainScreenWidget: Container(), 
      floatingWidget: const CircularFabMenu(),
      
    );;
  }
}