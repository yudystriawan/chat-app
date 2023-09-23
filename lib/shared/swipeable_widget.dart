import 'package:core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwipeableWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  const SwipeableWidget({
    Key? key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
  }) : super(key: key);

  @override
  State<SwipeableWidget> createState() => _SwipeableWidgetState();
}

class _SwipeableWidgetState extends State<SwipeableWidget>
    with TickerProviderStateMixin {
  double _position = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  static double threshold = 24.0.w;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
          ..addListener(() {
            setState(() {
              // Rebuild the widget with updated position
              _position = _animation.value;
            });
          });
  }

  void _handleSwipe(DragUpdateDetails details) {
    setState(() {
      // Adjust the range to limit the swipe
      _position += details.delta.dx;

      if (_position > 0 && widget.onSwipeRight == null) {
        // Prevent right swipe if onSwipeRight is null
        _position = 0.0;
      } else if (_position < 0 && widget.onSwipeLeft == null) {
        // Prevent left swipe if onSwipeLeft is null
        _position = 0.0;
      }
    });
  }

  void _handleSwipeEnd(DragEndDetails details) {
    if (_position.abs() >= threshold) {
      if (_position > 0) {
        // Right swipe
        widget.onSwipeRight?.call();
      } else {
        // Left swipe
        widget.onSwipeLeft?.call();
      }
      _animationController.reverse(from: 0);
    } else {
      _position = 0.0;
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleSwipe,
      onHorizontalDragEnd: _handleSwipeEnd,
      child: Stack(
        children: [
          if (_position != 0.0)
            Positioned.fill(
              child: Align(
                alignment: _position > 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Icon(
                  Icons.reply,
                  size: 24.w,
                  color: NeutralColor.disabled,
                ),
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: Transform(
              transform: Matrix4.translationValues(_position, 0, 0),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
