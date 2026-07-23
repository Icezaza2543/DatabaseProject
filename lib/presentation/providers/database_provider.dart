import 'package:flutter/foundation.dart';
import '../../domain/entities/student.dart';
import '../../domain/entities/department.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/repositories/i_database_repository.dart';
import '../../data/repositories/database_repository_impl.dart';

class DatabaseProvider extends ChangeNotifier {
  final IDatabaseRepository _repository = DatabaseRepositoryImpl();

  String _searchQuery = '';
  String _selectedMajor = 'ALL';
  String _sortColumn = 'id';
  bool _sortAscending = true;
  QueryResult? _lastQueryResult;

  DatabaseProvider() {
    executeSqlQuery('SELECT * FROM students');
  }

  // Getters
  String get searchQuery => _searchQuery;
  String get selectedMajor => _selectedMajor;
  String get sortColumn => _sortColumn;
  bool get sortAscending => _sortAscending;
  QueryResult? get lastQueryResult => _lastQueryResult;

  List<Department> get departments => _repository.getAllDepartments();
  List<Course> get courses => _repository.getAllCourses();

  List<Student> get rawStudents => _repository.getAllStudents();

  /// Filtered & Sorted list of students for presentation
  List<Student> get filteredStudents {
    List<Student> list = _repository.getAllStudents();

    // 1. Search Query Filter
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      list = list.where((s) {
        return s.id.toLowerCase().contains(query) ||
            s.name.toLowerCase().contains(query) ||
            s.email.toLowerCase().contains(query) ||
            s.major.toLowerCase().contains(query);
      }).toList();
    }

    // 2. Department / Major Filter
    if (_selectedMajor != 'ALL') {
      list = list.where((s) => s.major == _selectedMajor).toList();
    }

    // 3. Sorting
    list.sort((a, b) {
      int comp = 0;
      switch (_sortColumn) {
        case 'name':
          comp = a.name.compareTo(b.name);
          break;
        case 'gpa':
          comp = a.gpa.compareTo(b.gpa);
          break;
        case 'admissionYear':
          comp = a.admissionYear.compareTo(b.admissionYear);
          break;
        case 'id':
        default:
          comp = a.id.compareTo(b.id);
          break;
      }
      return _sortAscending ? comp : -comp;
    });

    return list;
  }

  Map<String, dynamic> get analyticsSummary => _repository.getAnalyticsSummary();

  List<Enrollment> getStudentEnrollments(String studentId) {
    return _repository.getStudentEnrollments(studentId);
  }

  // Actions
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedMajor(String major) {
    _selectedMajor = major;
    notifyListeners();
  }

  void setSorting(String column) {
    if (_sortColumn == column) {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumn = column;
      _sortAscending = true;
    }
    notifyListeners();
  }

  void addStudent(Student student) {
    _repository.addStudent(student);
    notifyListeners();
  }

  void updateStudent(Student student) {
    _repository.updateStudent(student);
    notifyListeners();
  }

  void deleteStudent(String id) {
    _repository.deleteStudent(id);
    notifyListeners();
  }

  void executeSqlQuery(String sql) {
    _lastQueryResult = _repository.executeSqlQuery(sql);
    notifyListeners();
  }
}
