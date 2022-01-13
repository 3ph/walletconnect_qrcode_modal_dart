import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ModalQrCodePage extends StatefulWidget {
  const ModalQrCodePage({
    required this.uri,
    Key? key,
  }) : super(key: key);

  final String uri;

  @override
  State<ModalQrCodePage> createState() => _ModalQrCodePageState();
}

class _ModalQrCodePageState extends State<ModalQrCodePage> {
  bool _copiedToClipboard = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          const Text(
            'Scan QR code with a WalletConnect-compatible wallet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: QrImage(data: widget.uri),
            ),
          ),
          TextButton(
              child: Text(
                _copiedToClipboard ? 'Copied' : 'Copy to clipboard',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              onPressed: _copiedToClipboard
                  ? null
                  : () async {
                      await Clipboard.setData(ClipboardData(text: widget.uri));
                      setState(() => _copiedToClipboard = true);
                      await Future.delayed(const Duration(seconds: 1),
                          () => setState(() => _copiedToClipboard = false));
                    }),
        ],
      ),
    );
  }
}
