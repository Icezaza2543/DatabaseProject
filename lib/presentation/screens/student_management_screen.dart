import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/database_provider.dart';
import '../../domain/entities/student.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/add_student_dialog.dart';
import '../widgets/student_detail_dialog.dart';

class StudentManagementScreen extends StatelessWidget {
  const StudentManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context);
    final students = dbProvider.filteredStudents;
    final selectedMajor = dbProvider.selectedMajor;

    final majors = ['ALL', 'CPE', 'SKE', 'EE', 'ME', 'CE'];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Controls Bar (Search + Major Filter Chips)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (v) => dbProvider.setSearchQuery(v),
                            decoration: InputDecoration(
                              hintText: 'Search by Student Name, ID, or Email...',
                              prefixIcon: const Icon(Icons.search, color: AppColors.accent),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => const AddStudentDialog(),
                            );
                          },
                          icon: const Icon(Icons.person_add_rounded, size: 20),
                          label: const Text('Add Student', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Major Filter Chips
                    Row(
                      children: [
                        Text(
                          'Filter Major: ',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Wrap(
                          spacing: 8,
                          children: majors.map((m) {
                            final isSelected = selectedMajor == m;
                            return ChoiceChip(
                              label: Text(m),
                              selected: isSelected,
                              selectedColor: AppColors.accent,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (_) => dbProvider.setSelectedMajor(m),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Records Summary Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Relational Student Records (${students.length} found)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Click column header to sort index',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Records Data Table
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: students.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open_outlined, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'No student records match search criteria.',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(AppColors.primaryLight.withOpacity(0.05)),
                              sortColumnIndex: _getSortIndex(dbProvider.sortColumn),
                              sortAscending: dbProvider.sortAscending,
                              columns: [
                                DataColumn(
                                  label: const Text('Student ID', style: TextStyle(fontWeight: FontWeight.bold)),
                                  onSort: (_, __) => dbProvider.setSorting('id'),
                                ),
                                DataColumn(
                                  label: const Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold)),
                                  onSort: (_, __) => dbProvider.setSorting('name'),
                                ),
                                DataColumn(
                                  label: const Text('Major', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: const Text('GPA', style: TextStyle(fontWeight: FontWeight.bold)),
                                  onSort: (_, __) => dbProvider.setSorting('gpa'),
                                ),
                                DataColumn(
                                  label: const Text('Year', style: TextStyle(fontWeight: FontWeight.bold)),
                                  onSort: (_, __) => dbProvider.setSorting('admissionYear'),
                                ),
                                DataColumn(
                                  label: const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                const DataColumn(
                                  label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                              rows: students.map((student) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        student.id,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundColor: _getMajorColor(student.major).withOpacity(0.15),
                                            child: Text(
                                              student.name.substring(0, 1),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: _getMajorColor(student.major),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(student.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                                              Text(student.email, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Chip(
                                        label: Text(
                                          student.major,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: _getMajorColor(student.major),
                                          ),
                                        ),
                                        backgroundColor: _getMajorColor(student.major).withOpacity(0.1),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: student.gpa >= 3.5
                                              ? AppColors.emerald.withOpacity(0.1)
                                              : (student.gpa < 2.5 ? AppColors.rose.withOpacity(0.1) : Colors.grey.shade100),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          student.gpa.toStringAsFixed(2),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: student.gpa >= 3.5
                                                ? AppColors.emerald
                                                : (student.gpa < 2.5 ? AppColors.rose : AppColors.textPrimary),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(student.admissionYear.toString())),
                                    DataCell(
                                      Text(
                                        student.status,
                                        style: TextStyle(
                                          color: student.status == 'Active' ? AppColors.emerald : AppColors.amber,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.visibility_outlined, color: AppColors.accent, size: 20),
                                            tooltip: 'View Transcript',
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => StudentDetailDialog(student: student),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined, color: AppColors.amber, size: 20),
                                            tooltip: 'Edit Student',
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => AddStudentDialog(initialStudent: student),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: AppColors.rose, size: 20),
                                            tooltip: 'Delete Student',
                                            onPressed: () => _confirmDelete(context, dbProvider, student),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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

  int _getSortIndex(String column) {
    switch (column) {
      case 'id':
        return 0;
      case 'name':
        return 1;
      case 'gpa':
        return 3;
      case 'admissionYear':
        return 4;
      default:
        return 0;
    }
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

  void _confirmDelete(BuildContext context, DatabaseProvider provider, Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete student "${student.name}" (ID: ${student.id})?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.rose),
            onPressed: () {
              provider.deleteStudent(student.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Student record deleted.')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
