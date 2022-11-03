import 'package:flutter/material.dart';

import '../utils/utils.dart';

class WalletListSettings {
  final String title;
  final TextAlign titleTextAlign;
  final TextStyle? titleTextStyle;
  final EdgeInsets titlePadding;

  final Color? loadingColor;

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
    this.loadingColor,
    this.listPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 16),
    this.itemTextStyle,
    this.itemImageBorderRadius,
    this.itemImageShadowColor,
    this.itemImageSize = 30,
    this.itemIconPadding = const EdgeInsets.only(left: 8.0),
    this.itemImageShadowBlurRadius = 5,
    this.itemImageShadowSpreadRadius = 2,
    this.itemIconData = Icons.arrow_forward_ios,
    this.itemIconSize = 20,
    this.itemIconColor,
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
      loadingColor: context.theme().onBackground,
    );
  }

  WalletListSettings copyWith({
    String? title,
    TextAlign? titleTextAlign,
    TextStyle? titleTextStyle,
    EdgeInsets? titlePadding,
    Color? loadingColor,
    EdgeInsets? listPadding,
    EdgeInsets? itemPadding,
    TextStyle? itemTextStyle,
    BorderRadius? itemImageBorderRadius,
    Color? itemImageShadowColor,
    double? itemImageSize,
    EdgeInsets? itemIconPadding,
    double? itemImageShadowBlurRadius,
    double? itemImageShadowSpreadRadius,
    IconData? itemIconData,
    double? itemIconSize,
    Color? itemIconColor,
  }) {
    return WalletListSettings(
      title: title ?? this.title,
      titleTextAlign: titleTextAlign ?? this.titleTextAlign,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      titlePadding: titlePadding ?? this.titlePadding,
      loadingColor: loadingColor ?? this.loadingColor,
      listPadding: listPadding ?? this.listPadding,
      itemPadding: itemPadding ?? this.itemPadding,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      itemImageBorderRadius:
          itemImageBorderRadius ?? this.itemImageBorderRadius,
      itemImageShadowColor: itemImageShadowColor ?? this.itemImageShadowColor,
      itemImageSize: itemImageSize ?? this.itemImageSize,
      itemIconPadding: itemIconPadding ?? this.itemIconPadding,
      itemImageShadowBlurRadius:
          itemImageShadowBlurRadius ?? this.itemImageShadowBlurRadius,
      itemImageShadowSpreadRadius:
          itemImageShadowSpreadRadius ?? this.itemImageShadowSpreadRadius,
      itemIconData: itemIconData ?? this.itemIconData,
      itemIconSize: itemIconSize ?? this.itemIconSize,
      itemIconColor: itemIconColor ?? this.itemIconColor,
    );
  }

  @override
  String toString() {
    return 'WalletListSettings(title: $title, titleTextAlign: $titleTextAlign, titleTextStyle: $titleTextStyle, titlePadding: $titlePadding, loadingColor: $loadingColor, listPadding: $listPadding, itemPadding: $itemPadding, itemTextStyle: $itemTextStyle, itemImageBorderRadius: $itemImageBorderRadius, itemImageShadowColor: $itemImageShadowColor, itemImageSize: $itemImageSize, itemIconPadding: $itemIconPadding, itemImageShadowBlurRadius: $itemImageShadowBlurRadius, itemImageShadowSpreadRadius: $itemImageShadowSpreadRadius, itemIconData: $itemIconData, itemIconSize: $itemIconSize, itemIconColor: $itemIconColor)';
  }

  @override
  bool operator ==(covariant WalletListSettings other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.titleTextAlign == titleTextAlign &&
        other.titleTextStyle == titleTextStyle &&
        other.titlePadding == titlePadding &&
        other.loadingColor == loadingColor &&
        other.listPadding == listPadding &&
        other.itemPadding == itemPadding &&
        other.itemTextStyle == itemTextStyle &&
        other.itemImageBorderRadius == itemImageBorderRadius &&
        other.itemImageShadowColor == itemImageShadowColor &&
        other.itemImageSize == itemImageSize &&
        other.itemIconPadding == itemIconPadding &&
        other.itemImageShadowBlurRadius == itemImageShadowBlurRadius &&
        other.itemImageShadowSpreadRadius == itemImageShadowSpreadRadius &&
        other.itemIconData == itemIconData &&
        other.itemIconSize == itemIconSize &&
        other.itemIconColor == itemIconColor;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        titleTextAlign.hashCode ^
        titleTextStyle.hashCode ^
        titlePadding.hashCode ^
        loadingColor.hashCode ^
        listPadding.hashCode ^
        itemPadding.hashCode ^
        itemTextStyle.hashCode ^
        itemImageBorderRadius.hashCode ^
        itemImageShadowColor.hashCode ^
        itemImageSize.hashCode ^
        itemIconPadding.hashCode ^
        itemImageShadowBlurRadius.hashCode ^
        itemImageShadowSpreadRadius.hashCode ^
        itemIconData.hashCode ^
        itemIconSize.hashCode ^
        itemIconColor.hashCode;
  }
}
