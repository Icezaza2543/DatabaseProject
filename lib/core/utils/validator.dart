class Validator {
  static String? validateStudentId(String? value, List<String> existingIds) {
    if (value == null || value.trim().isEmpty) {
      return 'Student ID is required.';
    }
    final trimmed = value.trim();
    if (!RegExp(r'^\d{8}$').hasMatch(trimmed)) {
      return 'Student ID must be exactly 8 numeric digits (e.g. 64010001).';
    }
    if (existingIds.contains(trimmed)) {
      return 'Student ID already exists (Primary Key Violation).';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full Name is required.';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required.';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? validateGpa(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'GPA is required.';
    }
    final gpa = double.tryParse(value.trim());
    if (gpa == null) {
      return 'GPA must be a valid number.';
    }
    if (gpa < 0.0 || gpa > 4.0) {
      return 'GPA must be between 0.00 and 4.00.';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required.';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Age must be an integer.';
    }
    if (age < 15 || age > 90) {
      return 'Age must be between 15 and 90.';
    }
    return null;
  }
}
