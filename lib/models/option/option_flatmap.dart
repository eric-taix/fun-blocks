import 'package:flutter/material.dart';
import 'package:fp_blocky/models/monad.dart';
import 'package:fp_blocky/models/monad_failure.dart';
import 'package:fp_blocky/widgets/blocks/painter/monad_painter.dart';
import 'package:fp_blocky/widgets/blocks/painter/paths/monad_path.dart';
import 'package:fpdart/fpdart.dart' as fp;

import 'option_colors.dart';

class OptionFlatMap extends MonadModel {
  factory OptionFlatMap.prototype() => OptionFlatMap._(
        inputType: fp.some('Option<String>'),
        outputType: fp.some('Option<String>'),
      );

  OptionFlatMap._({
    required super.inputType,
    required super.outputType,
  });

  @override
  Widget get widget => MonadPainter(
        color: OptionColors.color,
        name: 'flatMap<C>',
        connectors: [ConnectorType.output, ConnectorType.input],
      );

  @override
  fp.Either<MonadFailure, MonadModel> connect({fp.Option<MonadModel>? output, fp.Option<MonadModel>? input}) {
    return fp.Right(
      OptionFlatMap._(
        inputType: inputType,
        outputType: outputType,
      ),
    );
  }

  @override
  MonadModel clone({required double x, required double y}) {
    return OptionFlatMap._(
      inputType: inputType,
      outputType: outputType,
    );
  }

  @override
  String toString() {
    return 'OptionFlatMap{ inputType: $inputType, outputType: $outputType }';
  }
}
