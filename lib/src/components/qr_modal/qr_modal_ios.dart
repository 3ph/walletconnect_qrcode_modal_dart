import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../store/store.dart';
import '../../utils/utils.dart';
import 'qr_modal.dart';
import '../segments/segments.dart';

class QrModalIOS extends StatelessWidget {
  const QrModalIOS({
    required this.uri,
    required this.walletCallback,
    this.store = const WalletStore(),
    Key? key,
  }) : super(key: key);

  final String uri;
  final WalletCallback walletCallback;
  final WalletStore store;

  @override
  Widget build(BuildContext context) {
    return ModalBase(
      uri: uri,
      segments: [
        ListSegment(
          uri: uri,
          wallets: iOSWallets,
          onPressed: (wallet, uri) {
            walletCallback.call(wallet);
            Utils.iosLaunch(wallet: wallet, uri: uri);
          },
          title: "Mobile",
        ),
        QrCodeSegment(uri: uri),
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
