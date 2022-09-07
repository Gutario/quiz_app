import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/menu.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/setting.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.correctAnswers, required this.category, required this.difficulty, required this.questions}) : super(key: key);

  final int correctAnswers, questions;
  final String category, difficulty;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  void saveResult() async {
    CollectionReference users = FirebaseFirestore.instance.collection('results');

    users.add({
      'wrong_answers': widget.questions - widget.correctAnswers,
      'category': widget.category,
      'correct_answers': widget.correctAnswers,
      'date': DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
      'difficulty': widget.difficulty
    }).then((value) {
      showToast('Success', Colors.green);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MenuPage()));
    }).catchError((error) {
      showToast('Error', Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Ваш результат:\n${widget.correctAnswers} из ${widget.questions}', style: const TextStyle(fontSize: 24), textAlign: TextAlign.center)
            )
          ),
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Сохранить результат', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        saveResult();
                      }
                    )
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Начать заново', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MenuPage()));
                      }
                    )
                  )
                ],
              )
            )
          )
        ],
      )
    );
  }
}