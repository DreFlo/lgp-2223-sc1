import 'package:flutter/material.dart';

import '../../model/course.dart';
import 'components/course_card.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Tasks",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Color.fromARGB(255, 248, 245, 245), fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: courses
                      .map(
                        (course) => Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: CourseCard(
                            title: course.title,
                            description: course.description,
                            color: course.color,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Studying",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Color.fromARGB(255, 245, 243, 243), fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Lottie.network('https://assets9.lottiefiles.com/packages/lf20_ketv1eqz.json'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
