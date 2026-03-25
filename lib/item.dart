class Item {
  final int id;
  String name;
  String description;
  String category;
  String donor;
  String status; // 'available' or 'taken'
  String? imageUrl; // base64 string
  String? takenBy;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.donor,
    this.status = 'available',
    this.imageUrl,
    this.takenBy,
  });
}