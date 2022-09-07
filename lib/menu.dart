import 'package:flutter/material.dart';
import 'package:quiz_app/quiz.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  String _category = 'Any Category', _difficulty = 'Any Difficulty';
  final List<String> _categoryList = [
    'Any Category',
    'Linux',
    'Bash',
    'Uncategorized',
    'Docker',
    'SQL',
    'CMS',
    'Code',
    'DevOps'
  ], _difficultyList = ['Any Difficulty', 'Easy', 'Medium', 'Hard'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dropdownButton(_categoryList, true),
                  const SizedBox(height: 20),
                  dropdownButton(_difficultyList, false)
                ],
              )
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Начать', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(category: _category, difficulty: _difficulty)));
                }
              )
            )
          ]
        )
      )
    );
  }

  Widget dropdownButton(List<String> list, bool val){
    return DropdownButton<String>(
      value: val ? _category : _difficulty,
      items: list.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (res) {
        setState(() {
          val ? _category = res ?? '' : _difficulty = res ?? '';
        });
      }
    );
  }
}