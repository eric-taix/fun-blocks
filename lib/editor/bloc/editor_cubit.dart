import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fp_blocky/models/node.dart';

part 'editor_state.dart';

class EditorCubit extends Cubit<EditorState> {
  EditorCubit() : super(EditorEmpty());

  void add(Node node, Offset position) {
    node.moveTo(position.dx, position.dy);
    state.nodes.add(node);
    emit(EditorChanged(state.nodes));
  }

  void connectInputToOutput(Node input, Node output) {
    state.nodes.insertNext(output, input);
    emit(EditorChanged(state.nodes));
  }

  void move(Node node, Offset position) {
    node.moveTo(position.dx, position.dy);
    emit(EditorChanged(state.nodes));
  }
}
