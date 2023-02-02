import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'modal_segment_thumb_widget.dart';
import 'modal_widget.dart';

class ModalSelectorWidget extends StatelessWidget {
  const ModalSelectorWidget({
    required this.selection,
    this.backgroundColor,
    this.padding,
    this.qrSegmentThumbBuilder,
    this.walletSegmentThumbBuilder,
    this.onSelectionChanged,
    Key? key,
  }) : super(key: key);

  /// Segmented control background color
  final Color? backgroundColor;

  /// Segmented control padding
  final EdgeInsets? padding;

  /// Thumb builder for QR code segment
  final ModalSegmentThumbBuilder? qrSegmentThumbBuilder;

  /// Thumb builder for Wallet segment
  final ModalSegmentThumbBuilder? walletSegmentThumbBuilder;

  /// Currently selected selector index
  final int selection;

  /// Callback for a new selection
  final Function(int)? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<int>(
      groupValue: selection,
      onValueChanged: (value) => onSelectionChanged?.call(value ?? 0),
      backgroundColor: backgroundColor ?? Colors.grey.shade300,
      padding: padding ?? const EdgeInsets.all(4),
      children: {
        0: Utils.isDesktop
            ? _QrSegment(
                thumbBuilder: qrSegmentThumbBuilder,
              )
            : _ListSegment(
                thumbBuilder: walletSegmentThumbBuilder,
              ),
        1: Utils.isDesktop
            ? _ListSegment(
                thumbBuilder: walletSegmentThumbBuilder,
              )
            : _QrSegment(
                thumbBuilder: qrSegmentThumbBuilder,
              ),
      },
    );
  }

  ModalSelectorWidget copyWith({
    int? selection,
    Color? backgroundColor,
    EdgeInsets? padding,
    ModalSegmentThumbBuilder? qrSegmentThumbBuilder,
    ModalSegmentThumbBuilder? walletSegmentThumbBuilder,
    Function(int)? onSelectionChanged,
    Key? key,
  }) =>
      ModalSelectorWidget(
        selection: selection ?? this.selection,
        onSelectionChanged: onSelectionChanged ?? this.onSelectionChanged,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        padding: padding ?? this.padding,
        qrSegmentThumbBuilder:
            qrSegmentThumbBuilder ?? this.qrSegmentThumbBuilder,
        walletSegmentThumbBuilder:
            walletSegmentThumbBuilder ?? this.walletSegmentThumbBuilder,
        key: key ?? this.key,
      );
}

class _ListSegment extends StatelessWidget {
  const _ListSegment({
    this.thumbBuilder,
    Key? key,
  }) : super(key: key);

  final ModalSegmentThumbBuilder? thumbBuilder;

  @override
  Widget build(BuildContext context) {
    final text = Utils.isDesktop ? 'Desktop' : 'Mobile';
    final defaultWidget = ModalSegmentThumbWidget(text: text);

    if (thumbBuilder != null) {
      return thumbBuilder!.call(context, defaultWidget);
    }

    return defaultWidget;
  }
}

class _QrSegment extends StatelessWidget {
  const _QrSegment({
    this.thumbBuilder,
    Key? key,
  }) : super(key: key);

  final ModalSegmentThumbBuilder? thumbBuilder;

  @override
  Widget build(BuildContext context) {
    const text = 'QR Code';
    const defaultWidget = ModalSegmentThumbWidget(text: text);

    if (thumbBuilder != null) {
      return thumbBuilder!.call(context, defaultWidget);
    }

    return defaultWidget;
  }
}
