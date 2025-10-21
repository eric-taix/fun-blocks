import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:fpdart/fpdart.dart';

import 'monad_failure.dart';

abstract class MonadModel {
  MonadModel({
    required this.inputType,
    required this.outputType,
  });

  Widget get widget;

  final Option<String> inputType;
  final Option<String> outputType;

  fp.Either<MonadFailure, MonadModel> connect({fp.Option<MonadModel>? output, fp.Option<MonadModel>? input});

  MonadModel clone({required double x, required double y});
}

class EmptyMonad extends MonadModel {
  EmptyMonad() : super(inputType: fp.None(), outputType: fp.None());

  @override
  Widget get widget => throw UnimplementedError();

  @override
  fp.Either<MonadFailure, MonadModel> connect({fp.Option<MonadModel>? output, fp.Option<MonadModel>? input}) {
    throw UnimplementedError();
  }

  @override
  MonadModel clone({required double x, required double y}) {
    throw UnimplementedError();
  }
}
