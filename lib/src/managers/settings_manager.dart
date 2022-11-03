import 'package:flutter/material.dart';

import '../settings/settings.dart';

class SettingsManager {
  SettingsManager._();
  static SettingsManager? _instance;
  static SettingsManager get instance {
    _instance ??= SettingsManager._();
    return _instance!;
  }

  late final GlobalKey key;

  bool _isInitialised = false;
  bool get isInitialised => _isInitialised;

  void init(GlobalKey key) {
    if (_isInitialised) {
      return;
    }
    this.key = key;
    _isInitialised = true;
  }

  QrCodeSettings? _qrCodeSettings;
  QrCodeSettings get qrCodeSettings {
    if (!_isInitialised || key.currentContext == null) {
      throw "Not initialised";
    }
    _qrCodeSettings ??= QrCodeSettings.fromContext(key.currentContext!);
    return _qrCodeSettings!;
  }

  ModalSettings? _modalSettings;
  ModalSettings get modalSettings {
    if (!_isInitialised || key.currentContext == null) {
      throw "Not initialised";
    }
    _modalSettings ??= ModalSettings.fromContext(key.currentContext!);
    return _modalSettings!;
  }

  LaunchWalletSettings? _launchWalletSettings;
  LaunchWalletSettings get launchWalletSettings {
    if (!_isInitialised || key.currentContext == null) {
      throw "Not initialised";
    }
    _launchWalletSettings ??=
        LaunchWalletSettings.fromContext(key.currentContext!);
    return _launchWalletSettings!;
  }

  WalletListSettings? _walletListSettings;
  WalletListSettings get walletListSettings {
    if (!_isInitialised || key.currentContext == null) {
      throw "Not initialised";
    }
    _walletListSettings ??= WalletListSettings.fromContext(key.currentContext!);
    return _walletListSettings!;
  }

  void update({
    QrCodeSettings? qrCodeSettings,
    ModalSettings? modalSettings,
    LaunchWalletSettings? launchWalletSettings,
    WalletListSettings? walletListSettings,
  }) {
    _qrCodeSettings = qrCodeSettings;
    _modalSettings = modalSettings;
    _launchWalletSettings = launchWalletSettings;
    _walletListSettings = walletListSettings;
  }
}
