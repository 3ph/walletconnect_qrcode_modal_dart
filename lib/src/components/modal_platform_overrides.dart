/// Wallet widget type for platform overrides
enum ModalWalletType {
  button,
  listMobile,
  listDesktop,
}

/// Overrides for default platform builders
class ModalWalletPlatformOverrides {
  const ModalWalletPlatformOverrides({
    this.ios,
    this.android,
    this.desktop,
  });
  final ModalWalletType? ios;
  final ModalWalletType? android;
  final ModalWalletType? desktop;
}
