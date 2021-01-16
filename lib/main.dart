import 'package:flatto/screens/MapScreen.dart';
import 'package:flatto/screens/NoticeScreen.dart';
import 'package:flatto/screens/ProfileScreen.dart';
import 'package:flatto/screens/RankingScreen.dart';
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
          controller: _pageController,
          physics: new NeverScrollableScrollPhysics(),
          children: [
            MapScreen(),
            RankingScreen(),
            NoticeScreen(),
            ProfileScreen(),
          ]),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.emoji_flags_rounded), label: 'Bussiness'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active), label: 'School'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_sharp), label: 'Profile')
          ],
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
