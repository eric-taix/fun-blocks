import 'package:flutter/material.dart';
import 'package:fp_blocky/models/monad.dart';
import 'package:fp_blocky/models/monad_failure.dart';
import 'package:fp_blocky/widgets/blocks/painter/monad_painter.dart';
import 'package:fp_blocky/widgets/blocks/painter/paths/monad_path.dart';
import 'package:fpdart/fpdart.dart' as fp;

import 'option_colors.dart';

class OptionOf extends MonadModel {
  OptionOf()
      : super(
          inputType: fp.None(),
          outputType: fp.some('Option<String>'),
        );

  factory OptionOf.prototype() => OptionOf._(
        outputType: fp.some('Option<String>'),
      );

  OptionOf._({
    required super.outputType,
  }) : super(inputType: fp.None());

  @override
  Widget get widget => MonadPainter(
        color: OptionColors.color,
        name: 'Option.of<A>',
        connectors: [ConnectorType.output],
      );

  @override
  fp.Either<MonadFailure, MonadModel> connect({fp.Option<MonadModel>? output, fp.Option<MonadModel>? input}) {
    return fp.Right(
      OptionOf._(
        outputType: outputType,
      ),
    );
  }

  @override
  MonadModel clone({required double x, required double y}) {
    return OptionOf._(
      outputType: outputType,
    );
  }
}
