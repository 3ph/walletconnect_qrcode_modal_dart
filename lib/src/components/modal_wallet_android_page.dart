import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ModalWalletAndroidPage extends StatelessWidget {
  const ModalWalletAndroidPage({
    required this.uri,
    Key? key,
  }) : super(key: key);

  final String uri;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => launchUrl(Uri.parse(uri)),
        child: const Text('Connect'),
      ),
    );
  }
}
