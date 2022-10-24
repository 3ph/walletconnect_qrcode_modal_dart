import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:walletconnect_qrcode_modal_dart/walletconnect_qrcode_modal_dart.dart';

class ModalQrCodePage extends StatefulWidget {
  final String uri;

  const ModalQrCodePage({
    required this.uri,
    Key? key,
  }) : super(key: key);

  @override
  State<ModalQrCodePage> createState() => _ModalQrCodePageState();
}

class _ModalQrCodePageState extends State<ModalQrCodePage> {
  bool _copiedToClipboard = false;

  @override
  Widget build(BuildContext context) {
    WalletConnectStyle style = WalletConnectStyle();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Text(
            'Scan QR code with a WalletConnect-compatible wallet',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: style.secondaryTextColor ?? Colors.grey,
                ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: QrImage(
                data: widget.uri,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: style.qrCodeColor ?? Colors.black,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: style.qrCodeColor ?? Colors.black,
                ),
              ),
            ),
          ),
          TextButton(
              child: Text(
                _copiedToClipboard ? 'Copied' : 'Copy to clipboard',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: style.secondaryTextColor ?? Colors.grey,
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
