import 'package:flutter/material.dart';

import 'algorand_test_connector.dart';

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
  final AlgorandTestConnector connector = AlgorandTestConnector();

  TransactionState _state = TransactionState.disconnected;

  @override
  void initState() {
    connector.registerListeners(
        // connected
        (session) => print('Connected: $session'),
        // session updated
        (response) => print('Session updated: $response'),
        // disconnected
        () => print('Disconnected'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRCode Modal Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Text(
                'Click on the button below to transfer 0.0001 Algo from the Algorand account connected through WalletConnect to the same account.',
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
                await connector.sendTestingAlgo(session);
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
}
