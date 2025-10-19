import 'package:flutter/material.dart';
import 'package:fp_blocky/widgets/blocks/monad_block.dart';

class EditorView extends StatelessWidget {
  const EditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.01,
      child: Stack(
        children: [
          MonadBlock(x: 100, y: 100),
          MonadBlock(x: 200, y: 150),
          MonadBlock(x: 500, y: 150),
          MonadBlock(x: 200, y: 800),
        ],
      ),
      /*Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 0,
          children: <Widget>[
            const Text('Functional Programming w/ Blocks', style: TextStyle(fontSize: 18)),
            SizedBox(height: 50),
            MonadPainter(
              color: Colors.blue.shade400,
              borderColor: Colors.black87,
              name: 'Option.of',
              connectors: [ConnectorType.output],
            ),
            MonadPainter(
              color: Colors.blue.shade400,
              borderColor: Colors.black87,
              connectors: [ConnectorType.input, ConnectorType.output],
              name: 'map',
            ),
            MonadPainter(
              color: Colors.blue.shade400,
              borderColor: Colors.black87,
              connectors: [ConnectorType.input, ConnectorType.output],
              name: 'flatMap',
            ),
          ],
        ),
      ), */
    );
  }
}
