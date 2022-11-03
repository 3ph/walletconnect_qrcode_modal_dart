import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../managers/managers.dart';
import '../../models/models.dart';
import '../../store/store.dart';
import '../../utils/utils.dart';
import '../segments/segments.dart';
import 'qr_modal.dart';

class QrModalDesktop extends HookWidget {
  const QrModalDesktop({
    this.store = const WalletStore(),
    Key? key,
  }) : super(key: key);

  final WalletStore store;

  @override
  Widget build(BuildContext context) {
    final walletManager = WalletManager.instance;
    final wallets = useFuture(desktopWallets());

    return ModalBase(
      segments: [
        const QrCodeSegment(),
        ListSegment(
          wallets: wallets.data ?? [],
          onPressed: (wallet) {
            walletManager.update(wallet: wallet);
            Utils.desktopLaunch(wallet: wallet, uri: walletManager.uri);
          },
          title: "Desktop",
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
