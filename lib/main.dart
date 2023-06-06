import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondText = "";
  GameState gameState = GameState.readyToStart;

  Timer? _waitingTimer;
  Timer? _stoppableTimer;
  // String? get millisecondsText => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282E3D),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.8),
            child: Text(
              'Test your\nreaction speed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: const Color(0xFF6D6D6D),
              child: SizedBox(
                height: 160,
                width: 300,
                child: Center(
                  child: Text(
                    millisecondText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.8),
            child: GestureDetector(
              onTap: () => setState(() {
                switch (gameState) {
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    millisecondText = "";
                    break;
                  case GameState.waiting:
                    _startWaitingTimer();

                    gameState = GameState.canBeStopped;
                    break;
                  case GameState.canBeStopped:
                    gameState = GameState.readyToStart;
                    _stoppableTimer?.cancel();
                    break;
                }
              }),
              child: ColoredBox(
                color: _getButtonColor(),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Text(
                      _getButtonText(),
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "START";
      case GameState.waiting:
        return "WAIT";
      case GameState.canBeStopped:
        return "STOP";
    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;
    _waitingTimer = Timer(Duration(microseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer() {
    _stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondText = "${timer.tick * 16} ms";
      });
    });
  }

  _getButtonColor() {
    switch (gameState) {
      case GameState.readyToStart:
        return const Color(0xFF40CA88);
      case GameState.waiting:
        return const Color(0xFFE0982D);
      case GameState.canBeStopped:
        return const Color(0xFFE02D47);
    }
  }

  @override
  void dispose() {
    //waitingTimer?.cancel();
    _waitingTimer?.cancel();
    _stoppableTimer?.cancel();
    super.dispose();
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
