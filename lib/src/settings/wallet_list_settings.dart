import 'package:flutter/material.dart';

import '../utils/utils.dart';

class WalletListSettings {
  final String title;
  final TextAlign titleTextAlign;
  final TextStyle? titleTextStyle;
  final EdgeInsets titlePadding;

  final EdgeInsets listPadding;

  final EdgeInsets itemPadding;
  final TextStyle? itemTextStyle;
  final BorderRadius? itemImageBorderRadius;
  final Color? itemImageShadowColor;
  final double itemImageSize;
  final EdgeInsets itemIconPadding;
  final double itemImageShadowBlurRadius;
  final double itemImageShadowSpreadRadius;
  final IconData itemIconData;
  final double itemIconSize;
  final Color? itemIconColor;

  WalletListSettings({
    this.title = 'Choose your preferred wallet',
    this.titleTextAlign = TextAlign.center,
    this.titleTextStyle,
    this.titlePadding = const EdgeInsets.only(top: 16, bottom: 8),
    this.listPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 16),
    this.itemTextStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    this.itemImageBorderRadius,
    this.itemImageShadowColor,
    this.itemIconData = Icons.arrow_forward_ios,
    this.itemIconSize = 20,
    this.itemIconColor,
    this.itemImageShadowBlurRadius = 5,
    this.itemImageShadowSpreadRadius = 2,
    this.itemIconPadding = const EdgeInsets.only(left: 8.0),
    this.itemImageSize = 30,
  });

  factory WalletListSettings.fromContext(BuildContext context) {
    return WalletListSettings(
      titleTextStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: context.theme().onBackground,
      ),
      itemImageBorderRadius: BorderRadius.circular(8.0),
      itemImageShadowColor: context.theme().shadow.withOpacity(0.3),
      itemIconColor: context.theme().onBackground,
    );
  }
}
