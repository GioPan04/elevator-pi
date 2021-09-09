class ElevatorException {}

class FloorNotExist extends ElevatorException {
  final int floor;

  FloorNotExist(this.floor);
}
