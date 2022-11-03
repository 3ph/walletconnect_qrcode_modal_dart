import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ModalQrCodeWidget extends StatefulWidget {
  const ModalQrCodeWidget({
    required this.uri,
    this.title = 'Scan QR code with a WalletConnect-compatible wallet',
    this.copyText = 'Copy to clipboard',
    this.copiedText = 'Copied',
    this.titleTextStyle,
    this.titleTextAlign,
    this.qrCodeWidget,
    this.qrCodePadding,
    this.padding,
    this.copyButton,
    this.copyButtonStyle,
    this.copyButtonTextStyle,
    this.copyButtonTextAlign,
    Key? key,
  }) : super(key: key);

  final String uri;

  /// Padding around the content
  final EdgeInsets? padding;

  // Title customizations
  final String title;
  final TextStyle? titleTextStyle;
  final TextAlign? titleTextAlign;

  // QR code customizations
  final Widget? qrCodeWidget;
  final EdgeInsets? qrCodePadding;

  // Copy customizations
  final Widget? copyButton;
  final ButtonStyle? copyButtonStyle;
  final String copyText;
  final String copiedText;
  final TextStyle? copyButtonTextStyle;
  final TextAlign? copyButtonTextAlign;

  @override
  State<ModalQrCodeWidget> createState() => _ModalQrCodeWidget();

  ModalQrCodeWidget copyWith({
    EdgeInsets? padding,
    TextStyle? titleTextStyle,
    TextAlign? titleTextAlign,
    Widget? qrCodeWidget,
    EdgeInsets? qrCodePadding,
    Widget? copyButton,
    ButtonStyle? copyButtonStyle,
    TextStyle? copyButtonTextStyle,
    TextAlign? copyButtonTextAlign,
  }) =>
      ModalQrCodeWidget(
        uri: uri,
        title: title,
        copyText: copyText,
        copiedText: copiedText,
        padding: padding ?? this.padding,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        titleTextAlign: titleTextAlign ?? this.titleTextAlign,
        qrCodeWidget: qrCodeWidget ?? this.qrCodeWidget,
        qrCodePadding: qrCodePadding ?? this.qrCodePadding,
        copyButton: copyButton ?? this.copyButton,
        copyButtonStyle: copyButtonStyle ?? this.copyButtonStyle,
        copyButtonTextStyle: copyButtonTextStyle ?? this.copyButtonTextStyle,
        copyButtonTextAlign: copyButtonTextAlign ?? this.copyButtonTextAlign,
      );
}

class _ModalQrCodeWidget extends State<ModalQrCodeWidget> {
  bool _copiedToClipboard = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Text(
            widget.title,
            textAlign: widget.titleTextAlign ?? TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          Expanded(
            child: Padding(
              padding: widget.qrCodePadding ?? const EdgeInsets.only(top: 8),
              child: widget.qrCodeWidget ?? QrImage(data: widget.uri),
            ),
          ),
          TextButton(
            style: widget.copyButtonStyle,
            onPressed: _copiedToClipboard
                ? null
                : () async {
                    await Clipboard.setData(ClipboardData(text: widget.uri));
                    setState(() => _copiedToClipboard = true);
                    await Future.delayed(const Duration(seconds: 1),
                        () => setState(() => _copiedToClipboard = false));
                  },
            child: Text(
              _copiedToClipboard ? widget.copiedText : widget.copyText,
              style: widget.copyButtonTextStyle ??
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
              textAlign: widget.copyButtonTextAlign,
            ),
          ),
        ],
      ),
    );
  }
}
