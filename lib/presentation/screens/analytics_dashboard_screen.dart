import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/database_provider.dart';
import '../widgets/analytics_card.dart';
import '../../core/constants/app_colors.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context);
    final summary = dbProvider.analyticsSummary;

    final int totalStudents = summary['totalStudents'] ?? 0;
    final double avgGpa = (summary['averageGpa'] as num?)?.toDouble() ?? 0.0;
    final int highPerformers = summary['highPerformers'] ?? 0;
    final int probationCount = summary['probationCount'] ?? 0;

    final Map<String, int> majorDist = Map<String, int>.from(summary['majorDistribution'] ?? {});
    final Map<String, int> gpaRanges = Map<String, int>.from(summary['gpaRanges'] ?? {});

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Row
            Row(
              children: [
                Expanded(
                  child: AnalyticsCard(
                    title: 'Total Enrolled Students',
                    value: totalStudents.toString(),
                    subtitle: 'Across 5 Engineering Majors',
                    icon: Icons.groups_outlined,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AnalyticsCard(
                    title: 'Faculty Mean GPA',
                    value: avgGpa.toStringAsFixed(2),
                    subtitle: 'Out of 4.00 Max GPA',
                    icon: Icons.auto_graph_outlined,
                    color: AppColors.teal,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AnalyticsCard(
                    title: 'First-Class Honors',
                    value: highPerformers.toString(),
                    subtitle: 'Students with GPA >= 3.50',
                    icon: Icons.emoji_events_outlined,
                    color: AppColors.emerald,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AnalyticsCard(
                    title: 'Probation Alerts',
                    value: probationCount.toString(),
                    subtitle: 'Students with GPA < 2.50',
                    icon: Icons.warning_amber_outlined,
                    color: AppColors.rose,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Charts Row (GPA Histogram & Major Distribution)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GPA Range Histogram
                Expanded(
                  flex: 3,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'GPA Distribution Histogram',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.bar_chart, color: AppColors.accent),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Frequency of students grouped by academic GPA brackets',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            height: 240,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: (gpaRanges.values.isEmpty
                                        ? 5
                                        : (gpaRanges.values.reduce((a, b) => a > b ? a : b) + 2))
                                    .toDouble(),
                                barTouchData: BarTouchDataEnabled(false),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (context, value) => const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                    margin: 12,
                                    getTitles: (double value) {
                                      final keys = gpaRanges.keys.toList();
                                      int idx = value.toInt();
                                      if (idx >= 0 && idx < keys.length) {
                                        return keys[idx];
                                      }
                                      return '';
                                    },
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (context, value) => const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                    ),
                                    interval: 1,
                                  ),
                                  topTitles: SideTitles(showTitles: false),
                                  rightTitles: SideTitles(showTitles: false),
                                ),
                                borderData: FlBorderData(show: false),
                                barGroups: gpaRanges.entries.toList().asMap().entries.map((entry) {
                                  int index = entry.key;
                                  int count = entry.value.value;
                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        y: count.toDouble(),
                                        colors: [AppColors.accent, AppColors.accentLight],
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                        width: 24,
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Department Distribution Pie Chart
                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Major Enrolment Share',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.pie_chart_outline, color: AppColors.teal),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Student distribution ratio across departments',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            height: 180,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 3,
                                centerSpaceRadius: 35,
                                sections: majorDist.entries.map((entry) {
                                  final major = entry.key;
                                  final count = entry.value;
                                  final color = _getMajorColor(major);
                                  return PieChartSectionData(
                                    color: color,
                                    value: count.toDouble(),
                                    title: '$major\n($count)',
                                    radius: 50,
                                    titleStyle: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Department Breakdown Legend
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: majorDist.keys.map((m) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: _getMajorColor(m),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$m: ${majorDist[m]}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getMajorColor(String major) {
    switch (major) {
      case 'CPE':
        return AppColors.accent;
      case 'SKE':
        return AppColors.teal;
      case 'EE':
        return AppColors.amber;
      case 'ME':
        return AppColors.rose;
      case 'CE':
        return AppColors.purple;
      default:
        return Colors.blueGrey;
    }
  }
}
