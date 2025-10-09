import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:luna_arc_sync/app.dart'; // Import the new App widget
import 'package:luna_arc_sync/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Important for some plugins
  
  // Initialize flutter_inappwebview (enable debugging for development)
  await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  
  await configureDependencies();
  runApp(const App()); // Run our new root App widget
}
