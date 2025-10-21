import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';
import 'package:fp_blocky/models/drag_data.dart';
import 'package:fp_blocky/models/node.dart';

class MonadBlock extends StatelessWidget {
  const MonadBlock({
    super.key,
    required this.node,
    required this.onConnect,
  });

  final Node node;
  final Function(Node target, Node dragged) onConnect;

  Widget _buildInteractiveBlock(Widget widget) => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(height: 20, color: Colors.red.withOpacity(0.8)),
          Draggable<DragData>(
            data: MoveBlockDragData(node),
            feedback: Material(
              color: Colors.transparent,
              child: _buildNodeWithChildren(false),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _buildNodeWithChildren(false),
            ),
            child: widget,
          ),
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
                  onConnect(node, data.node);
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

  Widget _buildNodeWithChildren(bool interactive) {
    Widget buildChain(Node currentNode) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          interactive ? _buildInteractiveBlock(currentNode.widget) : currentNode.widget,
          currentNode.next.match(
            () => const SizedBox.shrink(),
            (nextNode) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 0),
                buildChain(nextNode),
              ],
            ),
          ),
        ],
      );
    }

    return buildChain(node);
  }

  @override
  Widget build(BuildContext context) {
    return DeferredPointerHandler(child: _buildNodeWithChildren(true));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Draggable<DragData>(
          data: MoveBlockDragData(node),
          feedback: Material(color: Colors.transparent, child: _buildNodeWithChildren(true)),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _buildNodeWithChildren(true),
          ),
          child: node.widget,
        ),
        DragTarget<DragData>(
          onWillAcceptWithDetails: (details) {
            final accept = node.monad.outputType == details.data.node.monad.inputType;
            return true;
          },
          onAcceptWithDetails: (details) {
            final data = details.data;
            onConnect(node, data.node);
          },
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty || rejectedData.isNotEmpty;
            final accepting = candidateData.isNotEmpty;
            return isHovering
                ? Container(
                    height: 20,
                    width: 100,
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
                : const SizedBox(height: 20, width: 100);
          },
        ),
        node.next.match(
          () => const SizedBox.shrink(),
          (nextNode) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              MonadBlock(
                node: nextNode,
                onConnect: onConnect,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
