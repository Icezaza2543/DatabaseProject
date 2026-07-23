import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/student.dart';
import '../../core/utils/validator.dart';
import '../providers/database_provider.dart';
import '../../core/constants/app_colors.dart';

class AddStudentDialog extends StatefulWidget {
  final Student? initialStudent;

  const AddStudentDialog({Key? key, this.initialStudent}) : super(key: key);

  @override
  _AddStudentDialogState createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _gpaController;
  late String _selectedMajor;
  late String _selectedStatus;

  final List<String> _majors = ['CPE', 'SKE', 'EE', 'ME', 'CE'];
  final List<String> _statuses = ['Active', 'Graduated', 'Probation'];

  @override
  void initState() {
    super.initState();
    final s = widget.initialStudent;
    _idController = TextEditingController(text: s?.id ?? '');
    _nameController = TextEditingController(text: s?.name ?? '');
    _emailController = TextEditingController(text: s?.email ?? '');
    _ageController = TextEditingController(text: s?.age.toString() ?? '20');
    _gpaController = TextEditingController(text: s?.gpa.toString() ?? '3.00');
    _selectedMajor = s?.major ?? 'CPE';
    _selectedStatus = s?.status ?? 'Active';
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

      final newStudent = Student(
        id: _idController.text.trim(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : '${_idController.text.trim()}@ku.th',
        age: int.parse(_ageController.text.trim()),
        departmentId: 'DEP_${_selectedMajor}',
        major: _selectedMajor,
        gpa: double.parse(_gpaController.text.trim()),
        admissionYear: 2020 + (int.tryParse(_idController.text.trim().substring(0, 2)) ?? 21),
        status: _selectedStatus,
      );

      if (widget.initialStudent != null) {
        dbProvider.updateStudent(newStudent);
      } else {
        dbProvider.addStudent(newStudent);
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.initialStudent != null
                ? 'Student record updated successfully!'
                : 'Student added to database successfully!',
          ),
          backgroundColor: AppColors.emerald,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final existingIds = dbProvider.rawStudents.map((s) => s.id).toList();

    if (widget.initialStudent != null) {
      existingIds.remove(widget.initialStudent!.id);
    }

    final isEdit = widget.initialStudent != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(
            isEdit ? Icons.edit_note : Icons.person_add_rounded,
            color: AppColors.accent,
          ),
          const SizedBox(width: 10),
          Text(
            isEdit ? 'Edit Student Record' : 'Add New Student',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          width: 440,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _idController,
                  enabled: !isEdit,
                  decoration: const InputDecoration(
                    labelText: 'Student ID (8 digits)',
                    hintText: 'e.g. 64010008',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => Validator.validateStudentId(v, existingIds),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'e.g. John Doe',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: Validator.validateName,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'e.g. john.d@ku.th',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: Validator.validateEmail,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _gpaController,
                        decoration: const InputDecoration(
                          labelText: 'GPA (0.00 - 4.00)',
                          prefixIcon: Icon(Icons.grade_outlined),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: Validator.validateGpa,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          prefixIcon: Icon(Icons.cake_outlined),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: Validator.validateAge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedMajor,
                        decoration: const InputDecoration(
                          labelText: 'Major / Department',
                          prefixIcon: Icon(Icons.school_outlined),
                          border: OutlineInputBorder(),
                        ),
                        items: _majors.map((m) {
                          return DropdownMenuItem(value: m, child: Text(m));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedMajor = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Academic Status',
                          border: OutlineInputBorder(),
                        ),
                        items: _statuses.map((s) {
                          return DropdownMenuItem(value: s, child: Text(s));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedStatus = val);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _submit,
          icon: const Icon(Icons.save_rounded, size: 18),
          label: Text(isEdit ? 'Update Record' : 'Save Record'),
        ),
      ],
    );
  }
}
