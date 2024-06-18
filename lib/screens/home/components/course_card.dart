import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/course.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    Key? key,
    required this.course,
    required this.onTap,
  }) : super(key: key);

  final Course course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        height: 208,
        width: 220,
        decoration: BoxDecoration(
          color: course.bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Text(
                      course.description,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  const Text(
                    "61 SECTIONS - 11 HOURS",
                    style: TextStyle(color: Colors.white54),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Transform.translate(
                        offset: Offset((-10 * index).toDouble(), 0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SvgPicture.asset(course.iconSrc)
          ],
        ),
      ),
    );
  }
}
