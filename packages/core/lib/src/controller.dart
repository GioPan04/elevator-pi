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

  ElevatorController(this.chip, this.startingPin, this.endingPin, this.motorLine);

  factory ElevatorController.fromChipName(String chipName, int startingPin, int endingPin, int motorPin) {
    final GpioChip chip = FlutterGpiod.instance.chips.singleWhere((chip) => chip.label == chipName);
    final GpioLine motorLine = chip.lines[motorPin];
    return ElevatorController(chip, startingPin, endingPin, motorLine);
  }

  /// Init the lines
  void init() {
    motorLine.requestOutput(consumer: _CONSUMER, initialValue: false);

    for(int i = startingPin; i < endingPin; i++) {
      final line = chip.lines[i];
      // Request a callback only when the "button" is pressed
      line.requestInput(consumer: _CONSUMER, triggers: { SignalEdge.rising });
      line.onEvent.listen((event) => _onEvent(event, i));
    }
  }

  /// Relase all the lines
  void dispose() {
    _floorStreamController.close();
    motorLine.release();
    for(int i = startingPin; i < endingPin; i++) {
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

enum GoAction {UP, DOWN}