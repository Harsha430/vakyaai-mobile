import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analysis_model.dart';
import '../services/api_service.dart';

// Provider for the API Service
final apiServiceProvider = Provider((ref) => ApiService());

// State class for Analysis
enum ErrorType { none, validation, major }

class AnalysisState {
  final bool isLoading;
  final AnalysisModel? analysis;
  final String? errorMessage;
  final ErrorType errorType;
  final String lastPitch;

  AnalysisState({
    this.isLoading = false,
    this.analysis,
    this.errorMessage,
    this.errorType = ErrorType.none,
    this.lastPitch = '',
  });

  AnalysisState copyWith({
    bool? isLoading,
    AnalysisModel? analysis,
    String? errorMessage,
    ErrorType? errorType,
    String? lastPitch,
  }) {
    return AnalysisState(
      isLoading: isLoading ?? this.isLoading,
      analysis: analysis ?? this.analysis,
      errorMessage: errorMessage ?? this.errorMessage,
      errorType: errorType ?? this.errorType,
      lastPitch: lastPitch ?? this.lastPitch,
    );
  }
}

// Notifier for Analysis
class AnalysisNotifier extends StateNotifier<AnalysisState> {
  final ApiService _apiService;

  AnalysisNotifier(this._apiService) : super(AnalysisState());

  Future<void> analyzePitch(String pitchText) async {
    if (pitchText.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please enter your pitch first.',
        errorType: ErrorType.validation,
      );
      return;
    }

    state = state.copyWith(
      isLoading: true, 
      errorMessage: null,
      errorType: ErrorType.none,
      lastPitch: pitchText,
    );

    try {
      final result = await _apiService.analyzePitch(pitchText);
      state = state.copyWith(isLoading: false, analysis: result);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        errorType: ErrorType.major,
      );
    }
  }

  void retry() {
    if (state.lastPitch.isNotEmpty) {
      analyzePitch(state.lastPitch);
    }
  }

  void reset() {
    state = AnalysisState();
  }
}

// Provider for the Analysis state
final analysisProvider = StateNotifierProvider<AnalysisNotifier, AnalysisState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AnalysisNotifier(apiService);
});
