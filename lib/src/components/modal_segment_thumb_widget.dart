import 'package:flutter/material.dart';

class ModalSegmentThumbWidget extends StatelessWidget {
  const ModalSegmentThumbWidget({
    required this.text,
    this.width,
    this.textStyle,
    this.textAlign,
    Key? key,
  }) : super(key: key);

  /// Thumb text
  final String text;

  /// Thumb width
  final double? width;

  /// Thumb text style
  final TextStyle? textStyle;

  /// Thumb text alignment
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 100,
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.center,
        style: textStyle ??
            Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                ),
      ),
    );
  }

  ModalSegmentThumbWidget copyWith({
    double? width,
    TextStyle? textStyle,
    TextAlign? textAlign,
  }) =>
      ModalSegmentThumbWidget(
        text: text,
        width: width ?? this.width,
        textStyle: textStyle ?? this.textStyle,
        textAlign: textAlign ?? this.textAlign,
      );
}
