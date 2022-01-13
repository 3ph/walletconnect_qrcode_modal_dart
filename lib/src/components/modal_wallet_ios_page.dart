import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/wallet.dart';
import '../store/wallet_store.dart';

class ModalWalletIOSPage extends StatelessWidget {
  const ModalWalletIOSPage({
    required this.uri,
    this.store = const WalletStore(),
    Key? key,
  }) : super(key: key);

  final String uri;
  final WalletStore store;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: store.load(),
      builder: (context, AsyncSnapshot<List<Wallet>> walletData) {
        if (walletData.hasData) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Choose your preferred wallet',
                  style: TextStyle(
                    fontSize: 15,
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
                            if (await canLaunch(wallet.mobile.universal)) {
                              await launch(
                                _convertToWcLink(
                                    appLink: wallet.mobile.universal,
                                    wcUri: uri),
                                forceSafariVC: false,
                                universalLinksOnly: true,
                              );
                            } else if (await canLaunch(wallet.mobile.native)) {
                              await launch(
                                _convertToWcLink(
                                    appLink: wallet.mobile.native, wcUri: uri),
                              );
                            } else {
                              await launch(wallet.app.ios);
                            }
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

  String _convertToWcLink({
    required String appLink,
    required String wcUri,
  }) =>
      '$appLink/wc?uri=${Uri.encodeComponent(wcUri)}';
}
