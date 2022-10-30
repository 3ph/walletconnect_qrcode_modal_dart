import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_qrcode_modal_dart/src/components/modal_segment_thumb_widget.dart';

import '/src/modal_main_page.dart';
import '/src/utils/utils.dart';
import '/src/components/modal_qrcode_widget.dart';
import '/src/components/modal_wallet_ios_page.dart';
import 'modal_wallet_android_widget.dart';

import '/src/components/modal_wallet_desktop_page.dart';

typedef ModalSegmentThumbBuilder = Widget Function(
  BuildContext context,

  /// Thumb text
  String text,
  ModalSegmentThumbWidget defaultSegmentThumbWidget,
);

typedef ModalWalletButtonBuilder = Widget Function(
  BuildContext context,

  /// Button text
  String text,

  /// WC url
  String url,

  /// Represents one click button on Android
  ModalWalletButtonWidget defaultWalletButtonWidget,
);

class ModalWidget extends StatefulWidget {
  const ModalWidget({
    required this.uri,
    this.walletCallback,
    this.width,
    this.height,
    this.cardPadding,
    this.segmentedControlBackgroundColor,
    this.segmentedControlPadding,
    this.walletSegmentThumbBuilder,
    this.qrSegmentThumbBuilder,
    this.walletButtonBuilder,
    Key? key,
  }) : super(key: key);

  /// WallectConnect URI
  final String uri;

  /// Wallet callback (when wallet is selected)
  final WalletCallback? walletCallback;

  /// Height of the modal
  final double? width;

  /// Width of the modal
  final double? height;

  /// Content card padding
  final EdgeInsets? cardPadding;

  /// Segmented control styling
  final Color? segmentedControlBackgroundColor;
  final EdgeInsets? segmentedControlPadding;

  /// Thumb builder for QR code segment
  final ModalSegmentThumbBuilder? qrSegmentThumbBuilder;

  /// Thumb builder for Wallet segment
  final ModalSegmentThumbBuilder? walletSegmentThumbBuilder;

  /// Modal content for Android
  final ModalWalletButtonBuilder? walletButtonBuilder;

  @override
  State<ModalWidget> createState() => _ModalWidgetState();

  ModalWidget copyWith({
    double? width,
    double? height,
    EdgeInsets? cardPadding,
    Color? segmentedControlBackgroundColor,
    EdgeInsets? segmentedControlPadding,
    ModalSegmentThumbBuilder? qrSegmentThumbBuilder,
    ModalSegmentThumbBuilder? walletSegmentThumbBuilder,
    ModalWalletButtonBuilder? walletAndroidBuilder,
    Key? key,
  }) =>
      ModalWidget(
        uri: uri,
        walletCallback: walletCallback,
        width: width ?? this.width,
        height: height ?? this.height,
        cardPadding: cardPadding ?? this.cardPadding,
        segmentedControlBackgroundColor: segmentedControlBackgroundColor ??
            this.segmentedControlBackgroundColor,
        segmentedControlPadding:
            segmentedControlPadding ?? this.segmentedControlPadding,
        qrSegmentThumbBuilder:
            qrSegmentThumbBuilder ?? this.qrSegmentThumbBuilder,
        walletSegmentThumbBuilder:
            walletSegmentThumbBuilder ?? this.walletSegmentThumbBuilder,
        walletButtonBuilder: walletAndroidBuilder ?? this.walletButtonBuilder,
        key: key ?? this.key,
      );
}

class _ModalWidgetState extends State<ModalWidget> {
  int? _groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
        height:
            widget.height ?? max(500, MediaQuery.of(context).size.height * 0.5),
        child: Card(
          child: Padding(
            padding: widget.cardPadding ?? const EdgeInsets.all(8),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  CupertinoSlidingSegmentedControl<int>(
                    groupValue: _groupValue,
                    onValueChanged: (value) => setState(() {
                      _groupValue = value;
                    }),
                    backgroundColor: widget.segmentedControlBackgroundColor ??
                        Colors.grey.shade300,
                    padding: widget.segmentedControlPadding ??
                        const EdgeInsets.all(4),
                    children: {
                      0: Utils.isDesktop
                          ? _QrSegment(
                              thumbBuilder: widget.qrSegmentThumbBuilder,
                            )
                          : _ListSegment(
                              thumbBuilder: widget.walletSegmentThumbBuilder,
                            ),
                      1: Utils.isDesktop
                          ? _ListSegment(
                              thumbBuilder: widget.walletSegmentThumbBuilder,
                            )
                          : _QrSegment(
                              thumbBuilder: widget.qrSegmentThumbBuilder,
                            ),
                    },
                  ),
                  Expanded(
                    child: _ModalContent(
                      groupValue: _groupValue!,
                      walletCallback: widget.walletCallback,
                      uri: widget.uri,
                      walletButtonBuilder: widget.walletButtonBuilder,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
      return thumbBuilder!.call(context, text, defaultWidget);
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
      return thumbBuilder!.call(context, text, defaultWidget);
    }

    return defaultWidget;
  }
}

class _ModalContent extends StatelessWidget {
  const _ModalContent({
    required this.groupValue,
    required this.uri,
    this.walletCallback,
    this.walletButtonBuilder,
    Key? key,
  }) : super(key: key);

  final int groupValue;
  final String uri;
  final WalletCallback? walletCallback;
  final ModalWalletButtonBuilder? walletButtonBuilder;

  @override
  Widget build(BuildContext context) {
    if (groupValue == (Utils.isDesktop ? 1 : 0)) {
      if (Utils.isIOS) {
        return ModalWalletIOSPage(uri: uri, walletCallback: walletCallback);
      } else if (Utils.isAndroid) {
        final defaultWidget = ModalWalletButtonWidget(uri: uri);
        if (walletButtonBuilder != null) {
          return walletButtonBuilder!.call(
            context,
            defaultWidget.text,
            uri,
            defaultWidget,
          );
        }
        return defaultWidget;
      } else {
        return ModalWalletDesktopPage(uri: uri, walletCallback: walletCallback);
      }
    }
    return ModalQrCodeWidget(uri: uri);
  }
}
