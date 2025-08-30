import 'package:device_preview/device_preview.dart'; // 👈 импорт
import 'package:flutter/material.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:notes_app/pages/notes_page.dart';
import 'package:notes_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    DevicePreview(
      enabled: false, // 👈 выключится на релизе
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NoteDatabase()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ignore: deprecated_member_use
      useInheritedMediaQuery: true, // 👈 чтобы DevicePreview работал корректно
      locale: DevicePreview.locale(context), // 👈 локаль берётся из превью
      builder: DevicePreview.appBuilder, // 👈 билдится через превью
      home: const NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
