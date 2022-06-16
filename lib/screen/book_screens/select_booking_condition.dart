//사용자가 방을 예약하기위해 자신이 원하는 옵션을 고르는 기능을 할 수 있는 화면이다.

import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tong_myung_hotel/CustomButtons/ButtonTextStyle.dart';
import 'package:tong_myung_hotel/CustomButtons/CustomRadioButton.dart';
import 'package:tong_myung_hotel/method_variable_collection.dart';

import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/model/bookingConditionSlide.dart';
import 'package:tong_myung_hotel/model/homeSlide.dart';
import 'package:tong_myung_hotel/screen/book_screens/booking_room.dart';
import 'package:tong_myung_hotel/widgets/bookingCondition_slide_dots.dart';
import 'package:tong_myung_hotel/widgets/bookingCondition_slide_item.dart';
import 'package:tong_myung_hotel/widgets/home_slide_dots.dart';

////PageController 를 사용하기위해 import 한 녀석들이다.////
import '../../widgets/slide_item.dart';
import '../../model/slide.dart';
import '../../widgets/slide_dots.dart';
////PageController 를 사용하기위해 import 한 녀석들이다.////

class Book_room_stful extends StatefulWidget {
  String type;

  Book_room_stful({
    this.type,
  });

  @override
  _Book_room_stfulState createState() => _Book_room_stfulState();
}

class _Book_room_stfulState extends State<Book_room_stful> {

  // 라디오 버튼을 클릭할때마다 바뀌는 UI 를 표현하기위한 변수이다. (남자 라디오 버튼)
  var change_radio_button_man=true;

  // 라디오 버튼을 클릭할때마다 바뀌는 UI 를 표현하기위한 변수이다. (여자 라디오 버튼)
  var change_radio_button_woman=false;

  // 다음부터 이런 변수는 남기지 말것.
  int a=1;

  //edit this
  bool selected = true;
  //사용자가 설정하는 퇴실날짜 시간이다.
  DateTime _dateTime_exit_room_time;
  //사용자가 설정하는 입실날짜 시간이다.
  DateTime _dateTime_enter_room_time;

  ////////  체크박스의 남자와 여자를 체크하기위해 존재하는 변수이다.   ////////
  int _counter=0;
  var _isChecked=false;


  //고객이 설정한 성별이다.
  String gender;
  String _gender="Gender.MAN";

  var result;

  Object get type => null;

  void _incrementCounter(){
    setState((){

      _counter++;

    });
  }
  ////////  체크박스의 남자와 여자를 체크하기위해 존재하는 변수이다.   ////////

  //방에 들어갈 인원수를 표현하기위한 코드들이다.
  //초기값
  String dropdownValue = '';
  int dropdownValue_Integer=1;

  /////////////////////   방유형을 표현하는 PageController 와 관련된 코드이다.  ////////////////////

  //최근 페이지를 의미한다.
  int _currentPage = 0;
  //스피너의 현재 페이지를 표현하기위한 변수다
  int now_page = 0;

  //PageController : A controller for [PageView].
  //내 생각 : 한장씩 바뀌는 페이지를 표현해주는 코드인듯 하다. 가장 첫페이지는 PageController의 생성자를 통해서 0으로 설정되있다.
  final PageController _pageController = PageController(initialPage: 0);

  /////////////////////   방유형을 표현하는 PageController 와 관련된 코드이다.  ////////////////////

  /////////////////////   Time Picker 기능(달력에서 시간설정하기) 기능을 사용하기위한 코드이다  ////////////////////
  String _selectedDate = '날짜 선택';
  //입실시간 UI 색깔이다.
  Color enter_time_Color = Color.fromARGB(225, 168, 168, 168);
  //퇴실시간 UI 색깔이다.
  Color exit_time_Color = Color.fromARGB(225, 168, 168, 168);

  /////////////////////   Time Picker 기능(달력에서 시간설정하기) 기능을 사용하기위한 코드이다  ////////////////////

  @override
  void initState() {
    super.initState();

    //한페이지가 얼만큼 머루를것인지 시간을 설정해주는 코드인듯 하다.
    //Timer : Creates a new repeating timer. (periodic : 반복되는)

    //"만약 5초의 시간이 흐른다면" 을 표현하는 코드인듯. 사진이 한번씩 바뀌는 시간주기이다.
    Timer.periodic(Duration(seconds: 50000), (Timer timer) {

      //animateToPage : Animates(만화영화로 만들다) the controlled [PageView] from the current page to the given page.
      _pageController.animateToPage(
        _currentPage,

        // The animation lasts for the given duration and follows the given curve.
        // 애니메이션이 주어진 시간동안 유지되고 주어진 curve에 따른다.
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  //페이지가 바뀔 때 마다 호출되는 메소드이다. 현재 몇번째 페인지 변수로 알 수 있다.
  _onPageChanged(int index) {
    setState(() {
      if(index==2){
        _currentPage=3;
        now_page=2;
        print("_currentPage1");
        print(_currentPage);
      }
      else{
        _currentPage = index;
        now_page=index;
        print("_currentPage2");
        print(_currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    //전체 Container  이 코드는 S20 을 기준으로 했을때 유효한 코드다.
//    double width=getWidthRatio(360,context);
//    double height=getHeightRatio(640,context);

    //핸드폰 전체크기의 비율값
    double width=getWidthRatio(MediaQuery.of(context).size.width,context);
    double height=getHeightRatio(MediaQuery.of(context).size.height,context);
    double ratio = (MediaQuery.of(context).size.width+MediaQuery.of(context).size.height)/2;

    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);

    print(width);
    print(height);

    //사용자가 묶을 방의형태에 따라 인원수를 설정하는 스피너는 보일 수 도 있고 안보일 수 도 있다. 스피너유무를 설정해주는 변수이다.
    var spinner_condition;

    if(Variable.sleep_type=="Hotel"){
      spinner_condition=false;
      Count_Hotel();
    }
    else if(Variable.sleep_type=="Guest_House"){
      spinner_condition=true;
    }

    //사용자가 설정한 입실날짜가 오늘보다 과거를 선택했는지 알려주는 변수다. 값이 음수일 경우 사용자가 잘못 설정한거다.
    int check_enter_day;

    //사용자가 입력한 입실날짜와 퇴실날짜의 차이를 표현하는 변수다.
    String time_differ;

    //사용자가 입력한 입실날짜와 퇴실날짜의 차이를 표현하는 변수다. (int 형)
    int time_differ_Integer;

    // 사용자가 몇일이나 묶는지 확인할 때 조건문에 필요한 변수
    int idx;
    String gap;

    int test_Integer;

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
        body: SingleChildScrollView(
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
                    top: 209*height,
                        left: 18*width,
                        child: Text('인원수', textAlign: TextAlign.left, style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'NanumSquareB',
                            fontSize: MediaQuery.of(context).size.width/27,
                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1*height
                        ),)
                    ),

                    //"(최대 4인까지 가능)" 텍스트를 표현한다
                    Positioned(
                        top: 209*height,
                        left: 55*width,
                        child: Text('(최대 4인까지 가능)', textAlign: TextAlign.left, style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'NanumSquareB',
                            fontSize: MediaQuery.of(context).size.width/32,
                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1*height
                        ),)
                    ),

                    //"방의유형" 텍스트를 표현한다.
                    Positioned(
                        top: 307*height,
                        left: 18*width,
                        child: Text('방의 유형', textAlign: TextAlign.left, style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'NanumSquareB',
                            fontSize: MediaQuery.of(context).size.width/27,
                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1*height
                        ),)
                    ),

                    //"성별" 텍스트를 표현한다.
                    Positioned(
                        top: 10*height,
                        left: 18*width,
                        child: Text('성별', textAlign: TextAlign.left, style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'NanumSquareB',
                            fontSize: MediaQuery.of(context).size.width/27,
                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1*height
                        ),)
                    ),

                    //입실날짜와 퇴실날짜를 표현하는 Text 이다.
                    Positioned(
                        top: 111*height,
                        left: 18*width,
                        child: Text('입실날짜                                   퇴실날짜', textAlign: TextAlign.left, style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'NanumSquareB',
                            fontSize: MediaQuery.of(context).size.width/27,
                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1*height
                        ),)
                    ),

                    //입실날짜와 퇴실날짜 텍스트 바로아래의 타원형 도형이다.
                    Positioned(
                      top: 140*height,
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
                      top: 140*height,
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

                    //성별선택에 라디오버튼(남자)
                    Positioned(
                      top: 45*height,
                      left: 14*width,
                      child:
                      Container(
                        padding: EdgeInsets.all(3.5),

                        child: change_radio_button_man==true?
                        ButtonTheme(
                          minWidth: 160*width,
                          height: 50*height,
                          child : FlatButton(

                            child: Text( change_radio_button_man ? "남자" : "남자",style: TextStyle(fontSize: MediaQuery.of(context).size.width/20,fontWeight: FontWeight.w300,fontFamily: 'NanumSquareB'),),
                            onPressed: () {
                              setState(() {
                                _gender="Gender.MAN";
                                Change_page();
                                if(change_radio_button_man==true){
                                  change_radio_button_man=true;
                                  change_radio_button_woman=false;
                                }
                                else if(change_radio_button_man==false){
                                  change_radio_button_man=true;
                                  change_radio_button_woman=false;
                                }

                                //change_radio_button_man = !change_radio_button_man;
                                //change_radio_button_woman = !change_radio_button_woman;
                                print("눌렀다고1");
                                print(change_radio_button_man);
                              });
                            },
                            textColor: Colors.white,
                            color:  Color.fromARGB(225, 28, 174, 129),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              //bottomRight: Radius.circular(12),
                              topLeft: Radius.circular(10),
                              //topRight:Radius.circular(12),

                            ),),
                          ),
                        )
                            : ButtonTheme(
                          minWidth: 160*width,
                          height: 50*height,
                          child:FlatButton(
                            child: Text( change_radio_button_man ? "남자" : "남자",style: TextStyle(fontSize: MediaQuery.of(context).size.width/20,fontWeight: FontWeight.w300, fontFamily: 'NanumSquareB'),),
                            onPressed: () {
                              setState(() {
                                _gender="Gender.MAN";
                                Change_page();
                                if(change_radio_button_man==true){
                                  change_radio_button_man=true;
                                  change_radio_button_woman=false;
                                }
                                else if(change_radio_button_man==false){
                                  change_radio_button_man=true;
                                  change_radio_button_woman=false;
                                }

                                //change_radio_button_man = !change_radio_button_man;
                                //change_radio_button_woman = !change_radio_button_woman;
                                print("눌렀다고2");
                                print(change_radio_button_man);
                              });
                            },
                            textColor: Colors.black,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                //bottomRight: Radius.circular(12),
                                topLeft: Radius.circular(10),
                                //topRight:Radius.circular(12),
                              ),
                              side: BorderSide(color: Color.fromARGB(225, 168, 168, 168),),
                            ),
                          ),
                        ),



                      ),

                    ),

                    //성별선택에 라디오버튼(여자)
                    Positioned(
                      top: 45*height,
                      left: 174*width,
                      child:
                      Container(
                        padding: EdgeInsets.all(3.5),

                        child: change_radio_button_woman==true?
                        ButtonTheme(
                          minWidth: 160*width,
                          height: 50*height,
                          child : FlatButton(

                            child: Text( change_radio_button_woman ? "여자" : "여자",style: TextStyle(fontSize: MediaQuery.of(context).size.width/20,fontWeight: FontWeight.w300,fontFamily: 'NanumSquareB'),),
                            onPressed: () {
                              setState(() {
                                _gender="Gender.WOMEN";
                                Change_page();
                                if(change_radio_button_woman==true){
                                  change_radio_button_woman=true;
                                  change_radio_button_man=false;
                                }
                                else if(change_radio_button_woman==false){
                                  change_radio_button_woman=true;
                                  change_radio_button_man=false;
                                }

                                //change_radio_button_woman = !change_radio_button_woman;
                                print("눌렀다고1");
                                print(change_radio_button_woman);
                              });
                            },
                            textColor: Colors.white,
                            color:  Color.fromARGB(225, 28, 174, 129),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                              //bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              //topLeft: Radius.circular(10),
                              topRight:Radius.circular(10),

                            ),),
                          ),
                        )
                            : ButtonTheme(
                          minWidth: 160*width,
                          height: 50*height,
                          child:FlatButton(
                            child: Text( change_radio_button_woman ? "여자" : "여자",style: TextStyle(fontSize: MediaQuery.of(context).size.width/20,fontWeight: FontWeight.w300, fontFamily: 'NanumSquareB'),),
                            onPressed: () {
                              setState(() {
                                _gender="Gender.WOMEN";
                                Change_page();
                                if(change_radio_button_woman==true){
                                  change_radio_button_woman=true;
                                  change_radio_button_man=false;
                                }
                                else if(change_radio_button_woman==false){
                                  change_radio_button_woman=true;
                                  change_radio_button_man=false;
                                }

                                //change_radio_button_woman = !change_radio_button_woman;
                                print("눌렀다고2");
                                print(change_radio_button_woman);
                              });
                            },
                            textColor: Colors.black,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                //bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                //topLeft: Radius.circular(10),
                                topRight:Radius.circular(10),
                              ),
                              side: BorderSide(color: Color.fromARGB(225, 168, 168, 168),),
                            ),
                          ),
                        ),
                      ),
                    ),



                    //사용자가 설정한 날짜가 텍스트에 출력된다. (퇴실시간 날짜)
                    Positioned(
                      top: 145*height,
                      left: 220*width,

                      child: Container(
                        width: 120*width,
                        height: 36*height,

                      ),
                    ),

                    //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                    Positioned(
                      top: 143*height,
                      left: -14*width,

                      child: Container(
                        width: 120*width,
                        height: 36*height,

                        //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                        child: IconButton(
                          icon: Icon(Icons.calendar_today, color: enter_time_Color),
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: _dateTime_enter_room_time == null ? DateTime.now() : _dateTime_enter_room_time,


                                //달력내에서 선택할 수 있는 첫 년도이다.
                                firstDate: DateTime(2020),

                                //달력내에서 선택할 수 있는 제일 마지막 년도이다.
                                lastDate: DateTime(2024)
                            ).then((date){
                              setState((){
                                _dateTime_enter_room_time=date;
                                _selectedDate=_dateTime_enter_room_time.toString();
                                print("입실날짜 "+_dateTime_enter_room_time.toString());

                              });
                            });

                            //입실날짜를 사용자가 선택하는경우 달력과 설정한 시간을 표현하는 텍스트의 색깔을 변경시켜준다.
                            print(_selectedDate);
                            enter_time_Color = Color.fromARGB(225,56,56,56);

                          },  //onPressed end
                        ),
                      ),
                    ),

                    //사용자가 설정한 날짜가 텍스트에 출력된다. (입실시간 날짜)
                    Positioned(
                      top: 154*height,
                      left: 64*width,
                      child: Container(
                          width: 120*width,
                          height: 36*height,

                          //사용자가 선택한 날짜를 띄워주는 Text
                          child : InkWell(
                            child:Text(_dateTime_enter_room_time == null ? '입실 날짜 선택' : _dateTime_enter_room_time.toString().substring(0,10),
                              style: TextStyle(
                                color: enter_time_Color,
                                fontFamily: 'NanumSquareB',
                              ),
                            ),
                            onTap: (){
                              //사용자가 입실날짜를 설정하기위한 버튼을 누르면 버튼의 색을 수정시킨다.
                              enter_time_Color = Color.fromARGB(225,56,56,56);
                              showDatePicker(
                                  context: context,
                                  initialDate: _dateTime_enter_room_time == null ? DateTime.now() : _dateTime_enter_room_time,

                                  //달력내에서 선택할 수 있는 첫 년도이다.
                                  firstDate: DateTime(2020),

                                  //달력내에서 선택할 수 있는 제일 마지막 년도이다.
                                  lastDate: DateTime(2024)
                              ).then((date){
                                setState((){
                                  _dateTime_enter_room_time=date;
                                  _selectedDate=_dateTime_enter_room_time.toString();
                                  print("입실날짜 "+_dateTime_enter_room_time.toString());

                                  //만약 사용자가 날짜를 선택하지않고 취소를 한다면 다시 회색으로 달력및 글을 출력한다.
                                  if(date==null){
                                    enter_time_Color = Color.fromARGB(225, 168, 168, 168);
                                  }
                                });
                              });
                            },    //onTap end
                          )

                      ),
                    ),

                    //사용자가 퇴실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                    Positioned(
                      top: 143*height,
                      left: 144*width,

                      child: Container(
                        width: 120*width,
                        height: 36*height,

                        //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                        child: IconButton(
                          icon: Icon(Icons.calendar_today, color: exit_time_Color),
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: _dateTime_exit_room_time == null ? DateTime.now() : _dateTime_exit_room_time,

                                //달력내에서 선택할 수 있는 첫 년도이다.
                                firstDate: DateTime(2020),

                                //달력내에서 선택할 수 있는 제일 마지막 년도이다.
                                lastDate: DateTime(2024)
                            ).then((date){
                              setState((){
                                _dateTime_exit_room_time=date;
                                _selectedDate=_dateTime_exit_room_time.toString();
                                print("퇴실날짜 "+_dateTime_exit_room_time.toString());

                              });
                            });

                            //입실날짜를 사용자가 선택하는경우 달력과 설정한 시간을 표현하는 텍스트의 색깔을 변경시켜준다.
                            print(_selectedDate);
                            enter_time_Color = Color.fromARGB(225,56,56,56);

                          },  //onPressed end
                        ),
                      ),
                    ),

                    //사용자가 설정한 날짜가 텍스트에 출력된다. (퇴실시간 날짜)
                    Positioned(
                      top: 154*height,
                      left: 224*width,
                      child: Container(
                          width: 120*width,
                          height: 36*height,

                          //사용자가 선택한 날짜를 띄워주는 Text
                          child : InkWell(
                            child:Text(_dateTime_exit_room_time == null ? '퇴실 날짜 선택' : _dateTime_exit_room_time.toString().substring(0,10),
                              style: TextStyle(
                                color: enter_time_Color,
                                fontFamily: 'NanumSquareB',
                              ),
                            ),
                            onTap: (){
                              //사용자가 입실날짜를 설정하기위한 버튼을 누르면 버튼의 색을 수정시킨다.
                              exit_time_Color = Color.fromARGB(225,56,56,56);
                              showDatePicker(
                                  context: context,
                                  initialDate: _dateTime_exit_room_time == null ? DateTime.now() : _dateTime_exit_room_time,

                                  //달력내에서 선택할 수 있는 첫 년도이다.
                                  firstDate: DateTime(2020),

                                  //달력내에서 선택할 수 있는 제일 마지막 년도이다.
                                  lastDate: DateTime(2024)
                              ).then((date){
                                setState((){
                                  _dateTime_exit_room_time=date;
                                  _selectedDate=_dateTime_exit_room_time.toString();
                                  print("톼실날짜 "+_dateTime_exit_room_time.toString());

                                  //만약 사용자가 날짜를 선택하지않고 취소를 한다면 다시 회색으로 달력및 글을 출력한다.
                                  if(date==null){
                                    exit_time_Color = Color.fromARGB(225, 168, 168, 168);
                                  }
                                });
                              });
                            },    //onTap end
                          )

                      ),
                    ),


                    //'인원수' 글자 밑에 있는 회색 타원형박스
                    Positioned(
                      top: 240*height,
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

                    // - 버튼을 표현한다.
                    Positioned(
                        top: 245*height,
                        left: -8*width,
                        //사용자가 호텔식, 게스트하우스식 무엇을 선택하냐에 따라서 보여지는 UI가 다르다.
                        child: spinner_condition == true ? new

                        //사용자가 게스트하우스식을 선택한다면 드랍다운버튼이 표현되는 UI를 보여준다.
                        Container(
                          width: 110*width,
                          height: 39*height,

                          //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                          child: IconButton(
                            icon: Icon(Icons.remove_circle_outline, color: Color.fromARGB(225, 28, 174, 129),),
                            onPressed: Count_people_minus,
                          ),
                        )

                        //만약 사용자가 호텔식을 선택했다면 드롭다운 버튼의 UI 는 보이지 않는다.
                            : new Container(

                        )
                    ),

                    // + 버튼을 표현한다.
                    Positioned(
                        top: 245*height,
                        left: 245*width,
                        //사용자가 호텔식, 게스트하우스식 무엇을 선택하냐에 따라서 보여지는 UI가 다르다.
                        child: spinner_condition == true ? new

                        //사용자가 게스트하우스식을 선택한다면 드랍다운버튼이 표현되는 UI를 보여준다.
                        Container(
                          width: 110*width,
                          height: 39*height,

                          //사용자가 입실날짜를 선택할 수 있는 버튼이다. 누르면 달력이 나와서 날짜 설정이 가능하다.
                          child: IconButton(
                            icon: Icon(Icons.add_circle_outline, color: Color.fromARGB(225, 28, 174, 129),),
                            onPressed: Count_people_plus,
                          ),
                        )
                        //만약 사용자가 호텔식을 선택했다면 드롭다운 버튼의 UI 는 보이지 않는다.
                            : new Container(

                        )
                    ),

                    //드롭다운버튼 사이에서 사용자가 설정한 인원수를 표현하는 숫자다
                    Positioned(
                        top: 256*height,
                        left: 180*width,
                        child:Container(
                          child: Text(
                            //dropdownValue.substring(0,1),
                            '$dropdownValue_Integer',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'NanumSquareB',
                              fontSize: MediaQuery.of(context).size.width/18,
                            ),
                          ),
                        )


                    ),

                    //방의유형을 표현하는 PageController 이다.
                    Positioned(
                      top: 327*height,
                      left: 14*width,
                      child: SingleChildScrollView(
                          child: Container(
                              width: 333*width,
                              height: 240*height,

                              child: Expanded(
                                  child: Stack(
                                      alignment: AlignmentDirectional.bottomCenter,
                                      children: <Widget>[


                                      //방의 유형을 판별해주는 조건문이다.
                                      _gender.toString() == "Gender.MAN" ?

                                  //움직이는 페이지를 표현한다. (남자 손님들이 봐야하는 페이지)
                                  new PageView.builder(
                                    scrollDirection: Axis.horizontal,
                                    controller: _pageController,
                                    onPageChanged: _onPageChanged,

                                    itemCount: man_type.length,
                                    //itemCount: woman_type.length,
                                    itemBuilder: (ctx, i) => BookingCondition_slide_item(i),
                                  ) :

                                  //움직이는 페이지를 표현한다. (여자 손님들이 봐야하는 페이지)
                                  new PageView.builder(
                                    scrollDirection: Axis.horizontal,
                                    controller: _pageController,
                                    onPageChanged: _onPageChanged,

                                    //itemCount: woman_type.length,
                                    itemCount: slideList_room_condition.length,
                                    //itemCount: man_type.length,
                                    itemBuilder: (ctx, i) => BookingCondition_slide_item(i),
                                  ),

                                  Stack(
                                      alignment: AlignmentDirectional.topStart,
                                      children: <Widget>[

                                  Container(
                                  margin: const EdgeInsets.only(bottom: 3),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                  for(int i = 0; i<slideList_room_condition.length; i++)
                                  if( i == now_page )
                              BookingConditionSlideDots(true)
                          else
                          BookingConditionSlideDots(false)
                      ],
                    ),
                  )

                ],
              )
              ],
            ),
          ),

        )),
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
    color: Color.fromARGB(225, 56, 56, 56),
    child: Text('검색하기', style: TextStyle(
    color: Color.fromARGB(225, 255, 255, 255),
    fontFamily: 'NanumSquareB',
    fontSize: MediaQuery.of(context).size.width/23,)),
    onPressed: () =>
    {
    print("검색하기 누름"),

    //사용자가 선택한 입실날짜는 오늘보다 과거이면 안된다. 만약 그렇게 설정했을 경우를 대비해서 사용자에게 재설정해라고 알려주는 역할을 해주는 메소드다.
    check_enter_day=Compare_today_with_enterDay(),

    //사용자가 입실날짜를 제대로 설정했을 경우
    if(check_enter_day>=0){
    ////time_differ=_dateTime_exit_room_time.difference(_dateTime_enter_room_time).toString(),
    time_differ=FindException(),
    print(time_differ),
    idx = time_differ.indexOf(":"),
    gap = time_differ.substring(0, idx),
    time_differ_Integer=int.parse(gap),
    time_differ_Integer=time_differ_Integer~/24,
    print("퇴실일과 입실일의 차이"),
    print(time_differ_Integer),

    //사용자가 입실날짜와 퇴실날짜를 잘못 입력한 경우 토스트메세지로 알려준다.
    if(time_differ_Integer<=0){
    Fluttertoast.showToast(
    msg: "입실날짜와 퇴실날짜를 정확하게 선택해주세요",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0
    ),
    }

    //사용자가 입실날짜와 퇴실날짜를 제대로 입력한 경우
    else{
    //사용자가 호텔식을 선택했을 때 Firestore에서 실제로 차감되야 하는 수는 방의 개수1개 임으로 4가아닌 1로 초기화한다.
    if(Variable.sleep_type=="Hotel"){
    dropdownValue_Integer=1,
    },
    dropdownValue=dropdownValue_Integer.toString()+'명',
    Navigator.of(context).push(
    MaterialPageRoute(builder: (context) =>

    Booking_room(
    search_condition: widget.type,
    guest_gender: _gender.toString(),
    exit_room_time: _dateTime_exit_room_time.toString().substring(0, 10),
    enter_room_time: _dateTime_enter_room_time.toString().substring(0, 10),
    room_type: _currentPage.toString(),
    supply: dropdownValue,
    time_differ: time_differ_Integer)
    ),
    ),
    }
    }
    //사용자가 입실날짜를 오늘보다 과거로 설정한 경우
    else if(check_enter_day<0){
    Fluttertoast.showToast(
    msg: "입실날짜를 정확하게 설정해주세요",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0
    ),
    }

    } //onPressed

    ),
    ),




    ),

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

  //인원수를 설정하는 메소드이다. (마이너스 버튼을 누른경우)
  void Count_people_minus() {
    setState(() {

      dropdownValue_Integer--;
      if(dropdownValue_Integer<=0){
        dropdownValue_Integer=0;
      }

    });
  }

  //사용자가 설정한 입실날짜와 오늘을 비교하는 메소드이다.
  Compare_today_with_enterDay(){
    print("Compare_today_with_enterDay");

    //오늘 날짜를 표현하는 변수이다. 사용자가 입력한 입실날짜와 비교해야한다.
    DateTime today=DateTime.now();

    print("select_... initState 함수 호출");
    String today_str=today.toString().substring(0, 10).toString()+" 00:00:00.000";

    print(today_str);

    today = DateTime.parse(today_str);

    print("today 값");
    print(today);

    String time_differ_=_dateTime_enter_room_time.difference(today).toString();

    int idx = time_differ_.indexOf(":");
    String gap = time_differ_.substring(0, idx);
    int time_differ_Integer=int.parse(gap);
    time_differ_Integer=time_differ_Integer~/24;
    print("입실일과 오늘의 차이");
    print(time_differ_Integer);

    return time_differ_Integer;
  }

  //인원수를 설정하는 메소드이다. (플러스 버튼을 누른경우)
  void Count_people_plus() {
    setState(() {

      dropdownValue_Integer++;
      if(dropdownValue_Integer>=4){
        dropdownValue_Integer=4;
      }
    });
  }

  //만약 사용자가 호텔식을 설정했다면 인원수는 디폴트로 4로 설정한다.
  void Count_Hotel(){
    dropdownValue_Integer=4;
  }


  // 입실일과 퇴실일을 사용자가 입력하지 않았을 때 입력해라고 정보를 알리기위한 메소드이다.
  FindException() {
    String time_differ_;
    try{
      time_differ_=_dateTime_exit_room_time.difference(_dateTime_enter_room_time).toString();
    }

    //입실날짜와 퇴실날짜를 사용자가 정확하게 누르지 않은 경우
    catch(e){
      Fluttertoast.showToast(
          msg: "입실날짜와 퇴실날짜를 정확하게 선택해주세요",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }

    return time_differ_;
  }

  // 사용자가 검색조건에서 성별을 여자로 선택했을 때 방의 유형을 선택하는 PageController 를 값을 0으로 초기화 시켜준다.
  void Change_page(){
    print("Change_page 메소드 호출");
    //_pageController = PageController(initialPage: 0);
    _pageController.jumpToPage(0);
  }

}

