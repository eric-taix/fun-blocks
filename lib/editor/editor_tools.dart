import 'package:flutter/material.dart';

class EditorTools extends StatelessWidget {
  const EditorTools({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black45, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              Icon(Icons.delete),
              Icon(Icons.copy),
              Icon(Icons.paste),
            ],
          ),
        ),
      ),
    );
  }
}
