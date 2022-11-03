import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/utils.dart';

class ModalSettings {
  final double? width;
  final double? height;
  final EdgeInsets cardPadding;
  final EdgeInsets tabPadding;
  final Color? cardColor;
  final Color? tabBackgroundColor;
  final Color? thumbColor;
  final double thumbWidth;
  final TextAlign thumbTextAlign;
  final TextStyle? thumbTextStyle;

  ModalSettings({
    this.width,
    this.height,
    this.cardPadding = const EdgeInsets.all(8.0),
    this.tabPadding = const EdgeInsets.all(4.0),
    this.cardColor,
    this.tabBackgroundColor,
    this.thumbColor,
    this.thumbWidth = 100.0,
    this.thumbTextAlign = TextAlign.center,
    this.thumbTextStyle,
  });

  factory ModalSettings.fromContext(BuildContext context) {
    return ModalSettings(
      width: min(context.width() * 0.9, 600),
      height: max(context.height() * 0.5, 500),
      cardColor: context.theme().background,
      tabBackgroundColor: context.theme().primaryContainer.darken(0.1),
      thumbColor: context.theme().primaryContainer,
      thumbTextStyle: context.textTheme().titleMedium?.copyWith(
            color: context.theme().onPrimaryContainer,
          ),
    );
  }

  ModalSettings copyWith({
    double? width,
    double? height,
    EdgeInsets? cardPadding,
    EdgeInsets? tabPadding,
    Color? cardColor,
    Color? tabBackgroundColor,
    Color? thumbColor,
    double? thumbWidth,
    TextAlign? thumbTextAlign,
    TextStyle? thumbTextStyle,
  }) {
    return ModalSettings(
      width: width ?? this.width,
      height: height ?? this.height,
      cardPadding: cardPadding ?? this.cardPadding,
      tabPadding: tabPadding ?? this.tabPadding,
      cardColor: cardColor ?? this.cardColor,
      tabBackgroundColor: tabBackgroundColor ?? this.tabBackgroundColor,
      thumbColor: thumbColor ?? this.thumbColor,
      thumbWidth: thumbWidth ?? this.thumbWidth,
      thumbTextAlign: thumbTextAlign ?? this.thumbTextAlign,
      thumbTextStyle: thumbTextStyle ?? this.thumbTextStyle,
    );
  }

  @override
  String toString() {
    return 'ModalSettings(width: $width, height: $height, cardPadding: $cardPadding, tabPadding: $tabPadding, cardColor: $cardColor, tabBackgroundColor: $tabBackgroundColor, thumbColor: $thumbColor, thumbWidth: $thumbWidth, thumbTextAlign: $thumbTextAlign, thumbTextStyle: $thumbTextStyle)';
  }

  @override
  bool operator ==(covariant ModalSettings other) {
    if (identical(this, other)) return true;

    return other.width == width &&
        other.height == height &&
        other.cardPadding == cardPadding &&
        other.tabPadding == tabPadding &&
        other.cardColor == cardColor &&
        other.tabBackgroundColor == tabBackgroundColor &&
        other.thumbColor == thumbColor &&
        other.thumbWidth == thumbWidth &&
        other.thumbTextAlign == thumbTextAlign &&
        other.thumbTextStyle == thumbTextStyle;
  }

  @override
  int get hashCode {
    return width.hashCode ^
        height.hashCode ^
        cardPadding.hashCode ^
        tabPadding.hashCode ^
        cardColor.hashCode ^
        tabBackgroundColor.hashCode ^
        thumbColor.hashCode ^
        thumbWidth.hashCode ^
        thumbTextAlign.hashCode ^
        thumbTextStyle.hashCode;
  }
}
