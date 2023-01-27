import 'package:flutter/material.dart';

import 'test_connector.dart';
import 'wallet.dart';
import 'algorand_test_connector.dart';
import 'ethereum_test_connector.dart';

void main() {
  runApp(const MyApp());
}

enum ConnectionState {
  disconnected,
  connecting,
  connected,
  connectionFailed,
  connectionCancelled,
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

  static const _networks = ['Ethereum (Ropsten)', 'Algorand (Testnet)'];

  ConnectionState _state = ConnectionState.disconnected;
  String? _networkName = _networks.first;

  @override
  void initState() {
    connector.registerListeners(
        // connected
        (session) => debugPrint('Connected: $session'),
        // session updated
        (response) => debugPrint('Session updated: $response'),
        // disconnected
        () {
      setState(() => _state = ConnectionState.disconnected);
      debugPrint('Disconnected');
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
                    bottom: 32,
                  ),
                  child: Text(
                    'Connect to the $_networkName account through WalletConnect.\n\nPlease note that the transaction will be sent to testnet network no matter what your Wallet is set to.',
                    style: Theme.of(context).textTheme.bodyLarge,
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

  String _transactionStateToString({required ConnectionState state}) {
    switch (state) {
      case ConnectionState.disconnected:
        return 'Connect!';
      case ConnectionState.connecting:
        return 'Connecting';
      case ConnectionState.connected:
        return 'Session connected';
      case ConnectionState.connectionFailed:
        return 'Connection failed';
      case ConnectionState.connectionCancelled:
        return 'Connection cancelled';
    }
  }

  void _openWalletPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletPage(connector: connector),
      ),
    );
  }

  VoidCallback? _transactionStateToAction(BuildContext context,
      {required ConnectionState state}) {
    debugPrint('State: ${_transactionStateToString(state: state)}');
    switch (state) {
      // Progress, action disabled
      case ConnectionState.connecting:
        return null;
      case ConnectionState.connected:
        // Open new page
        return () => _openWalletPage();

      // Initiate the connection
      case ConnectionState.disconnected:
      case ConnectionState.connectionCancelled:
      case ConnectionState.connectionFailed:
        return () async {
          setState(() => _state = ConnectionState.connecting);
          try {
            final session = await connector.connect(context);
            if (session != null) {
              setState(() => _state = ConnectionState.connected);
              Future.delayed(Duration.zero, () => _openWalletPage());
            } else {
              setState(() => _state = ConnectionState.connectionCancelled);
            }
          } catch (e) {
            debugPrint('WC exception occured: $e');
            setState(() => _state = ConnectionState.connectionFailed);
          }
        };
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
        _state = ConnectionState.disconnected;
      },
    );
  }
}
