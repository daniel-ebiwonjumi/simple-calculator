import 'package:flutter/material.dart';
import 'calculatorScreen.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
      title: "Calculator",
      theme: ThemeData.dark(),
    );
  }
}
