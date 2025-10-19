import 'package:flutter/material.dart';
import 'package:fp_blocky/editor/left_panel.dart';
import 'package:google_fonts/google_fonts.dart';

import 'editor/editor_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Blocks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        canvasColor: Colors.white,
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
      ),
      home: const MyHomePage(title: 'FunBlock Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          LeftPanel(),
          Expanded(child: EditorView()),
        ],
      ),
    );
  }
}
