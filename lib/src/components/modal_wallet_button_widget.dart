import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ModalWalletButtonWidget extends StatelessWidget {
  const ModalWalletButtonWidget({
    required this.uri,
    this.text = 'Connect',
    this.buttonStyle,
    this.textStyle,
    this.textAlign,
    Key? key,
  }) : super(key: key);

  /// WalletConnect URI
  final String uri;

  /// Button text
  final String text;

  /// Button style
  final ButtonStyle? buttonStyle;

  /// Button text style
  final TextStyle? textStyle;

  /// Button text align
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: () => launchUrl(Uri.parse(uri)),
        child: Text(
          text,
          style: textStyle,
          textAlign: textAlign,
        ),
      ),
    );
  }

  ModalWalletButtonWidget copyWith({
    String? uri,
    String? text,
    ButtonStyle? buttonStyle,
    TextStyle? textStyle,
    TextAlign? textAlign,
    Key? key,
  }) =>
      ModalWalletButtonWidget(
        uri: uri ?? this.uri,
        text: text ?? this.text,
        buttonStyle: buttonStyle,
        textStyle: textStyle ?? this.textStyle,
        textAlign: textAlign ?? textAlign,
        key: key ?? this.key,
      );
}
