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
    final wcPath = 'wc?uri=${Uri.encodeComponent(wcUri)}';
    if (isDeepLink) {
      final scheme = Uri.tryParse(appLink)?.scheme;
      if (scheme != null) {
        return Uri.parse('$scheme://$wcPath');
      }
    }
    return Uri.parse('$appLink/$wcPath');
  }

  static Future<bool> iosLaunch({
    required Wallet wallet,
    required String uri,
    required bool verifyNativeLink,
  }) async {
    if (await openableLink(wallet.mobile.universal)) {
      return await launchUrl(
        convertToWcLink(appLink: wallet.mobile.universal!, wcUri: uri),
        mode: LaunchMode.externalApplication,
      );
    } else if (!verifyNativeLink || await openableLink(wallet.mobile.native)) {
      return await launchUrl(
        convertToWcLink(
          appLink: wallet.mobile.native!,
          wcUri: uri,
          isDeepLink: true,
        ),
      );
    } else {
      if (Utils.isDesktop && await openableLink(wallet.app.browser)) {
        return await launchUrl(Uri.parse(wallet.app.browser!));
      } else if (Utils.isAndroid && await openableLink(wallet.app.android)) {
        return await launchUrl(Uri.parse(wallet.app.android!));
      } else if (Utils.isIOS && await openableLink(wallet.app.ios)) {
        return await launchUrl(Uri.parse(wallet.app.ios!));
      }
    }
    return false;
  }

  static Future<bool> desktopLaunch({
    required Wallet wallet,
    required String uri,
  }) async {
    if (linkHasContent(wallet.desktop.universal)) {
      return await launchUrl(
        convertToWcLink(appLink: wallet.desktop.universal!, wcUri: uri),
        mode: LaunchMode.externalApplication,
      );
    } else if (linkHasContent(wallet.desktop.native)) {
      return await launchUrl(
        convertToWcLink(appLink: wallet.desktop.native!, wcUri: uri),
      );
    }
    return false;
  }
}
