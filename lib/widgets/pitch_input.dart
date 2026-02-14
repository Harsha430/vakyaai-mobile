import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/analysis_provider.dart';
import '../core/constants.dart';

class PitchInputWidget extends ConsumerStatefulWidget {
  const PitchInputWidget({super.key});

  @override
  ConsumerState<PitchInputWidget> createState() => _PitchInputWidgetState();
}

class _PitchInputWidgetState extends ConsumerState<PitchInputWidget> {
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;
  
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _selectedAudience = 'Investors';
  
  final List<String> _audiences = ['Investors', 'Technical Juries', 'Professors', 'Accelerators'];
  final List<Map<String, String>> _templates = [
    {'label': 'Hackathon', 'text': 'Problem: \nSolution: \nTech Stack: \nImpact: '},
    {'label': 'Seed Round', 'text': 'The Problem: \nOur Solution: \nMarket Size: \nMonetization: '},
    {'label': 'Academic Viva', 'text': 'Objective: \nMethodology: \nFindings: \nContribution: '},
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _controller.addListener(() {
      setState(() {
        _charCount = _controller.text.length;
      });
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _controller.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Audience Selector
        Text(
          'SELECT YOUR AUDIENCE',
          style: GoogleFonts.cinzel(color: const Color(AppConstants.accentHex), fontSize: 12, fontWeight: FontWeight.bold),
        ).animate().fadeIn(),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(AppConstants.accentHex).withValues(alpha: 0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedAudience,
              isExpanded: true,
              dropdownColor: const Color(AppConstants.primaryBgHex),
              style: GoogleFonts.inter(color: Colors.white),
              items: _audiences.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedAudience = newValue!;
                });
              },
            ),
          ),
        ).animate().fadeIn().slideX(begin: -0.1),
        const SizedBox(height: 24),

        // Template Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _templates.map((template) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  label: Text(template['label']!),
                  backgroundColor: const Color(AppConstants.accentHex).withValues(alpha: 0.1),
                  labelStyle: GoogleFonts.cinzel(color: const Color(AppConstants.accentHex), fontSize: 10),
                  onPressed: () {
                    _controller.text = template['text']!;
                  },
                ),
              );
            }).toList(),
          ),
        ).animate().fadeIn(),
        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: const Color(AppConstants.secondaryHex).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(AppConstants.accentHex).withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller,
                  maxLines: 8,
                  minLines: 5,
                  style: GoogleFonts.inter(
                    color: const Color(AppConstants.secondaryHex),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Present your vision here...',
                    hintStyle: GoogleFonts.inter(
                      color: const Color(AppConstants.secondaryHex).withValues(alpha: 0.3),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    suffixIcon: IconButton(
                      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      color: const Color(AppConstants.accentHex),
                      onPressed: _listen,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '$_charCount characters',
                    style: GoogleFonts.inter(
                      color: const Color(AppConstants.accentHex).withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn().scale(delay: 200.ms),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              ref.read(analysisProvider.notifier).analyzePitch(_controller.text);
            },
            style: ElevatedButton.styleFrom(
              shadowColor: const Color(AppConstants.accentHex).withValues(alpha: 0.5),
              elevation: 10,
            ).copyWith(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return const Color(AppConstants.accentHex);
              }),
            ),
            child: Text(
              'ANALYZE MANUSCRIPT',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }
}
