import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/event.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/event_list_screen.dart';
import 'screens/profile_screen.dart';
import 'services/auth_service.dart';
import 'services/event_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService(prefs: prefs)),
        ChangeNotifierProvider(create: (_) => StorageService(prefs: prefs)),
        Provider(create: (_) => EventService()),
      ],
      child: MaterialApp(
        title: 'Event Explorer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
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
