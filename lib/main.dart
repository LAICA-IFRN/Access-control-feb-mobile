import 'package:flutter/material.dart';
import 'package:laica_mobile/init.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MaterialApp(
      home: Init()
  ));
}

