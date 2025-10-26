import 'package:flutter/material.dart';
import 'package:fp_blocky/models/block_color.dart';
import 'package:fp_blocky/models/option/option_colors.dart';

class EitherColors {
  static final Color foundationColor = Color(0xFFE740FF);
  static final BlockColor color = BlockColor(fromColor: foundationColor);
  static final BlockColor toOptionColor = BlockColor(fromColor: foundationColor, toColor: OptionColors.foundationColor);
}
