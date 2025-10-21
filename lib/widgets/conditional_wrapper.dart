import 'package:flutter/material.dart';

class ConditionalWrapper extends StatelessWidget {
  const ConditionalWrapper({super.key, required this.child, required this.condition, required this.wrapperBuilder});

  final Widget Function(bool isWrapped) child;
  final bool Function() condition;
  final Widget Function(Widget child) wrapperBuilder;

  @override
  Widget build(BuildContext context) {
    return condition() ? wrapperBuilder(child(true)) : child(false);
  }
}
