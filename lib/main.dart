import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/event_list_screen.dart';
import 'screens/profile_screen.dart';
import 'services/auth_service.dart';
import 'services/event_service.dart';
import 'services/storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance(); // Initialize here
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs}); // Use super.key

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService(prefs: prefs)),
        ChangeNotifierProvider(create: (_) => StorageService()),
        Provider(create: (_) => EventService()),
      ],
      child: MaterialApp(
        title: 'Event Explorer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true, // Enable Material 3
          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(fontSize: 16),
            headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontSize: 18),
          ),
        ),
        home: Consumer<AuthService>(
          builder: (context, auth, child) {
            return auth.isAuthenticated
                ? const EventListScreen()
                : const LoginScreen();
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/events': (context) => const EventListScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
