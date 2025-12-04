import 'package:flutter/material.dart';
import '../../../models/lesson_content.dart';
import 'text_section_widget.dart';
import 'exercise_section_widget.dart';
import 'example_section_widget.dart';

class LessonContentWidget extends StatelessWidget {
  final LessonContent content;
  final ValueChanged<int>? onExerciseCompleted;
  final String languageCode;

  const LessonContentWidget({
    super.key,
    required this.content,
    this.onExerciseCompleted,
    this.languageCode = 'es', // Default to Spanish if not provided
  });

  @override
  Widget build(BuildContext context) {
    int exerciseIndex = 0;

    return Column(
      children: content.sections.map((section) {
        if (section is TextSection) {
          return TextSectionWidget(section: section);
        } else if (section is ExampleSection) {
          return ExampleSectionWidget(
            section: section,
            languageCode: languageCode,
          );
        } else if (section is ExerciseSection) {
          final currentIndex = exerciseIndex++;
          return ExerciseSectionWidget(
            section: section,
            onAnswerSubmitted: (isCorrect) {
              onExerciseCompleted?.call(currentIndex);
            },
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }
}
