import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../managers/managers.dart';
import 'segments.dart';

class QrCodeSegment extends Segment {
  const QrCodeSegment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletManager = WalletManager.instance;
    final settings = SettingsManager.instance.qrCodeSettings;
    final isCopied = useState(false);
    final onPressed = isCopied.value
        ? null
        : () async {
            await Clipboard.setData(
              ClipboardData(
                text: walletManager.uri,
              ),
            );
            isCopied.value = true;
            await Future.delayed(
              const Duration(seconds: 2),
              () => isCopied.value = false,
            );
          };

    return CustomWidgetManager.instance.qrPageBuilder?.call(
          context,
          settings,
          onPressed,
          isCopied.value,
          walletManager.uri,
        ) ??
        Padding(
          padding: settings.padding,
          child: Column(
            children: [
              Text(
                settings.title,
                textAlign: settings.titleTextAlign,
                style: settings.titleTextStyle,
              ),
              Expanded(
                child: Padding(
                  padding: settings.qrCodePadding,
                  child: QrImage(
                    data: walletManager.uri,
                    foregroundColor: settings.qrCodeColor,
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: settings.copyButtonStyle,
                label: Text(
                  isCopied.value ? settings.copiedText : settings.copyText,
                ),
                icon: Icon(
                  isCopied.value ? settings.copiedIcon : settings.copyIcon,
                ),
                onPressed: onPressed,
              ),
            ],
          ),
        );
  }

  @override
  String title() => "QR Code";
}
