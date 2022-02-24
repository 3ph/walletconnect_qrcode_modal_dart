import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'modal_qrcode_page.dart';
import 'modal_wallet_ios_page.dart';
import 'modal_wallet_android_page.dart';

import '../models/wallet.dart';

class ModalMainPage extends StatefulWidget {
  const ModalMainPage({
    required this.uri,
    this.walletCallback,
    Key? key,
  }) : super(key: key);

  final String uri;
  final WalletCallback? walletCallback;

  @override
  State<ModalMainPage> createState() => _ModalMainPageState();
}

typedef WalletCallback = Function(Wallet);

class _ModalMainPageState extends State<ModalMainPage> {
  int? _groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: max(500, MediaQuery.of(context).size.height * 0.5),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  CupertinoSlidingSegmentedControl<int>(
                    groupValue: _groupValue,
                    onValueChanged: (value) => _groupValue = value,
                    backgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.all(4),
                    children: {
                      0: _Segment(
                        text: 'Mobile',
                        onTap: () => setState(
                          () => _groupValue = 0,
                        ),
                      ),
                      1: _Segment(
                        text: 'QR Code',
                        onTap: () => setState(
                          () => _groupValue = 1,
                        ),
                      ),
                    },
                  ),
                  Expanded(
                    child: _ModalContent(
                      groupValue: _groupValue!,
                      walletCallback: widget.walletCallback,
                      uri: widget.uri,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModalContent extends StatelessWidget {
  const _ModalContent({
    required this.groupValue,
    required this.uri,
    this.walletCallback,
    Key? key,
  }) : super(key: key);

  final int groupValue;
  final String uri;
  final WalletCallback? walletCallback;

  @override
  Widget build(BuildContext context) {
    if (groupValue == 0) {
      if (Platform.isIOS) {
        return ModalWalletIOSPage(uri: uri, walletCallback: walletCallback);
      } else {
        return ModalWalletAndroidPage(uri: uri);
      }
    }
    return ModalQrCodePage(uri: uri);
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.text,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
