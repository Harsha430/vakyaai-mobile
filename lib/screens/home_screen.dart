import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/analysis_provider.dart';
import '../widgets/pitch_input.dart';
import 'dashboard_screen.dart';
import 'error_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../core/constants.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(analysisProvider);

    // Navigate to result screen when analysis is ready
    ref.listen(analysisProvider, (previous, next) {
      if (next.analysis != null && !next.isLoading) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
      if (next.errorMessage != null) {
        if (next.errorType == ErrorType.validation) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (next.errorType == ErrorType.major) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorScreen(
                message: next.errorMessage!,
                onRetry: () {
                  ref.read(analysisProvider.notifier).retry();
                },
              ),
            ),
          );
        }
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Elements (Subtle Gold Line)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(AppConstants.accentHex).withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'VākyaAI',
                    style: GoogleFonts.cinzel(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: const Color(AppConstants.accentHex),
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Refine Your Words.\nCommand Your Vision.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzelDecorative(
                      fontSize: 24,
                      color: const Color(AppConstants.secondaryHex),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Transformation of a simple thought into a compelling narrative through the precision of ancient wisdom and modern AI.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 60),
                  const PitchInputWidget(),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            if (analysisState.isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SpinKitDancingSquare(
                        color: Color(AppConstants.accentHex),
                        size: 60.0,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Analyzing Manuscript...',
                        style: GoogleFonts.cinzel(
                          color: const Color(AppConstants.accentHex),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const LoadingIndicatorText(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LoadingIndicatorText extends StatefulWidget {
  const LoadingIndicatorText({super.key});

  @override
  State<LoadingIndicatorText> createState() => _LoadingIndicatorTextState();
}

class _LoadingIndicatorTextState extends State<LoadingIndicatorText> {
  int _currentStep = 0;
  final List<String> _steps = [
    'Evaluating clarity...',
    'Analyzing structure...',
    'Optimizing persuasion...',
    'Refining vocabulary...',
  ];

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _currentStep = (_currentStep + 1) % _steps.length;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _steps[_currentStep],
      style: GoogleFonts.inter(
        color: const Color(AppConstants.secondaryHex).withValues(alpha: 0.7),
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
