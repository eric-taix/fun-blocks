import 'package:flutter/material.dart';
import 'package:fp_blocky/widgets/blocks/monad_block.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import 'monad.dart';

class Node {
  late Option<Node> previous;
  late Option<Node> next;
  late final String uuid;
  late final MonadModel monad;
  double _x = 0;
  double _y = 0;

  Node(this.monad) {
    uuid = Uuid().v4();
    previous = none();
    next = none();
  }

  factory Node.empty() => Node(EmptyMonad());

  double get x => _x;
  double get y => _y;

  void moveTo(double x, double y) {
    _x = x;
    _y = y;
  }

  @override
  String toString() => 'Node $uuid: next: $next';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Node && runtimeType == other.runtimeType && uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  int get count => next.fold(() => 1, (next) => next.count + 1);

  Widget get widget => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          monad.widget,
          next.match(
            () => SizedBox.shrink(),
            (value) => Align(
              alignment: Alignment.topLeft,
              child: MonadBlock(
                node: value,
                onConnect: (Node targetNode, Node draggedNode) {
                  print('Not implemented. Should it be?');
                },
              ),
            ),
          ),
        ],
      );
}

class NodeList {
  List<Node> nodes = [];

  NodeList();

  factory NodeList.fromNodes(List<Node> nodes) => NodeList()..nodes = nodes;

  void add(Node node) {
    nodes.add(node);
  }

  void remove(Node node) {
    nodes.remove(node);
  }

  void detachPrevious(Node node) {
    node.previous.match(
      () {},
      (previous) {
        node.previous = none();
        previous.next = none();
        nodes.add(node);
      },
    );
  }

  void insertNext(Node target, Node node) {
    return target.next.match(
      () {
        target.next = some(node);
        node.previous = some(target);
        node.next = none();
      },
      (next) {
        target.next = some(node);
        node.previous = some(target);
        node.next = some(next);
        next.previous = some(node);
      },
    );
  }

  void insertPrevious(Node target, Node node) {
    return target.previous.match(
      () {
        target.previous = some(node);
        node.next = some(target);
        node.previous = none();
        nodes.remove(target);
        nodes.insert(0, node);
      },
      (previous) {
        target.previous = some(node);
        node.next = some(target);

        node.previous = some(previous);
        previous.next = some(node);
      },
    );
  }
}
