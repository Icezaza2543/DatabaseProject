import 'package:flutter/foundation.dart';
import '../models/student.dart';

class DatabaseService extends ChangeNotifier {
  // Mock data for the database
  List<Student> _students = [
    Student(id: '64001', name: 'Alice Smith', age: 21, major: 'CPE', gpa: 3.8),
    Student(id: '64002', name: 'Bob Johnson', age: 22, major: 'SKE', gpa: 3.5),
    Student(id: '64003', name: 'Charlie Brown', age: 20, major: 'CPE', gpa: 3.2),
    Student(id: '64004', name: 'Diana Prince', age: 21, major: 'EE', gpa: 3.9),
  ];

  List<Student> get students => _students;

  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  void updateStudent(Student updatedStudent) {
    final index = _students.indexWhere((s) => s.id == updatedStudent.id);
    if (index != -1) {
      _students[index] = updatedStudent;
      notifyListeners();
    }
  }

  void deleteStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
