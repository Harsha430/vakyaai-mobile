import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/analysis_model.dart';

class ApiService {
  static const String geminiApiKey = AppConstants.geminiApiKey;
  static const String geminiEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  ApiService();

  Future<AnalysisModel> analyzePitch(String pitchText, {String targetAudience = 'General Investor'}) async {
    print('🚀 [API] Starting analyzePitch...');
    
    final url = Uri.parse(geminiEndpoint);
    
    final prompt = _buildPrompt(pitchText, targetAudience);

    try {
      print('📡 [API] Sending POST request...');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': geminiApiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 4000,
          },
        }),
      ).timeout(const Duration(seconds: 60));

      print('✅ [API] Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
         return _processResponse(response.body);
      } else {
        print('❌ [API] Error status code: ${response.statusCode}');
        throw Exception('Gemini API Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('💥 [API] Exception caught: $e');
      print('📋 [API] Stack trace: $stackTrace');
      return _getFallbackAnalysis(pitchText);
    }
  }

  String _buildPrompt(String pitchText, String targetAudience) {
    return '''
Act as an elite Copywriter and Startup Guru. Transform this raw pitch into professional artifacts.
DO NOT echo the input. CREATE new, high-conversion narratives.

OUTPUT: STRICT VALID JSON ONLY.

{
  "overall_score": 0-100,
  "scores": {"Impact":0-100, "Clarity":0-100, "Feasibility":0-100, "Market":0-100, "Execution":0-100},
  "strengths": ["Strategic advantage (10 words)"],
  "weaknesses": ["Critical gap (10 words)"],
  "suggestions": ["Actionable growth hack"],
  "improved_pitch": "A PROFESSSIONAL REWRITE. 2-3 paragraphs. Enrich with professional vocabulary, better flow, and a compelling 'Why Now' narrative. Do not repeat the input word-for-word.",
  "linkedin_hook": "A scroll-stopping social hook. Explain the 'disruption' factor. Use professional social media style.",
  "elevator_pitch": "A 60-second high-impact version. Focus on the 'Unfair Advantage'.",
  "formal_email": "A COMPLETE EMAIL. Include: Subject Line, Professional Greeting, Body, and a clear Call to Action (CTA).",
  "checklist": [{"label": "Essential Component", "status": true}],
  "analysis_id": "unique_id",
  "deck_structure": [{"slide_title": "Professional Title", "content": "THE TRUTH: What SPECIFICALLY should this slide say? (Bullet points of text)."}],
  "roadmap": ["Specific strategic milestone"],
  "resources": [{"title":"Relevant Startup Resource", "type":"Blog", "link":"url"}]
}

LIMITS: max 5 strengths/weaknesses, max 8 slides.
TARGET AUDIENCE: $targetAudience
RAW PITCH: $pitchText
''';
  }

  AnalysisModel _processResponse(String body) {
    print('\n🔍 [PARSE] Starting surgical process...');
    
    try {
      final data = jsonDecode(body);
      String generatedText = data['candidates'][0]['content']['parts'][0]['text'] ?? '';
      
      String cleanJson = generatedText.trim();
      // Remove potentially long preamble/postamble
      if (cleanJson.contains('```json')) {
        cleanJson = cleanJson.split('```json').last.split('```').first.trim();
      } else if (cleanJson.contains('```')) {
        cleanJson = cleanJson.split('```').last.split('```').first.trim();
      }
      
      print('✅ [PARSE] Extracted text length: ${cleanJson.length}');

      String repaired = _repairJsonSurgically(cleanJson);
      
      try {
        final jsonData = jsonDecode(repaired);
        print('📦 [API-DEBUG] Keys found: ${jsonData.keys.toList()}');
        return AnalysisModel.fromJson(jsonData);
      } catch (e) {
        print('⚠️ [PARSE] Surgical repair failed to decode: $e');
        
        // Find the last "}" that looks like it's at a top-level key/value boundary
        // This is a bit risky but can recover mid-array truncations
        try {
          print('🩹 [PARSE] Last-ditch: Brute force closure...');
          int lastBrace = cleanJson.lastIndexOf('}');
          if (lastBrace != -1) {
             String cutJson = cleanJson.substring(0, lastBrace + 1);
             // Verify it still starts with {
             if (!cutJson.startsWith('{')) cutJson = '{' + cutJson.substring(cutJson.indexOf('{') + 1);
             final jsonData = jsonDecode(cutJson);
             return AnalysisModel.fromJson(jsonData);
          }
        } catch (_) {}
        
        return _getFallbackAnalysis('Critical parsing failure');
      }
    } catch (e) {
      print('❌ [PARSE] Global Error: $e');
      return _getFallbackAnalysis('Extraction failure');
    }
  }

  String _repairJsonSurgically(String json) {
    String working = json.trim();
    if (!working.startsWith('{')) {
      int firstBrace = working.indexOf('{');
      if (firstBrace != -1) working = working.substring(firstBrace);
      else return working;
    }
    
    // Remove trailing junk until we hit a "valid" ending character for a JSON fragment
    while (working.isNotEmpty && !working.endsWith('}') && !working.endsWith(']') && !working.endsWith('"') && !working.endsWith('true') && !working.endsWith('false') && !RegExp(r'\d$').hasMatch(working)) {
      working = working.substring(0, working.length - 1).trim();
    }

    // 1. Close unclosed strings
    int quotes = '"'.allMatches(working).length;
    if (quotes % 2 != 0) working += '"';

    // 2. Structural balancing
    int openBraces = '{'.allMatches(working).length;
    int closeBraces = '}'.allMatches(working).length;
    int openBrackets = '['.allMatches(working).length;
    int closeBrackets = ']'.allMatches(working).length;

    // We must close brackets before braces because arrays are likely children of the main object
    if (openBrackets > closeBrackets) working += ']' * (openBrackets - closeBrackets);
    if (openBraces > closeBraces) working += '}' * (openBraces - closeBraces);

    return working;
  }

  AnalysisModel _getFallbackAnalysis(String pitchText) {
    return AnalysisModel(
      analysisId: 'fallback-${DateTime.now().millisecondsSinceEpoch}',
      overallScore: 75.0,
      scores: {
        'Clarity': 75,
        'Impact': 70,
        'Innovation': 72,
        'Technical Depth': 74,
        'Persuasiveness': 73,
      },
      strengths: [
        "Clear problem explanation",
        "Logical solution flow",
        "Relevant use case"
      ],
      weaknesses: [
        "Impact not strongly emphasized",
        "Technical depth could be clearer"
      ],
      suggestions: ["Add specific metrics", "Highlight team expertise"],
      improvedPitch: "This solution addresses a key problem using a structured and scalable technical approach, delivering measurable real-world impact.",
      linkedinHook: "Revolutionizing industry standards with a scalable AI-driven approach. #Innovation #Startup",
      elevatorPitch: "We provide a scalable solution for key industry problems, delivering real-world impact through cutting-edge technology.",
      formalEmail: "Subject: Introduction to [Project Name]\n\nDear Stakeholder,\n\nI am reaching out to share our latest vision for solving key industry challenges...",
      checklist: [
        {"label": "Problem Defined", "status": true},
        {"label": "Solution Scalable", "status": true},
        {"label": "Market Identified", "status": false},
      ],
      deckStructure: [
        {"slide_title": "Problem", "content": "Define the core problem"},
        {"slide_title": "Solution", "content": "Present your solution"},
        {"slide_title": "Market", "content": "Show market opportunity"},
      ],
      roadmap: [
        "Q1: MVP Development",
        "Q2: Beta Testing",
        "Q3: Market Launch",
        "Q4: Scale Operations"
      ],
      resources: [
        {"title": "Startup Pitch Guide", "type": "Blog", "link": "https://example.com/guide"},
        {"title": "Investor Deck Template", "type": "Deck", "link": "https://example.com/template"},
      ],
    );
  }
}
