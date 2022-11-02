import 'package:url_launcher/url_launcher.dart';

import '../models/models.dart';
import '../utils/utils.dart';

class WalletManager {
  WalletManager._();
  static WalletManager? _instance;
  static WalletManager get instance {
    _instance ??= WalletManager._();
    return _instance!;
  }

  Wallet? _wallet;
  Wallet? get wallet => _wallet;

  String? _uri;
  String get uri => _uri ?? "";

  /// Try to open Wallet selected during session creation.
  /// For iOS will try to open previously selected Wallet
  /// For Android will open system dialog
  Future<void> openWalletApp() async {
    if (_uri == null) return;

    if (Utils.isIOS) {
      if (_wallet == null) return;

      await Utils.iosLaunch(wallet: _wallet!, uri: _uri!);
    } else {
      await launchUrl(Uri.parse(_uri!));
    }
  }

  void update({Wallet? wallet, String? uri}) {
    if (wallet != null) _wallet = wallet;
    if (uri != null) _uri = uri;
  }

  void clear() {
    _wallet = null;
    _uri = null;
  }
}
