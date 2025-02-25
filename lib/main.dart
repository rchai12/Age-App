import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    value -=1;
    notifyListeners();
  }

  void setValue(int val) {
    value = val;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

String getMilestoneMessage(int age) {
    if (age <= 12) {
      return "You're a child!";
    } else if (age <= 19) {
      return "Teenager time!";
    } else if (age <= 30) {
      return "You're a young adult!";
    } else if (age <= 50) {
      return "You're an adult now!";
    } else {
      return "Golden years!";
    }
  }

  Color getBackgroundColor(int age) {
    if (age <= 12) {
      return Colors.lightBlue;
    } else if (age <= 19) {
      return Colors.lightGreen;
    } else if (age <= 30) {
      return Colors.yellow;
    } else if (age <= 50) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  Color getProgressColor(int age) {
    if (age <= 33) {
      return Colors.green;
    } else if (age <= 67) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    var counter = context.watch<Counter>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter App'),
      ),
      backgroundColor: getBackgroundColor(counter.value),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('I am ${counter.value} years old',
              style: TextStyle(fontSize: 24),
            ),
            Text(getMilestoneMessage(counter.value),
              style: TextStyle(fontSize: 36),
            ),
            Slider(
              value: counter.value.toDouble(),
              min: 0,
              max: 99,
              divisions: 99,
              label: counter.value.toString(),
              onChanged: (double newValue) {
                counter.setValue(newValue.toInt());
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearProgressIndicator(
                value: counter.value / 99,
                backgroundColor: Colors.grey[300],
                color: getProgressColor(counter.value),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    counter.increment();
                  },
                  child: const Text('Increase Age'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    counter.decrement();
                  },
                  child: const Text('Reduce Age'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
