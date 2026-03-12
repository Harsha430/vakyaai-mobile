import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';

class ScoreChartWidget extends StatelessWidget {
  final Map<String, int> scores;

  const ScoreChartWidget({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = scores.keys.toList();
    
    return SizedBox(
      height: 350,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          dataSets: [
            RadarDataSet(
              fillColor: const Color(AppConstants.accentHex).withValues(alpha: 0.2),
              borderColor: const Color(AppConstants.accentHex),
              entryRadius: 3,
              dataEntries: categories.map((cat) {
                return RadarEntry(value: scores[cat]!.toDouble());
              }).toList(),
            ),
          ],
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.white24, width: 1),
          titlePositionPercentageOffset: 0.15,
          titleTextStyle: GoogleFonts.cinzel(color: Colors.white70, fontSize: 10),
          getTitle: (index, angle) {
            if (index >= 0 && index < categories.length) {
              return RadarChartTitle(
                text: _formatKey(categories[index]),
                angle: angle,
              );
            }
            return const RadarChartTitle(text: '');
          },
          tickCount: 5,
          ticksTextStyle: const TextStyle(color: Colors.white24, fontSize: 8),
          gridBorderData: const BorderSide(color: Colors.white10, width: 1),
        ),
      ),
    );
  }

  String _formatKey(String key) {
    return key.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join(' ');
  }
}
