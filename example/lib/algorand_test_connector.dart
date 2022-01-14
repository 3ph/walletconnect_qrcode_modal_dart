import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_qrcode_modal_dart/walletconnect_qrcode_modal_dart.dart';

class AlgorandTestConnector {
  AlgorandTestConnector() {
    _connector = WalletConnectQrCodeModal(
      connector: WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        clientMeta: const PeerMeta(
          name: 'QRCodeModalExampleApp',
          description: 'WalletConnect Developer App',
          url: 'https://walletconnect.org',
          icons: [
            'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ],
        ),
      ),
    );

    _connector.setDefaultProvider(AlgorandWCProvider(_connector.connector));
  }

  Future<SessionStatus?> connect(BuildContext context) async {
    return await _connector.connect(context, chainId: 4160);
  }

  Future<String> sendTestingAlgo(SessionStatus session) async {
    final sender = Address.fromAlgorandAddress(address: session.accounts[0]);

    // Fetch the suggested transaction params
    final params = await _algorand.getSuggestedTransactionParams();

    // Build the transaction
    final transaction = await (PaymentTransactionBuilder()
          ..sender = sender
          ..noteText = 'Signed with WalletConnectQrCodeModal'
          ..amount = Algo.toMicroAlgos(0.0001)
          ..receiver = sender
          ..suggestedParams = params)
        .build();

    // Sign the transaction
    final txBytes = Encoder.encodeMessagePack(transaction.toMessagePack());
    final signedBytes = await _connector.signTransaction(
      txBytes,
      params: {
        'message': 'Optional description message',
      },
    );

    // Broadcast the transaction
    final txId = await _algorand.sendRawTransactions(
      signedBytes,
      waitForConfirmation: true,
    );

    // Kill the session
    // TODO: session is killed before transaction is finished
    // _connector.killSession();

    return txId;
  }

  late final WalletConnectQrCodeModal _connector;
  late final _algorand = Algorand(
    algodClient: AlgodClient(apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL),
  );
}
