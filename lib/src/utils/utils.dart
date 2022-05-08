import 'package:url_launcher/url_launcher.dart';

import '../models/wallet.dart';

class Utils {
  static Future<void> iosLaunch({
    required Wallet wallet,
    required String uri,
  }) async {
    Uri convertToWcLink({
      required String appLink,
      required String wcUri,
    }) =>
        Uri.parse('$appLink/wc?uri=${Uri.encodeComponent(wcUri)}');

    if (wallet.mobile.universal != null &&
        await canLaunchUrl(Uri.parse(wallet.mobile.universal!))) {
      await launchUrl(
        convertToWcLink(appLink: wallet.mobile.universal!, wcUri: uri),
        mode: LaunchMode.externalApplication,
      );
    } else if (wallet.mobile.native != null &&
        await canLaunchUrl(Uri.parse(wallet.mobile.native!))) {
      await launchUrl(
        convertToWcLink(appLink: wallet.mobile.native!, wcUri: uri),
      );
    } else {
      if (wallet.app.ios != null) await launchUrl(Uri.parse(wallet.app.ios!));
    }
  }
}
