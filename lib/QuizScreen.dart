// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worthy/SpeechToTextPage.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<List<String>> questionsAndAnswers = [
    [
      'When you feel self-conscious, which of the following aspects do you often focus on the most?',
      'My physical appearance',
      'How others perceive me socially',
      'My academic performance or intelligence',
      'My abilities and skills in various areas',
    ],
    [
      'How do societal beauty standards influence your perception of your own appearance?',
      'I constantly compare myself to unrealistic beauty standards portrayed in the media.',
      'I feel pressured to conform to certain beauty ideals in order to feel accepted or attractive.',
      'I recognize that beauty comes in diverse forms, but I still struggle with accepting my own appearance.',
      'I recognize that beauty comes in diverse forms, but I still struggle with accepting my own appearance.',
    ],
    [
      'When you look in the mirror, what specific features or aspects of your appearance do you feel most dissatisfied with?',
      'Facial features (e.g., nose, eyes, skin)',
      'Body shape or size (e.g., weight, height)',
      'Hair (e.g., style, texture)',
      'Overall physical condition (e.g., fitness level, health)',
    ],
    [
      'In social settings, what specific behaviors or situations trigger feelings of insecurity or rejection?',
      'Being excluded or left out of social gatherings or conversations',
      'Receiving negative feedback or criticism from peers',
      "Feeling like I don't belong or fit in with certain social groups",
      'Comparing myself unfavorably to others in terms of popularity or social status',
    ],
    [
      'In social settings, what specific behaviors or situations trigger feelings of insecurity or rejection?',
      'Being excluded or left out of social gatherings or conversations',
      'Receiving negative feedback or criticism from peers',
      "Feeling like I don't belong or fit in with certain social groups",
      'Comparing myself unfavorably to others in terms of popularity or social status',
    ],
  ];

  int currentQuestionIndex = 0;
  List<List<int>> selectedOptions = [];
  PageController _pageController = PageController();

  void _navigateToResultPage() {
    // Replace `YourResultPage()` with the actual result page you want to navigate to
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SpeechToTextPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building widget for index $currentQuestionIndex");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/arrowcircleleft2.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Figuring out the insecurities',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: questionsAndAnswers.length,
        onPageChanged: (index) {
          print("Page changed to index $index");
          setState(() {
            currentQuestionIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 350,
                    child: Text(
                      questionsAndAnswers[currentQuestionIndex][0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  buildMenuItem(
                      1, questionsAndAnswers[currentQuestionIndex][1]),
                  buildMenuItem(
                      2, questionsAndAnswers[currentQuestionIndex][2]),
                  buildMenuItem(
                      3, questionsAndAnswers[currentQuestionIndex][3]),
                  buildMenuItem(
                      4, questionsAndAnswers[currentQuestionIndex][4]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          if (currentQuestionIndex > 0) {
                            setState(() {
                              currentQuestionIndex--;
                            });
                          }
                        },
                        child: Text(
                          'Back',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          print("Next button pressed");
                          if (currentQuestionIndex <
                              questionsAndAnswers.length - 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // If on the last question, navigate to the result page
                            _navigateToResultPage();
                          }
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildMenuItem(int index, String text) {
    bool isLastQuestion =
        currentQuestionIndex == questionsAndAnswers.length - 1;
    List<int> currentSelectedOptions =
        selectedOptions.length > currentQuestionIndex
            ? selectedOptions[currentQuestionIndex]
            : [];

    bool isSelected = currentSelectedOptions.contains(index);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            // If already selected, remove it from the list
            currentSelectedOptions.remove(index);
          } else {
            // If not selected, add it to the list
            currentSelectedOptions.add(index);
          }
          // Update the selectedOptions list with the modified list
          if (selectedOptions.length > currentQuestionIndex) {
            selectedOptions[currentQuestionIndex] = currentSelectedOptions;
          } else {
            selectedOptions.add(currentSelectedOptions);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.all(8),
        width: 300,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff8367C7) : null,
          border: Border.all(
            color: Color(0xff8367C7),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: isSelected ? Colors.white : Color(0xff8367C7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
