import 'package:flutter_test/flutter_test.dart';
import 'package:fp_blocky/models/node.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('NodeList basic operations', () {
    test('Should add node', () {
      final nodeList = NodeList();
      final node = Node.empty();
      nodeList.add(node);
      expect(nodeList.nodes, [node]);
    });
    test('Should insert a second node', () {
      final nodeList = NodeList();
      final node1 = Node.empty();
      final node2 = Node.empty();
      nodeList.add(node2);
      nodeList.add(node1);
      expect(nodeList.nodes, containsAllInOrder([node2, node1]));
    });
    test('Should remove a node if is in the list', () {
      final node = Node.empty();
      final nodeList = NodeList.fromNodes([node]);
      nodeList.remove(node);
      expect(nodeList.nodes, []);
    });
    test('Should not remove a node if is not in the list', () {
      final existingNode = Node.empty();
      final node = Node.empty();
      final nodeList = NodeList.fromNodes([existingNode]);
      nodeList.remove(node);
      expect(nodeList.nodes, [existingNode]);
    });
    test('Should detach a node', () {
      final node1 = Node.empty();
      final node2 = Node.empty();
      final nodeList = NodeList.fromNodes([node1]);
      nodeList.insertAfter(node1, node2);
      expect(nodeList.nodes, containsAllInOrder([node1]));

      nodeList.detachPrevious(node2);
      expect(nodeList.nodes, containsAllInOrder([node1, node2]));
    });
  });
  group('New single node', () {
    group('Inserted before', () {
      test('A node w/o parent should be inserted before the node', () {
        final node = Node.empty();
        final nodeList = NodeList.fromNodes([node]);
        final nodeToInsert = Node.empty();
        nodeList.insertBefore(node, nodeToInsert);
        expect(nodeList.nodes, containsAllInOrder([nodeToInsert]));
        expect(nodeToInsert.previous, none());
        expect(nodeToInsert.next, some(node));
        expect(node.previous, some(nodeToInsert));
        expect(node.next, none());
      });
      test('A child node w/ parent should be inserted before the child and after the parent', () {
        final node1 = Node.empty();
        final node2 = Node.empty();
        final nodeList = NodeList.fromNodes([node1]);
        nodeList.insertAfter(node1, node2);
        final nodeToInsert = Node.empty();
        nodeList.insertBefore(node2, nodeToInsert);
        expect(nodeList.nodes, containsAllInOrder([node1]));
        expect(node1.next, some(nodeToInsert));
        expect(nodeToInsert.previous, some(node1));
        expect(nodeToInsert.next, some(node2));
        expect(node2.previous, some(nodeToInsert));
        expect(node2.next, none());
      });
    });
    group('Inserted after', () {
      test('A node w/o child should be inserted after the node', () {
        final node = Node.empty();
        final nodeList = NodeList.fromNodes([node]);
        final nodeToInsert = Node.empty();
        nodeList.insertAfter(node, nodeToInsert);
        expect(nodeList.nodes, containsAllInOrder([node]));
        expect(node.next, some(nodeToInsert));
        expect(node.previous, none());
        expect(nodeToInsert.previous, some(node));
        expect(nodeToInsert.next, none());
      });
      test('A node w/ child should be inserted after the node but before its child', () {
        final node1 = Node.empty();
        final node2 = Node.empty();
        final nodeList = NodeList.fromNodes([node1]);
        nodeList.insertAfter(node1, node2);
        final nodeToInsert = Node.empty();
        nodeList.insertAfter(node1, nodeToInsert);
        expect(nodeList.nodes, containsAllInOrder([node1]));
        expect(node1.next, some(nodeToInsert));
        expect(node1.previous, none());
        expect(nodeToInsert.previous, some(node1));
        expect(nodeToInsert.next, some(node2));
        expect(node2.previous, some(nodeToInsert));
        expect(node2.next, none());
      });
    });
  });
  group('Existing single node', () {
    group('Inserted before a node', () {
      test('Should be removed from the list', () {
        final node1 = Node.empty();
        final node2 = Node.empty();
        final nodeList = NodeList.fromNodes([node1, node2]);
        nodeList.insertBefore(node1, node2);
        expect(nodeList.nodes, containsAllInOrder([node2]));
        expect(node2.previous, none());
        expect(node2.next, some(node1));
        expect(node1.previous, some(node2));
        expect(node1.next, none());
      });
    });
    group('Inserted after a node', () {
      test('Should be removed from the list', () {
        final node1 = Node.empty();
        final node2 = Node.empty();
        final nodeList = NodeList.fromNodes([node1, node2]);
        nodeList.insertAfter(node1, node2);
        expect(nodeList.nodes, containsAllInOrder([node1]));
        expect(node1.next, some(node2));
        expect(node1.previous, none());
        expect(node2.previous, some(node1));
        expect(node2.next, none());
      });
    });
  });
  group('Existing linked nodes', () {
    group('Inserted before a node w/o a parent', () {
      test('Should insert all linked nodes before the node', () {
        final node1 = Node.empty();
        final node2 = Node.empty();
        final node3 = Node.empty();
        final nodeList = NodeList.fromNodes([node1, node2]);
        nodeList.insertAfter(node2, node3);
        nodeList.insertBefore(node1, node2);
        expect(nodeList.nodes, containsAllInOrder([node2]));
        expect(node2.previous, none());
        expect(node2.next, some(node3));
        expect(node3.previous, some(node2));
        expect(node3.next, some(node1));
        expect(node1.previous, some(node3));
        expect(node1.next, none());
      });
    });
    group('Inserted before a node w/ a parent', () {
      test('Should insert all linked nodes before the node', () {
        final node1 = Node.empty();
        final node2 = Node.empty();
        final node3 = Node.empty();
        final node4 = Node.empty();
        final nodeList = NodeList.fromNodes([node1, node3]);
        nodeList.insertAfter(node1, node2);
        nodeList.insertAfter(node3, node4);
        nodeList.insertBefore(node2, node3);
        expect(nodeList.nodes, containsAllInOrder([node1]));
        expect(node1.previous, none());
        expect(node1.next, some(node3));
        expect(node3.previous, some(node1));
        expect(node3.next, some(node4));
        expect(node4.previous, some(node3));
        expect(node4.next, some(node2));
        expect(node2.previous, some(node4));
        expect(node2.next, none());
      });
    });
    group('Inserted after a node w/o a parent', () {
      test('Should insert all linked nodes after the node', () {
        final node1 = Node.empty();
        final node2 = Node.empty();
        final node3 = Node.empty();
        final nodeList = NodeList.fromNodes([node1, node2]);
        nodeList.insertAfter(node2, node3);
        nodeList.insertAfter(node1, node2);

        expect(nodeList.nodes, containsAllInOrder([node1]));
        expect(node1.previous, none());
        expect(node1.next, some(node2));
        expect(node2.previous, some(node1));
        expect(node2.next, some(node3));
        expect(node3.previous, some(node2));
        expect(node3.next, none());
      });
    });
    group('Inserted after a node w/ a parent', () {
      test('Should insert all linked nodes after the node', () {});
    });
  });

  group('Insert operations', () {
    test('Should insert a node after another node', () {
      final node1 = Node.empty();
      final nodeList = NodeList.fromNodes([node1]);
      final nodeToInsert = Node.empty();
      nodeList.insertAfter(node1, nodeToInsert);
      expect(nodeList.nodes, containsAllInOrder([node1]));
      expect(node1.next, some(nodeToInsert));
      expect(nodeToInsert.previous, some(node1));
    });
    test('Should insert a node after another node which is in a list', () {
      final node1 = Node.empty();
      final node2 = Node.empty();
      final node3 = Node.empty();
      final nodeList = NodeList.fromNodes([node1, node2, node3]);
      final nodeToInsert = Node.empty();
      nodeList.insertAfter(node2, nodeToInsert);
      expect(nodeList.nodes, containsAllInOrder([node1, node2, node3]));
      expect(node2.next, some(nodeToInsert));
      expect(nodeToInsert.previous, some(node2));
    });
    test('Should insert a node between two nodes', () {
      final node2 = Node.empty();
      final node1 = Node.empty();
      final nodeList = NodeList.fromNodes([node1]);
      nodeList.insertAfter(node1, node2);
      final nodeToInsert = Node.empty();
      nodeList.insertAfter(node1, nodeToInsert);
      expect(nodeList.nodes, containsAllInOrder([node1]));
      expect(node1.next, some(nodeToInsert));
      expect(nodeToInsert.previous, some(node1));
      expect(nodeToInsert.next, some(node2));
      expect(node2.previous, some(nodeToInsert));
      expect(node2.next, none());
    });
    test('Should insert a node before another node', () {
      final node1 = Node.empty();
      final nodeList = NodeList.fromNodes([node1]);
      final nodeToInsert = Node.empty();
      nodeList.insertBefore(node1, nodeToInsert);
      expect(nodeList.nodes, containsAllInOrder([nodeToInsert]));
      expect(nodeToInsert.next, some(node1));
      expect(node1.previous, some(nodeToInsert));
    });
    test('Should insert a node before between two nodes', () {
      final node2 = Node.empty();
      final node1 = Node.empty();
      final nodeList = NodeList.fromNodes([node1]);
      nodeList.insertAfter(node1, node2);
      final nodeToInsert = Node.empty();
      nodeList.insertBefore(node2, nodeToInsert);
      expect(nodeList.nodes, containsAllInOrder([node1]));
      expect(node1.next, some(nodeToInsert));
      expect(node1.previous, none());
      expect(nodeToInsert.next, some(node2));
      expect(nodeToInsert.previous, some(node1));
      expect(node1.previous, none());
      expect(node2.next, none());
    });
    test('Should insert linked nodes before another node', () {
      final node1 = Node.empty();
      final node2 = Node.empty();
      final node3 = Node.empty();
      final nodeList = NodeList.fromNodes([node1, node2]);
      nodeList.insertAfter(node2, node3);
      nodeList.insertBefore(node1, node2);
      expect(nodeList.nodes, containsAllInOrder([node2]));
      expect(node2.next, some(node3));
      expect(node2.previous, none());
      expect(node3.next, Some(node1));
      expect(node3.previous, Some(node2));
      expect(node1.next, none());
      expect(node1.previous, Some(node3));
    });
    test('Should remove node from list when connecting it to another node', () {
      final node1 = Node.empty();
      final node2 = Node.empty();
      final nodeList = NodeList.fromNodes([node1]);

      nodeList.add(node2);
      expect(nodeList.nodes.length, 2);
      expect(nodeList.nodes, containsAllInOrder([node1, node2]));

      nodeList.insertAfter(node1, node2);

      expect(nodeList.nodes.length, 1);
      expect(nodeList.nodes, containsAllInOrder([node1]));
      expect(node1.next, some(node2));
      expect(node2.previous, some(node1));
    });
  });
}
