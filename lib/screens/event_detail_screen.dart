// screens/event_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            event.imageUrl.isNotEmpty
                ? Image.network(event.imageUrl)
                : const Icon(Icons.event, size: 200),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Date: ${event.date}'),
            Text('Location: ${event.location}'),
            const SizedBox(height: 16),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final userEmail = Provider.of<AuthService>(context, listen: false)
                      .currentUserEmail;
                  if (userEmail != null) {
                    Provider.of<StorageService>(context, listen: false)
                        .registerForEvent(userEmail, event);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registered for event!')),
                    );
                  }
                },
                child: const Text('Register for Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// services/storage_service.dart
import 'package:flutter/material.dart';
import '../models/event.dart';

class StorageService {
  final Map<String, List<Event>> _userEvents = {};

  List<Event> getRegisteredEvents(String userEmail) {
    return _userEvents[userEmail] ?? [];
  }

  void registerForEvent(String userEmail, Event event) {
    if (!_userEvents.containsKey(userEmail)) {
      _userEvents[userEmail] = [];
    }
    _userEvents[userEmail]!.add(event);
  }
}