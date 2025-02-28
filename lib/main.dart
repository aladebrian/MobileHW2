import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHome();
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<String> numbers = [];
  List<String> op = [];
  List<String> items = [
    "7",
    "8",
    "9",
    "/",
    "4",
    "5",
    "6",
    "*",
    "1",
    "2",
    "3",
    "+",
    "0",
    "AC",
    "=",
    "-",
  ];
  String text = "";
  late Map<String, List<dynamic>> operatorList = {
    "+": [add, 0],
    "-": [sub, 0],
    "*": [mul, 1],
    "/": [div, 1],
  };
  bool isOperator(String key) {
    return operatorList.containsKey(key);
  }

  bool needNumber() {
    return numbers.length <= op.length;
  }

  int add(int n1, int n2) {
    return n1 + n2;
  }

  int sub(int n1, int n2) {
    return n1 - n2;
  }

  int mul(int n1, int n2) {
    return n1 * n2;
  }

  int div(int n1, int n2) {
    return (n2 == 0) ? 0 : n1 ~/ n2;
  }

  void clear() {
    numbers = [];
    op = [];
    setState(() {
      text = "";
    });
  }

  void evaluate(value) {
    if (value == "=") {
      solve();
    } else if (value == "AC") {
      clear();
    } else {
      addExpression(value);
    }
  }

  void solve() {

  }

  void addExpression(value) {
    // Holds most edge cases. If an operator is placed next to another, the previous one is
    // replaced. If two numbers are side by side, they are concatenated. If an operator is
    // placed with no numbers available, it is ignored.
    if (isOperator(value)) {
      if (numbers.isEmpty) {
        return;
      }
      if (needNumber()) {
        text = text.substring(
          0,
          text.length - 1,
        ); //Decreasing one value from text
        op.removeLast();
      }
      op.add(value);
    } else if (!needNumber()) {
      numbers.last = numbers.last + value;
    } else {
      numbers.add(value);
    }
    setState(() {
      text += value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(text, style: TextStyle(color: Colors.black, fontSize: 75)),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 25,
                    width: 25,
                    color: Colors.purple,
                    child: TextButton(
                      onPressed: () => evaluate(items[index]),
                      child: Text(
                        items[index],
                        style: TextStyle(color: Colors.black, fontSize: 75),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
