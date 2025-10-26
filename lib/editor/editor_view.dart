import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fp_blocky/editor/bloc/editor_cubit.dart';
import 'package:fp_blocky/models/drag_data.dart';
import 'package:fp_blocky/models/node.dart';
import 'package:fp_blocky/widgets/blocks/draggable_block.dart';

class EditorView extends StatelessWidget {
  const EditorView({super.key});

  void _handleDropToEditor(BuildContext context, DragData dragData, Offset position) {
    switch (dragData) {
      case CreateBlockDragData(:final node):
        context.read<EditorCubit>().add(node, position);
      //final newMonad = monad.clone(x: position.dy, y: position.dx);
      //_monads.add(newMonad);
      case MoveBlockDragData(:final node):
        context.read<EditorCubit>().move(node, position);
    }
  }

  void _handleConnectToOutput(BuildContext context, Node output, Node input) {
    print('Connecting output: $output, input: $input');
    if (output != input) {
      context.read<EditorCubit>().connectInputToOutput(input, output);
    }
  }

  void _handleConnectToInput(BuildContext context, Node input, Node output) {
    print('Connecting output: $output, input: $input');
    if (output != input) {
      context.read<EditorCubit>().connectOutputToInput(output, input);
    }
  }

  List<Widget> _buildBlocksWithConnections(BuildContext context, NodeList nodes) {
    return nodes.nodes
        .map(
          (node) => Positioned(
            top: node.y,
            left: node.x,
            child: DraggableBlock(
              node: node,
              onConnectToOutput: (target, dragged) => _handleConnectToOutput(context, target, dragged),
              onConnectToInput: (target, dragged) => _handleConnectToInput(context, target, dragged),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<DragData>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.offset);
        _handleDropToEditor(context, details.data, localPosition);
      },
      builder: (context, candidateData, rejectedData) {
        return BlocBuilder<EditorCubit, EditorState>(
          builder: (context, state) {
            final count = state.nodes.nodes.fold(0, (previous, element) => previous + element.count);
            return Stack(
              children: [
                Positioned(
                  top: 6,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black45, width: 0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '$count block${count > 1 ? 's' : ''}',
                      ),
                    ),
                  ),
                ),
                InteractiveViewer(
                  minScale: 0.01,
                  child: Stack(
                    children: [
                      ..._buildBlocksWithConnections(context, state.nodes),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
