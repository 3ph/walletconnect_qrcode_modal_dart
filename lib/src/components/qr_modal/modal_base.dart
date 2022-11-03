import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../managers/managers.dart';
import '../../utils/utils.dart';
import '../segments/segments.dart';

class ModalBase extends HookWidget {
  const ModalBase({
    required this.segments,
    Key? key,
  }) : super(key: key);

  final List<Segment> segments;

  @override
  Widget build(BuildContext context) {
    final settings = SettingsManager.instance.modalSettings;
    final groupValue = useState(0);

    return Center(
      child: SizedBox(
        width: settings.width,
        height: settings.height,
        child: Card(
          color: settings.cardColor,
          child: Padding(
            padding: settings.cardPadding,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  CupertinoSlidingSegmentedControl<int>(
                    groupValue: groupValue.value,
                    onValueChanged: (value) => groupValue.value = value ?? 0,
                    backgroundColor: settings.tabBackgroundColor ??
                        context.theme().primaryContainer.darken(0.1),
                    thumbColor:
                        settings.thumbColor ?? context.theme().primaryContainer,
                    padding: settings.tabPadding,
                    children: segments
                        .map(
                          (e) => SizedBox(
                            width: settings.thumbWidth,
                            child: Text(
                              e.title(),
                              textAlign: settings.thumbTextAlign,
                              style: settings.thumbTextStyle,
                            ),
                          ),
                        )
                        .toList()
                        .asMap(),
                  ),
                  Expanded(
                    child: segments[groupValue.value],
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
