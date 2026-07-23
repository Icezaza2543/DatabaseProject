import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/database_provider.dart';
import '../../core/constants/app_colors.dart';

class SqlConsoleScreen extends StatefulWidget {
  const SqlConsoleScreen({Key? key}) : super(key: key);

  @override
  _SqlConsoleScreenState createState() => _SqlConsoleScreenState();
}

class _SqlConsoleScreenState extends State<SqlConsoleScreen> {
  final TextEditingController _queryController = TextEditingController(
    text: 'SELECT * FROM students WHERE gpa >= 3.5 ORDER BY gpa DESC;',
  );

  final List<String> _presets = [
    'SELECT * FROM students;',
    'SELECT * FROM students WHERE gpa >= 3.5;',
    'SELECT * FROM students WHERE major = \'CPE\';',
    'SELECT * FROM departments;',
    'SELECT * FROM courses;',
    'SELECT * FROM enrollments;',
  ];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _runQuery() {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    provider.executeSqlQuery(_queryController.text);
  }

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context);
    final queryResult = dbProvider.lastQueryResult;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SQL Console Input Header
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.terminal_rounded, color: AppColors.accent),
                            SizedBox(width: 8),
                            Text(
                              'Interactive SQL Query Console',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _runQuery,
                          icon: const Icon(Icons.play_arrow_rounded, size: 20),
                          label: const Text('Execute SQL', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Query Editor
                    TextField(
                      controller: _queryController,
                      maxLines: 3,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        hintText: 'Enter SQL Query here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Query Presets
                    Row(
                      children: [
                        Text(
                          'SQL Presets: ',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _presets.map((preset) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ActionChip(
                                    label: Text(
                                      preset,
                                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _queryController.text = preset;
                                      });
                                      _runQuery();
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Execution Output Header
            if (queryResult != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Query Results',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: queryResult.isSuccess ? AppColors.emerald.withOpacity(0.1) : AppColors.rose.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${queryResult.rows.length} rows (${queryResult.executionTimeMs} ms)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: queryResult.isSuccess ? AppColors.emerald : AppColors.rose,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 8),

            // Query Results Table Output
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: queryResult == null
                    ? const Center(child: Text('Execute a query to inspect relational table output.'))
                    : queryResult.error != null
                        ? Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, color: AppColors.rose, size: 48),
                                const SizedBox(height: 12),
                                Text(
                                  queryResult.error!,
                                  style: const TextStyle(color: AppColors.rose, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.all(AppColors.primary.withOpacity(0.05)),
                                  columns: queryResult.columns.map((col) {
                                    return DataColumn(
                                      label: Text(
                                        col.toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    );
                                  }).toList(),
                                  rows: queryResult.rows.map((row) {
                                    return DataRow(
                                      cells: queryResult.columns.map((col) {
                                        final val = row[col];
                                        return DataCell(
                                          Text(
                                            val != null ? val.toString() : 'NULL',
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }).toList(),
                                ),
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
