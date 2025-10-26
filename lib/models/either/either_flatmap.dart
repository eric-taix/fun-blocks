import 'package:flutter/material.dart';
import 'package:fp_blocky/models/either/either_colors.dart';
import 'package:fp_blocky/models/monad.dart';
import 'package:fp_blocky/models/monad_failure.dart';
import 'package:fp_blocky/widgets/blocks/painter/monad_painter.dart';
import 'package:fp_blocky/widgets/blocks/painter/paths/monad_path.dart';
import 'package:fpdart/fpdart.dart' as fp;

class EitherFlatMap extends MonadModel {
  factory EitherFlatMap.prototype() => EitherFlatMap._(
        inputType: fp.some('Either<String>'),
        outputType: fp.some('Either<String>'),
      );

  EitherFlatMap._({
    required super.inputType,
    required super.outputType,
  });

  @override
  Widget get widget => MonadPainter(
        color: EitherColors.color,
        name: 'flatMap<C>',
        connectors: [ConnectorType.output, ConnectorType.input],
      );

  @override
  fp.Either<MonadFailure, MonadModel> connect({fp.Option<MonadModel>? output, fp.Option<MonadModel>? input}) {
    return fp.Right(
      EitherFlatMap._(
        inputType: inputType,
        outputType: outputType,
      ),
    );
  }

  @override
  MonadModel clone({required double x, required double y}) {
    return EitherFlatMap._(
      inputType: inputType,
      outputType: outputType,
    );
  }

  @override
  String toString() {
    return 'EitherFlatMap{ inputType: $inputType, outputType: $outputType }';
  }
}
