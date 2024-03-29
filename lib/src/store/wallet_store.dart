import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../models/wallet.dart';

class WalletStore {
  const WalletStore();

  Future<List<Wallet>> load() async {
    final walletFile = await DefaultCacheManager()
        .getSingleFile('https://registry.walletconnect.org/data/wallets.json');
    final walletData = json.decode(await walletFile.readAsString());

    final List<Wallet> wallets = walletData.entries
        .map<Wallet>((data) => Wallet.fromJson(data.value))
        .toList();

    wallets
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return wallets;
  }
}
