class Student {
  final String id;
  final String name;
  final int age;
  final String major;
  final double gpa;

  Student({
    required this.id,
    required this.name,
    required this.age,
    required this.major,
    required this.gpa,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        major: json['major'],
        gpa: json['gpa'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'major': major,
        'gpa': gpa,
      };
}
