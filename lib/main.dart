import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  runApp(const MainApp());
  await initializeDateFormatting('id_ID', null); 

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF2A4463);   
    const Color tealColor = Color(0xFF5993A2);   
    const Color lightText = Colors.white;
    const Color darkText = Color(0xFF333333);

    return MaterialApp(
      title: 'To-Do List Mahasiswa',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: darkBlue,
        hintColor: lightText.withOpacity(0.8),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(color: darkText, fontSize: 22, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: darkText),
        ),

        cardColor: tealColor,

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: darkBlue,
          foregroundColor: lightText,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkBlue,
            foregroundColor: lightText,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: tealColor,
          labelStyle: TextStyle(color: lightText.withOpacity(0.8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),

        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return tealColor;
            }
            return null;
          }),
          checkColor: MaterialStateProperty.all(lightText),
          side: BorderSide(color: Colors.grey.shade400),
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: darkText),
          bodyMedium: TextStyle(color: darkText),
          titleLarge: TextStyle(color: darkText, fontWeight: FontWeight.bold, fontSize: 22),
          titleMedium: TextStyle(color: lightText, fontWeight: FontWeight.bold, fontSize: 16),
          bodySmall: TextStyle(color: lightText, fontSize: 14),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Nama Lengkap = Anna Maulina
// NIM = 230441100178
// Kelas = PEMBER C
// Nama Asprak = Dhea Rahma Dianti
