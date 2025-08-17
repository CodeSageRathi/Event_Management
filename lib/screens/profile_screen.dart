// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/event.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<AuthService>(context).currentUserEmail;
    final registeredEvents = userEmail != null
        ? Provider.of<StorageService>(context).getRegisteredEvents(userEmail)
        : <Event>[];

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: $userEmail',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Registered Events:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            if (registeredEvents.isEmpty)
              const Text('No events registered yet')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: registeredEvents.length,
                  itemBuilder: (context, index) {
                    final event = registeredEvents[index];
                    return ListTile(
                      title: Text(event.title),
                      subtitle: Text(event.date),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<AuthService>(context, listen: false).logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
