import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_qrcode_modal_dart/walletconnect_qrcode_modal_dart.dart';

import '../models/wallet.dart';
import '../utils/utils.dart';
import 'modal_qrcode_page.dart';
import 'modal_wallet_android_page.dart';
import 'modal_wallet_desktop_page.dart';
import 'modal_wallet_ios_page.dart';

WalletConnectStyle style = WalletConnectStyle();
typedef WalletCallback = Function(Wallet);

class ListSegment extends StatelessWidget {
  const ListSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Segment(
      text: Utils.isDesktop ? 'Desktop' : 'Mobile',
    );
  }
}

class ModalMainPage extends StatefulWidget {
  final String uri;

  final WalletCallback? walletCallback;
  const ModalMainPage({
    required this.uri,
    this.walletCallback,
    Key? key,
  }) : super(key: key);

  @override
  State<ModalMainPage> createState() => _ModalMainPageState();
}

class QrSegment extends StatelessWidget {
  const QrSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _Segment(
      text: 'QR Code',
    );
  }
}

class _ModalContent extends StatelessWidget {
  final int groupValue;

  final String uri;
  final WalletCallback? walletCallback;
  const _ModalContent({
    required this.groupValue,
    required this.uri,
    this.walletCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (groupValue == (Utils.isDesktop ? 1 : 0)) {
      if (Utils.isIOS) {
        return ModalWalletIOSPage(uri: uri, walletCallback: walletCallback);
      } else if (Utils.isAndroid) {
        return ModalWalletAndroidPage(uri: uri);
      } else {
        return ModalWalletDesktopPage(uri: uri, walletCallback: walletCallback);
      }
    }
    return ModalQrCodePage(uri: uri);
  }
}

class _ModalMainPageState extends State<ModalMainPage> {
  int? _groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: max(500, MediaQuery.of(context).size.height * 0.5),
        child: Card(
          color: style.backgroundColor ?? Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  CupertinoSlidingSegmentedControl<int>(
                    groupValue: _groupValue,
                    onValueChanged: (value) => setState(() {
                      _groupValue = value;
                    }),
                    thumbColor: style.tabThumbColor ?? Colors.white,
                    backgroundColor:
                        style.tabBackgroundColor ?? Colors.grey.shade300,
                    padding: const EdgeInsets.all(4),
                    children: {
                      0: Utils.isDesktop
                          ? const QrSegment()
                          : const ListSegment(),
                      1: Utils.isDesktop
                          ? const ListSegment()
                          : const QrSegment(),
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

class _Segment extends StatelessWidget {
  final String text;

  const _Segment({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        width: 100,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                height: 1,
                color: style.textColor ?? Colors.black,
              ),
        ),
      ),
    );
  }
}
