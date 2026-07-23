import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/student.dart';
import '../providers/database_provider.dart';
import '../../core/constants/app_colors.dart';

class StudentDetailDialog extends StatelessWidget {
  final Student student;

  const StudentDetailDialog({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final enrollments = dbProvider.getStudentEnrollments(student.id);
    final courses = dbProvider.courses;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.accent.withOpacity(0.15),
            child: Text(
              student.major,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'ID: ${student.id} | ${student.major} Department',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: student.status == 'Active'
                  ? AppColors.emerald.withOpacity(0.1)
                  : AppColors.rose.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: student.status == 'Active' ? AppColors.emerald : AppColors.rose,
              ),
            ),
            child: Text(
              student.status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: student.status == 'Active' ? AppColors.emerald : AppColors.rose,
              ),
            ),
          ),
        ],
      ),
      content: Container(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              // Metadata Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoTile('Cumulative GPA', student.gpa.toStringAsFixed(2), Icons.grade),
                  _infoTile('Email Address', student.email, Icons.email_outlined),
                  _infoTile('Admission Year', student.admissionYear.toString(), Icons.calendar_today),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Academic Course Enrollments & Grades',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              enrollments.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'No enrollment records registered in database.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Table(
                      border: TableBorder.all(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(4),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey.shade100),
                          children: const [
                            Padding(padding: EdgeInsets.all(8), child: Text('Code', style: TextStyle(fontWeight: FontWeight.bold))),
                            Padding(padding: EdgeInsets.all(8), child: Text('Course Title', style: TextStyle(fontWeight: FontWeight.bold))),
                            Padding(padding: EdgeInsets.all(8), child: Text('Semester', style: TextStyle(fontWeight: FontWeight.bold))),
                            Padding(padding: EdgeInsets.all(8), child: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                        ...enrollments.map((e) {
                          final crs = courses.firstWhere(
                            (c) => c.id == e.courseId,
                            orElse: () => const Course(id: '', code: 'N/A', title: 'Unknown', credits: 3, departmentId: ''),
                          );
                          return TableRow(
                            children: [
                              Padding(padding: const EdgeInsets.all(8), child: Text(crs.code)),
                              Padding(padding: const EdgeInsets.all(8), child: Text(crs.title)),
                              Padding(padding: const EdgeInsets.all(8), child: Text(e.semester)),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  e.grade,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _infoTile(String title, String val, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
