import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'flatto',
    home: MyStatefulWidget(),
  ));
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  PageController _pageController;
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    // PageControllerの初期化
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('フラッと')),
      body: PageView(
          //TODO: pageViwqのコントローラ属性について勉強する
          controller: _pageController,
          physics: new NeverScrollableScrollPhysics(),
          children: [
            //ここにWidgetを突っ込む
            Text(
              'Index:1',
              style: optionStyle,
            ),
            Text(
              'Index:2',
              style: optionStyle,
            ),
            Text(
              'Index:3',
              style: optionStyle,
            )
          ]),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.business), label: 'Bussiness'),
            BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School'),
          ],
          selectedItemColor: Colors.amber[80],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            });
          }),
    );
  }
}

//TODO: PageControllerの仕組みを勉強する
