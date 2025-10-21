import 'package:flutter/material.dart';
import 'package:fp_blocky/widgets/blocks/painter/paths/monad_path.dart';

class MonadPainter extends StatelessWidget {
  const MonadPainter({
    required this.color,
    required this.borderColor,
    required this.name,
    this.connectors = const [],
    super.key,
  });

  final String name;
  final Color color;
  final Color borderColor;
  final List<ConnectorType> connectors;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MonadCustomPainter(color: color, borderColor: borderColor, connectors: connectors),
      child: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6, left: 12, right: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$name ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            //ElevatedButton(onPressed: () {}, child: Text('(A a) => Option<B>')),
          ],
        ),
      ),
    );
  }
}

class _MonadCustomPainter extends CustomPainter {
  _MonadCustomPainter({required this.color, required this.borderColor, required this.connectors});

  final Color color;
  final Color borderColor;
  final List<ConnectorType> connectors;

  @override
  void paint(Canvas canvas, Size size) {
    final path = inputOutputPath(size.width, size.height, connectors);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
