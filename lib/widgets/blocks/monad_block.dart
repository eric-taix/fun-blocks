import 'package:flutter/material.dart';
import 'package:fp_blocky/widgets/blocks/painter/monad_painter.dart';
import 'package:fp_blocky/widgets/blocks/painter/paths/monad_path.dart';

class MonadBlock extends StatelessWidget {
  const MonadBlock({super.key, required this.x, required this.y});

  final double x;
  final double y;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: x,
      left: y,
      child: MonadPainter(color: Colors.red, name: 'Red', borderColor: Colors.red, connectors: [ConnectorType.output]),
    );
  }
}
