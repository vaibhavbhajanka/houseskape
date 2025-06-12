/// Extensions to keep legacy Material 2 TextTheme getters working on
/// newer versions of Flutter where they have been renamed.
/// This prevents having to touch every widget file whilst upgrading.
library;
import 'package:flutter/material.dart';

extension LegacyTextTheme on TextTheme {
  TextStyle? get bodyText2 => bodyMedium;
  TextStyle? get bodyText1 => bodyLarge;
  TextStyle? get headline6 => titleLarge;
  TextStyle? get headline5 => titleMedium;
  TextStyle? get headline4 => titleSmall;
} 