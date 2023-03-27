import 'package:flutter/material.dart' show Color;

class Task {
  final String title, description;
  final Color color;

  Task({
    required this.title,
    this.description = 'Deliver essay for ER class before Friday',
    this.color = const Color(0xFF7553F6),
  });
}

final List<Task> courses = [
  Task(
    title: "Essay for ER",
  ),
  Task(
    title: "Math assignment for Algebra",
    description: "Do 3 problems from page 12 before Thursday",
    color: const Color(0xFF80A4FF),
  ),
];
