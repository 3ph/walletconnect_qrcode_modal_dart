import 'package:url_launcher/url_launcher.dart';

import '../models/wallet.dart';

class Utils {
  static Future<void> iosLaunch({
    required Wallet wallet,
    required String uri,
  }) async {
    String convertToWcLink({
      required String appLink,
      required String wcUri,
    }) =>
        '$appLink/wc?uri=${Uri.encodeComponent(wcUri)}';

    if (wallet.mobile.universal != null &&
        await canLaunch(wallet.mobile.universal!)) {
      await launch(
        convertToWcLink(appLink: wallet.mobile.universal!, wcUri: uri),
        forceSafariVC: false,
        universalLinksOnly: true,
      );
    } else if (wallet.mobile.native != null &&
        await canLaunch(wallet.mobile.native!)) {
      await launch(
        convertToWcLink(appLink: wallet.mobile.native!, wcUri: uri),
      );
    } else {
      if (wallet.app.ios != null) await launch(wallet.app.ios!);
    }
  }
}
