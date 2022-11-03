import 'package:flutter/material.dart';

import '../utils/utils.dart';

class LaunchWalletSettings {
  final IconData connectIcon;
  final String connectText;
  final ButtonStyle? buttonStyle;

  LaunchWalletSettings({
    this.connectIcon = Icons.open_in_browser,
    this.connectText = "Connect",
    this.buttonStyle,
  });

  factory LaunchWalletSettings.fromContext(BuildContext context) {
    return LaunchWalletSettings(
      buttonStyle: context.theme().primaryButton(),
    );
  }

  LaunchWalletSettings copyWith({
    IconData? connectIcon,
    String? connectText,
    ButtonStyle? buttonStyle,
  }) {
    return LaunchWalletSettings(
      connectIcon: connectIcon ?? this.connectIcon,
      connectText: connectText ?? this.connectText,
      buttonStyle: buttonStyle ?? this.buttonStyle,
    );
  }

  @override
  bool operator ==(covariant LaunchWalletSettings other) {
    if (identical(this, other)) return true;

    return other.connectIcon == connectIcon &&
        other.connectText == connectText &&
        other.buttonStyle == buttonStyle;
  }

  @override
  int get hashCode =>
      connectIcon.hashCode ^ connectText.hashCode ^ buttonStyle.hashCode;
}
