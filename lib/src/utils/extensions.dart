import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double width() => MediaQuery.of(this).size.width;
  double height() => MediaQuery.of(this).size.height;
  ColorScheme theme() => Theme.of(this).colorScheme;
  TextTheme textTheme() => Theme.of(this).textTheme;
  NavigatorState navigator() => Navigator.of(this);
  ScaffoldMessengerState scaffoldMessenger() => ScaffoldMessenger.of(this);
}

extension ThemeExtension on ColorScheme {
  ButtonStyle primaryButton() => ElevatedButton.styleFrom(
        foregroundColor: onPrimary,
        backgroundColor: primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      );
}

extension ColorExtension on Color {
  // ranges from 0.0 to 1.0

  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
