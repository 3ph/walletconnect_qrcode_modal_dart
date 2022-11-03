import 'package:flutter/material.dart';

import '../settings/settings.dart';

class SettingsManager {
  SettingsManager._();
  static SettingsManager? _instance;
  static SettingsManager get instance {
    _instance ??= SettingsManager._();
    return _instance!;
  }

  late final BuildContext context;

  bool _isInitialised = false;
  bool get isInitialised => _isInitialised;

  void init(BuildContext context) {
    if (_isInitialised) {
      return;
    }
    this.context = context;
    _isInitialised = true;
  }

  QrCodeSettings? _qrCodeSettings;
  QrCodeSettings get qrCodeSettings {
    if (!_isInitialised) {
      throw "Not initialised";
    }
    _qrCodeSettings ??= QrCodeSettings.fromContext(context);
    return _qrCodeSettings!;
  }

  ModalSettings? _modalSettings;
  ModalSettings get modalSettings {
    if (!_isInitialised) {
      throw "Not initialised";
    }
    _modalSettings ??= ModalSettings.fromContext(context);
    return _modalSettings!;
  }

  LaunchWalletSettings? _launchWalletSettings;
  LaunchWalletSettings get launchWalletSettings {
    if (!_isInitialised) {
      throw "Not initialised";
    }
    _launchWalletSettings ??= LaunchWalletSettings.fromContext(context);
    return _launchWalletSettings!;
  }

  WalletListSettings? _walletListSettings;
  WalletListSettings get walletListSettings {
    if (!_isInitialised) {
      throw "Not initialised";
    }
    _walletListSettings ??= WalletListSettings.fromContext(context);
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
