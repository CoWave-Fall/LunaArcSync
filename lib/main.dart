import 'package:flutter/material.dart';
import 'package:luna_arc_sync/app.dart'; // Import the new App widget
import 'package:luna_arc_sync/core/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Important for some plugins
  configureDependencies();
  runApp(const App()); // Run our new root App widget
}