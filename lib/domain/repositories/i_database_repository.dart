import '../entities/student.dart';
import '../entities/department.dart';
import '../entities/course.dart';
import '../entities/enrollment.dart';

class QueryResult {
  final List<String> columns;
  final List<Map<String, dynamic>> rows;
  final int executionTimeMs;
  final String? error;
  final String queryExecuted;

  QueryResult({
    required this.columns,
    required this.rows,
    required this.executionTimeMs,
    this.error,
    required this.queryExecuted,
  });

  bool get isSuccess => error == null;
}

abstract class IDatabaseRepository {
  List<Student> getAllStudents();
  Student? getStudentById(String id);
  void addStudent(Student student);
  void updateStudent(Student student);
  void deleteStudent(String id);

  List<Department> getAllDepartments();
  List<Course> getAllCourses();
  List<Enrollment> getStudentEnrollments(String studentId);

  QueryResult executeSqlQuery(String sqlQuery);
  Map<String, dynamic> getAnalyticsSummary();
}
