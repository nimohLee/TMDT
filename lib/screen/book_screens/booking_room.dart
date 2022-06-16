import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/method_variable_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tong_myung_hotel/model/note.dart';
import 'package:tong_myung_hotel/screen/book_screens/hotel_motel_choice.dart';
import 'package:tong_myung_hotel/service/firebase_firestore_service.dart.dart';

import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tong_myung_hotel/state/current_State.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Booking_room extends StatefulWidget {

  String search_condition;
  String guest_gender;
  String exit_room_time;
  String enter_room_time;
  String room_type;
  String supply;
  int time_differ;


  Booking_room({
    this.search_condition,
    this.guest_gender,
    this.exit_room_time,
    this.enter_room_time,
    this.room_type,
    this.supply,
    this.time_differ,
  });

  @override
  _Booking_roomState createState() => _Booking_roomState();
}

class _Booking_roomState extends State<Booking_room> {

  String customer_choice; //손님이 설정한 호/게하 방식 및 안원수를 담는 변수다.
  String guest_gender;  //고객의 성별
  String guest_roomtype; //고객이 이전 화면에서 설정한 방의 이미지다.
  int remain_seat;  //예약자가 원하는 방의 남은 개수
  String stop; //서버와 예약관련 통신을 중단시킬지 판별해주는 변수
  String users_room_type_for_update_data; //사용자의 예약정보를 수정할 떄 "방 유형" 필드에 들어갈 값이다.

  //토스트메세지를 한번만 띄워주기위한 변수
  int just_one=0;

  // 인원수를 표현하는 Text 에 담길 변수를 표현한다.
  int supply=0;

  // 방의 유형에대한 설명을 담는 변수다. (방의 유형 Text 우측에 표현될 정보이다.)
  String room_type_explain;

  // 프로그레스바를 실행시키고 중단시키는 역할을 해주는 변수이다.
  bool _isInAsyncCall = false;

  @override
  void initState() {
    super.initState();

    //이전 화면에서 받아온 데이터들을 로그로 출력했다.
    print("이전 화면에서 받아온 데이터들을 로그로 출력했다.");
    print(widget.time_differ);
    print(widget.room_type);
    print(widget.supply);
    print(widget.search_condition);
    print(widget.guest_gender);
    print(widget.enter_room_time);
    print(widget.exit_room_time);

    if(widget.room_type=="0"){
      guest_roomtype="1호관1유형";
      room_type_explain="(3인실 입니다)";
    }
    else if(widget.room_type=="1"){
      guest_roomtype="1호관2유형";
      room_type_explain="(2인실 입니다)";
    }
    else if(widget.room_type=="3"){
      guest_roomtype="2호관2유형";
      room_type_explain="(4인실 입니다)";
    }

    //사용자가 설정한 성별을 초기화해주는 조거문이다.
    if(widget.guest_gender=="Gender.WOMEN"){
      guest_gender="여자";
    }
    else if(widget.guest_gender=="Gender.MAN"){
      guest_gender="남자";
    }


    if(guest_gender.contains("여자")){
      customer_choice="woman";
    }
    else if(guest_gender.contains("남자")){
      customer_choice="man";
    }

    if(guest_roomtype=="1호관1유형"){
      customer_choice=customer_choice+"_three_";
    }
    else if(guest_roomtype=="1호관2유형"){
      customer_choice=customer_choice+"_two_";
    }
    else if(guest_roomtype=="2호관2유형"){
      customer_choice=customer_choice+"_four_";
    }
    if(widget.search_condition=="hotel"){
      customer_choice=customer_choice+"hotel";
    }
    else if(widget.search_condition=="guest_house"){
      customer_choice=customer_choice+"guesthouse";
    }

    print("customer_choice 값");
    print(customer_choice);

    if(customer_choice.contains("hotel")){
      supply=4;
    }
    else{
      String supply_str=widget.supply.substring(0,1);
      print(supply_str);

      //사용자가 설정한 숙박 인원수이다.
      supply=int.parse(supply_str);
    }

  }

  @override
  void dispose() {
    super.dispose();
  }

  _onPageChanged(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    /////////////////   모든기기에서 위젯들의 크기, 배치가 동일하게 하기위해서 배율을 사용한다.    /////////////////
    //핸드폰 전체크기의 비율값
    double width=getWidthRatio(MediaQuery.of(context).size.width,context);
    double height=getHeightRatio(MediaQuery.of(context).size.height,context);
    double ratio = (MediaQuery.of(context).size.width+MediaQuery.of(context).size.height)/2;



    /////////////////   모든기기에서 위젯들의 크기, 배치가 동일하게 하기위해서 배율을 사용한다.    /////////////////


    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,size: ratio/30 ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('    예약하기', style: TextStyle(
          color: Colors.black,
          fontFamily: 'NanumSquareB',
        )),

        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        //body: Container(
        child: Center(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(

                children: <Widget>[

                  Positioned(
                    //top 과 left 가 존재하지 않는 이유는 Figma 에서 가져올 때 Group 형태로 가져오지 않고 Frame 그 자체로 가져왔기 떄문이다. 따라서 여백이 없다.

                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        // Figma Flutter Generator Android1Widget - FRAME
                        Container(
                          width: 360*width,
                          height: 640*height,
                          decoration: BoxDecoration(
                            color : Color.fromRGBO(255, 255, 255, 1),
                          ),

                          child: Stack(
                            children: <Widget>[

                              //입실날짜 아래쪽에 "인원수" 를 표현하는 텍스트이다.
                              Positioned(
                                  top: 275*height,
                                  left: 18*width,
                                  child: Text('인원수', textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumSquareB',
                                      fontSize: MediaQuery.of(context).size.width/23,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1*height
                                  ),)
                              ),

                              //"(최대 4인까지 가능)" 텍스트를 표현한다
                              Positioned(
                                  top: 277*height,
                                  left: 65*width,
                                  child: Text('(최대 4인까지 가능)', textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumSquareB',
                                      fontSize: MediaQuery.of(context).size.width/27,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1*height
                                  ),)
                              ),

                              //"방의유형" 텍스트를 표현한다.
                              Positioned(
                                  top: 363*height,
                                  left: 18*width,
                                  child: Text('방의 유형', textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumSquareB',
                                      fontSize: MediaQuery.of(context).size.width/23,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1*height
                                  ),)
                              ),

                              //방의 유형에대한설명을 표현하는 텍스트를 출력한다.
                              Positioned(
                                  top: 365*height,
                                  left: 85*width,
                                  child: Text(room_type_explain, textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumSquareB',
                                      fontSize: MediaQuery.of(context).size.width/27,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1*height
                                  ),)
                              ),

                              //방의유형을 표현하는 이미지이다.
                              Positioned(
                                  top: 380*height,
                                  left: 18*width,
                                  child: Container(

                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/$guest_roomtype.png'),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius: BorderRadius.circular(10), //모서리를 둥글게
                                        border: Border.all(color: Colors.white, width: 1)

                                    ), //테두리

                                    width: 330*width,   //249
                                    height: 200*height, //243

                                  )

                              ),

                              //검색하기 버튼이다
                              Positioned(
                                top: 585*height,
                                left: 14*width,
                                child:
                                ButtonTheme(
                                  minWidth: 330*height,
                                  height: 50.0*width,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        //side: BorderSide(color: Colors.red)
                                      ),
                                      color: Color.fromARGB(225, 28, 174, 129),
                                      child: Text('예약하기', style: TextStyle(
                                        color: Color.fromARGB(225, 255, 255, 255),
                                        fontFamily: 'NanumSquareB',
                                        fontSize: MediaQuery.of(context).size.width/23,)),
                                      onPressed: () =>
                                      {
                                      Bookingroom(),
                                      } //onPressed

                                  ),
                                ),




                              ),

                              //'성별' 글자 위에 있는 회색 네모박스
                              Positioned(
                                top: -20*height,
                                left: 0*width,
                                child: Container(
                                  height: 80*width,
                                  width: 400*height,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(225, 168, 168, 168),
                                    ),
                                    //borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(

                                  ),
                                ),

                              ),

                              //검색조건과 일치하는 방을 찾았습니다! 텍스트
                              Positioned(
                                  top: 25*height,
                                  left: 80*width,
                                  child:Container(
                                    child: Text(
                                      //dropdownValue.substring(0,1),
                                      '검색조건과 일치하는 방을 찾았습니다!',
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'NanumSquareB',
                                        fontSize: MediaQuery.of(context).size.width/25,
                                      ),
                                    ),
                                  )


                              ),

                              //"성별" 텍스트를 표현한다.
                              Positioned(
                                  top: 80*height,
                                  left: 18*width,
                                  child: Text('성별', textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumSquareB',
                                      fontSize: MediaQuery.of(context).size.width/23,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1*height
                                  ),)
                              ),

                              //'인원수' 글자 밑에 있는 회색 타원형박스
                              Positioned(
                                top: 110*height,
                                left: 14*width,
                                child: Container(
                                  height: 50*width,
                                  width: 330*height,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(225, 168, 168, 168),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(

                                  ),
                                ),

                              ),

                              //드롭다운버튼 사이에서 사용자가 설정한 인원수를 표현하는 숫자다
                              Positioned(
                                  top: 125*height,
                                  left: 165*width,
                                  child:Container(
                                    child: Text(
                                      //dropdownValue.substring(0,1),
                                      guest_gender,
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'NanumSquareB',
                                        fontSize: MediaQuery.of(context).size.width/18,
                                      ),
                                    ),
                                  )


                              ),


                              //입실날짜와 퇴실날짜를 표현하는 Text 이다.
                              Positioned(
                                  top: 175*height,
                                  left: 18*width,
                                  child: Text('입실날짜                            퇴실날짜', textAlign: TextAlign.left, style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'NanumSquareB',
                                      fontSize: MediaQuery.of(context).size.width/23,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1*height
                                  ),)
                              ),

                              //입실날짜와 퇴실날짜 텍스트 바로아래의 타원형 도형이다.
                              Positioned(
                                top: 205*height,
                                left: 14*width,
                                child: Container(
                                  height: 50*width,
                                  width: 330*height,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(225, 168, 168, 168),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(

                                  ),
                                ),

                              ),

                              //입실날짜와 퇴실날짜 텍스트 바로아래의 타원형 사이의 중간선을 의미한다 top 과 left에 width 와 height 값을 서로 반대로 적었는데 결과가 제대로나와서 걍 내비둠.
                              Positioned(
                                top: 205*height,
                                left: 54*width,
                                child: Container(
                                  height: 50*width,
                                  width: 125*height,
                                  decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Color.fromARGB(225, 168, 168, 168),
                                          width:1*width,
                                        ),
                                      )
                                  ),
                                  child: Center(

                                  ),
                                ),

                              ),

                              //사용자가 설정한 날짜가 텍스트에 출력된다. (퇴실시간 날짜)
                              Positioned(
                                top: 225*height,
                                left: 220*width,

                                child: Container(
                                  width: 120*width,
                                  height: 36*height,

                                ),
                              ),

                              //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                              Positioned(
                                top: 210*height,
                                left: -14*width,

                                child: Container(
                                  width: 120*width,
                                  height: 36*height,

                                  //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                                  child: IconButton(
                                    icon: Icon(Icons.calendar_today, color: Color.fromARGB(225, 168, 168, 168)),
                                  ),
                                ),
                              ),

                              //사용자가 설정한 날짜가 텍스트에 출력된다. (입실시간 날짜)
                              Positioned(
                                top: 223*height,
                                left: 64*width,
                                child: Container(
                                    width: 120*width,
                                    height: 36*height,

                                    //사용자가 선택한 날짜를 띄워주는 Text
                                    child : InkWell(
                                      child:Text(widget.enter_room_time,
                                        style: TextStyle(
                                          fontFamily: 'NanumSquareB',
                                          fontSize: MediaQuery.of(context).size.width/25,
                                        ),
                                      ),
                                    )

                                ),
                              ),

                              //사용자가 퇴실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                              Positioned(
                                top: 210*height,
                                left: 144*width,

                                child: Container(
                                  width: 120*width,
                                  height: 36*height,

                                  //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                                  child: IconButton(
                                    icon: Icon(Icons.calendar_today, color: Color.fromARGB(225, 168, 168, 168)),

                                  ),
                                ),
                              ),

                              //사용자가 설정한 날짜가 텍스트에 출력된다. (퇴실시간 날짜)
                              Positioned(
                                top: 223*height,
                                left: 224*width,
                                child: Container(
                                    width: 120*width,
                                    height: 36*height,

                                    //사용자가 선택한 날짜를 띄워주는 Text
                                    child : InkWell(
                                      child:Text(widget.exit_room_time,
                                        style: TextStyle(
                                          fontFamily: 'NanumSquareB',
                                          fontSize: MediaQuery.of(context).size.width/25,
                                        ),
                                      ),
                                      //onTap end
                                    )

                                ),
                              ),


                              //'인원수' 글자 밑에 있는 회색 타원형박스
                              Positioned(
                                top: 300*height,
                                left: 14*width,
                                child: Container(
                                  height: 50*width,
                                  width: 330*height,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(225, 168, 168, 168),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(

                                  ),
                                ),

                              ),

                              //드롭다운버튼 사이에서 사용자가 설정한 인원수를 표현하는 숫자다
                              Positioned(
                                  top: 315*height,
                                  left: 165*width,
                                  child:Container(
                                    child: Text(
                                      //dropdownValue.substring(0,1),
                                      supply.toString(),
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'NanumSquareB',
                                        fontSize: MediaQuery.of(context).size.width/18,
                                      ),
                                    ),
                                  )


                              ),
//
//
//
//    //검색하기 버튼이다
//    Positioned(
//    top: 585*height,
//    left: 14*width,
//    child:
//    ButtonTheme(
//    minWidth: 330*height,
//    height: 50.0*width,
//    child: RaisedButton(
//    shape: RoundedRectangleBorder(
//    borderRadius: BorderRadius.circular(10.0),
//    //side: BorderSide(color: Colors.red)
//    ),
//    color: Color.fromARGB(225, 56, 56, 56),
//    child: Text('검색하기', style: TextStyle(
//    color: Color.fromARGB(225, 255, 255, 255),
//    fontFamily: 'NanumSquareB',
//    fontSize: MediaQuery.of(context).size.width/23,)),
//    onPressed: () =>
//    {
//      //예약하기
//
//    } //onPressed
//
//    ),
//    ),
//
//
//
//
//    ),

                            ],
                          ),
                        ),

                      ],
                    ),

                  )


                ],
              )


          ),

        ),
      ),
    );


  }

  //방을 예약, 예약수정을해주는 메소드이다.
  void Bookingroom() async{
    print("Bookingroom 메소드 진입");

    //Execute_progress_bar();
    FocusScope.of(context).requestFocus(new FocusNode());
    // start the modal progress HUD 모달 프로그레스바를 시작한다 _isInAsyncCall 의 값을 false 에서 true 로 바꿈으로서 말이다.
    setState(() {
      _isInAsyncCall = true;
    });
    // Simulate a service call
    Future.delayed(Duration(seconds: 1), () {
      print("_submit 메소드 호출4");
      setState(() async {

        //예약 및 예약수정의 절차
        //1. 반복문으로 퇴실날짜 하루전까지 아래의 과정을 반복한다.
        //2. 입실날짜명의로된 다큐먼트아이디를 FIrestore에서 검색한다.
        //3. 만약 검색결과가 존재하지않는다면 사용자가 설정한 예약조건을 기반으로 Firestore에 데이터를 추가한다.
        //4. 만약 검색결과가 존재한다면 사용자가 설정한 예약조건을 기반으로 Firestore에서 데이터를 차감시킨다.

        print(widget.time_differ);
        //사용자가 머무르는 날의 숫자다
        int due=widget.time_differ;


        print(due);

        var time=DateTime.parse(widget.enter_room_time);
        var time2=DateTime.parse(widget.enter_room_time);
        print(widget.enter_room_time);
        print(due);

        //이 반복문은 손님이 설정한 날짜에 예약할 수 있는방이 있는지 체크하는 역할을 하는 반복문이다.
        for(int i=0;i<due;i++) {

          print("예약가능여부 반복문 시작");
          if (i == 0) {
            print("i=0 일때-1");
            stop=await Find_zero2(time2);
            print("stop 의 값");
            print(stop);
            if (stop == "자리없음") {
              print("예약가능여부 서버와 통신 중단");

              //호텔,게스트하우스식을 선택하는 화면으로 되돌아간다.
              Navigator.push(context, MaterialPageRoute(builder: (context) => Hotel_motel_choice_()),);

              //남은 방이 없는경우 토스트메세지를 띄운다.
              Fluttertoast.showToast(
                  msg: "이런, 빈 방이 없습니다!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

              break;
            }
          }
          else {
            time2 = time2.add(new Duration(days: 1));
            print("i=0 이 아닐때-1");
            stop=await Find_zero2(time2);
            print("stop 의 값");
            print(stop);
            if (stop == "자리없음") {
              print("예약가능여부 서버와 통신 중단");

              //호텔,게스트하우스식을 선택하는 화면으로 되돌아간다.
              Navigator.push(context, MaterialPageRoute(builder: (context) => Hotel_motel_choice_()),);

              //남은 방이 없는경우 토스트메세지를 띄운다.
              Fluttertoast.showToast(
                  msg: "이런, 빈 방이 없습니다!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

              break;
            }
          }
          print("예약가능여부 반복문 끝");
        }

        //1. 반복문으로 퇴실날짜 하루전까지 아래의 과정을 반복한다.
        for(int i=0;i<due;i++){
          print("for문 시작");
          print(time);

          if (stop == "자리없음") {
            print("서버와 통신 중단");
            break;
          }

          if(i==0){
            print("i=0 일때-2");
            Booking(time);
          }
          else{
            time=time.add(new Duration(days: 1));
            print("i=0 이 아닐때-2");
            Booking(time);
          }

          print("for문 끝");
        }


        _isInAsyncCall = false;
      });

    });


  }

  void Booking(var time){
    print("Booking 메소드 시작");

    just_one=0;

    //예약하는 절차의 코드
    Firestore.instance.collection('Tongmyung_dormitory2').document(time.toString().substring(0,10)).get() .then((DocumentSnapshot ds){
      //만약 서버에 검색결과가 존재한다면
      if(ds.exists){
        print("이미 서버에 데이터가 존재한다.");
        print("4. 만약 검색결과가 존재한다면 사용자가 설정한 예약조건을 기반으로 Firestore에서 데이터를 차감시킨다.");

        print("time");
        print(time);

        //호텔에 관한데이터를 서버에 수정
        if(widget.search_condition=="hotel" || widget.search_condition=="guest_house"){

          String supply=widget.supply.substring(0,1);
          print(supply);

          //서버로부터 받아온 남은 자리수다
          int remain = ds.data[customer_choice];

          //사용자가 설정한 숙박 인원수이다.
          int supply_int=int.parse(supply);

          //만약 남은자리숫자가 고객이 원하는 자리수보다 부족하면 토스트메세지로 남은자리가 없다고 알려준다.
          if(remain-supply_int<0){
            print("서버에 빈방이 없다고 데이터가 옴");
            print(time.toString().substring(0,10));
            print(remain-supply_int);

            //호텔,게스트하우스식을 선택하는 화면으로 되돌아간다.
            Navigator.push(context, MaterialPageRoute(builder: (context) => Hotel_motel_choice_()),);

            //남은 방이 없는경우 토스트메세지를 띄운다.
            Fluttertoast.showToast(
                msg: "이런, 빈 방이 없습니다!!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );

          }
          //만약 남은자리숫자가 충분하다면 예약을 진행한다.
          else{
            print("서버에 빈방이 남았다고 데이터가 옴");
            print(customer_choice);
            Firestore.instance.collection("Tongmyung_dormitory2").document(time.toString().substring(0,10)).updateData({customer_choice:remain-supply_int});

            if(customer_choice=="man_three_guesthouse"){
              users_room_type_for_update_data="1";
            }
            else if(customer_choice=="man_three_hotel"){
              users_room_type_for_update_data="2";
            }
            else if(customer_choice=="man_two_guesthouse"){
              users_room_type_for_update_data="3";
            }
            else if(customer_choice=="man_two_hotel"){
              users_room_type_for_update_data="4";
            }
            else if(customer_choice=="woman_four_guesthouse"){
              users_room_type_for_update_data="5";
            }
            else if(customer_choice=="woman_four_hotel"){
              users_room_type_for_update_data="6";
            }
            else if(customer_choice=="woman_three_guesthouse"){
              users_room_type_for_update_data="7";
            }
            else if(customer_choice=="woman_three_hotel"){
              users_room_type_for_update_data="8";
            }
            else if(customer_choice=="woman_two_guesthouse"){
              users_room_type_for_update_data="9";
            }
            else if(customer_choice=="woman_two_hotel"){
              users_room_type_for_update_data="10";
            }

            Firestore.instance.collection("Users").document(CurrentUser.login_user_uid).updateData({"입실일":widget.enter_room_time,"입실일후기":widget.enter_room_time,"퇴실일":widget.exit_room_time,"퇴실일후기":widget.exit_room_time,"인원":widget.supply.substring(0,1),"인원후기":widget.supply.substring(0,1),"방 유형후기":users_room_type_for_update_data,"방 유형":users_room_type_for_update_data});

            print("스캔 결과");

            //check point
//            Navigator.pop(context);
//            Navigator.pop(context);

            if(just_one==0){
              //예약완료 사실을  토스트메세지를 띄운다.
//              Fluttertoast.showToast(
//                  msg: "예약을 완료했습니다! 예약정보는 마이페이지에서 확인가능합니다.",
//                  toastLength: Toast.LENGTH_SHORT,
//                  gravity: ToastGravity.CENTER,
//                  backgroundColor: Colors.green,
//                  textColor: Colors.white,
//                  fontSize: 16.0
//              );

              //남은 방이 없는경우 토스트메세지를 띄운다.
              Fluttertoast.showToast(
                  msg: "예약을 완료했습니다! 예약정보는 마이페이지에서 확인가능합니다.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

              Navigator.pop(context);
              Navigator.pop(context);

              just_one=1;
            }



          }


        }




      }
      //만약 서버에 검색결과가 존재하지않는다면
      else if(!ds.exists){
        print("없따");
        print("3. 만약 검색결과가 존재하지않는다면 사용자가 설정한 예약조건을 기반으로 Firestore에 데이터를 추가한다.");

        //호텔에 관한데이터를 서버에 추가
        if(widget.search_condition=="hotel"){
          //사용자가 남자삼인실 호텔을 선택한 경우
          if(guest_roomtype=="1호관1유형" && widget.guest_gender=="Gender.MAN"){
            Firestore.instance.collection('Tongmyung_dormitory2').document(time.toString().substring(0,10)).setData({ 'man_two_hotel': 3, 'man_three_hotel': 88, 'woman_two_hotel':2, 'woman_three_hotel':38, 'woman_four_hotel':20, 'man_two_guesthouse':6,'man_three_guesthouse':264,'woman_two_guesthouse':4,'woman_three_guesthouse':117,'woman_four_guesthouse':80});
          }
          //사용자가 남자이인실 호텔을 선택한 경우
          else if(guest_roomtype=="1호관2유형" && widget.guest_gender=="Gender.MAN"){
            Firestore.instance.collection('Tongmyung_dormitory2').document(time.toString().substring(0,10)).setData({ 'man_two_hotel': 2, 'man_three_hotel': 89, 'woman_two_hotel':2, 'woman_three_hotel':38, 'woman_four_hotel':20, 'man_two_guesthouse':6,'man_three_guesthouse':264,'woman_two_guesthouse':4,'woman_three_guesthouse':117,'woman_four_guesthouse':80});
          }
          //사용자가 여자이인실 호텔을 선택한 경우
          else if(guest_roomtype=="1호관2유형" && widget.guest_gender=="Gender.WOMEN"){
            Firestore.instance.collection('Tongmyung_dormitory2').document(time.toString().substring(0,10)).setData({ 'man_two_hotel': 3, 'man_three_hotel': 89, 'woman_two_hotel':1, 'woman_three_hotel':38, 'woman_four_hotel':20, 'man_two_guesthouse':6,'man_three_guesthouse':264,'woman_two_guesthouse':4,'woman_three_guesthouse':117,'woman_four_guesthouse':80});
          }
          //사용자가 여자삼인실 호텔을 선택한 경우
          else if(guest_roomtype=="1호관1유형" && widget.guest_gender=="Gender.WOMEN"){
            Firestore.instance.collection('Tongmyung_dormitory2').document(time.toString().substring(0,10)).setData({ 'man_two_hotel': 3, 'man_three_hotel': 89, 'woman_two_hotel':2, 'woman_three_hotel':37, 'woman_four_hotel':20, 'man_two_guesthouse':6,'man_three_guesthouse':264,'woman_two_guesthouse':4,'woman_three_guesthouse':117,'woman_four_guesthouse':80});
          }
          //사용자가 여자사인실 호텔을 선택한 경우
          else if(guest_roomtype=="2호관2유형" && widget.guest_gender=="Gender.WOMEN"){
            Firestore.instance.collection('Tongmyung_dormitory2').document(time.toString().substring(0,10)).setData({ 'man_two_hotel': 2, 'man_three_hotel': 89, 'woman_two_hotel':2, 'woman_three_hotel':38, 'woman_four_hotel':19, 'man_two_guesthouse':6,'man_three_guesthouse':264,'woman_two_guesthouse':4,'woman_three_guesthouse':117,'woman_four_guesthouse':80});
          }


        }

        //게스트하우스에 관한데이터를 서버에 추가
        else if(widget.search_condition=="guest_house"){

          String supply=widget.supply.substring(0,1);
          print(supply);
          int supply_int=int.parse(supply);

          //사용자가 남자삼인실 게스트하우스식을 선택한 경우
          if(guest_roomtype=="1호관1유형" && widget.guest_gender=="Gender.MAN"){
            Firestore.instance.collection('Tongmyung_dormitory2').document(time.toString().substring(0,10)).setData({ 'man_two_hotel': 3, 'man_three_hotel': 89, 'woman_two_hotel':2, 'woman_three_hotel':38, 'woman_four_hotel':20, 'man_two_guesthouse':6,'man_three_guesthouse':264-supply_int,'woman_two_guesthouse':4,'woman_three_guesthouse':117,'woman_four_guesthouse':80});
          }
          //사용자가 남자이인실 게스트하우스식을 선택한 경우
          else if(guest_roomtype=="1호관2유형" && widget.guest_gender=="Gender.MAN"){
            Firestore.instance.collection('Tongmyung_dormitory2').document(time.toString().substring(0,10)).setData({ 'man_two_hotel': 3, 'man_three_hotel': 89, 'woman_two_hotel':2, 'woman_three_hotel':38, 'woman_four_hotel':20, 'man_two_guesthouse':6-supply_int,'man_three_guesthouse':264,'woman_two_guesthouse':4,'woman_three_guesthouse':117,'woman_four_guesthouse':80});
          }
          //사용자가 여자이인실 게스트하우스식을 선택한 경우
          else if(guest_roomtype=="1호관2유형" && widget.guest_gender=="Gender.WOMEN"){

            //현재 남은 침대의 수이다.
            int remain=4;
            if(supply_int-remain==0){
              print("예약할 수 없습니다. 빈 침대가 없습니다.");

              //호텔,게스트하우스식을 선택하는 화면으로 되돌아간다.
              Navigator.push(context, MaterialPageRoute(builder: (context) => Hotel_motel_choice_()),);

              //남은 방이 없는경우 토스트메세지를 띄운다.
              Fluttertoast.showToast(
                  msg: "이런, 빈 방이 없습니다!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

            }
            else{
              Firestore.instance.collection('Tongmyung_dormitory2').document(time.toString().substring(0,10)).setData({ 'man_two_hotel': 3, 'man_three_hotel': 89, 'woman_two_hotel':2, 'woman_three_hotel':38, 'woman_four_hotel':20, 'man_two_guesthouse':6,'man_three_guesthouse':264,'woman_two_guesthouse':4-supply_int,'woman_three_guesthouse':117,'woman_four_guesthouse':80});
            }

          }
          //사용자가 여자삼인실 게스트하우스식을 선택한 경우
          else if(guest_roomtype=="1호관1유형" && widget.guest_gender=="Gender.WOMEN"){
            Firestore.instance.collection('Tongmyung_dormitory2').document(time.toString().substring(0,10)).setData({ 'man_two_hotel': 3, 'man_three_hotel': 89, 'woman_two_hotel':2, 'woman_three_hotel':38, 'woman_four_hotel':20, 'man_two_guesthouse':6,'man_three_guesthouse':264,'woman_two_guesthouse':4,'woman_three_guesthouse':117-supply_int,'woman_four_guesthouse':80});
          }
          //사용자가 여자사인실 게스트하우스식을 선택한 경우
          else if(guest_roomtype=="2호관2유형" && widget.guest_gender=="Gender.WOMEN"){
            Firestore.instance.collection('Tongmyung_dormitory2').document(time.toString().substring(0,10)).setData({ 'man_two_hotel': 3, 'man_three_hotel': 89, 'woman_two_hotel':2, 'woman_three_hotel':38, 'woman_four_hotel':20, 'man_two_guesthouse':6,'man_three_guesthouse':264,'woman_two_guesthouse':4,'woman_three_guesthouse':117,'woman_four_guesthouse':80-supply_int});
          }


        }

        //time=time.add(new Duration(days: 1));
        print("time");
        print(time);

        //남은 방이 없는경우 토스트메세지를 띄운다.
        Fluttertoast.showToast(
            msg: "예약을 완료했습니다! 예약정보는 마이페이지에서 확인가능합니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );

      } //만약 검색결과가 없다면

    });

    print("Booking 메소드 끝");
  }

  Future<String> Find_zero2(var time) async {
    print("Find_zero2 호출");
    var order = await Find_zero3(time);
    print("order 의 값");
    print(order);
    print("Find_zero2 종료");
    return order;
  }

  Future<String> Find_zero3(var time){
    print("Find_zero3 호출");
    String sit="자리있음";

    Firestore.instance.collection("Tongmyung_dormitory2").document(time.toString().substring(0,10)).get().then((DocumentSnapshot ds){
      int remain = ds.data[customer_choice];
      print("Find_zero3메소드에서 불러온 remain 의 값");
      print(remain);

      //사용자가 설정한 숙박 인원수이다.
      int supply_int=int.parse(widget.supply.substring(0,1));

      //기숙사에 남아있는 자리수가 사용자가 이용하려고하는 방 or 침대수 보다 작으면 예약을 할 수 없다.
      if(remain-supply_int<0){
        print("Find_zero3메소드에서 remain이 0인경우");
        stop="자리없음";
        sit="자리없음";

        print("sit의 값");
        print(sit);
      }

    });
    print("Find_zero3 종료");
    return Future.delayed(Duration(seconds: 1), () => sit);
  }

  void Execute_progress_bar(){
    print("Execute_progress_bar");
    // dismiss keyboard during async call
    FocusScope.of(context).requestFocus(new FocusNode());
    // start the modal progress HUD 모달 프로그레스바를 시작한다 _isInAsyncCall 의 값을 false 에서 true 로 바꿈으로서 말이다.
    setState(() {
      _isInAsyncCall = true;
    });
    // Simulate a service call
    Future.delayed(Duration(seconds: 1), () {
      print("_submit 메소드 호출4");
      setState(() {
        _isInAsyncCall = false;
      });

    });


    // dismiss keyboard during async call//
//    FocusScope.of(context).requestFocus(new FocusNode());
//
//    // start the modal progress HUD 모달 프로그레스바를 시작한다 _isInAsyncCall 의 값을 false 에서 true 로 바꿈으로서 말이다.
//    setState(() {
//      _isInAsyncCall = true;
//    });
//
//    // Simulate a service call
//    Future.delayed(Duration(seconds: 1), () {
//
//      setState(() {
//        //남은 방이 없는경우 토스트메세지를 띄운다.
//        Fluttertoast.showToast(
//            msg: "예약을 완료했습니다! 예약정보는 마이페이지에서 확인가능합니다.",
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.CENTER,
//            backgroundColor: Colors.green,
//            textColor: Colors.white,
//            fontSize: 16.0
//        );
//
//        _isInAsyncCall = false;
//      });
//
//    });

  }

}
