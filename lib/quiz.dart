import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/result.dart';
import 'package:quiz_app/setting.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.category, required this.difficulty}) : super(key: key);

  final String category, difficulty;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  bool _loading = true;
  int _question = 0, _correctAnswers = 0;
  dynamic _data;

  @override
  void initState() {
    getQuiz();
    super.initState();
  }

  void getQuiz() async {
    var response = await http.get(
      Uri.parse('https://quizapi.io/api/v1/questions?&limit=10${widget.category != 'Any Category' ? '&category=${widget.category}' : ''}${widget.difficulty != 'Any Difficulty' ? '&difficulty=${widget.difficulty}' : ''}'),
      headers: {
        'X-Api-Key': const String.fromEnvironment('API_KEY')
      }
    );
    var body = jsonDecode(response.body);
    if (kDebugMode) {
      print(response.statusCode);
      print(body.length);
    }
    switch(response.statusCode){
      case 200:
        setState(() {
          _data = body;
          _loading = false;
        });
      break;
      case 404:
        showToast('404', Colors.red);
        pop();
      break;
      case 500:
        if (kDebugMode) {
          print(response.statusCode);
          print(body);
        }
        showToast('500', Colors.red);
        pop();
      break;
      default:
        showToast('Error', Colors.red);
        pop();
      break;
    }
  }

  void pop() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading ? const CircularProgressIndicator()
            :
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(_data[_question]['question'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  )
                ),
                Expanded(
                  flex: 2,
                  child: ScrollConfiguration(
                    behavior: Behavior(),
                    child: ListView.builder(
                      itemCount: _data[_question]['answers'].length,
                      itemBuilder: (context, i) {
                        var item = _data[_question]['answers'].entries.map((entry) => entry.value).toList()[i];
                        return item != null ? Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text('$item', style: const TextStyle(color: Colors.white))
                            ),
                            onPressed: () {
                              setState(() {
                                if(_data[_question]['correct_answers'].entries.map((entry) => entry.value).toList()[i] == 'true'){
                                  _correctAnswers++;
                                }
                                _question < _data.length - 1 ?
                                _question++ :
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultPage(correctAnswers: _correctAnswers, difficulty: widget.difficulty, questions: _question + 1, category: widget.category)));
                              });
                            }
                          )
                        ) : Container();
                      }
                    )
                  )
                )
              ],
            ),
          )
        )
      ),
    );
  }
}