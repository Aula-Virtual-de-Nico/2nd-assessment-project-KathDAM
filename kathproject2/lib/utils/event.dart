import 'dart:typed_data';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final double price;
  final String imageUrl;
  final Uint8List? imageBytes;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.price,
    required this.imageUrl,
    this.imageBytes,
  });
}
