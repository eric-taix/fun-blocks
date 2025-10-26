import 'package:flutter/material.dart';
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

  Node get last => next.fold(() => this, (next) => next.last);

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

  int get count => 1; //next.fold(() => 1, (next) => next.count + 1);

  Widget get widget => monad.widget;

  Node clone() {
    return Node(monad.clone(x: x, y: y));
  }
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

  void insertAfter(Node target, Node node) {
    node.previous.match(
      () => nodes.remove(node),
      (_) {},
    );

    return target.next.match(
      () {
        target.next = some(node);
        node.previous = some(target);
        //node.next = none();
      },
      (next) {
        target.next = some(node);
        node.previous = some(target);
        node.next = some(next);
        next.previous = some(node);
      },
    );
  }

  void insertBefore(Node target, Node node) {
    return target.previous.match(
      () {
        target.previous = some(node.last);
        node.last.next = some(target);
        node.previous = none();
        node.moveTo(target._x, target._y);
        nodes.remove(target);
        nodes.insert(0, node);
      },
      (previous) {
        target.previous = some(node.last);
        node.last.next = some(target);

        node.previous = some(previous);
        previous.next = some(node);
        nodes.remove(node);
      },
    );
  }
}
