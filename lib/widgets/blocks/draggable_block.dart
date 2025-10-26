import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';
import 'package:fp_blocky/models/drag_data.dart';
import 'package:fp_blocky/models/node.dart';
import 'package:fp_blocky/widgets/blocks/node_block.dart';

class DraggableBlock extends StatelessWidget {
  DraggableBlock({super.key, required this.node, required this.onConnectToOutput, required this.onConnectToInput});

  final Node node;
  final Function(Node target, Node dragged) onConnectToOutput;
  final Function(Node input, Node output) onConnectToInput;

  final ValueNotifier<bool> isDraggingNotifier = ValueNotifier(false);

  Widget _buildNode(Node node) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Draggable<DragData>(
          data: MoveBlockDragData(node),
          onDragStarted: () => isDraggingNotifier.value = true,
          onDragEnd: (_) => isDraggingNotifier.value = false,
          onDraggableCanceled: (_, __) => isDraggingNotifier.value = false,
          feedback: Material(
            color: Colors.transparent,
            child: NodeBlock(node: node),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: NodeBlock(node: node),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  node.widget,
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -20,
                    child: DeferPointer(
                      child: DragTarget<DragData>(
                        onWillAcceptWithDetails: (details) {
                          final accept = node.monad.outputType == details.data.node.monad.inputType;
                          return true;
                        },
                        onAcceptWithDetails: (details) {
                          final data = details.data;
                          onConnectToOutput(node, data.node);
                        },
                        builder: (context, candidateData, rejectedData) {
                          final isHovering = candidateData.isNotEmpty || rejectedData.isNotEmpty;
                          final accepting = candidateData.isNotEmpty;
                          return isHovering
                              ? Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: accepting ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                                    border: accepting
                                        ? Border.all(color: Colors.green, width: 2)
                                        : Border.all(color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: accepting
                                      ? Center(
                                          child: Icon(Icons.add, size: 16, color: Colors.green),
                                        )
                                      : null,
                                )
                              : const SizedBox(height: 20);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              node.next.match(
                () => SizedBox.shrink(),
                (nextNode) => _buildNode(nextNode),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: DeferPointer(
            child: DragTarget<DragData>(
              onWillAcceptWithDetails: (details) {
                final accept = node.monad.outputType == details.data.node.monad.inputType;
                return true;
              },
              onAcceptWithDetails: (details) {
                final data = details.data;
                print('Accepting input: $node, $data');
                onConnectToInput(node, data.node);
              },
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty || rejectedData.isNotEmpty;
                final accepting = candidateData.isNotEmpty;
                return isHovering
                    ? Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: accepting ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                          border: accepting
                              ? Border.all(color: Colors.green, width: 2)
                              : Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: accepting
                            ? Center(
                                child: Icon(Icons.add, size: 16, color: Colors.green),
                              )
                            : null,
                      )
                    : const SizedBox(height: 20);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DeferredPointerHandler(
      child: ValueListenableBuilder<bool>(
        valueListenable: isDraggingNotifier,
        builder: (BuildContext context, bool isDragging, Widget? child) => _buildNode(node),
      ),
    );
  }
}
