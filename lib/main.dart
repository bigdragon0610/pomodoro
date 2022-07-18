import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 25 * 60;
  bool _pause = true;

  String _toggleIcon() {
    if (_pause) {
      return "▶";
    } else {
      return "||";
    }
  }

  String _getTime() {
    int minute = _counter ~/ 60;
    int second = _counter - minute * 60;
    String time =
        '${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
    return time;
  }

  void _resetCounter() {
    setState(() {
      _counter = 25 * 60;
    });
  }

  void _executePomodoroTimer() {
    if (_counter == 0) {
      return;
    }

    setState(() {
      _pause = !_pause;
    });
    if (!_pause) {
      _pomodoroTimer();
    }
  }

  void _incrementMinute() {
    setState(() {
      _counter = (_counter / 60 + 1).floor() * 60;
    });
  }

  void _decrementMinute() {
    setState(() {
      _counter = (_counter / 60 - 1).ceil() * 60;
      if (_counter < 0) {
        _counter = 0;
      }
    });
  }

  void _pomodoroTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_counter == 0 || _pause) {
        setState(() {
          _pause = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            _getTime(),
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: _executePomodoroTimer,
                  child: Text(
                    _toggleIcon(),
                    style: const TextStyle(fontSize: 16),
                  )),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: _incrementMinute, child: const Text("↑")),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: _decrementMinute, child: const Text("↓"))
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _resetCounter, child: const Text("Reset"))
        ]),
      ),
    );
  }
}
