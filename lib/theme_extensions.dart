import 'package:flutter/material.dart';

class FunBlockMenuStyleExtension implements ThemeExtension<FunBlockMenuStyleExtension> {
  FunBlockMenuStyleExtension({required this.textStyle});

  final TextStyle textStyle;

  @override
  ThemeExtension<FunBlockMenuStyleExtension> copyWith({TextStyle? textStyle}) {
    return FunBlockMenuStyleExtension(textStyle: textStyle ?? this.textStyle);
  }

  @override
  ThemeExtension<FunBlockMenuStyleExtension> lerp(
      covariant ThemeExtension<FunBlockMenuStyleExtension>? other, double t) {
    if (other is! FunBlockMenuStyleExtension) {
      return this.copyWith();
    }
    return FunBlockMenuStyleExtension(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
    );
  }

  @override
  Object get type => FunBlockMenuStyleExtension;
}
