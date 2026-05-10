import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/student.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context);
    final students = dbService.students;

    return Scaffold(
      appBar: AppBar(
        title: Text('CPE Database System'),
        centerTitle: true,
      ),
      body: students.isEmpty
          ? Center(child: Text('No records found.'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(student.major),
                    ),
                    title: Text(student.name),
                    subtitle: Text('ID: ${student.id} | GPA: ${student.gpa}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        dbService.deleteStudent(student.id);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Mock logic to add a new student
          dbService.addStudent(
            Student(
              id: '6400${students.length + 1}',
              name: 'New Student ${students.length + 1}',
              age: 20,
              major: 'CPE',
              gpa: 3.0,
            ),
          );
        },
      ),
    );
  }
}
