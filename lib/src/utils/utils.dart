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

    if (await canLaunch(wallet.mobile.universal)) {
      await launch(
        convertToWcLink(appLink: wallet.mobile.universal, wcUri: uri),
        forceSafariVC: false,
        universalLinksOnly: true,
      );
    } else if (await canLaunch(wallet.mobile.native)) {
      await launch(
        convertToWcLink(appLink: wallet.mobile.native, wcUri: uri),
      );
    } else {
      await launch(wallet.app.ios);
    }
  }
}
