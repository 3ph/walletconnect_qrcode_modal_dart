<p align="center">
<img src="https://eidoohelp.zendesk.com/hc/article_attachments/360071262952/mceclip0.png">
</p>

[![pub.dev][pub-dev-shield]][pub-dev-url]
[![Effective Dart][effective-dart-shield]][effective-dart-url]
[![Stars][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

WalletConnect is an open source protocol for connecting decentralised applications to mobile wallets
with QR code scanning or deep linking. A user can interact securely with any Dapp from their mobile
phone, making WalletConnect wallets a safer choice compared to desktop or browser extension wallets.

## Introduction
This package provides UX for dApp to seamlessly connect to a wallet app. On iOS list of wallet apps is provided for user to select from, on Android there is one click connect. QR code option is also provided.

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

// Create QR code modal and connect to a wallet
await qrCodeModal.connect(context, chainId: 2);
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

Each builder needs to return a `Widget` to be used by the package. For the convenience `defaultWidget` is always provided in the builder to either be customised using its `copyWith` method or replaced completely with another widget.

For example if you want to change card color of the modal:
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
`jk``

You could also return your custom widget in the builder rather than the `defaultModalWidget` if the level of customization is not sufficient. All the necessary data to build your own widget are either passed in through the builder arguments or can be obtained from the `default...Widget`.

For example the main `modalBuilder` passes through the `uri` which is the WalletConnect URI and `walletCallback` which should be called when the `Wallet` is selected.

Various UI elements are accessible through different builders which allows you to mix and match which bits you want to customize or which to replace.

### Builders

- `modalBuilder` - main builder representing the whole modal, provides default `ModalWidget`

`ModalWidget` builders:
- `walletSegmentThumbBuilder` - represents the `Wallet/Desktop` segmented control thumb
- `qrSegmentThumbBuilder` - represents the `QR Code` segmented control thumb
- `walletButtonBuilder` - represents Android modal content (single button with 'Connect')
- `walletListBuilder` - represents iOS/Desktop modal content (list of wallets)
- `qrCodeBuilder` - represents QR Code content

`ModalWalletListWidget` builders:
- `rowBuilder` - represent a Wallet row in the Wallet list

### Properties

All the customizable properties can be found in API reference. List of customisable widgets:

`ModalWidget` - represents the whole modal
`ModalSegmentThumbWidget` - represents a segment in the main segmented control widget
`ModalWalletButtonWidget` - represents the single button widget (for Android)
`ModalWalletListWidget` - represents the list of wallets (for iOS and desktop)
`ModalQrCodeWidget` - represent the QR code widget

## Example
The aim of the example app is to demonstrate simple transaction using QR code modal. The connected wallet has to be configured for Ethereum (Ropsten) or Algorand test network with at least 0.001 tokens available (plus fee amount for the transaction). After connecting to the wallet the app would try to transfer 0.001 Eth/Algo from wallet account to the same account (you should see some fee being deducted as well).

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
