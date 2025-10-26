import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';
import 'package:fp_blocky/models/drag_data.dart';
import 'package:fp_blocky/models/node.dart';

typedef BlockWrapper = Widget Function(Node node);

class MonadBlock extends StatefulWidget {
  const MonadBlock({
    super.key,
    required this.node,
    required this.onConnect,
    this.parentDragging = false,
  });

  final Node node;
  final Function(Node target, Node dragged) onConnect;
  final bool parentDragging;

  @override
  State<MonadBlock> createState() => _MonadBlockState();
}

class _MonadBlockState extends State<MonadBlock> {
  bool _isDragging = false;

  Widget identityWrapper(Node node) => node.widget;

  Widget _buildStaticChain(Node node) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        node.widget,
        node.next.match(
          () => const SizedBox.shrink(),
          (nextNode) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 0),
              _buildStaticChain(nextNode),
            ],
          ),
        ),
      ],
    );
  }

  Widget draggableWrapper(Node node) => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(height: 20, color: Colors.red.withOpacity(0.8)),
          Draggable<DragData>(
            data: MoveBlockDragData(node),
            onDragStarted: () => setState(() => _isDragging = true),
            onDragEnd: (_) => setState(() => _isDragging = false),
            onDraggableCanceled: (_, __) => setState(() => _isDragging = false),
            feedback: Material(
              color: Colors.transparent,
              child: _buildNodeWithChildren(node, identityWrapper),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _buildStaticChain(node),
            ),
            child: node.widget,
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
                  widget.onConnect(node, data.node);
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

  Widget _buildNodeWithChildren(Node node, BlockWrapper blockWrapper) {
    Widget buildChain(Node currentNode, bool isFirst) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          blockWrapper(currentNode),
          currentNode.next.match(
            () => const SizedBox.shrink(),
            (nextNode) => Opacity(
              opacity: (isFirst && _isDragging) ? 0.3 : 1.0,
              child: MonadBlock(
                node: nextNode,
                onConnect: widget.onConnect,
                parentDragging: isFirst ? _isDragging : widget.parentDragging,
              ),
            ),
          ),
        ],
      );
    }

    return buildChain(node, true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parentDragging) {
      return DeferredPointerHandler(
        child: _buildNodeWithChildren(widget.node, (node) => Stack(
          clipBehavior: Clip.none,
          children: [
            Container(height: 20, color: Colors.red.withOpacity(0.8)),
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
                    widget.onConnect(node, data.node);
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
        )),
      );
    }
    return DeferredPointerHandler(
      child: _buildNodeWithChildren(widget.node, draggableWrapper),
    );
    /*return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Draggable<DragData>(
          data: MoveBlockDragData(node),
          feedback: Material(color: Colors.transparent, child: _buildNodeWithChildren(node, identityWrapper)),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _buildNodeWithChildren(node, identityWrapper),
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
    );*/
  }
}
