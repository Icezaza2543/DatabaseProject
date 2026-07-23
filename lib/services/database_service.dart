import 'package:flutter/foundation.dart';
import '../domain/entities/student.dart';
import '../presentation/providers/database_provider.dart';

/// Legacy Service Alias maintaining backward compatibility with original codebase
class DatabaseService extends ChangeNotifier {
  final DatabaseProvider _provider = DatabaseProvider();

  List<Student> get students => _provider.filteredStudents;

  void addStudent(Student student) {
    _provider.addStudent(student);
    notifyListeners();
  }

  void updateStudent(Student updatedStudent) {
    _provider.updateStudent(updatedStudent);
    notifyListeners();
  }

  void deleteStudent(String id) {
    _provider.deleteStudent(id);
    notifyListeners();
  }
}
