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
    // Works by iterating vthrough the operator list twice. The first time is for
    // * and /, because they have higher precedence, and the second si for + and -
    // The moment an operator with the correct precedence is spotted, the numbers
    // associated with it are evaluated, and the answer is stored in such a way that the
    // next operator is able to access it. This ensures precedence between operators and
    // direction is maintained, and that it doesn't needlessly iterate more than once.
    if (needNumber()) {
      return;
    }
    for (var precedent in [1, 0]) {
      List<String> newNum = [];
      List<String> newOp = [];
      for (var i = 0; i < op.length; i++) {
        if (operatorList[op[i]]![1] == precedent) {
          numbers[i + 1] =
              operatorList[op[i]]![0](
                    int.parse(numbers[i]),
                    int.parse(numbers[i + 1]),
                  )
                  .toString();
        } else {
          newNum.add(numbers[i]);
          newOp.add(op[i]);
        }
      }
      newNum.add(numbers.last);
      numbers = newNum;
      op = newOp;
    }
    setState(() {
      text = numbers[0];
    });
  }

  void addExpression(value) {
    // Holds most edge cases.
    // If an operator is placed with no numbers available, it is ignored.
    // If an operator is placed next to another, the previous one is replaced.
    // If two numbers are side by side, they are concatenated, unless 0 is the previous.
    // If 0 is the previous number, and a new number is added, 0 is replaced.
    if (isOperator(value)) {
      if (numbers.isEmpty) {
        return;
      } else if (needNumber()) {
        //Decreasing one value from text
        text = text.substring(0, text.length - 1);
        op.last = value;
      } else {
        op.add(value);
      }
    } else {
      if (!needNumber() && numbers.last == "0") {
        text = text.substring(0, text.length - 1);
        numbers.last = value;
      } else if (!needNumber()) {
        numbers.last = numbers.last + value;
      } else {
        numbers.add(value);
      }
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
