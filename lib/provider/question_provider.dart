import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/screens/forms/add_form.dart';

class QuestionProvider with ChangeNotifier {
  FormBuilderQuestion? _selectedQuestion;

  FormBuilderQuestion? get selectedQuestion => _selectedQuestion;
  String questionType = 'singleChoice';

  FormBuilderQuestion _tempFormQuestion = FormBuilderQuestion(
    key: 0,
    type: 'text',
    question: '',
  );

  FormBuilderQuestion get tempFormQuestion => _tempFormQuestion;

  List<Choice> choices = [];

  void updateQuestionType(String type) {
    questionType = type;
    notifyListeners();
  }

  void changeTypeOfTempFormQuesiton(String type) {
    _tempFormQuestion = FormBuilderQuestion(
      key: _tempFormQuestion.key,
      type: type,
      question: _tempFormQuestion.question,
    );
    notifyListeners();
  }

  void addChoicesToTempFormQuestion(String choice) {
    choices.add(Choice(label: choice));
    _tempFormQuestion = FormBuilderQuestion(
      key: _tempFormQuestion.key,
      type: _tempFormQuestion.type,
      question: _tempFormQuestion.question,
      choices: choices,
    );
    notifyListeners();
  }

  void getDefalutTempFormQuestion() {
    _tempFormQuestion = FormBuilderQuestion(
      key: 0,
      type: 'text',
      question: '',
    );
    notifyListeners();
  }

  final List<FormBuilderQuestion> formQuestions = [
    // //dummy data
    // FormBuilderQuestion(
    //   key: 1,
    //   type: 'text',
    //   question: 'What is your name?',
    // ),
    // FormBuilderQuestion(
    //   key: 2,
    //   type: 'slider',
    //   question: 'How old are you?',
    // ),
    // FormBuilderQuestion(
    //   key: 3,
    //   type: 'singlechoice',
    //   question: 'Which is your favourite color?',
    //   choices: [
    //     Choice(label: 'Choice 1'),
    //     Choice(label: 'Choice 2'),
    //     Choice(label: 'Choice 3'),
    //   ],
    // ),
    // FormBuilderQuestion(
    //   key: 4,
    //   type: 'multiChoice',
    //   question: 'Which are your favourite colors?',
    //   choices: [
    //     Choice(label: 'Choice 1'),
    //     Choice(label: 'Choice 2'),
    //     Choice(label: 'Choice 3'),
    //   ],
    // ),
  ];

  void addQuestion(FormBuilderQuestion question) {
    formQuestions.insert(0, question);
    notifyListeners();
  }

  void selectQuestion(FormBuilderQuestion question) {
    _selectedQuestion = question;
    notifyListeners();
  }

  void deselectQuestion() {
    _selectedQuestion = null;
    notifyListeners();
  }
}
