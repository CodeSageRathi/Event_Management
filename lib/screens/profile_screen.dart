import 'package:event_explorer/screens/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key}); // Fixed key

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final storageService = Provider.of<StorageService>(context);

    if (authService.currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view profile')),
      );
    }

    final registeredEvents = storageService.getRegisteredEvents(
      authService.currentUser!.email,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: ${authService.currentUser!.email}',
              style: Theme.of(context).textTheme.headlineSmall, // Updated
            ),
            const SizedBox(height: 20),
            Text(
              'Registered Events:',
              style: Theme.of(context).textTheme.titleMedium, // Updated
            ),
            const Divider(),
            Expanded(
              child: registeredEvents.isEmpty
                  ? const Center(child: Text('No events registered yet'))
                  : ListView.builder(
                      itemCount: registeredEvents.length,
                      itemBuilder: (context, index) {
                        final event = registeredEvents[index];
                        return ListTile(
                          title: Text(event.title),
                          subtitle: Text(event.date),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailScreen(event: event),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  authService.logout();
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
