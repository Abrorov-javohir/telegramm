import 'package:flutter/material.dart';

class PageViewBuilder extends StatefulWidget {
  final String question;
  final List<String> answers; // Ensure answers are a list of strings
  final int index;
  final int totalQuestions;
  final int correct;
  final void Function(bool isCorrect) nextQuestion;

  PageViewBuilder({
    Key? key,
    required this.answers,
    required this.question,
    required this.index,
    required this.totalQuestions,
    required this.nextQuestion,
    required this.correct,
  }) : super(key: key);

  @override
  State<PageViewBuilder> createState() => _PageViewBuilderState();
}

class _PageViewBuilderState extends State<PageViewBuilder> {
  int? selectedAnswer;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.question,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
        for (int i = 0; i < widget.answers.length; i++)
          ListTile(
            title: Text(
              widget.answers[i],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  selectedAnswer = i;
                  isChecked = true;
                });
                // Delay to show the user their selection before moving to the next question
                Future.delayed(const Duration(seconds: 1), () {
                  widget.nextQuestion(selectedAnswer == widget.correct);
                });
              },
              icon: selectedAnswer == i
                  ? const Icon(Icons.check_box)
                  : const Icon(Icons.check_box_outline_blank),
            ),
          ),
        if (isChecked)
          selectedAnswer == widget.correct
              ? Image.network(
                  'https://www.shutterstock.com/image-vector/check-mark-icon-tick-symbol-600nw-1938875785.jpg',
                  width: 200,
                  height: 200,
                )
              : Image.network(
                  'https://www.shutterstock.com/image-vector/cross-icon-incorrect-sign-prohibited-260nw-1450589105.jpg',
                  width: 100,
                  height: 100,
                ),
      ],
    );
  }
}
