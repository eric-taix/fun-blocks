import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fp_blocky/editor/bloc/editor_cubit.dart';
import 'package:fp_blocky/widgets/buttons/mini_button.dart';

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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              MiniButton(
                color: Colors.white,
                onTap: () {
                  context.read<EditorCubit>().clear();
                },
                child: Icon(Icons.delete),
              ),
              MiniButton(child: Icon(Icons.copy), onTap: () {}),
              MiniButton(child: Icon(Icons.paste), onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
