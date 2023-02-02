import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_qrcode_modal_dart/src/components/modal_segment_thumb_widget.dart';
import 'package:walletconnect_qrcode_modal_dart/src/components/modal_selector_widget.dart';

import '../models/wallet.dart';
import '../store/wallet_store.dart';
import '/src/modal_main_page.dart';
import '/src/utils/utils.dart';
import '/src/components/modal_qrcode_widget.dart';
import 'modal_wallet_list_widget.dart';
import 'modal_wallet_button_widget.dart';

/// Custom segment thumb builder
typedef ModalSelectorBuilder = Widget Function(
  BuildContext context,
  ModalSelectorWidget defaultSelectorWidget,
);

/// Custom segment thumb builder
typedef ModalSegmentThumbBuilder = Widget Function(
  BuildContext context,
  ModalSegmentThumbWidget defaultSegmentThumbWidget,
);

/// Custom wallet button builder
typedef ModalWalletButtonBuilder = Widget Function(
  BuildContext context,

  /// Represents one click button on Android
  ModalWalletButtonWidget defaultWalletButtonWidget,
);

/// Custom wallet list builder
typedef ModalWalletListBuilder = Widget Function(
  BuildContext context,

  /// Represents selection list on iOS/desktop
  ModalWalletListWidget defaultWalletListWidget,
);

/// Custom QR code builder
typedef ModalQrCodeBuilder = Widget Function(
  BuildContext context,

  /// Represents QR code
  ModalQrCodeWidget defaultQrCodeWidget,
);

class ModalWidget extends StatefulWidget {
  const ModalWidget({
    required this.uri,
    this.walletCallback,
    this.width,
    this.height,
    this.cardColor,
    this.cardPadding,
    this.selectorBuilder,
    this.walletButtonBuilder,
    this.walletListBuilder,
    this.qrCodeBuilder,
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

  /// Content card color
  final Color? cardColor;

  /// Content card padding
  final EdgeInsets? cardPadding;

  /// Modal selector widget (for choosing between list and QR)
  final ModalSelectorBuilder? selectorBuilder;

  /// Modal content for Android
  final ModalWalletButtonBuilder? walletButtonBuilder;

  /// Modal content for iOS/desktop
  final ModalWalletListBuilder? walletListBuilder;

  /// Modal content QR code
  final ModalQrCodeBuilder? qrCodeBuilder;

  @override
  State<ModalWidget> createState() => _ModalWidgetState();

  ModalWidget copyWith({
    double? width,
    double? height,
    EdgeInsets? cardPadding,
    Color? cardColor,
    ModalSelectorBuilder? selectorBuilder,
    ModalWalletButtonBuilder? walletButtonBuilder,
    ModalWalletListBuilder? walletListBuilder,
    ModalQrCodeBuilder? qrCodeBuilder,
    Key? key,
  }) =>
      ModalWidget(
        uri: uri,
        walletCallback: walletCallback,
        width: width ?? this.width,
        height: height ?? this.height,
        cardPadding: cardPadding ?? this.cardPadding,
        cardColor: cardColor ?? this.cardColor,
        selectorBuilder: selectorBuilder ?? this.selectorBuilder,
        walletButtonBuilder: walletButtonBuilder ?? this.walletButtonBuilder,
        walletListBuilder: walletListBuilder ?? this.walletListBuilder,
        qrCodeBuilder: qrCodeBuilder ?? this.qrCodeBuilder,
        key: key ?? this.key,
      );
}

class _ModalWidgetState extends State<ModalWidget> {
  int selectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final defaultSelectorWidget = ModalSelectorWidget(
      selection: selectionIndex,
      onSelectionChanged: (selection) =>
          setState(() => selectionIndex = selection),
    );

    final Widget selectorWidget;
    if (widget.selectorBuilder != null) {
      selectorWidget =
          widget.selectorBuilder!.call(context, defaultSelectorWidget);
    } else {
      selectorWidget = defaultSelectorWidget;
    }

    return Center(
      child: SizedBox(
        width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
        height:
            widget.height ?? max(500, MediaQuery.of(context).size.height * 0.5),
        child: Card(
          color: widget.cardColor,
          child: Padding(
            padding: widget.cardPadding ?? const EdgeInsets.all(8),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  selectorWidget,
                  Expanded(
                    child: _ModalContent(
                      groupValue: selectionIndex,
                      walletCallback: widget.walletCallback,
                      uri: widget.uri,
                      walletButtonBuilder: widget.walletButtonBuilder,
                      walletListBuilder: widget.walletListBuilder,
                      qrCodeBuilder: widget.qrCodeBuilder,
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

class _ModalContent extends StatelessWidget {
  const _ModalContent({
    required this.groupValue,
    required this.uri,
    this.walletCallback,
    this.walletButtonBuilder,
    this.walletListBuilder,
    this.qrCodeBuilder,
    Key? key,
  }) : super(key: key);

  final int groupValue;
  final String uri;
  final WalletCallback? walletCallback;
  final ModalWalletButtonBuilder? walletButtonBuilder;
  final ModalWalletListBuilder? walletListBuilder;
  final ModalQrCodeBuilder? qrCodeBuilder;

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
        final defaultWidget = ModalWalletListWidget(
          url: uri,
          wallets: _desktopWallets,
          walletCallback: walletCallback,
          onWalletTap: (wallet, url) => Utils.desktopLaunch(
            wallet: wallet,
            uri: uri,
          ),
        );
        if (walletListBuilder != null) {
          return walletListBuilder!.call(context, defaultWidget);
        }

        return defaultWidget;
      }
    }

    final qrCodeWidget = ModalQrCodeWidget(uri: uri);

    if (qrCodeBuilder != null) {
      return qrCodeBuilder!.call(context, qrCodeWidget);
    }
    return qrCodeWidget;
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

  Future<List<Wallet>> get _desktopWallets {
    return const WalletStore().load().then(
          (wallets) => wallets
              .where(
                (wallet) =>
                    Utils.linkHasContent(wallet.desktop.universal) ||
                    Utils.linkHasContent(wallet.desktop.native),
              )
              .toList(),
        );
  }
}
