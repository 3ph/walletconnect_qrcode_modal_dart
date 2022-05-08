import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'test_connector.dart';

enum TransactionState {
  idle,
  sending,
  successful,
  failed,
}

class WalletPage extends StatefulWidget {
  const WalletPage({
    required this.connector,
    Key? key,
  }) : super(key: key);

  final TestConnector connector;

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late Future<double> balanceFuture = widget.connector.getBalance();
  final addressController = TextEditingController();
  final amountController = TextEditingController();
  bool validateAddress = true;
  bool validateAmount = true;
  TransactionState state = TransactionState.idle;

  @override
  void dispose() {
    addressController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () => copyAddressToClipboard());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Address',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Text(widget.connector.address),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Balance',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                FutureBuilder<double>(
                  future: balanceFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final balance = snapshot.data;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${balance!.toStringAsFixed(5)} ${widget.connector.coinName}'),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => setState(() {
                                  balanceFuture = widget.connector.getBalance();
                                }),
                                child: const Text('Refresh'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: ElevatedButton(
                                  onPressed: () {
                                    copyAddressToClipboard();
                                    Future.delayed(
                                      const Duration(seconds: 1),
                                      () => launchUrl(
                                        Uri.parse(
                                          widget.connector.faucetUrl,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Faucet'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: addressController,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      labelText: 'Recipient address',
                      errorText: validateAddress ? null : 'Invalid address',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      errorText: validateAmount
                          ? null
                          : 'Please enter amount in ${widget.connector.coinName}',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (amountController.text.isNotEmpty) {
                        setState(() => validateAmount = true);
                        if (widget.connector
                            .validateAddress(address: addressController.text)) {
                          setState(() => validateAddress = true);

                          // action
                          await transactionAction();
                        } else {
                          setState(() => validateAddress = false);
                        }
                      } else {
                        setState(() => validateAmount = false);
                      }
                    },
                    child: Text(transactionString()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String transactionString() {
    switch (state) {
      case TransactionState.idle:
        return 'Send transaction';
      case TransactionState.sending:
        return 'Sending transaction. Please go back to the Wallet to confirm.';
      case TransactionState.successful:
        return 'Transaction successful';
      case TransactionState.failed:
        return 'Transaction failed';
    }
  }

  Future<void> transactionAction() async {
    switch (state) {
      case TransactionState.idle:
        // Send transaction
        setState(() => state = TransactionState.sending);

        Future.delayed(Duration.zero, () => widget.connector.openWalletApp());

        final hash = await widget.connector.sendTestingAmount(
            recipientAddress: addressController.text,
            amount: double.parse(amountController.text));

        if (hash != null) {
          setState(() => state = TransactionState.successful);
        } else {
          setState(() => state = TransactionState.failed);
        }
        break;
      case TransactionState.sending:
      case TransactionState.successful:
      case TransactionState.failed:
        // Do nothing
        break;
    }
  }

  void copyAddressToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.connector.address));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('Address copied!'),
      ),
    );
  }
}
