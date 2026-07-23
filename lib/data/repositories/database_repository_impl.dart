import '../../domain/entities/student.dart';
import '../../domain/entities/department.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/repositories/i_database_repository.dart';
import '../../core/engine/database_engine.dart';
import '../../core/engine/sql_parser.dart';
import '../sample_data.dart';

class DatabaseRepositoryImpl implements IDatabaseRepository {
  final DatabaseEngine _engine = DatabaseEngine();

  DatabaseRepositoryImpl() {
    _engine.initialize(
      students: SampleData.students,
      departments: SampleData.departments,
      courses: SampleData.courses,
      enrollments: SampleData.enrollments,
    );
  }

  @override
  List<Student> getAllStudents() {
    return _engine.getAllStudents();
  }

  @override
  Student? getStudentById(String id) {
    return _engine.getStudentById(id);
  }

  @override
  void addStudent(Student student) {
    _engine.addStudent(student);
  }

  @override
  void updateStudent(Student student) {
    _engine.updateStudent(student);
  }

  @override
  void deleteStudent(String id) {
    _engine.deleteStudent(id);
  }

  @override
  List<Department> getAllDepartments() {
    return _engine.getAllDepartments();
  }

  @override
  List<Course> getAllCourses() {
    return _engine.getAllCourses();
  }

  @override
  List<Enrollment> getStudentEnrollments(String studentId) {
    return _engine.getStudentEnrollments(studentId);
  }

  @override
  QueryResult executeSqlQuery(String sqlQuery) {
    return SqlParser.parseAndExecute(
      rawSql: sqlQuery,
      students: _engine.getAllStudents(),
      departments: _engine.getAllDepartments(),
      courses: _engine.getAllCourses(),
      enrollments: _engine.getAllEnrollments(),
    );
  }

  @override
  Map<String, dynamic> getAnalyticsSummary() {
    final students = _engine.getAllStudents();
    if (students.isEmpty) {
      return {
        'totalStudents': 0,
        'averageGpa': 0.0,
        'highPerformers': 0,
        'probationCount': 0,
        'majorDistribution': <String, int>{},
        'gpaRanges': <String, int>{},
      };
    }

    final totalStudents = students.length;
    final totalGpa = students.fold<double>(0.0, (sum, s) => sum + s.gpa);
    final avgGpa = totalGpa / totalStudents;

    final highPerformers = students.where((s) => s.gpa >= 3.5).length;
    final probationCount = students.where((s) => s.gpa < 2.5).length;

    // Major distribution
    final Map<String, int> majorDist = {};
    for (var s in students) {
      majorDist[s.major] = (majorDist[s.major] ?? 0) + 1;
    }

    // GPA histogram buckets
    final Map<String, int> gpaRanges = {
      '3.50 - 4.00': 0,
      '3.00 - 3.49': 0,
      '2.50 - 2.99': 0,
      '2.00 - 2.49': 0,
      '< 2.00': 0,
    };

    for (var s in students) {
      if (s.gpa >= 3.5) {
        gpaRanges['3.50 - 4.00'] = gpaRanges['3.50 - 4.00']! + 1;
      } else if (s.gpa >= 3.0) {
        gpaRanges['3.00 - 3.49'] = gpaRanges['3.00 - 3.49']! + 1;
      } else if (s.gpa >= 2.5) {
        gpaRanges['2.50 - 2.99'] = gpaRanges['2.50 - 2.99']! + 1;
      } else if (s.gpa >= 2.0) {
        gpaRanges['2.00 - 2.49'] = gpaRanges['2.00 - 2.49']! + 1;
      } else {
        gpaRanges['< 2.00'] = gpaRanges['< 2.00']! + 1;
      }
    }

    return {
      'totalStudents': totalStudents,
      'averageGpa': avgGpa,
      'highPerformers': highPerformers,
      'probationCount': probationCount,
      'majorDistribution': majorDist,
      'gpaRanges': gpaRanges,
    };
  }
}
