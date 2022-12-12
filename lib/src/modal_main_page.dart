import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/modal_widget.dart';

import 'models/wallet.dart';

/// Builder for custom QR code modal
typedef QrCodeModalBuilder = Widget Function(
  BuildContext,
  String uri,
  WalletCallback walletCallback,
  ModalWidget defaultModalWidget,
);

/// Callback when wallet is selected
typedef WalletCallback = Function(Wallet);

class ModalMainPage extends StatelessWidget {
  const ModalMainPage({
    required this.uri,
    required this.walletCallback,
    this.modalBuilder,
    Key? key,
  }) : super(key: key);

  final String uri;
  final QrCodeModalBuilder? modalBuilder;
  final WalletCallback walletCallback;

  @override
  Widget build(BuildContext context) {
    final defaultWidget = ModalWidget(
      uri: uri,
      walletCallback: walletCallback,
    );

    if (modalBuilder != null) {
      return modalBuilder!.call(context, uri, walletCallback, defaultWidget);
    }

    return defaultWidget;
  }
}
