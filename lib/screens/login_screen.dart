import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../providers/auth_provider.dart';
import '../core/constants.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(AppConstants.primaryBgHex),
        ),
        child: Stack(
          children: [
            // Subtle Glow Background
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(AppConstants.accentHex).withValues(alpha: 0.1),
                ),
              ),
            ),
            
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: GlassmorphicContainer(
                  width: double.infinity,
                  height: 450,
                  borderRadius: 20,
                  blur: 20,
                  alignment: Alignment.bottomCenter,
                  border: 2,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFffffff).withValues(alpha: 0.1),
                      const Color(0xFFFFFFFF).withValues(alpha: 0.05),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(AppConstants.accentHex).withValues(alpha: 0.5),
                      const Color((AppConstants.secondaryHex)).withValues(alpha: 0.5),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'VākyaAI',
                          style: GoogleFonts.cinzel(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(AppConstants.accentHex),
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'The Architect of Eloquence',
                          style: GoogleFonts.cinzel(
                            fontSize: 14,
                            color: const Color(AppConstants.secondaryHex),
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: _emailController,
                          style: GoogleFonts.inter(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'EMAIL',
                            prefixIcon: Icon(Icons.email_outlined, color: Color(AppConstants.accentHex)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: GoogleFonts.inter(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'PASSWORD',
                            prefixIcon: Icon(Icons.lock_outline, color: Color(AppConstants.accentHex)),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () {
                                    ref.read(authProvider.notifier).login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  },
                            child: authState.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('RESTORE SESSION'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignupScreen()),
                            );
                          },
                          child: Text(
                            'NEW MANUSCRIPT? SIGNUP',
                            style: GoogleFonts.cinzel(
                              color: const Color(AppConstants.secondaryHex),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
