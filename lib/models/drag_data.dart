import 'package:fp_blocky/models/node.dart';

sealed class DragData {
  final Node node;

  DragData(this.node);
}

final class CreateBlockDragData extends DragData {
  CreateBlockDragData(super.node);
}

final class MoveBlockDragData extends DragData {
  MoveBlockDragData(super.node);
}
