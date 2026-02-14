import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../providers/auth_provider.dart';
import '../core/constants.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(AppConstants.primaryBgHex),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -100,
              left: -100,
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
                  height: 520,
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
                          'Initiate Your Journey',
                          style: GoogleFonts.cinzel(
                            fontSize: 14,
                            color: const Color(AppConstants.secondaryHex),
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: _nameController,
                          style: GoogleFonts.inter(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'FULL NAME',
                            prefixIcon: Icon(Icons.person_outline, color: Color(AppConstants.accentHex)),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                                : () async {
                                    await ref.read(authProvider.notifier).register(
                                      _nameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                    if (context.mounted && authState.errorMessage == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Registration successful. Please login.')),
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                            child: authState.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('BEGIN MANUSCRIPT'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'ALREADY A SCRIBE? LOGIN',
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
