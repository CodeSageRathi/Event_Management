import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {
  Future<List<Event>> fetchEvents() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> products = data['products'];
      return products.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}

// models/event.dart
class Event {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      title: json['title'] ?? json['name'] ?? 'No Title',
      description: json['description'] ?? 'No description available',
      imageUrl: json['thumbnail'] ?? json['image'] ?? '',
      date: json['createdAt'] ?? '2023-01-01',
      location: json['brand'] ?? 'Unknown Location',
    );
  }
}
