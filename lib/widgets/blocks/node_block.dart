import 'package:flutter/material.dart';
import 'package:fp_blocky/models/node.dart';

/// The widget responsible to display a node and its children if any
///
class NodeBlock extends StatelessWidget {
  const NodeBlock({super.key, required this.node});

  final Node node;

  List<Widget> _buildNode(Node rootNode) {
    return [
      rootNode.widget,
      ...rootNode.next.match(
        () => [SizedBox.shrink()],
        (nextNode) => _buildNode(nextNode),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildNode(node),
    );
  }
}
