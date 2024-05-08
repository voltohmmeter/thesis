import 'package:flutter/material.dart';

class Course {
  final String title, description, iconSrc;
  final Color bgColor;

  Course({
    required this.title,
    this.description = "Learn basic sign language",
    this.iconSrc = "assets/icons/ios.svg",
    this.bgColor = const Color.fromARGB(255, 123, 79, 192),
  });
}

List<Course> courses = [
  Course(title: "Basic Signlanguage Tutorials"),
  Course(
    title: "Sign Language Compilations",
    iconSrc: "assets/icons/code.svg",
    bgColor: const Color.fromRGBO(187, 114, 255, 1),
  ),
];

// We need it later
List<Course> recentCourses = [
  Course(title: "State Machine"),
  Course(
    title: "Animated Menu",
    bgColor: const Color(0xFF9CC5FF),
    iconSrc: "assets/icons/code.svg",
  ),
  Course(title: "Flutter with Rive"),
];
