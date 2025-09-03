import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/app_colors.dart';

/// Chart widget for displaying caffeine intake history
class HistoryChart extends StatelessWidget {
  final Map<DateTime, double> data;

  const HistoryChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyChart();
    }

    final maxY = _getMaxY();
    final interval = _getOptimalInterval(maxY);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.grey200,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: interval,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}',
                  style: const TextStyle(
                    color: AppColors.grey500,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  final date = data.keys.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: const TextStyle(
                        color: AppColors.grey500,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: AppColors.grey200,
            width: 1,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _buildSpots(),
            isCurved: true,
            color: AppColors.primaryOrange,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primaryOrange,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryOrange.withOpacity(0.1),
            ),
          ),
        ],
        minY: 0,
        maxY: maxY,
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 48,
            color: AppColors.grey300,
          ),
          const SizedBox(height: 12),
          Text(
            'No data to display',
            style: TextStyle(
              color: AppColors.grey500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _buildSpots() {
    final spots = <FlSpot>[];
    final dates = data.keys.toList()..sort();
    
    for (int i = 0; i < dates.length; i++) {
      final date = dates[i];
      final value = data[date] ?? 0.0;
      spots.add(FlSpot(i.toDouble(), value));
    }
    
    return spots;
  }

  double _getMaxY() {
    if (data.isEmpty) return 400.0;
    
    final maxValue = data.values.reduce((a, b) => a > b ? a : b);
    // Add 20% padding and round to nearest 50
    final padded = maxValue * 1.2;
    return ((padded / 50).ceil() * 50).toDouble();
  }

  double _getOptimalInterval(double maxY) {
    // Target 4-5 divisions on Y axis
    const targetDivisions = 4.0;
    final rawInterval = maxY / targetDivisions;
    
    // Round to nice numbers (10, 25, 50, 100, 200, 250, 500, etc.)
    if (rawInterval <= 10) return 10;
    if (rawInterval <= 25) return 25;
    if (rawInterval <= 50) return 50;
    if (rawInterval <= 100) return 100;
    if (rawInterval <= 200) return 200;
    if (rawInterval <= 250) return 250;
    if (rawInterval <= 500) return 500;
    
    // For very high values, use multiples of 500
    return ((rawInterval / 500).ceil() * 500).toDouble();
  }
}
