import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/model/bookingConditionSlide.dart';

import '../model/homeSlide.dart';

class BookingCondition_slide_item extends StatelessWidget {
  final int index;
  BookingCondition_slide_item(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
//      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // SizedBox(height: MediaQuery.of(context).size.width/2.5,)
        Container(
          width:  MediaQuery.of(context).size.width/2.5,
          height:  MediaQuery.of(context).size.width/2.5,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: AssetImage(slideList_room_condition[index].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),

        //Welcome 과 동명대학교 로고사이의 공백이다
        SizedBox(
          height: MediaQuery.of(context).size.height/50,
        ),

        //초록색 글을 표현한다.
        Text(
          slideList_room_condition[index].title,
          style: TextStyle(
            fontFamily: 'NanumSquareEB',
            fontSize:  MediaQuery.of(context).size.width/20,
            color: Color.fromRGBO(28, 174, 129, 1),
            fontWeight: FontWeight.w900,
          ),
        ),

        //초록글과 초록글아래의 회색글 사이의 여백을 표현한다.
        SizedBox(
          height: MediaQuery.of(context).size.height/50,
        ),

        //초록글 아래의 회색글을 표현한다.
        Text(
          slideList_room_condition[index].description,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'NanumSquareR',fontSize:  MediaQuery.of(context).size.width/25),
        ),

      ],
    );
  }
}
