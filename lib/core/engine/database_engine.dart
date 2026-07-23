import '../../domain/entities/student.dart';
import '../../domain/entities/department.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/enrollment.dart';
import 'index_manager.dart';

class DatabaseEngine {
  final IndexManager<Student> _studentIndexManager = IndexManager<Student>();

  final List<Department> _departments = [];
  final List<Course> _courses = [];
  final List<Enrollment> _enrollments = [];

  DatabaseEngine() {
    _studentIndexManager.createSecondaryIndex('departmentId');
    _studentIndexManager.createSecondaryIndex('major');
  }

  // Initial Seed
  void initialize({
    required List<Student> students,
    required List<Department> departments,
    required List<Course> courses,
    required List<Enrollment> enrollments,
  }) {
    _studentIndexManager.clear();
    _departments.clear();
    _courses.clear();
    _enrollments.clear();

    _departments.addAll(departments);
    _courses.addAll(courses);
    _enrollments.addAll(enrollments);

    for (var s in students) {
      _insertStudentIntoIndex(s);
    }
  }

  void _insertStudentIntoIndex(Student student) {
    _studentIndexManager.insert(
      student.id,
      student,
      {
        'departmentId': student.departmentId,
        'major': student.major,
      },
    );
  }

  // Getters
  List<Student> getAllStudents() {
    return _studentIndexManager.primaryIndex.values.toList();
  }

  List<Department> getAllDepartments() => List.unmodifiable(_departments);
  List<Course> getAllCourses() => List.unmodifiable(_courses);
  List<Enrollment> getAllEnrollments() => List.unmodifiable(_enrollments);

  /// O(1) Lookup by Primary Key
  Student? getStudentById(String id) {
    return _studentIndexManager.lookupByPk(id);
  }

  /// Secondary Index Lookup by Major
  List<Student> getStudentsByMajor(String major) {
    return _studentIndexManager.lookupBySecondaryIndex('major', major);
  }

  /// Insert Student with Primary Key uniqueness check
  void addStudent(Student student) {
    if (_studentIndexManager.lookupByPk(student.id) != null) {
      throw ArgumentError('Primary Key Violation: Student ID ${student.id} already exists.');
    }
    _insertStudentIntoIndex(student);
  }

  /// Update Student
  void updateStudent(Student updatedStudent) {
    final existing = _studentIndexManager.lookupByPk(updatedStudent.id);
    if (existing != null) {
      // Remove old secondary index references
      _studentIndexManager.remove(existing.id, {
        'departmentId': existing.departmentId,
        'major': existing.major,
      });
      // Insert updated
      _insertStudentIntoIndex(updatedStudent);
    }
  }

  /// Delete Student
  void deleteStudent(String id) {
    final existing = _studentIndexManager.lookupByPk(id);
    if (existing != null) {
      _studentIndexManager.remove(existing.id, {
        'departmentId': existing.departmentId,
        'major': existing.major,
      });
      // Delete cascade enrollments
      _enrollments.removeWhere((e) => e.studentId == id);
    }
  }

  /// Get enrollments for student
  List<Enrollment> getStudentEnrollments(String studentId) {
    return _enrollments.where((e) => e.studentId == studentId).toList();
  }
}
