import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/mood_model.dart';
import '../../utils/helpers.dart';

class MoodChartWidget extends StatelessWidget {
  final List<MoodModel> moods;

  const MoodChartWidget({super.key, required this.moods});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < moods.length) {
                    return Text(
                      Helpers.formatDate(moods[value.toInt()].timestamp),
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: moods
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value.moodLevel.toDouble(),
                      ))
                  .toList(),
              isCurved: true,
              color: Theme.of(context).primaryColor,
              barWidth: 3,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}