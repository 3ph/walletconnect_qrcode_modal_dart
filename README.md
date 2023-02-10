<div align="center">
<img src="https://github.com/Orange-Wallet/orangewallet-utils/raw/master/assets/images/walletconnect.png" alt="Wallet Connect Logo" width="70"/>
<h1>Wallet Connect</h1>
</div>

[![pub.dev][pub-dev-shield]][pub-dev-url]
[![Effective Dart][effective-dart-shield]][effective-dart-url]
[![Stars][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

WalletConnect is an open-source protocol for connecting decentralised applications to mobile wallets
with QR code scanning or deep linking. A user can interact securely with any Dapp from their mobile
phone, making WalletConnect wallets a safer choice compared to desktop or browser extension wallets.

## Introduction
This package provides UX for dApp to seamlessly connect to a wallet app. On iOS list of wallet apps is provided for the user to select from, on Android there is one click connect. QR code option is also provided.

The package uses [walletconnect-dart] package for underlying WalletConnect communication.

## Usage

<p>
<img src="https://github.com/nextchapterstudio/walletconnect_qrcode_modal_dart/raw/main/ios.gif">
</p>

Once installed, you can simply connect your application to a wallet.

**Initiate connection - show QR code modal**

```dart
// Create a connector
final qrCodeModal = WalletConnectQrCodeModal(
   connector: WalletConnect(
     bridge: 'https://bridge.walletconnect.org',
     clientMeta: const PeerMeta( // <-- Meta data of your app appearing in the wallet when connecting
       name: 'QRCodeModalExampleApp',
       description: 'WalletConnect Developer App',
       url: 'https://walletconnect.org',
       icons: [
         'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
       ],
     ),
   ),
 );
```

```dart
// Subscribe to events
qrCodeModal.registerListeners(
  onConnect: (session) => print('Connected: $session'),
  onSessionUpdate: (response) => print('Session updated: $response'),
  onDisconnect: () => print('Disconnected'),
);

// Create QR code modal and connect to a wallet, connector returns WalletConnect
// session which can be saved and restored.
final session = await qrCodeModal.connect(context, chainId: 2)
    // Errors can also be caught from connector, eg. session cancelled
    .catchError((error) {
        // Handle error here
        debugPrint(error);
        return null;
    });
```

**Send transaction**

Example of Ethereum transaction:

```dart
final provider = EthereumWalletConnectProvider(connector);
final ethereum = Web3Client('https://ropsten.infura.io/', Client());
final sender = EthereumAddress.fromHex(session.accounts[0]);

final transaction = Transaction(
  to: sender,
  from: sender,
  gasPrice: EtherAmount.inWei(BigInt.one),
  maxGas: 100000,
  value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 1),
);

final credentials = WalletConnectEthereumCredentials(provider: provider);

// Send the transaction
final txBytes = await ethereum.sendTransaction(credentials, transaction);
```

**Kill session**

```dart
await qrCodeModal.killSession();
```

## Customizations
The library UI is completely customizable through its `modalBuilder` builder. It lets you either customize existing UI elements or replace them with your own.

Each builder needs to return a `Widget` to be used by the package. For convenience `defaultWidget` is always provided in the builder to either be customised using its `copyWith` method or replaced completely with another widget.

For example, if you want to change the card color of the modal:
```dart
WalletConnectQrCodeModal(
  connector: WalletConnect(
    ...
  ),
  modalBuilder: (context, uri, callback, defaultModalWidget) {
    return defaultModalWidget.copyWith(
      cardColor: Colors.pink,
    );
  });
```

You could also return your custom widget in the builder rather than the `defaultModalWidget` if the level of customization is not sufficient. All the necessary data to build your own widget are either passed in through the builder arguments or can be obtained from the `default...Widget`.

For example, the main `modalBuilder` passes through the `uri` which is the WalletConnect URI and `walletCallback` which should be called when the `Wallet` is selected.

Various UI elements are accessible through different builders which allows you to mix and match which bits you want to customize or which to replace.

### Builders

- `modalBuilder` - the main builder representing the whole modal, provides default `ModalWidget`

`ModalWidget` builders:
- `selectorBuilder` - represents the Wallet list or QR code selector
- `walletButtonBuilder` - represents Android modal content (single button with 'Connect')
- `walletListBuilder` - represents iOS/Desktop modal content (list of wallets)
- `qrCodeBuilder` - represents QR Code content

`ModalSelectorWidget` builder:
- `walletSegmentThumbBuilder` - represents the Wallet/Desktop segmented control thumb
- `qrSegmentThumbBuilder` - represents the QR Code segmented control thumb

`ModalWalletListWidget` builders:
- `rowBuilder` - represents a Wallet row in the Wallet list

### Properties

List of customisable widgets:

- `ModalWidget` - represents the whole modal
- `ModalSelectorWidget` - represents the segmented control widget for choosing between list and QR code
- `ModalSegmentThumbWidget` - represents a segment in the main segmented control widget
- `ModalWalletButtonWidget` - represents the single button widget (for Android)
- `ModalWalletListWidget` - represents the list of wallets (for iOS and desktop)
- `ModalQrCodeWidget` - represents the QR code widget

### Platform overrides

It is possible override the default behavior on certain platform to customize the platform experience. For example you can override for Android to show the wallet list rather than a single button. It is recommended to stick with platform defaults.

Example:

```dart
modalBuilder: (context, uri, callback, defaultModalWidget) {
  return defaultModalWidget.copyWith(
    platformOverrides: const ModalWalletPlatformOverrides(
      android: ModalWalletType.listMobile,
    ),
  );
}
```

This would force the library to use `walletListBuilder` on the Android platform. There are 3 types of types available:
- `button` - shows single button (default for Android), `walletButtonBuilder` is used
- `listMobile` - shows list of possible wallets which can be linked on the mobile platform (default for iOS), `walletListBuilder` is used
- `listDesktop` - shows list of possible wallets which can be linked on the desktop platform (default for desktop), `walletListBuilder` is used

Platform can be overriden to use any of the above types, the default functionality is not guaranteed (due to restriction on some platforms) but it allows more customization on each platform.

## Example
The aim of the example app is to demonstrate simple transaction using QR code modal. The connected wallet has to be configured for Ethereum (Ropsten) or Algorand test network with at least 0.001 tokens available (plus fee amount for the transaction). After connecting to the wallet the app would try to transfer 0.001 Eth/Algo from the wallet account to the same account (you should see some fee being deducted as well).

## Migration guide

### 0.1.x to 0.2.x
`selectorBuilder` was added to add more flexibility to customize the whole selector segmented control. `ModalSelectorWidget` now represents this widget.
- `walletSegmentThumbBuilder` and `qrSegmentThumbBuilder` was moved into the new `ModalSelectorWidget`
- `segmentedControlBackgroundColor` was renamed to `backgroundColor` and moved to `ModalSelectorWidget`
- `segmentedControlPadding` was renamed to `padding` and moved to `ModalSelectorWidget`
- `cardShape` was added to `ModalWidget` to represent card shape parameter

## Changelog

Please see [CHANGELOG](CHANGELOG.md) for more information on what has changed recently.

## Credits

- [Tom Friml](https://github.com/3ph)
- [elliotsayes](https://github.com/elliotsayes)
- [All Contributors](../../contributors)

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[pub-dev-shield]: https://img.shields.io/pub/v/walletconnect_qrcode_modal_dart?style=for-the-badge
[pub-dev-url]: https://pub.dev/packages/walletconnect_qrcode_modal_dart
[effective-dart-shield]: https://img.shields.io/badge/style-effective_dart-40c4ff.svg?style=for-the-badge
[effective-dart-url]: https://github.com/tenhobi/effective_dart
[stars-shield]: https://img.shields.io/github/stars/nextchapterstudio/walletconnect_qrcode_modal_dart.svg?style=for-the-badge&logo=github&colorB=deeppink&label=stars
[stars-url]: https://packagist.org/packages/nextchapterstudio/walletconnect_qrcode_modal_dart
[issues-shield]: https://img.shields.io/github/issues/nextchapterstudio/walletconnect_qrcode_modal_dart.svg?style=for-the-badge
[issues-url]: https://github.com/nextchapterstudio/walletconnect_qrcode_modal_dart/issues
[license-shield]: https://img.shields.io/github/license/nextchapterstudio/walletconnect_qrcode_modal_dart.svg?style=for-the-badge
[license-url]: https://github.com/nextchapterstudio/walletconnect_qrcode_modal_dart/blob/master/LICENSE
[walletconnect-dart]: https://pub.dev/packages/walletconnect_qrcode_modal_dart
