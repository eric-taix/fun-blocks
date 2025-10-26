import 'package:flutter/material.dart';
import 'package:fp_blocky/models/monad.dart';
import 'package:fp_blocky/models/monad_failure.dart';
import 'package:fp_blocky/widgets/blocks/painter/monad_painter.dart';
import 'package:fp_blocky/widgets/blocks/painter/paths/monad_path.dart';
import 'package:fpdart/fpdart.dart' as fp;

import 'option_colors.dart';

class OptionToEither extends MonadModel {
  OptionToEither()
      : super(
          inputType: fp.Some('Option<T>'),
          outputType: fp.some('toEither<L, R>'),
        );

  factory OptionToEither.prototype() => OptionToEither._(
        inputType: fp.Some('Option<T>'),
        outputType: fp.some('toEither<L, R>'),
      );

  OptionToEither._({
    required super.inputType,
    required super.outputType,
  });

  @override
  Widget get widget => MonadPainter(
        color: OptionColors.toEitherColor,
        name: 'toEither<L, R>',
        connectors: [ConnectorType.input, ConnectorType.output],
      );

  @override
  fp.Either<MonadFailure, MonadModel> connect({fp.Option<MonadModel>? output, fp.Option<MonadModel>? input}) {
    return fp.Right(
      OptionToEither._(
        inputType: inputType,
        outputType: outputType,
      ),
    );
  }

  @override
  MonadModel clone({required double x, required double y}) {
    return OptionToEither._(
      inputType: inputType,
      outputType: outputType,
    );
  }
}
