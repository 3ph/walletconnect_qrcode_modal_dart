import 'package:flutter/material.dart';
import 'package:qrcode_modal_example/test_connector.dart';

import 'algorand_test_connector.dart';
import 'ethereum_test_connector.dart';

void main() {
  runApp(const MyApp());
}

enum TransactionState {
  disconnected,
  connecting,
  connected,
  connectionFailed,
  transferring,
  success,
  failed,
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  TestConnector connector = EthereumTestConnector();

  static const _networks = ['Ethereum', 'Algorand'];
  static const _coins = ['Eth', 'Algo'];

  TransactionState _state = TransactionState.disconnected;
  String? _networkName = _networks.first;
  String? _coinName = _coins.first;

  @override
  void initState() {
    connector.registerListeners(
        // connected
        (session) => print('Connected: $session'),
        // session updated
        (response) => print('Session updated: $response'),
        // disconnected
        () {
      setState(() => _state = TransactionState.disconnected);
      print('Disconnected');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRCode Modal Example'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Select network: '),
              ),
              Expanded(
                child: DropdownButton(
                  value: _networkName,
                  items: _networks
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  onChanged: _changeNetwork,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Text(
                    'Click on the button below to transfer 0.0001 $_coinName from the $_networkName account connected through WalletConnect to the same account.',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: _transactionStateToAction(context, state: _state),
                  child: Text(
                    _transactionStateToString(state: _state),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _transactionStateToString({required TransactionState state}) {
    switch (state) {
      case TransactionState.disconnected:
        return 'Connect!';
      case TransactionState.connecting:
        return 'Connecting';
      case TransactionState.connected:
        return 'Session connected, preparing transaction...';
      case TransactionState.connectionFailed:
        return 'Connection failed';
      case TransactionState.transferring:
        return 'Transaction in progress...';
      case TransactionState.success:
        return 'Transaction successful';
      case TransactionState.failed:
        return 'Transaction failed';
    }
  }

  VoidCallback? _transactionStateToAction(BuildContext context,
      {required TransactionState state}) {
    switch (state) {
      // Progress, action disabled
      case TransactionState.connecting:
      case TransactionState.transferring:
      case TransactionState.connected:
        return null;

      // Initiate the connection
      case TransactionState.disconnected:
      case TransactionState.connectionFailed:
        return () async {
          setState(() => _state = TransactionState.connecting);
          final session = await connector.connect(context);
          if (session != null) {
            setState(() => _state = TransactionState.connected);
            Future.delayed(const Duration(seconds: 1), () async {
              // Initiate the transaction
              setState(() => _state = TransactionState.transferring);

              try {
                await connector.sendTestingAmount(session);
                setState(() => _state = TransactionState.success);
              } catch (e) {
                print('Transaction error: $e');
                setState(() => _state = TransactionState.failed);
              }
            });
          } else {
            setState(() => _state = TransactionState.connectionFailed);
          }
        };

      // Finished
      case TransactionState.success:
      case TransactionState.failed:
        return null;
    }
  }

  void _changeNetwork(String? network) {
    if (network == null || _networkName == network) return;

    final index = _networks.indexOf(network);
    // update connector
    switch (index) {
      case 0:
        connector = EthereumTestConnector();
        break;
      case 1:
        connector = AlgorandTestConnector();
        break;
    }

    setState(
      () {
        _networkName = network;
        _coinName = _coins[index];
        _state = TransactionState.disconnected;
      },
    );
  }
}
