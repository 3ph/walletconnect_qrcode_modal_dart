import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../managers/managers.dart';
import 'segments.dart';

class LaunchWalletSegment extends Segment {
  const LaunchWalletSegment({
    String title = "",
    Key? key,
  })  : _title = title,
        super(key: key);

  final String _title;

  @override
  Widget build(BuildContext context) {
    final settings = SettingsManager.instance.launchWalletSettings;
    launchWallet() async => launchUrl(Uri.parse(WalletManager.instance.uri));

    return CustomWidgetManager.instance.launchWalletPageBuilder?.call(
          context,
          settings,
          launchWallet,
        ) ??
        Center(
          child: ElevatedButton.icon(
            style: settings.buttonStyle,
            onPressed: launchWallet,
            label: Text(settings.connectText),
            icon: Icon(settings.connectIcon),
          ),
        );
  }

  @override
  String title() => _title;
}
