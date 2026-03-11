import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final icon;
  final String exerciseName;
  final int numberOfExercises;
  final color;
  final onpress;

  const ExerciseTile(
      {super.key,
      required this.icon,
      required this.exerciseName,
      required this.numberOfExercises,
      required this.color,
      required this.onpress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: color,
                      child: Icon(
                        icon,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //tile
                      Text(
                        exerciseName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      //subtitle
                      Text(
                        "$numberOfExercises exercises",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.more_horiz),
            ],
          ),
        ),
      ),
    );
  }
}
