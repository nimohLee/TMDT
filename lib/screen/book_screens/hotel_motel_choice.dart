//이 파일은 사용자가 호텔식으로 예약할지 모텔식으로 예약할지 선택할 수 있게끔 해주는 UI와 기능을 제공해주는 파일이다.

import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/method_variable_collection.dart';
import 'package:tong_myung_hotel/screen/book_screens/select_booking_condition.dart';
import 'package:tong_myung_hotel/screen/mypage_screens/mypage_main.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:tong_myung_hotel/screen/reviews_screens/review_main.dart';

class Hotel_motel_choice_ extends StatefulWidget {

  @override
  _Hotel_motel_choice_State createState() => _Hotel_motel_choice_State();
}

class _Hotel_motel_choice_State extends State<Hotel_motel_choice_> {
  Variable variable=new Variable();

  @override
  void initState() {
    super.initState();

    print("initState 메소드 호출");

//    print("MediaQuery.of(context).size.width"+MediaQuery.of(context).size.width.toString());
//    print("MediaQuery.of(context).size.height"+MediaQuery.of(context).size.height.toString());

  }


  @override
  Widget build(BuildContext context) {

    Book_room_stful book_room;

    //어떤 핸드폰에서든지 위젯의 위치가 똑같은 위치에 보이게끔 구현하기위해서 각 위젯들의 위치를 핸드폰의 전체비율에 따라 설정하기위해 아래 두 변수는 존재한다.
    double wi = MediaQuery.of(context).size.width;//핸드폰의 너비 Get
    double hi = MediaQuery.of(context).size.height;//핸드폰의 높이 Get

    print("MediaQuery.of(context).size.width"+MediaQuery.of(context).size.width.toString());      //360
    print("MediaQuery.of(context).size.height"+MediaQuery.of(context).size.height.toString());    //692

    double a=wi*1.4388888;
    double b=hi/2.9606299;

    //전체 Container  이 코드는 S20 을 기준으로 했을때 유효한 코드다.
//    double width=getWidthRatio(360,context);
//    double height=getHeightRatio(752,context);

    double width=getWidthRatio(MediaQuery.of(context).size.width,context);
    double height=getHeightRatio(MediaQuery.of(context).size.height,context);


    return
      Container(    //SingleChildScrollView
        child:SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child : Scaffold(

            body: Center(

              child: Stack(

                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  //TDMT 글자를 표현하는 사진이다.
                  Positioned(
                      top: 44*height,
                      left: 130*width,
                      child: Container(
                          width: 92*width,
                          height: 52*height,
                          child: Text('TMDT',
                            style: TextStyle(fontFamily: 'HYShortSamul',
                                color: Color.fromRGBO(28, 174, 129, 1),
                                fontSize: MediaQuery.of(context).size.width/9),
                            textAlign: TextAlign.center,
                          )
                      )
                  ),

                  //호텔식에대한 이미지이다.
                  Positioned(
                      top: 95*height,
                      left: 25*width,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/hotel.png'),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(10), //모서리를 둥글게
                            border: Border.all(color: Colors.white, width: 1)

                        ), //테두리

                        width: 300*width,
                        height: 203*height,

                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Book_room_stful(type:"hotel"),
                                ));//버튼이 눌리는 이벤트 발생 시, 다음 페이지에서 전달 받을 string 변수와 value('SecondRoute_Delivered')값을 직접 전달

                            variable.Sleep_Hotel();

                          },
                          //child: Image.asset("assets/images/hotel.png"),
                        ),

                      )

                  ),


                  //"호텔형식으로 예약" 텍스트를 표현한다
                  Positioned(
                      top: 310*height,
                      left: 25*width,
                      child: Text('호텔형식으로 예약', textAlign: TextAlign.left, style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'NanumSquareB',
                          fontSize: MediaQuery.of(context).size.width/20,
                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1
                      ),
                      )
                  ),

                  //호텔식으로 예약 오른쪽에 초록색 화살표를 의미한다
                  Positioned(
                      top: 305*height,
                      left: 160*width,
                      child: Container(
                        width: 30*width,
                        height: 30*height,

                        child: InkWell(
                          child: Image.asset("assets/images/right.png"),
                        ),

                      )

                  ),

                  //호텔식에대한 설명을 하는 Text 이다.
                  Positioned(
                      top: 350*height,
                      left: 25*width,
                      child: Text('가족 또는 친구들과 함께 오신 분들에게 추천드리는 호텔 \n 형식의 방으로, 3인 이상 이용 시 추천드립니다 :)', textAlign: TextAlign.left, style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'NanumSquareR',
                          fontSize: MediaQuery.of(context).size.width/30,
                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1
                      ),
                      )
                  ),

                  //게스트하우스식에대한 이미지이다.
                  Positioned(
                      top: 390*height,
                      left: 25*width,
                      child: Container(

                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/guest_house.jpg'),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(10), //모서리를 둥글게
                            border: Border.all(color: Colors.white, width: 1)

                        ), //테두리

                        width: 300*width,   //249
                        height: 203*height, //243

                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                                context, MaterialPageRoute(
                              builder: (context) => Book_room_stful(type:"guest_house",),
                            ));//버튼이 눌리는 이벤트 발생 시, 다음 페이지에서 전달 받을 string 변수와 value('SecondRoute_Delivered')값을 직접 전달
                            variable.Sleep_Guest_house();
                          },
                          //child: Image.asset("assets/images/guest_house.jpg"),
                        ),

                      )

                  ),

                  //"게스트하우스 형식으로 예약" 텍스트를 표현한다
                  Positioned(
                      top: 610*height,
                      left: 25*width,
                      child: Text('게스트하우스 형식으로 예약', textAlign: TextAlign.left, style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'NanumSquareB',
                          fontSize: MediaQuery.of(context).size.width/20,
                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1
                      ),
                      )
                  ),

                  //게스트하우스 형식으로 예약 오른쪽에 초록색 화살표를 의미한다
                  Positioned(
                      top: 600*height,
                      left: 230*width,
                      child: Container(
                        width: 30*width,
                        height: 30*height,

                        child: InkWell(
                          child: Image.asset("assets/images/right.png"),
                        ),

                      )

                  ),


                  //게스트하우스식에대한 설명을 하는 Text 이다.
                  Positioned(
                      top: 640*height,  //165
                      left: 25*width,
                      child: Text('혼자오신 분 또는 새로운 친구들과의 만남을 원하시는 분\n들에게 추천드립니다 :) 게스트 하우스 형식의 숙소에서 \n새로운 사람들과 함께 여행을 즐겨보세요!', textAlign: TextAlign.left, style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'NanumSquareR',
                          fontSize: 12,
                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1
                      ),
                      )
                  ),

                  //클릭하면 실시간 상담센터로 이동할 수 있게해주는 이미지다.
                  Positioned(
                      top: 635*height,
                      left: 295*width,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/QnA.png'),
                              fit: BoxFit.fill,
                            ),
                        ), //테두리
                        width: 60*width,
                        height: 60*height,

                        child: InkWell(
                          onTap: (){
                            _launchURL();
                          },
                        ),
                      )
                  ),


                ],
              ),
            ),

          ),), );
  }

  //동명대학교 고객센터로 연결해주는 메소드다
  _launchURL() async {
    const url = 'https://pf.kakao.com/_SNaGK';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch ';
    }
  }

}


