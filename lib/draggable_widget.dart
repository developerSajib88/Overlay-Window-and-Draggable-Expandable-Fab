import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

enum AlignmentType { onlyRight, onlyLeft, both }

class FloatingDraggableWidget extends StatefulWidget {
  FloatingDraggableWidget({
    Key? key,
    required this.floatingWidget,
    required this.floatingWidgetWidth,
    required this.floatingWidgetHeight,
    this.onDragEvent,
    this.autoAlignType = AlignmentType.both,
    this.disableBounceAnimation = false,
    this.dy,
    this.dx,
    this.screenHeight,
    this.screenWidth,
    this.speed,
    this.deleteWidget,
    this.onDeleteWidget,
    this.isDraggable = true,
    this.autoAlign = false,
    this.deleteWidgetAlignment = Alignment.bottomCenter,
    this.deleteWidgetAnimationDuration = 200,
    this.hasDeleteWidgetAnimationDuration = 300,
    this.deleteWidgetAnimationCurve = Curves.easeIn,
    this.deleteWidgetHeight = 50,
    this.deleteWidgetWidth = 50,
    this.isCollidingDeleteWidgetHeight = 70,
    this.isCollidingDeleteWidgetWidth = 70,
    this.deleteWidgetDecoration,
    this.deleteWidgetPadding = const EdgeInsets.only(bottom: 8),
    this.onDragging,
    this.widgetWhenDragging,
  }) : super(key: key);

  final double floatingWidgetWidth;
  final double floatingWidgetHeight;
  final Widget floatingWidget;
  final double? dy;
  final double? dx;
  final double? screenHeight;
  final double? screenWidth;
  final double? speed;
  final bool isDraggable;
  final bool autoAlign;
  final Widget? deleteWidget;
  final Function()? onDeleteWidget;
  final AlignmentGeometry deleteWidgetAlignment;
  final Curve deleteWidgetAnimationCurve;
  final int deleteWidgetAnimationDuration;
  final int hasDeleteWidgetAnimationDuration;
  final double deleteWidgetHeight;
  final double deleteWidgetWidth;
  final double isCollidingDeleteWidgetHeight;
  final double isCollidingDeleteWidgetWidth;
  final EdgeInsets? deleteWidgetPadding;
  final BoxDecoration? deleteWidgetDecoration;
  final AlignmentType autoAlignType;
  final bool disableBounceAnimation;
  final Function(double dx, double dy)? onDragEvent;
  final Function(bool)? onDragging;
  final Widget? widgetWhenDragging;

  @override
  State<FloatingDraggableWidget> createState() => _FloatingDraggableWidgetState();
}

class _FloatingDraggableWidgetState extends State<FloatingDraggableWidget> {
  late double top, left;
  bool isDragging = false;
  bool isRemoved = false;
  final GlobalKey deleteKey = GlobalKey();
  final GlobalKey floatingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    top = widget.dy ?? -1;
    left = widget.dx ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.screenWidth ?? MediaQuery.of(context).size.width;
    double height = widget.screenHeight ?? MediaQuery.of(context).size.height;

    final hasDeleteWidget = widget.deleteWidget != null;

    return Stack(
      children: [
        // Background screen (fill the available space)
        GestureDetector(
          onTap: ()async{
            await FlutterOverlayWindow.closeOverlay();
            // Handle background tap events here
            print("Background tapped!");
          },
          child: Container(
            width: width,
            height: height,
            color: Colors.transparent, // Ensure this is transparent to allow taps
          ),
        ),
        if (hasDeleteWidget) _buildDeleteWidget(),
        if (!isRemoved) _buildDraggableWidget(width, height),
      ],
    );
  }

  /// Builds the delete widget with animation, visible only while dragging.
  Widget _buildDeleteWidget() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: isDragging ? 1.0 : 0.0,
        duration: Duration(milliseconds: widget.hasDeleteWidgetAnimationDuration),
        child: Center(
          child: Container(
            key: deleteKey,
            height: widget.deleteWidgetHeight,
            width: widget.deleteWidgetWidth,
            decoration: widget.deleteWidgetDecoration,
            child: widget.deleteWidget,
          ),
        ),
      ),
    );
  }

  /// Builds the floating draggable widget with pan gesture detection.
  Widget _buildDraggableWidget(double width, double height) {
    return AnimatedPositioned(
      top: top == -1 ? null : top,
      left: left == -1 ? null : left,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onPanStart: (_) {
          setState(() {
            isDragging = true;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            top = _getDy(details.globalPosition.dy, height);
            left = _getDx(details.globalPosition.dx, width);
          });
          widget.onDragging?.call(true);
          widget.onDragEvent?.call(left, top);
        },
        onPanEnd: (_) {
          setState(() {
            isDragging = false;
            if (widget.onDragging != null) widget.onDragging!(false);
            if (_shouldDelete()) {
              _handleDeletion();
            }
          });
        },
        child: isDragging && widget.widgetWhenDragging != null
            ? widget.widgetWhenDragging!
            : Container(
                key: floatingKey,
                width: widget.floatingWidgetWidth,
                height: widget.floatingWidgetHeight,
                child: widget.floatingWidget,
              ),
      ),
    );
  }

  /// Gets the Y position, ensuring it's within bounds.
  double _getDy(double dy, double totalHeight) {
    if (dy >= (totalHeight - widget.floatingWidgetHeight)) {
      return (totalHeight - widget.floatingWidgetHeight);
    }
    return dy <= 0 ? 0 : dy;
  }

  /// Gets the X position, ensuring it's within bounds.
  double _getDx(double dx, double totalWidth) {
    if (dx >= (totalWidth - widget.floatingWidgetWidth)) {
      return (totalWidth - widget.floatingWidgetWidth);
    }
    return dx <= 0 ? 0 : dx;
  }

  /// Checks if the draggable widget should be deleted.
  bool _shouldDelete() {
    return widget.deleteWidget != null && _isColliding();
  }

  /// Handles widget deletion and triggers the onDelete callback if set.
  void _handleDeletion() {
    setState(() {
      isRemoved = true;
      widget.onDeleteWidget?.call();
    });
  }

  /// Collision detection logic between the floating widget and delete widget.
  bool _isColliding() {
    final deleteBox = deleteKey.currentContext?.findRenderObject() as RenderBox?;
    final floatingBox = floatingKey.currentContext?.findRenderObject() as RenderBox?;

    if (deleteBox != null && floatingBox != null) {
      final deletePosition = deleteBox.localToGlobal(Offset.zero);
      final floatingPosition = floatingBox.localToGlobal(Offset.zero);

      return (floatingPosition.dx < deletePosition.dx + deleteBox.size.width &&
          floatingPosition.dx + floatingBox.size.width > deletePosition.dx &&
          floatingPosition.dy < deletePosition.dy + deleteBox.size.height &&
          floatingPosition.dy + floatingBox.size.height > deletePosition.dy);
    }
    return false;
  }
}
