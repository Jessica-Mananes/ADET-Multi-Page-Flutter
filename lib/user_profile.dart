import 'item.dart';

class UserProfile {
  String username;
  String bio;
  DateTime joinedDate;
  List<Item> donatedItems;
  List<Item> takenItems;

  UserProfile({
    required this.username,
    this.bio = '',
    required this.joinedDate,
    List<Item>? donatedItems,
    List<Item>? takenItems,
  })  : donatedItems = donatedItems ?? [],
        takenItems = takenItems ?? [];

  // Must donate at least 1 item before taking
  bool get canTakeItem => donatedItems.isNotEmpty;
}