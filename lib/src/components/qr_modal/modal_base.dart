import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../utils/utils.dart';
import '../segments/segments.dart';

class ModalBase extends HookWidget {
  const ModalBase({
    required this.uri,
    required this.segments,
    Key? key,
  }) : super(key: key);

  final String uri;
  final List<Segment> segments;

  @override
  Widget build(BuildContext context) {
    final _groupValue = useState(0);

    return Center(
      child: SizedBox(
        width: min(context.width() * 0.9, 600),
        height: max(context.height() * 0.5, 500),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  CupertinoSlidingSegmentedControl<int>(
                    groupValue: _groupValue.value,
                    onValueChanged: (value) => _groupValue.value = value ?? 0,
                    backgroundColor:
                        context.theme().primaryContainer.darken(0.1),
                    thumbColor: context.theme().primaryContainer,
                    padding: const EdgeInsets.all(4),
                    children: segments
                        .map(
                          (e) => SizedBox(
                            width: 100,
                            child: Text(
                              e.title(),
                              textAlign: TextAlign.center,
                              style: context.textTheme().titleMedium?.copyWith(
                                    color: context.theme().onPrimaryContainer,
                                  ),
                            ),
                          ),
                        )
                        .toList()
                        .asMap(),
                  ),
                  Expanded(
                    child: segments[_groupValue.value],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
