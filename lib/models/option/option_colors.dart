import 'package:flutter/material.dart';
import 'package:fp_blocky/models/block_color.dart';
import 'package:fp_blocky/models/either/either_colors.dart';

class OptionColors {
  static final Color foundationColor = Color(0xFF33ABFF);
  static final BlockColor color = BlockColor(fromColor: foundationColor);
  static final BlockColor toEitherColor = BlockColor(fromColor: foundationColor, toColor: EitherColors.foundationColor);
}
