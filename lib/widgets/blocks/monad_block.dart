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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Draggable<DragData>(
          data: MoveBlockDragData(node),
          feedback: Material(color: Colors.transparent, child: node.widget),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: node.widget,
          ),
          child: node.widget,
        ),
        DragTarget<DragData>(
          onWillAcceptWithDetails: (details) {
            final accept = node.monad.outputType == details.data.node.monad.inputType;
            return accept;
          },
          onAcceptWithDetails: (details) {
            final data = details.data;
            onConnect(node, data.node);
          },
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty || rejectedData.isNotEmpty;
            print('c: $candidateData r:$rejectedData');
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
                : Container(
                    height: 20,
                    width: 100,
                  );
          },
        ),
      ],
    );
  }
}
