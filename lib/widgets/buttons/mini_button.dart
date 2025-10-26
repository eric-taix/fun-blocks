import 'package:flutter/material.dart';

class MiniButton extends StatelessWidget {
  const MiniButton({required this.child, required this.onTap, super.key});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.black12),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
