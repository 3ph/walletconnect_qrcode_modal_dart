import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qrcode_modal_example/test_connector.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_qrcode_modal_dart/walletconnect_qrcode_modal_dart.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class WalletConnectEthereumCredentials extends CustomTransactionSender {
  WalletConnectEthereumCredentials({required this.provider});

  final EthereumWalletConnectProvider provider;

  @override
  Future<EthereumAddress> extractAddress() {
    // TODO: implement extractAddress
    throw UnimplementedError();
  }

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    final hash = await provider.sendTransaction(
      from: transaction.from!.hex,
      to: transaction.to?.hex,
      data: transaction.data,
      gas: transaction.maxGas,
      gasPrice: transaction.gasPrice?.getInWei,
      value: transaction.value?.getInWei,
      nonce: transaction.nonce,
    );

    return hash;
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToSignature
    throw UnimplementedError();
  }

  @override
  // TODO: implement address
  EthereumAddress get address => throw UnimplementedError();

  @override
  MsgSignature signToEcSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToEcSignature
    throw UnimplementedError();
  }
}

class EthereumTestConnector implements TestConnector {
  EthereumTestConnector() {
    _connector = WalletConnectQrCodeModal(
      connector: WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        clientMeta: const PeerMeta(
          // <-- Meta data of your app appearing in the wallet when connecting
          name: 'QRCodeModalExampleApp',
          description: 'WalletConnect Developer App',
          url: 'https://walletconnect.org',
          icons: [
            'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ],
        ),
      ),

      // UNCOMMENT below to make customizations, a few example customizations listed
      // modalBuilder: (context, uri, callback, defaultModalWidget) {
      //   return defaultModalWidget.copyWith(
      //     cardColor: Colors.pink,
      //     selectorBuilder: (context, defaultSelectorWidget) =>
      //         defaultSelectorWidget.copyWith(
      //       backgroundColor: Colors.yellow,
      //       padding: const EdgeInsets.all(16),
      //       qrSegmentThumbBuilder: (context, defaultModalSegmentThumbWidget) {
      //         return defaultModalSegmentThumbWidget.copyWith(
      //             textAlign: TextAlign.right);
      //       },
      //     ),
      //     walletButtonBuilder: (context, defaultWalletButtonWidget) =>
      //         defaultWalletButtonWidget.copyWith(
      //       buttonStyle: ElevatedButton.styleFrom(
      //         backgroundColor: Colors.pink,
      //       ),
      //     ),
      //     walletListBuilder: (context, defaultWalletListWidget) =>
      //         defaultWalletListWidget.copyWith(
      //       titleTextAlign: TextAlign.end,
      //       rowBuilder: (context, wallet, imageUrl, defaultListRowWidget) =>
      //           defaultListRowWidget.copyWith(imageHeight: 50),
      //     ),
      //     qrCodeBuilder: (context, defaultQrCodeWidget) =>
      //         defaultQrCodeWidget.copyWith(
      //       copyButtonStyle: TextButton.styleFrom(
      //         backgroundColor: Colors.orange,
      //       ),
      //     ),
      //   );
      // },
    );

    _provider = EthereumWalletConnectProvider(_connector.connector);
  }

  @override
  Future<SessionStatus?> connect(BuildContext context) async {
    return await _connector.connect(context, chainId: 3);
  }

  @override
  void registerListeners(
    OnConnectRequest? onConnect,
    OnSessionUpdate? onSessionUpdate,
    OnDisconnect? onDisconnect,
  ) =>
      _connector.registerListeners(
        onConnect: onConnect,
        onSessionUpdate: onSessionUpdate,
        onDisconnect: onDisconnect,
      );

  @override
  Future<String?> sendTestingAmount({
    required String recipientAddress,
    required double amount,
  }) async {
    final sender =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);
    final recipient = EthereumAddress.fromHex(address);

    final etherAmount =
        EtherAmount.fromInt(EtherUnit.szabo, (amount * 1000 * 1000).toInt());

    final transaction = Transaction(
      to: recipient,
      from: sender,
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 100000,
      value: etherAmount,
    );

    final credentials = WalletConnectEthereumCredentials(provider: _provider);

    // Sign the transaction
    try {
      final txBytes = await _ethereum.sendTransaction(credentials, transaction);
      return txBytes;
    } catch (e) {
      debugPrint('Error: $e');
    }

    // Kill the session
    // _connector.killSession();

    return null;
  }

  @override
  Future<void> openWalletApp() async => await _connector.openWalletApp();

  @override
  Future<double> getBalance() async {
    final address =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);
    final amount = await _ethereum.getBalance(address);
    return amount.getValueInUnit(EtherUnit.ether).toDouble();
  }

  @override
  bool validateAddress({required String address}) {
    try {
      EthereumAddress.fromHex(address);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  String get faucetUrl => 'https://faucet.dimensions.network/';

  @override
  String get address => _connector.connector.session.accounts[0];

  @override
  String get coinName => 'Eth';

  late final WalletConnectQrCodeModal _connector;
  late final EthereumWalletConnectProvider _provider;
  final _ethereum = Web3Client(
    'https://goerli.infura.io/v3/0db053799f0e48e99357b6dce022b1e7',
    Client(),
  );
}
