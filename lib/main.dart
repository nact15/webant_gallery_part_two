import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/welcome_screen.dart';
Future<void> main() async {
  runZonedGuarded(() {
    runApp(WelcomeScreen());
  }, (error, stackTrace) {});
}
