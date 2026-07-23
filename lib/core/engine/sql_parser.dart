import '../../domain/entities/student.dart';
import '../../domain/entities/department.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/repositories/i_database_repository.dart';

class SqlParser {
  static QueryResult parseAndExecute({
    required String rawSql,
    required List<Student> students,
    required List<Department> departments,
    required List<Course> courses,
    required List<Enrollment> enrollments,
  }) {
    final stopwatch = Stopwatch()..start();
    final cleanSql = rawSql.trim().replaceAll(RegExp(r'\s+'), ' ');

    if (cleanSql.isEmpty) {
      return QueryResult(
        columns: [],
        rows: [],
        executionTimeMs: 0,
        error: 'Empty SQL query command.',
        queryExecuted: rawSql,
      );
    }

    final lowerSql = cleanSql.toLowerCase();

    try {
      if (lowerSql.startsWith('select')) {
        return _handleSelect(
          cleanSql,
          lowerSql,
          students,
          departments,
          courses,
          enrollments,
          stopwatch,
        );
      } else if (lowerSql.startsWith('insert')) {
        return QueryResult(
          columns: ['Status'],
          rows: [
            {'Status': 'Use Form Interface for safe INSERT statements with validation constraints.'}
          ],
          executionTimeMs: stopwatch.elapsedMilliseconds,
          queryExecuted: rawSql,
        );
      } else if (lowerSql.startsWith('delete')) {
        return QueryResult(
          columns: ['Status'],
          rows: [
            {'Status': 'Use Action Button in Records Table for safe DELETE statements.'}
          ],
          executionTimeMs: stopwatch.elapsedMilliseconds,
          queryExecuted: rawSql,
        );
      } else {
        return QueryResult(
          columns: [],
          rows: [],
          executionTimeMs: stopwatch.elapsedMilliseconds,
          error: 'Unsupported SQL Syntax. Supported commands: SELECT, INSERT, DELETE.',
          queryExecuted: rawSql,
        );
      }
    } catch (e) {
      stopwatch.stop();
      return QueryResult(
        columns: [],
        rows: [],
        executionTimeMs: stopwatch.elapsedMilliseconds,
        error: 'SQL Execution Error: ${e.toString()}',
        queryExecuted: rawSql,
      );
    }
  }

  static QueryResult _handleSelect(
    String cleanSql,
    String lowerSql,
    List<Student> students,
    List<Department> departments,
    List<Course> courses,
    List<Enrollment> enrollments,
    Stopwatch stopwatch,
  ) {
    // Extract Table Name
    final fromIndex = lowerSql.indexOf('from ');
    if (fromIndex == -1) {
      throw FormatException('Missing FROM clause in SELECT query.');
    }

    final afterFrom = cleanSql.substring(fromIndex + 5).trim();
    final parts = afterFrom.split(' ');
    final tableName = parts[0].replaceAll(';', '').toLowerCase();

    List<Map<String, dynamic>> rawData = [];

    if (tableName == 'students' || tableName == 'student') {
      rawData = students.map((s) => s.toJson()).toList();
    } else if (tableName == 'departments' || tableName == 'department') {
      rawData = departments.map((d) => d.toJson()).toList();
    } else if (tableName == 'courses' || tableName == 'course') {
      rawData = courses.map((c) => c.toJson()).toList();
    } else if (tableName == 'enrollments' || tableName == 'enrollment') {
      rawData = enrollments.map((e) => e.toJson()).toList();
    } else {
      throw FormatException('Table "$tableName" does not exist in relational schema.');
    }

    // Handle WHERE clause
    final whereIndex = lowerSql.indexOf('where ');
    if (whereIndex != -1) {
      String whereClause = cleanSql.substring(whereIndex + 6);
      final orderIndex = whereClause.toLowerCase().indexOf('order by');
      if (orderIndex != -1) {
        whereClause = whereClause.substring(0, orderIndex);
      }
      whereClause = whereClause.replaceAll(';', '').trim();
      rawData = _applyWhereFilter(rawData, whereClause);
    }

    // Handle ORDER BY clause
    final orderIndex = lowerSql.indexOf('order by ');
    if (orderIndex != -1) {
      String orderClause = cleanSql.substring(orderIndex + 9).replaceAll(';', '').trim();
      rawData = _applyOrderBy(rawData, orderClause);
    }

    if (rawData.isEmpty) {
      stopwatch.stop();
      return QueryResult(
        columns: ['Info'],
        rows: [
          {'Info': 'Query executed successfully. 0 records returned.'}
        ],
        executionTimeMs: stopwatch.elapsedMilliseconds,
        queryExecuted: cleanSql,
      );
    }

    final columns = rawData.first.keys.toList();
    stopwatch.stop();

    return QueryResult(
      columns: columns,
      rows: rawData,
      executionTimeMs: stopwatch.elapsedMilliseconds,
      queryExecuted: cleanSql,
    );
  }

  static List<Map<String, dynamic>> _applyWhereFilter(
    List<Map<String, dynamic>> rows,
    String whereClause,
  ) {
    // E.g. "gpa >= 3.5" or "major = 'CPE'" or "age > 20"
    final regex = RegExp(r"(\w+)\s*(=|>=|<=|>|<|!=)\s*'?([^']*)'?");
    final match = regex.firstMatch(whereClause);

    if (match == null) return rows;

    final field = match.group(1)!;
    final operator = match.group(2)!;
    final targetVal = match.group(3)!.trim();

    return rows.where((row) {
      if (!row.containsKey(field)) return true;
      final val = row[field];

      if (val is num) {
        final targetNum = double.tryParse(targetVal);
        if (targetNum == null) return false;
        final numVal = val.toDouble();

        switch (operator) {
          case '=':
            return numVal == targetNum;
          case '>=':
            return numVal >= targetNum;
          case '<=':
            return numVal <= targetNum;
          case '>':
            return numVal > targetNum;
          case '<':
            return numVal < targetNum;
          case '!=':
            return numVal != targetNum;
          default:
            return true;
        }
      } else {
        final strVal = val.toString().toLowerCase();
        final targetStr = targetVal.toLowerCase();

        switch (operator) {
          case '=':
            return strVal == targetStr;
          case '!=':
            return strVal != targetStr;
          default:
            return strVal.contains(targetStr);
        }
      }
    }).toList();
  }

  static List<Map<String, dynamic>> _applyOrderBy(
    List<Map<String, dynamic>> rows,
    String orderClause,
  ) {
    final parts = orderClause.split(' ');
    final field = parts[0].trim();
    final isDesc = parts.length > 1 && parts[1].toUpperCase() == 'DESC';

    rows.sort((a, b) {
      final valA = a[field];
      final valB = b[field];

      if (valA == null || valB == null) return 0;

      int comp = 0;
      if (valA is num && valB is num) {
        comp = valA.compareTo(valB);
      } else {
        comp = valA.toString().compareTo(valB.toString());
      }

      return isDesc ? -comp : comp;
    });

    return rows;
  }
}
