import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take One, Leave One',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: kNavy,
          secondary: kGold,
          surface: kCream,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: kCream,
      ),
      home: const HomeScreen(),
    );
  }
}