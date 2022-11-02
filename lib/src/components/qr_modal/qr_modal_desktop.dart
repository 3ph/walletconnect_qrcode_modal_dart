import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../store/store.dart';
import '../../utils/utils.dart';
import 'qr_modal.dart';
import '../segments/segments.dart';

class QrModalDesktop extends StatelessWidget {
  const QrModalDesktop({
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
        QrCodeSegment(uri: uri),
        ListSegment(
          uri: uri,
          wallets: desktopWallets(),
          onPressed: (wallet, uri) {
            walletCallback.call(wallet);
            Utils.desktopLaunch(wallet: wallet, uri: uri);
          },
        ),
      ],
    );
  }

  Future<List<Wallet>> desktopWallets() {
    return store.load().then(
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
