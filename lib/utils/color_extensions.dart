import 'package:flutter/material.dart';

extension ColorExtensions on Color {

  Color withOpacityValue(double opacity) {
    final int alpha = (opacity * 255).round().clamp(0, 255);
    return withAlpha(alpha);
  }
}
