import 'dart:ui';

enum ConnectorType { input, output }

Path inputOutputPath(double width, double height, List<ConnectorType> connectors) {
  final connectorHeight = 8.0;
  final connectorWidth = 18.0;
  final connectorRadius = 10.0;
  final connectorStartX = 14;
  final delta = 2.0;
  final radius = 8.0;
  Path path = Path()
    ..moveTo(radius, 0)
    ..lineTo(radius + connectorStartX + delta, 0);

  if (connectors.contains(ConnectorType.input)) {
    path = path
      ..lineTo(radius + connectorStartX, connectorHeight)
      ..arcToPoint(
        Offset(radius + connectorStartX + connectorWidth, connectorHeight),
        radius: Radius.circular(connectorRadius),
        clockwise: false,
      )
      ..lineTo(radius + connectorStartX + connectorWidth - delta, 0);
  }

  path = path
    ..lineTo(width - radius, 0)
    ..arcToPoint(Offset(width, radius), radius: Radius.circular(radius))
    ..lineTo(width, height - radius)
    ..arcToPoint(Offset(width - radius, height), radius: Radius.circular(radius))
    ..lineTo(radius + connectorStartX + connectorWidth - delta, height);

  if (connectors.contains(ConnectorType.output)) {
    path = path
      ..lineTo(radius + connectorStartX + connectorWidth, height + connectorHeight)
      ..arcToPoint(Offset(radius + connectorStartX, height + connectorHeight), radius: Radius.circular(connectorRadius))
      ..lineTo(radius + connectorStartX + delta, height);
  }

  path = path
    ..lineTo(radius, height)
    ..arcToPoint(Offset(0, height - radius), radius: Radius.circular(radius))
    ..lineTo(0, radius)
    ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));

  return path;
}
