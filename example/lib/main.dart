import 'package:example/alerts/ex_alert.dart';
import 'package:example/buttons/ex_enable_disbale.dart';
import 'package:example/text/ex_animated_text.dart';
import 'package:example/text/ex_glitch_price.dart';
import 'package:example/text/ex_glitch_text.dart';
import 'package:example/utils/ex_bounce_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExBounceWidget(),
    ),
  );
}
