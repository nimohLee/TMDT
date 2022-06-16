//예약하기화면에서 사용자가 방의유형을 선택할 때 사용하는 slide 이다.

import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/screen/sign_screens/signup_screen.dart';

class ReviewSlide {
  final String imageUrl;



  ReviewSlide({
    @required this.imageUrl,

  });
}

// Tip : read_me 파일을 확인하면 동명대학교 기숙사의 건물구조를 알 수 있다.

final photoList = [
  ReviewSlide(
    imageUrl: 'assets/images/1호관1유형.png',
  ),
  ReviewSlide(
    imageUrl: 'assets/images/1호관2유형.png',
  ),
  ReviewSlide(
      imageUrl: null)
];