import 'package:flutter/material.dart';

//예약조건에서 사용자가 방유유형을 설정하기위한 Slide 클래스다
class Slide_room_condition {
  final String imageUrl;
  final String title;
  final String description;

  Slide_room_condition({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList_room_condition= [
  Slide_room_condition(
    imageUrl: 'assets/images/1호관1유형.png',
    title: '1호관 건물',
    description: '3인실의 방입니다 :)',
  ),
  Slide_room_condition(
    imageUrl: 'assets/images/1호관2유형.png',
    title: '1호관 건물',
    description: '2인실의 방입니다 :)',
  ),
  Slide_room_condition(
    imageUrl: 'assets/images/2호관2유형.png',
    title: '2호관 건물',
    description: '4인실의 방입니다 :)',
  ),

];
