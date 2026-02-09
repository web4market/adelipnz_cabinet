import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<StorageService> _storageFuture;

  @override
  void initState() {
    super.initState();
    _storageFuture = StorageService.create();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StorageService>(
      future: _storageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final storageService = snapshot.data!;
          final apiService = ApiService();

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => AuthProvider(apiService, storageService),
              ),
            ],
            child: const AppContent(),
          );
        } else {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Инициализация...',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class AppContent extends StatefulWidget {
  const AppContent({super.key});

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Provider.of<AuthProvider>(context, listen: false).initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!_isInitialized || authProvider.isLoading) {
      return const MaterialApp(home: SplashScreen());
    }

    return MaterialApp(
      title: 'Личный кабинет',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => authProvider.isAuthenticated
            ? const HomeScreen()
            : const LoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
