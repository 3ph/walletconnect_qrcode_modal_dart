import 'package:flutter/material.dart';
import 'qr_modal.dart';

import '../segments/segments.dart';

class QrModalAndroid extends StatelessWidget {
  const QrModalAndroid({
    required this.uri,
    Key? key,
  }) : super(key: key);

  final String uri;

  @override
  Widget build(BuildContext context) {
    return ModalBase(
      uri: uri,
      segments: [
        SingleButtonSegment(
          uri: uri,
          title: "Mobile",
        ),
        QrCodeSegment(uri: uri),
      ],
    );
  }
}
