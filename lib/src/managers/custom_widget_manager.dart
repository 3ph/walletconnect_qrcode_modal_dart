import 'package:flutter/material.dart';

import '../models/models.dart';
import '../settings/settings.dart';

typedef QrPageBuilder = Widget Function(
  BuildContext context,
  QrCodeSettings qrCodeSettings,
  void Function()? copyToClipboard,
  bool isCopied,
  String uri,
);

typedef LaunchWalletPageBuilder = Widget Function(
  BuildContext context,
  LaunchWalletSettings launchWalletSettings,
  Future<bool> Function() launchWallet,
);

typedef WalletListPageBuilder = Widget Function(
  BuildContext context,
  WalletListSettings walletListSettings,
  List<Wallet> wallets,
);

class CustomWidgetManager {
  CustomWidgetManager._();
  static CustomWidgetManager? _instance;
  static CustomWidgetManager get instance {
    _instance ??= CustomWidgetManager._();
    return _instance!;
  }

  QrPageBuilder? _qrPageBuilder;
  QrPageBuilder? get qrPageBuilder => _qrPageBuilder;

  LaunchWalletPageBuilder? _launchWalletPageBuilder;
  LaunchWalletPageBuilder? get launchWalletPageBuilder =>
      _launchWalletPageBuilder;

  WalletListPageBuilder? _walletListPageBuilder;
  WalletListPageBuilder? get walletListPageBuilder => _walletListPageBuilder;

  update({
    QrPageBuilder? qrPageBuilder,
    LaunchWalletPageBuilder? launchWalletPageBuilder,
    WalletListPageBuilder? walletListPageBuilder,
  }) {
    _qrPageBuilder = qrPageBuilder;
    _launchWalletPageBuilder = launchWalletPageBuilder;
    _walletListPageBuilder = walletListPageBuilder;
  }
}
