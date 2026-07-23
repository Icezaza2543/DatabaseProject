class Course {
  final String id;
  final String code;
  final String title;
  final int credits;
  final String departmentId;

  const Course({
    required this.id,
    required this.code,
    required this.title,
    required this.credits,
    required this.departmentId,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'] as String,
        code: json['code'] as String,
        title: json['title'] as String,
        credits: json['credits'] as int,
        departmentId: json['departmentId'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'title': title,
        'credits': credits,
        'departmentId': departmentId,
      };
}
