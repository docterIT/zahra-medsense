import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'components/theme.dart';
import 'screens/language_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const ZahraMedSenseApp());
}

class ZahraMedSenseApp extends StatelessWidget {
  const ZahraMedSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zahra MedSense',
      debugShowCheckedModeBanner: false,
      theme: ZahraTheme.darkTheme,
      home: const LanguageSelectionScreen(),
    );
  }
}
