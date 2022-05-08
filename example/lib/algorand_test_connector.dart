import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_qrcode_modal_dart/walletconnect_qrcode_modal_dart.dart';

import 'test_connector.dart';

class AlgorandTestConnector implements TestConnector {
  AlgorandTestConnector() {
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
    );

    _provider = AlgorandWalletConnectProvider(_connector.connector);
  }

  @override
  Future<SessionStatus?> connect(BuildContext context) async {
    return await _connector.connect(context, chainId: 4160);
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
    final sender = Address.fromAlgorandAddress(
        address: _connector.connector.session.accounts[0]);
    final recipient = Address.fromAlgorandAddress(address: recipientAddress);

    // Fetch the suggested transaction params
    final params = await _algorand.getSuggestedTransactionParams();

    // Build the transaction
    final transaction = await (PaymentTransactionBuilder()
          ..sender = sender
          ..noteText = 'Signed with WalletConnectQrCodeModal'
          ..amount = Algo.toMicroAlgos(amount / 1000000)
          ..receiver = recipient
          ..suggestedParams = params)
        .build();

    // Sign the transaction
    final txBytes = Encoder.encodeMessagePack(transaction.toMessagePack());
    final signedBytes = await _provider.signTransaction(
      txBytes,
      params: {
        'message': 'Optional description message',
      },
    );

    // Broadcast the transaction
    try {
      final txId = await _algorand.sendRawTransactions(
        signedBytes,
        waitForConfirmation: true,
      );
      return txId;
    } catch (e) {
      print('Error: $e');
    }

    // Kill the session
    _connector.killSession();

    return null;
  }

  @override
  Future<void> openWalletApp() async => await _connector.openWalletApp();

  @override
  Future<double> getBalance() async {
    final address = _connector.connector.session.accounts[0];
    // balance in microAlgos
    final balance = await _algorand.getBalance(address);
    return balance / 1000000;
  }

  @override
  bool validateAddress({required String address}) {
    try {
      Address.fromAlgorandAddress(address: address);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  String get faucetUrl => 'https://bank.testnet.algorand.network/';

  @override
  String get address => _connector.connector.session.accounts[0];

  @override
  String get coinName => 'Algo';

  late final WalletConnectQrCodeModal _connector;
  late final AlgorandWalletConnectProvider _provider;
  late final _algorand = Algorand(
    algodClient: AlgodClient(apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL),
  );
}
