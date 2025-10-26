import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fp_blocky/editor/editor_tools.dart';
import 'package:fp_blocky/editor/left_panel.dart';
import 'package:fp_blocky/theme_extensions.dart';
import 'package:google_fonts/google_fonts.dart';

import 'editor/bloc/editor_cubit.dart';
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
        expansionTileTheme: ExpansionTileThemeData(),
        extensions: [
          FunBlockMenuStyleExtension(
            textStyle: GoogleFonts.robotoMonoTextTheme().bodySmall!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
          ),
        ],
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
    return BlocProvider<EditorCubit>(
      create: (context) => EditorCubit(),
      child: Scaffold(
        body: Row(
          children: [
            LeftPanel(),
            Expanded(
                child: Stack(
              children: [
                EditorView(),
                Align(alignment: Alignment.bottomCenter, child: EditorTools()),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
