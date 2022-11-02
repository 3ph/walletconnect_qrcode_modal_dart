import 'package:flutter/material.dart';
import '../../managers/managers.dart';

import '../../models/models.dart';
import '../../store/store.dart';
import '../../utils/utils.dart';
import '../segments/segments.dart';
import 'qr_modal.dart';

class QrModalIOS extends StatelessWidget {
  const QrModalIOS({
    this.store = const WalletStore(),
    Key? key,
  }) : super(key: key);

  final WalletStore store;

  @override
  Widget build(BuildContext context) {
    final walletManager = WalletManager.instance;

    return ModalBase(
      segments: [
        ListSegment(
          wallets: iOSWallets,
          onPressed: (wallet) {
            walletManager.update(wallet: wallet);
            Utils.iosLaunch(wallet: wallet, uri: walletManager.uri);
          },
          title: "Mobile",
        ),
        const QrCodeSegment(),
      ],
    );
  }

  Future<List<Wallet>> get iOSWallets {
    Future<bool> shouldShow(wallet) async =>
        await Utils.openableLink(wallet.mobile.universal) ||
        await Utils.openableLink(wallet.mobile.native) ||
        await Utils.openableLink(wallet.app.ios);

    return store.load().then(
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
