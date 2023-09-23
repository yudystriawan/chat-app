// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ScrollController useScrollControllerForAnimation({
  required AnimationController animationController,
  VoidCallback? onScrollEnd,
}) {
  return use(_ScrollControllerForAnimationHook(
    animationController: animationController,
    onScrollEnd: onScrollEnd,
  ));
}

class _ScrollControllerForAnimationHook extends Hook<ScrollController> {
  final AnimationController animationController;
  final VoidCallback? onScrollEnd;

  const _ScrollControllerForAnimationHook({
    required this.animationController,
    this.onScrollEnd,
  });

  @override
  HookState<ScrollController, Hook<ScrollController>> createState() =>
      _ScrollControllerForAnimationHookState();
}

class _ScrollControllerForAnimationHookState
    extends HookState<ScrollController, _ScrollControllerForAnimationHook> {
  late ScrollController _scrollController;

  @override
  void initHook() {
    super.initHook();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        case ScrollDirection.forward:
          hook.animationController.reverse();
          break;

        case ScrollDirection.reverse:
          hook.animationController.forward();
          break;

        case ScrollDirection.idle:
          hook.animationController.reverse();
          break;
      }

      // Detect scroll end by checking if we are at the bottom of the list
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Call the callback when the user reaches the end of the list
        hook.onScrollEnd?.call();
      }
    });
  }

  @override
  ScrollController build(BuildContext context) => _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
