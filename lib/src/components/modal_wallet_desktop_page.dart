import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../modal_main_page.dart';
import '../models/wallet.dart';
import '../store/wallet_store.dart';
import '../utils/utils.dart';

class ModalWalletDesktopPage extends StatelessWidget {
  const ModalWalletDesktopPage({
    required this.uri,
    this.store = const WalletStore(),
    this.walletCallback,
    Key? key,
  }) : super(key: key);

  final String uri;
  final WalletStore store;
  final WalletCallback? walletCallback;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: desktopWallets(),
      builder: (context, AsyncSnapshot<List<Wallet>> walletData) {
        if (walletData.hasData) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  'Choose your preferred wallet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: walletData.data!.length,
                    itemBuilder: (context, index) {
                      final wallet = walletData.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: () async {
                            walletCallback?.call(wallet);
                            Utils.desktopLaunch(wallet: wallet, uri: uri);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                    wallet.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://registry.walletconnect.org/logo/sm/${wallet.id}.jpeg',
                                  height: 30,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
        }
      },
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
