import 'package:flutter/material.dart';

import '../utils/utils.dart';

class QrCodeSettings {
  QrCodeSettings({
    this.padding = const EdgeInsets.only(top: 16),
    this.title = 'Scan QR code with a WalletConnect-compatible wallet',
    this.titleTextStyle,
    this.titleTextAlign = TextAlign.center,
    this.qrCodePadding = const EdgeInsets.only(top: 8),
    this.qrCodeColor,
    this.copyButtonStyle,
    this.copyText = 'Copy',
    this.copiedText = 'Copied',
    this.copyIcon = Icons.copy,
    this.copiedIcon = Icons.check,
  });

  factory QrCodeSettings.fromContext(BuildContext context) {
    return QrCodeSettings(
      titleTextStyle: context.textTheme().titleMedium?.copyWith(
                color: context.theme().onBackground,
              ) ??
          const TextStyle(),
      titleTextAlign: TextAlign.center,
      copyButtonStyle: context.theme().primaryButton(),
      qrCodeColor: context.theme().onBackground,
    );
  }

  /// Padding around the content
  final EdgeInsets padding;

  // Title customizations
  final String title;
  final TextStyle? titleTextStyle;
  final TextAlign titleTextAlign;

  // QR code customizations
  final EdgeInsets qrCodePadding;
  final Color? qrCodeColor;

  // Copy customizations
  final ButtonStyle? copyButtonStyle;
  final String copyText;
  final String copiedText;
  final IconData copyIcon;
  final IconData copiedIcon;

  QrCodeSettings copyWith({
    EdgeInsets? padding,
    String? title,
    TextStyle? titleTextStyle,
    TextAlign? titleTextAlign,
    EdgeInsets? qrCodePadding,
    Color? qrCodeColor,
    ButtonStyle? copyButtonStyle,
    String? copyText,
    String? copiedText,
    IconData? copyIcon,
    IconData? copiedIcon,
  }) {
    return QrCodeSettings(
      padding: padding ?? this.padding,
      title: title ?? this.title,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      titleTextAlign: titleTextAlign ?? this.titleTextAlign,
      qrCodePadding: qrCodePadding ?? this.qrCodePadding,
      qrCodeColor: qrCodeColor ?? this.qrCodeColor,
      copyButtonStyle: copyButtonStyle ?? this.copyButtonStyle,
      copyText: copyText ?? this.copyText,
      copiedText: copiedText ?? this.copiedText,
      copyIcon: copyIcon ?? this.copyIcon,
      copiedIcon: copiedIcon ?? this.copiedIcon,
    );
  }

  @override
  String toString() {
    return 'QrCodeSettings(padding: $padding, title: $title, titleTextStyle: $titleTextStyle, titleTextAlign: $titleTextAlign, qrCodePadding: $qrCodePadding, qrCodeColor: $qrCodeColor, copyButtonStyle: $copyButtonStyle, copyText: $copyText, copiedText: $copiedText, copyIcon: $copyIcon, copiedIcon: $copiedIcon)';
  }

  @override
  bool operator ==(covariant QrCodeSettings other) {
    if (identical(this, other)) return true;

    return other.padding == padding &&
        other.title == title &&
        other.titleTextStyle == titleTextStyle &&
        other.titleTextAlign == titleTextAlign &&
        other.qrCodePadding == qrCodePadding &&
        other.qrCodeColor == qrCodeColor &&
        other.copyButtonStyle == copyButtonStyle &&
        other.copyText == copyText &&
        other.copiedText == copiedText &&
        other.copyIcon == copyIcon &&
        other.copiedIcon == copiedIcon;
  }

  @override
  int get hashCode {
    return padding.hashCode ^
        title.hashCode ^
        titleTextStyle.hashCode ^
        titleTextAlign.hashCode ^
        qrCodePadding.hashCode ^
        qrCodeColor.hashCode ^
        copyButtonStyle.hashCode ^
        copyText.hashCode ^
        copiedText.hashCode ^
        copyIcon.hashCode ^
        copiedIcon.hashCode;
  }
}
