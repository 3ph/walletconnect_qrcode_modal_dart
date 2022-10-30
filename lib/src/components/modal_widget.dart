import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_qrcode_modal_dart/src/components/modal_segment_thumb_widget.dart';

import '../models/wallet.dart';
import '../store/wallet_store.dart';
import '/src/modal_main_page.dart';
import '/src/utils/utils.dart';
import '/src/components/modal_qrcode_widget.dart';
import 'modal_wallet_list_widget.dart';
import 'modal_wallet_button_widget.dart';

import '/src/components/modal_wallet_desktop_page.dart';

typedef ModalSegmentThumbBuilder = Widget Function(
  BuildContext context,
  ModalSegmentThumbWidget defaultSegmentThumbWidget,
);

typedef ModalWalletButtonBuilder = Widget Function(
  BuildContext context,

  /// Represents one click button on Android
  ModalWalletButtonWidget defaultWalletButtonWidget,
);

typedef ModalWalletListBuilder = Widget Function(
  BuildContext context,

  /// Represents one click button on iOS/desktop
  ModalWalletListWidget defaultWalletListWidget,
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
    this.walletListBuilder,
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

  /// Modal content for Android
  final ModalWalletListBuilder? walletListBuilder;

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
    ModalWalletButtonBuilder? walletButtonBuilder,
    ModalWalletListBuilder? walletListBuilder,
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
        walletButtonBuilder: walletButtonBuilder ?? this.walletButtonBuilder,
        walletListBuilder: walletListBuilder ?? this.walletListBuilder,
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
                      walletListBuilder: widget.walletListBuilder,
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

class _ModalContent extends StatelessWidget {
  const _ModalContent({
    required this.groupValue,
    required this.uri,
    this.walletCallback,
    this.walletButtonBuilder,
    this.walletListBuilder,
    Key? key,
  }) : super(key: key);

  final int groupValue;
  final String uri;
  final WalletCallback? walletCallback;
  final ModalWalletButtonBuilder? walletButtonBuilder;
  final ModalWalletListBuilder? walletListBuilder;

  @override
  Widget build(BuildContext context) {
    if (groupValue == (Utils.isDesktop ? 1 : 0)) {
      if (Utils.isIOS) {
        final defaultWidget = ModalWalletListWidget(
          url: uri,
          wallets: _iosWallets,
          walletCallback: walletCallback,
          onWalletTap: (wallet, url) => Utils.iosLaunch(
            wallet: wallet,
            uri: url,
          ),
        );
        if (walletListBuilder != null) {
          return walletListBuilder!.call(context, defaultWidget);
        }

        return defaultWidget;
      } else if (Utils.isAndroid) {
        final defaultWidget = ModalWalletButtonWidget(uri: uri);
        if (walletButtonBuilder != null) {
          return walletButtonBuilder!.call(
            context,
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

  Future<List<Wallet>> get _iosWallets {
    Future<bool> shouldShow(wallet) async =>
        await Utils.openableLink(wallet.mobile.universal) ||
        await Utils.openableLink(wallet.mobile.native) ||
        await Utils.openableLink(wallet.app.ios);

    return const WalletStore().load().then(
      (wallets) async {
        final filter = <Wallet>[];
        for (final wallet in wallets) {
          if (await shouldShow(wallet)) {
            filter.add(wallet);
          }
        }
        return filter;
      },
    );
  }
}
