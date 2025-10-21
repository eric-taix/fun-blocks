part of 'editor_cubit.dart';

@immutable
sealed class EditorState {
  final NodeList nodes;

  const EditorState(this.nodes);
}

final class EditorEmpty extends EditorState {
  EditorEmpty() : super(NodeList());
}

final class EditorChanged extends EditorState {
  const EditorChanged(super.nodes);
}
