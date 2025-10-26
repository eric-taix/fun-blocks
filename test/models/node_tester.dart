import 'package:flutter_test/flutter_test.dart';
import 'package:fp_blocky/models/node.dart';
import 'package:fpdart/fpdart.dart';

class NodeTester {
  final NodeList nodes = NodeList();
  final Map<String, Node> nodesMap = {};

  /// Create linked nodes using a String
  /// Example: 'a-b-c' will create 3 nodes linked in this order: a -> b -> c
  void prepareNodes(List<String> linkedNodeList) {
    linkedNodeList.map((linkedNode) => linkedNode.split('-').reversed.toList()).forEach((linkedNodeNames) {
      for (int i = 0; i < linkedNodeNames.length; i++) {
        final nodeName = linkedNodeNames[i];
        nodesMap[nodeName] = Node.empty(uuid: nodeName);
        nodes.add(nodesMap[nodeName]!);
        if (i > 0) {
          nodes.insertAfter(nodesMap[nodeName]!, nodesMap[linkedNodeNames[i - 1]]!);
        }
      }
    });
  }

  void insertAfter(String target, String node) {
    if (nodesMap[node] == null) {
      nodesMap[node] = Node.empty(uuid: node);
    }
    nodes.insertAfter(nodesMap[target]!, nodesMap[node]!);
  }

  void insertBefore(String target, String node) {
    if (nodesMap[node] == null) {
      nodesMap[node] = Node.empty(uuid: node);
    }
    nodes.insertBefore(nodesMap[target]!, nodesMap[node]!);
  }

  /// Assert that nodes are in the expected order in the list
  /// Example `assertNodes(['A-B-C', 'D'])` will assert that nodes are in this order: A -> B -> C
  /// and that 'D' is alone
  void assertNodes(List<String> expectedNodes) {
    final rootNodeList =
        expectedNodes.map((nodesName) => nodesName.split('-').map((name) => nodesMap[name]!).toList()).toList();

    final rootNodes = rootNodeList.map((nodes) => nodes.first).toList();
    expect(nodes.nodes, containsAll(rootNodes));

    rootNodeList.map((nodes) {
      for (int i = 0; i < nodes.length; i++) {
        final node = nodes[i];
        if (i == 0) {
          expect(node.previous, None());
        } else {
          expect(node.previous, Some(nodes[i - 1]));
        }
        if (i < nodes.length - 1) {
          expect(node.next, some(nodes[i + 1]));
        } else {
          expect(node.next, None());
        }
      }
    }).toList();
  }

  void detach(String node) {
    if (nodesMap[node] == null) {
      nodesMap[node] = Node.empty(uuid: node);
    }
    nodes.detach(nodesMap[node]!, Offset.zero);
  }

  void remove(String node) {
    if (nodesMap[node] == null) {
      nodesMap[node] = Node.empty(uuid: node);
    }
    nodes.remove(nodesMap[node]!);
  }
}
