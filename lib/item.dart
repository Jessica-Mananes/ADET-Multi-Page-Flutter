class Item {
  final int id;
  String name;
  String description;
  String category;
  String donor;
  String status; 
  String? imageUrl; 
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