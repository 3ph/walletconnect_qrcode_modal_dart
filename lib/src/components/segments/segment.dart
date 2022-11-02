import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

abstract class Segment extends HookWidget {
  const Segment({Key? key}) : super(key: key);
  String title();
}
