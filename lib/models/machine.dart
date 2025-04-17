class Machine {
  final String name;
  final String? imagePath;
  final double? quantityPrepared;
  final double? quantityToDo;
  final double? totalQuantity;
  final double? planned;
  final double? prepared;
  final double? remaining;
  final double? trs;
  final int? stops;
  final double? purgeWeight;
  final String image;

  Machine({
    required this.name,
    this.imagePath,
    this.quantityPrepared,
    this.quantityToDo,
    this.totalQuantity,
    this.planned,
    this.prepared,
    this.remaining,
    this.trs,
    this.stops,
    this.purgeWeight,
    required this.image,
  });
}
