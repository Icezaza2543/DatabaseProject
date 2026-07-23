class Enrollment {
  final String id;
  final String studentId;
  final String courseId;
  final String semester;
  final String grade; // e.g. 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'
  final double gradePoint; // 4.0, 3.5, 3.0, 2.5, 2.0, 1.5, 1.0, 0.0

  const Enrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.semester,
    required this.grade,
    required this.gradePoint,
  });

  static double calculateGradePoint(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return 4.0;
      case 'B+':
        return 3.5;
      case 'B':
        return 3.0;
      case 'C+':
        return 2.5;
      case 'C':
        return 2.0;
      case 'D+':
        return 1.5;
      case 'D':
        return 1.0;
      case 'F':
      default:
        return 0.0;
    }
  }

  factory Enrollment.fromJson(Map<String, dynamic> json) => Enrollment(
        id: json['id'] as String,
        studentId: json['studentId'] as String,
        courseId: json['courseId'] as String,
        semester: json['semester'] as String,
        grade: json['grade'] as String,
        gradePoint: (json['gradePoint'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'courseId': courseId,
        'semester': semester,
        'grade': grade,
        'gradePoint': gradePoint,
      };
}
