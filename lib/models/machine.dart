// lib/models/machine.dart
class Machine {
  final String name;
  final String imagePath;
  final int quantityPrepared;
  final int quantityToDo;
  final int totalQuantity;

  Machine({
    required this.name,
    required this.imagePath,
    required this.quantityPrepared,
    required this.quantityToDo,
    required this.totalQuantity,
  });
}
