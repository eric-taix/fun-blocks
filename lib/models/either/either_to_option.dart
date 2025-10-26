import 'package:flutter/material.dart';
import 'package:fp_blocky/models/monad.dart';
import 'package:fp_blocky/models/monad_failure.dart';
import 'package:fp_blocky/widgets/blocks/painter/monad_painter.dart';
import 'package:fp_blocky/widgets/blocks/painter/paths/monad_path.dart';
import 'package:fpdart/fpdart.dart' as fp;

import 'either_colors.dart';

class EitherToOption extends MonadModel {
  factory EitherToOption.prototype() => EitherToOption._(
        inputType: fp.some('Either<String>'),
        outputType: fp.some('Option<String>'),
      );

  EitherToOption._({
    required super.inputType,
    required super.outputType,
  });

  @override
  Widget get widget => MonadPainter(
        color: EitherColors.toOptionColor,
        name: 'toOption<C>',
        connectors: [ConnectorType.output, ConnectorType.input],
      );

  @override
  fp.Either<MonadFailure, MonadModel> connect({fp.Option<MonadModel>? output, fp.Option<MonadModel>? input}) {
    return fp.Right(
      EitherToOption._(
        inputType: inputType,
        outputType: outputType,
      ),
    );
  }

  @override
  MonadModel clone({required double x, required double y}) {
    return EitherToOption._(
      inputType: inputType,
      outputType: outputType,
    );
  }

  @override
  String toString() {
    return 'EitherToOption{ inputType: $inputType, outputType: $outputType }';
  }
}
