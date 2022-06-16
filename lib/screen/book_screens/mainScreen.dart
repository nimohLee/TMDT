import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/screen/book_screens/hotel_motel_choice.dart';
import 'package:tong_myung_hotel/screen/mypage_screens/mypage_main.dart';
import 'package:tong_myung_hotel/screen/reviews_screens/review_main.dart';

class mainPage extends StatefulWidget {
  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {

  final List<Widget> _children = [Hotel_motel_choice_(),Review(),MyPage()];
  var _index = 0; // 페이지 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromRGBO(28, 174, 129, 1),
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('홈'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('별점/후기'),
            icon: Icon(Icons.star_border),
          ),
          BottomNavigationBarItem(
            title: Text('마이페이지'),
            icon: Icon(Icons.person_outline),
          )

        ],
      ),
      body: _children[_index],
    );
  }
}
