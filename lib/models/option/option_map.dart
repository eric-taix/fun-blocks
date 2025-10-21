import 'package:flutter/material.dart';
import 'package:fp_blocky/models/monad.dart';
import 'package:fp_blocky/models/monad_failure.dart';
import 'package:fp_blocky/widgets/blocks/painter/monad_painter.dart';
import 'package:fp_blocky/widgets/blocks/painter/paths/monad_path.dart';
import 'package:fpdart/fpdart.dart' as fp;

class OptionMap extends MonadModel {
  factory OptionMap.prototype() => OptionMap._(
        inputType: fp.some('Option<String>'),
        outputType: fp.some('Option<String>'),
      );

  OptionMap._({
    required super.inputType,
    required super.outputType,
  });

  @override
  Widget get widget => MonadPainter(
        color: Colors.blue.shade600,
        borderColor: Colors.black,
        name: 'map<C>',
        connectors: [ConnectorType.output, ConnectorType.input],
      );

  @override
  fp.Either<MonadFailure, MonadModel> connect({fp.Option<MonadModel>? output, fp.Option<MonadModel>? input}) {
    return fp.Right(
      OptionMap._(
        inputType: inputType,
        outputType: outputType,
      ),
    );
  }

  @override
  MonadModel clone({required double x, required double y}) {
    return OptionMap._(
      inputType: inputType,
      outputType: outputType,
    );
  }

  @override
  String toString() {
    return 'OptionMap{ inputType: $inputType, outputType: $outputType }';
  }
}
