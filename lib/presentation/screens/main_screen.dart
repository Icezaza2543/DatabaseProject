import 'package:flutter/material.dart';
import 'student_management_screen.dart';
import 'analytics_dashboard_screen.dart';
import 'sql_console_screen.dart';
import '../../core/constants/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.storage_rounded, color: AppColors.accentLight, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'CPE Database Management System',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Computer Engineering Standard • 3NF Relational Engine',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentLight,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(
              icon: Icon(Icons.table_chart_outlined, size: 20),
              text: 'Student Records',
            ),
            Tab(
              icon: Icon(Icons.analytics_outlined, size: 20),
              text: 'Analytics & Insights',
            ),
            Tab(
              icon: Icon(Icons.terminal_rounded, size: 20),
              text: 'SQL Query Console',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          StudentManagementScreen(),
          AnalyticsDashboardScreen(),
          SqlConsoleScreen(),
        ],
      ),
    );
  }
}
