// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

AutoScrollController useAutoScrollController({
  required AnimationController animationController,
  VoidCallback? onScrollEnd,
}) {
  return use(_ScrollControllerForAnimationHook(
    animationController: animationController,
    onScrollEnd: onScrollEnd,
  ));
}

class _ScrollControllerForAnimationHook extends Hook<AutoScrollController> {
  final AnimationController animationController;
  final VoidCallback? onScrollEnd;

  const _ScrollControllerForAnimationHook({
    required this.animationController,
    this.onScrollEnd,
  });

  @override
  HookState<AutoScrollController, Hook<AutoScrollController>> createState() =>
      _ScrollControllerForAnimationHookState();
}

class _ScrollControllerForAnimationHookState
    extends HookState<AutoScrollController, _ScrollControllerForAnimationHook> {
  late AutoScrollController _scrollController;

  @override
  void initHook() {
    super.initHook();
    _scrollController = AutoScrollController();
    _scrollController.addListener(() {
      final scrollPosition = _scrollController.position;

      debugPrint(
          'changed: ${_scrollController.position.isScrollingNotifier.value} | ${scrollPosition.userScrollDirection}');

      switch (scrollPosition.userScrollDirection) {
        case ScrollDirection.forward:
          hook.animationController.reverse();
          break;

        case ScrollDirection.reverse:
          hook.animationController.forward();
          break;

        case ScrollDirection.idle:
        // hook.animationController.reverse();
        // break;
      }

      // Detect scroll end by checking if we are at the bottom of the list
      if (scrollPosition.pixels == scrollPosition.maxScrollExtent) {
        // Call the callback when the user reaches the end of the list
        hook.onScrollEnd?.call();
      }
    });
  }

  @override
  AutoScrollController build(BuildContext context) => _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
