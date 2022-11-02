import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'segments.dart';

class SingleButtonSegment extends Segment {
  const SingleButtonSegment({
    required this.uri,
    String title = "",
    Key? key,
  })  : _title = title,
        super(key: key);

  final String uri;
  final String _title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => launchUrl(Uri.parse(uri)),
        child: const Text('Connect'),
      ),
    );
  }

  @override
  String title() => _title;
}
