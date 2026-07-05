import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = '';
  String operand = '';
  String number2 = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  height: screenSize.height / 4,
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '$number1$operand$number2'.isEmpty
                        ? '0'
                        : '$number1$operand$number2',

                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            Wrap(
              children: Btn.buttons
                  .map(
                    (val) => SizedBox(
                      height: screenSize.height / 8,
                      width: Btn.zero.contains(val)
                          ? screenSize.width / 2
                          : screenSize.width / 4,
                      child: buildButton(val),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: getColor(value),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.grey),
        ),
        child: InkWell(
          onTap: () {
            onBtnTap(value);
          },
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String valueTapped) {
    if (valueTapped == Btn.clr) {
      clearAll(valueTapped);
      return;
    }
    if (valueTapped == Btn.del) {
      delete(valueTapped);
      return;
    }
    if (valueTapped == Btn.per) {
      percent(valueTapped);
      return;
    }
    if (valueTapped == Btn.calc) {
      calc();
      return;
    }

    appendValue(valueTapped);
  }

  void calc() {
    if (number1.isEmpty) return;
    if (number2.isEmpty) return;
    if (operand.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    double result = 0.0;

    switch (operand) {
      case Btn.add:
        result = num1 + num2;

        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      case Btn.minus:
        result = num1 - num2;
        break;
      default:
    }
    setState(() {
      number1 = '$result';
      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = '';
      number2 = '';
    });
  }

  void delete(String delete) {
    setState(() {
      if (number1.isNotEmpty) {
        number1 = number1.substring(0, number1.length - 1);
      } else if (operand.isNotEmpty) {
        operand = '';
      } else if (number2.isNotEmpty) {
        number2 = number2.substring(0, number2.length - 1);
      }
    });
  }

  void percent(String findPer) {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      //making sure sure the values are first calculaed before moving into anoher
      calc();
    }
    if (operand.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);

    setState(() {
      number1 = '${number / 100}';
    });
  }

  void clearAll(String clearAllValue) {
    setState(() {
      number1 = '';
      operand = '';
      number2 = '';
    });
  }

  void appendValue(String valueAppended) {
    if (valueAppended != Btn.dot && int.tryParse(valueAppended) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calc();
      }
      operand = valueAppended;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (valueAppended == Btn.dot && number1 == Btn.dot) return;
      if (valueAppended == Btn.dot && number1.isEmpty || number1 == Btn.dot) {
        valueAppended = '0.';
      }
      number1 += valueAppended;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (valueAppended == Btn.dot && number2 == Btn.dot) return;
      if (valueAppended == Btn.dot && number2.isEmpty || number2 == Btn.dot) {
        valueAppended = '0.';
      }
      number2 += valueAppended;
    }

    setState(() {});
  }

  Color getColor(String colorValue) {
    return [Btn.del, Btn.clr].contains(colorValue)
        ? Colors.grey
        : [
            Btn.add,
            Btn.minus,
            Btn.multiply,
            Btn.divide,
            Btn.calc,
          ].contains(colorValue)
        ? Colors.orange
        : Colors.black;
  }
}
