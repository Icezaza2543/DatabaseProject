class Student {
  final String id;
  final String name;
  final String email;
  final int age;
  final String departmentId;
  final String major;
  final double gpa;
  final int admissionYear;
  final String status; // 'Active', 'Graduated', 'Probation'

  const Student({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.departmentId,
    required this.major,
    required this.gpa,
    required this.admissionYear,
    this.status = 'Active',
  });

  Student copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    String? departmentId,
    String? major,
    double? gpa,
    int? admissionYear,
    String? status,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      departmentId: departmentId ?? this.departmentId,
      major: major ?? this.major,
      gpa: gpa ?? this.gpa,
      admissionYear: admissionYear ?? this.admissionYear,
      status: status ?? this.status,
    );
  }

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] ?? '${json['id']}@cpe.ku.ac.th',
        age: json['age'] as int,
        departmentId: json['departmentId'] ?? 'DEP_${json['major']}',
        major: json['major'] as String,
        gpa: (json['gpa'] as num).toDouble(),
        admissionYear: json['admissionYear'] ?? 2021,
        status: json['status'] ?? 'Active',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'age': age,
        'departmentId': departmentId,
        'major': major,
        'gpa': gpa,
        'admissionYear': admissionYear,
        'status': status,
      };
}
