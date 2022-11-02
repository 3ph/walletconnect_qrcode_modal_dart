import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/utils.dart';
import 'segments.dart';

class QrCodeSegment extends Segment {
  const QrCodeSegment({
    required this.uri,
    Key? key,
  }) : super(key: key);

  final String uri;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = context.scaffoldMessenger();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Text(
            'Scan QR code with a WalletConnect-compatible wallet',
            textAlign: TextAlign.center,
            style: context.textTheme().titleMedium?.copyWith(
                  color: context.theme().onBackground,
                ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: QrImage(
                data: uri,
                foregroundColor: context.theme().onBackground,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: context.theme().primaryButton(),
            label: Text(
              "Copy",
              style: context.textTheme().bodyMedium?.copyWith(
                    color: context.theme().onBackground,
                  ),
            ),
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(
                  text: uri,
                ),
              );
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text(
                    "Copied to Clipboard!",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  String title() => "QR Code";
}
