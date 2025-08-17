import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event}); // Fixed key

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            event.imageUrl.isNotEmpty
                ? Image.network(
                    event.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error),
                    ),
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.event, size: 50),
                  ),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ), // Updated
            const SizedBox(height: 8),
            Text('Date: ${event.date}'),
            Text('Location: ${event.location}'),
            const SizedBox(height: 16),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyMedium, // Updated
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (authService.currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please login first')),
                    );
                    return;
                  }

                  Provider.of<StorageService>(
                    context,
                    listen: false,
                  ).registerForEvent(authService.currentUser!.email, event);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registered for event!')),
                  );
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
