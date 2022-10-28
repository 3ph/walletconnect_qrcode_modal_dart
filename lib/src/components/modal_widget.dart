import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/src/modal_main_page.dart';
import '/src/utils/utils.dart';
import '/src/components/modal_qrcode_widget.dart';
import '/src/components/modal_wallet_ios_page.dart';
import '/src/components/modal_wallet_android_page.dart';

import '/src/components/modal_wallet_desktop_page.dart';

class ModalWidget extends StatefulWidget {
  const ModalWidget({
    required this.uri,
    this.walletCallback,
    this.width,
    this.height,
    this.cardPadding,
    this.segmentedControlBackgroundColor,
    this.segmentedControlPadding,
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

  @override
  State<ModalWidget> createState() => _ModalWidgetState();

  ModalWidget copyWith({
    double? width,
    double? height,
    EdgeInsets? cardPadding,
    Color? segmentedControlBackgroundColor,
    EdgeInsets? segmentedControlPadding,
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
        key: this.key ?? key,
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
                          ? const _QrSegment()
                          : const _ListSegment(),
                      1: Utils.isDesktop
                          ? const _ListSegment()
                          : const _QrSegment(),
                    },
                  ),
                  Expanded(
                    child: _ModalContent(
                      groupValue: _groupValue!,
                      walletCallback: widget.walletCallback,
                      uri: widget.uri,
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
  const _ListSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Segment(
      text: Utils.isDesktop ? 'Desktop' : 'Mobile',
    );
  }
}

class _QrSegment extends StatelessWidget {
  const _QrSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _Segment(
      text: 'QR Code',
    );
  }
}

class _ModalContent extends StatelessWidget {
  const _ModalContent({
    required this.groupValue,
    required this.uri,
    this.walletCallback,
    Key? key,
  }) : super(key: key);

  final int groupValue;
  final String uri;
  final WalletCallback? walletCallback;

  @override
  Widget build(BuildContext context) {
    if (groupValue == (Utils.isDesktop ? 1 : 0)) {
      if (Utils.isIOS) {
        return ModalWalletIOSPage(uri: uri, walletCallback: walletCallback);
      } else if (Utils.isAndroid) {
        return ModalWalletAndroidPage(uri: uri);
      } else {
        return ModalWalletDesktopPage(uri: uri, walletCallback: walletCallback);
      }
    }
    return ModalQrCodeWidget(uri: uri);
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }
}
