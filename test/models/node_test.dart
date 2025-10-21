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
      nodeList.insertNext(node1, node2);
      expect(nodeList.nodes, containsAllInOrder([node1]));

      nodeList.detachPrevious(node2);
      expect(nodeList.nodes, containsAllInOrder([node1, node2]));
    });
  });
  group('Insert operations', () {
    test('Should insert a node after another node', () {
      final node1 = Node.empty();
      final nodeList = NodeList.fromNodes([node1]);
      final nodeToInsert = Node.empty();
      nodeList.insertNext(node1, nodeToInsert);
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
      nodeList.insertNext(node2, nodeToInsert);
      expect(nodeList.nodes, containsAllInOrder([node1, node2, node3]));
      expect(node2.next, some(nodeToInsert));
      expect(nodeToInsert.previous, some(node2));
    });
    test('Should insert a node between two nodes', () {
      final node2 = Node.empty();
      final node1 = Node.empty();
      final nodeList = NodeList.fromNodes([node1]);
      nodeList.insertNext(node1, node2);
      final nodeToInsert = Node.empty();
      nodeList.insertNext(node1, nodeToInsert);
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
      nodeList.insertPrevious(node1, nodeToInsert);
      expect(nodeList.nodes, containsAllInOrder([nodeToInsert]));
      expect(nodeToInsert.next, some(node1));
      expect(node1.previous, some(nodeToInsert));
    });
    test('Should insert a node before between two nodes', () {
      final node2 = Node.empty();
      final node1 = Node.empty();
      final nodeList = NodeList.fromNodes([node1]);
      nodeList.insertNext(node1, node2);
      final nodeToInsert = Node.empty();
      nodeList.insertPrevious(node2, nodeToInsert);
      expect(nodeList.nodes, containsAllInOrder([node1]));
      expect(node1.next, some(nodeToInsert));
      expect(node1.previous, none());
      expect(nodeToInsert.next, some(node2));
      expect(nodeToInsert.previous, some(node1));
      expect(node1.previous, none());
      expect(node2.next, none());
    });
    test('Should remove node from list when connecting it to another node', () {
      final node1 = Node.empty();
      final node2 = Node.empty();
      final nodeList = NodeList.fromNodes([node1]);

      nodeList.add(node2);
      expect(nodeList.nodes.length, 2);
      expect(nodeList.nodes, containsAllInOrder([node1, node2]));

      nodeList.insertNext(node1, node2);

      expect(nodeList.nodes.length, 1);
      expect(nodeList.nodes, containsAllInOrder([node1]));
      expect(node1.next, some(node2));
      expect(node2.previous, some(node1));
    });
  });
}
