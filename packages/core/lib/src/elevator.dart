import 'dart:async';

import 'package:elevatorpi_core/src/controller.dart';
import 'package:elevatorpi_core/src/exceptions.dart';

const int STARTING_PIN = 22;

class Elevator {

  final int maxFloor, minFloor;
  final ElevatorController controller;
  Elevator(this.minFloor, this.maxFloor, this.controller);

  factory Elevator.fromChipName(final int minFloor, final int maxFloor, final String chipName, final int motorPin) {
    final controller = ElevatorController.fromChipName(chipName, STARTING_PIN + minFloor, STARTING_PIN + maxFloor, motorPin);
    controller.init();
    return Elevator(minFloor, maxFloor, controller);
  }

  
  int _currentFloor = 0;
  /// Current elevator floor
  int get currentFloor => _currentFloor;

  /// Check if the elevator can go up
  bool get canGoUp => _currentFloor < maxFloor;
  /// Check if the elevator can go down
  bool get canGoDown => _currentFloor > minFloor;
  
  /// Go to a specific floor
  Future<void> goToFloor(final int floor) async {
    // Check if the selected floot exist
    if(floor > maxFloor || floor < minFloor) throw new FloorNotExist(floor);
    // No need to move the elevator if it's yet at that floor
    if(floor == currentFloor) return;

    // Make the elevator move in the needed direction
    controller.go(floor > currentFloor ? GoAction.UP : GoAction.DOWN); 
    
    // When it arrives at the floor stop the elevator
    await controller.floorStream.firstWhere((element) {
      _currentFloor = element;

      return element == floor;
    });

    controller.stop();
  }

  /// Make the elevator go one floor up
  Future<void> goUp() {
    if(!canGoUp) return Future.value();
    return goToFloor(currentFloor + 1);
  }

  /// Make the elevator go one floor down
  Future<void> goDown() {
    if(!canGoDown) return Future.value();
    return goToFloor(currentFloor - 1);
  }
}