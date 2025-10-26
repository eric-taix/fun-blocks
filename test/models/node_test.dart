import 'package:flutter_test/flutter_test.dart';

import 'node_tester.dart';

void main() {
  group('Insert after', () {
    test('Insert new node', () {
      final tester = NodeTester();
      tester.prepareNodes(['A']);
      tester.insertAfter('A', 'B');
    });
    test('Insert alone existing node', () {
      final tester = NodeTester();
      tester.prepareNodes(['A', 'B']);
      tester.insertAfter('A', 'B');
      tester.assertNodes(['A-B']);
    });
    test('Insert existing linked nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A', 'B-C']);
      tester.insertAfter('A', 'B');
      tester.assertNodes(['A-B-C']);
    });
    test('Insert new node between nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B']);
      tester.insertAfter('A', 'C');
      tester.assertNodes(['A-C-B']);
    });
    test('Insert existing node between nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B', 'C']);
      tester.insertAfter('A', 'C');
      tester.assertNodes(['A-C-B']);
    });
    test('Insert existing linked nodes between nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B', 'C-D']);
      tester.insertAfter('A', 'C');
      tester.assertNodes(['A-C-D-B']);
    });
    test('Insert existing linked nodes after node by splitting', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B', 'C-D']);
      tester.insertAfter('A', 'D');
      tester.assertNodes(['A-D-B', 'C']);
    });
    test('Insert the last child between nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B-C-D']);
      tester.insertAfter('B', 'D');
      tester.assertNodes(['A-B-D-C']);
    });
    test('Insert a child with children between nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B-C-D-E']);
      tester.insertAfter('B', 'D');
      tester.assertNodes(['A-B-D-E-C']);
    });
  });
  group('Insert before', () {
    test('Insert new node', () {
      final tester = NodeTester();
      tester.prepareNodes(['A']);
      tester.insertBefore('A', 'B');
      tester.assertNodes(['B-A']);
    });
    test('Insert alone existing node', () {
      final tester = NodeTester();
      tester.prepareNodes(['A', 'B']);
      tester.insertBefore('A', 'B');
      tester.assertNodes(['B-A']);
    });
    test('Insert existing linked nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A', 'B-C']);
      tester.insertBefore('A', 'B');
      tester.assertNodes(['B-C-A']);
    });
    test('Insert new node between nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B']);
      tester.insertBefore('B', 'C');
      tester.assertNodes(['A-C-B']);
    });
    test('Insert existing node between nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B', 'C']);
      tester.insertBefore('B', 'C');
      tester.assertNodes(['A-C-B']);
    });
    test('Insert existing linked nodes between nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B', 'C-D']);
      tester.insertBefore('B', 'C');
      tester.assertNodes(['A-C-D-B']);
    });
    test('Insert existing linked nodes at root', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B', 'C-D']);
      tester.insertBefore('A', 'C');
      tester.assertNodes(['C-D-A-B']);
    });
    test('Insert existing linked nodes at root by splitting', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B', 'C-D']);
      tester.insertBefore('A', 'D');
      tester.assertNodes(['D-A-B', 'C']);
    });
    test('Insert existing linked nodes before node by splitting', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B', 'C-D']);
      tester.insertBefore('B', 'D');
      tester.assertNodes(['A-D-B', 'C']);
    });
    test('Insert the last child at root', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B-C']);
      tester.insertBefore('A', 'C');
      tester.assertNodes(['C-A-B']);
    });
    test('Insert a child with children at root', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B-C-D-E']);
      tester.insertBefore('A', 'D');
      tester.assertNodes(['D-E-A-B-C']);
    });
    test('Insert a child between nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B-C-D-E']);
      tester.insertBefore('B', 'D');
      tester.assertNodes(['A-D-E-B-C']);
    });
    test('Insert the last child between nodes', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B-C-D-E']);
      tester.insertBefore('C', 'E');
      tester.assertNodes(['A-B-E-C-D']);
    });
  });
  group('Detach', () {
    test('Change nothing if node is already detached', () {
      final tester = NodeTester();
      tester.prepareNodes(['A', 'B']);
      tester.detach('A');
      tester.assertNodes(['A', 'B']);
    });
    test('Detach the node if it has a previous', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B']);
      tester.detach('B');
      tester.assertNodes(['A', 'B']);
    });
    test('Change nothing if node is the root', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B']);
      tester.detach('A');
      tester.assertNodes(['A-B']);
    });
    test('Detach the node and its children if it has a previous', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B-C']);
      tester.detach('B');
      tester.assertNodes(['A', 'B-C']);
    });
    test('Change nothing if the node does not exist', () {
      final tester = NodeTester();
      tester.prepareNodes(['A']);
      tester.detach('B');
      tester.assertNodes(['A']);
    });
  });
  group('Remove', () {
    test('Does nothing if the node does not exist', () {
      final tester = NodeTester();
      tester.prepareNodes(['A', 'B']);
      tester.remove('C');
      tester.assertNodes(['A', 'B']);
    });
    test('Remove the node if the node exist', () {
      final tester = NodeTester();
      tester.prepareNodes(['A', 'B']);
      tester.remove('B');
      tester.assertNodes(['A']);
    });
    test('Remove the node and its children', () {
      final tester = NodeTester();
      tester.prepareNodes(['A-B-C']);
      tester.remove('B');
      tester.assertNodes(['A']);
    });
  });
}
