import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/wallet.dart';

class Utils {
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

  static bool get isDesktop => !isIOS && !isAndroid;

  static bool linkHasContent(String? link) => link != null && link.isNotEmpty;

  static Future<bool> openableLink(String? link) async =>
      linkHasContent(link) && await canLaunchUrl(Uri.parse(link!));

  static Uri convertToWcLink({
    required String appLink,
    required String wcUri,
    bool isDeepLink = false,
  }) {
    final appLinkUri = Uri.tryParse(appLink);
    if (appLinkUri != null) {
      final uri = Uri(
          scheme: appLinkUri.scheme,
          host: appLinkUri.host,
          path: 'wc?uri=${Uri.encodeComponent(wcUri)}');
      return uri;
    }
    return Uri.parse('$appLink/wc?uri=${Uri.encodeComponent(wcUri)}');
  }

  static Future<void> iosLaunch({
    required Wallet wallet,
    required String uri,
    required bool verifyNativeLink,
  }) async {
    if (await openableLink(wallet.mobile.universal)) {
      await launchUrl(
        convertToWcLink(appLink: wallet.mobile.universal!, wcUri: uri),
        mode: LaunchMode.externalApplication,
      );
    } else if (!verifyNativeLink || await openableLink(wallet.mobile.native)) {
      await launchUrl(
        convertToWcLink(appLink: wallet.mobile.native!, wcUri: uri),
      );
    } else {
      if (Utils.isDesktop && await openableLink(wallet.app.browser)) {
        await launchUrl(Uri.parse(wallet.app.browser!));
      } else if (Utils.isAndroid && await openableLink(wallet.app.android)) {
        await launchUrl(Uri.parse(wallet.app.android!));
      } else if (Utils.isIOS && await openableLink(wallet.app.ios)) {
        await launchUrl(Uri.parse(wallet.app.ios!));
      }
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
