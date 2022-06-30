import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/wallet.dart';

class Utils {
  static bool isIOS() => defaultTargetPlatform == TargetPlatform.iOS;

  static bool isAndroid() => defaultTargetPlatform == TargetPlatform.android;

  static bool isDesktop() => !isIOS() && !isAndroid();

  static bool linkHasContent(String? link) => link != null && link.isNotEmpty;

  static Future<bool> openableLink(String? link) async =>
      linkHasContent(link) && await canLaunchUrl(Uri.parse(link!));

  static Uri convertToWcLink({
    required String appLink,
    required String wcUri,
  }) =>
      Uri.parse('$appLink/wc?uri=${Uri.encodeComponent(wcUri)}');

  static Future<void> iosLaunch({
    required Wallet wallet,
    required String uri,
  }) async {
    if (await openableLink(wallet.mobile.universal)) {
      await launchUrl(
        convertToWcLink(appLink: wallet.mobile.universal!, wcUri: uri),
        mode: LaunchMode.externalApplication,
      );
    } else if (await openableLink(wallet.mobile.native)) {
      await launchUrl(
        convertToWcLink(appLink: wallet.mobile.native!, wcUri: uri),
      );
    } else if (await openableLink(wallet.app.ios)) {
      await launchUrl(Uri.parse(wallet.app.ios!));
    }
  }

  static Future<void> desktopLaunch({
    required Wallet wallet,
    required String uri,
  }) async {
    if (linkHasContent(wallet.desktop.universal)) {
      await launchUrl(
        convertToWcLink(appLink: wallet.desktop.universal!, wcUri: uri),
        mode: LaunchMode.externalApplication,
      );
    } else if (linkHasContent(wallet.desktop.native)) {
      await launchUrl(
        convertToWcLink(appLink: wallet.desktop.native!, wcUri: uri),
      );
    }
  }
}
