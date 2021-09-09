import 'dart:async';
import 'package:flutter_gpiod/flutter_gpiod.dart';

const String _CONSUMER = 'elevator-pi';

class ElevatorController {
  final GpioChip chip;
  final int startingPin, endingPin;

  final StreamController<int> _floorStreamController = StreamController<int>();
  Stream<int> get floorStream => _floorStreamController.stream;
  StreamSink get _floorSink => _floorStreamController.sink;

  final GpioLine motorLine;

  ElevatorController(
      this.chip, this.startingPin, this.endingPin, this.motorLine);

  factory ElevatorController.fromChipName(
      String chipName, int startingPin, int endingPin, int motorPin) {
    final GpioChip chip = FlutterGpiod.instance.chips
        .singleWhere((chip) => chip.label == chipName);
    final GpioLine motorLine = chip.lines[motorPin];
    return ElevatorController(chip, startingPin, endingPin, motorLine);
  }

  /// Init the lines
  void init() {
    motorLine.requestOutput(consumer: _CONSUMER, initialValue: false);

    for (int i = startingPin; i < endingPin; i++) {
      final line = chip.lines[i];
      // Request a callback only when the "button" is pressed
      line.requestInput(consumer: _CONSUMER, triggers: {SignalEdge.rising});
      line.onEvent.listen((event) => _onEvent(event, i));
    }
  }

  /// Relase all the lines
  void dispose() {
    _floorStreamController.close();
    motorLine.release();
    for (int i = startingPin; i < endingPin; i++) {
      final line = chip.lines[i];
      line.release();
    }
  }

  void _onEvent(final SignalEvent event, final int pin) {
    print("Got event $event on $pin pin");
    _floorSink.add(pin);
  }

  /// Move the elevator up or down
  void go(GoAction action) {
    // TODO: implement
  }

  /// Stop the elevator
  void stop() {
    motorLine.setValue(false);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage('1'),
    );
  }
}

class Floors extends StatelessWidget {
  final String floor;
  Floors(this.floor);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black87,
        ),
        child: TextButton(
          onPressed: () {},
          child:
              Text(floor, style: TextStyle(color: Colors.white, fontSize: 40)),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String floor;
  HomePage(this.floor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text('Elevator'), backgroundColor: Colors.black),
      body: Column(
        children: <Widget>[
          Divider(height: 50, color: Colors.grey[300]),
          Row(
            children: <Widget>[
              Floors('1'),
              Floors('2'),
              Floors('3'),
            ],
          ),
          Row(
            children: <Widget>[
              Floors('4'),
              Floors('5'),
              Floors('6'),
            ],
          ),
          Divider(height: 130, color: Colors.grey[300]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.exposure_minus_1, size: 50),
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[900],
                ),
                child: Text(
                  floor,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.exposure_plus_1, size: 50),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum GoAction { UP, DOWN }
