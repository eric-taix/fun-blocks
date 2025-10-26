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

  Node(this.monad, {String? uuid}) {
    this.uuid = uuid ?? Uuid().v4();
    previous = none();
    next = none();
  }

  factory Node.empty({String? uuid}) => Node(EmptyMonad(), uuid: uuid);

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

  int get count => next.fold(() => 1, (next) => next.count + 1);

  Widget get widget => monad.widget;

  Node clone() {
    return Node(monad.clone(x: x, y: y));
  }

  Option<Node> findChild(Node node) {
    return next.match(
      () => none(),
      (next) => next == node ? some(next) : next.findChild(node),
    );
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
    node.previous.match(
      () {},
      (previous) {
        previous.next = none();
        node.previous = none();
      },
    );
    nodes.remove(node);
  }

  void detach(Node node, Offset position) {
    node.previous.match(
      () {},
      (previous) {
        node.previous = none();
        previous.next = none();
        nodes.add(node);
      },
    );
    node.moveTo(position.dx, position.dy);
  }

  void insertAfter(Node target, Node node) {
    node.previous.match(
      () {},
      (previous) {
        previous.next = none();
        node.previous = none();
      },
    );
    nodes.remove(node);

    return target.next.match(
      () {
        target.next = some(node);
        node.previous = some(target);
        //node.next = none();
      },
      (next) {
        target.next = some(node);
        node.previous = some(target);
        final lastNode = node.last;
        node.last.next = some(next);
        next.previous = some(lastNode);
      },
    );
  }

  void insertBefore(Node target, Node node) {
    return target.previous.match(
      () {
        target.previous = some(node.last);
        node.last.next = some(target);
        node.moveTo(target._x, target._y);
        nodes.remove(target);
        nodes.add(node);
        // Not always insert
        node.previous.match(
          () {},
          (previous) {
            previous.next = none();
            node.previous = none();
            nodes.insert(0, node);
          },
        );
      },
      (previous) {
        final child = target.findChild(node);
        if (child case Some(:final value)) {
          final childPrevious = value.previous;
          value.previous = none();
          childPrevious.match(
            () {},
            (previous) {
              previous.next = none();
            },
          );
        }
        if (node.previous case Some(:final value)) {
          value.next = none();
          node.previous = none();
        }
        target.previous = some(node.last);
        node.last.next = some(target);
        node.previous = some(previous);
        previous.next = some(node);

        nodes.remove(node);
      },
    );
  }
}
