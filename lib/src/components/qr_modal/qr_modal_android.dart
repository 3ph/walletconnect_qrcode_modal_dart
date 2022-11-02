import 'package:flutter/material.dart';
import 'qr_modal.dart';

import '../segments/segments.dart';

class QrModalAndroid extends StatelessWidget {
  const QrModalAndroid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ModalBase(
      segments: [
        SingleButtonSegment(
          title: "Mobile",
        ),
        QrCodeSegment(),
      ],
    );
  }
}
