import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: VakyaAIApp(),
    ),
  );
}

class VakyaAIApp extends ConsumerWidget {
  const VakyaAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'VākyaAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: authState.isLoading 
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : authState.isAuthenticated 
              ? const HomeScreen() 
              : const LoginScreen(),
    );
  }
}
