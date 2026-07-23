class Department {
  final String id;
  final String code;
  final String name;
  final String faculty;
  final String headOfDepartment;

  const Department({
    required this.id,
    required this.code,
    required this.name,
    required this.faculty,
    required this.headOfDepartment,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json['id'] as String,
        code: json['code'] as String,
        name: json['name'] as String,
        faculty: json['faculty'] as String,
        headOfDepartment: json['headOfDepartment'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'faculty': faculty,
        'headOfDepartment': headOfDepartment,
      };
}
