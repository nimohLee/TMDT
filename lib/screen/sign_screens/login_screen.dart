import 'dart:async';

import 'package:tong_myung_hotel/model/homeSlide.dart';
import 'package:tong_myung_hotel/screen/book_screens/hotel_motel_choice.dart';
import 'package:tong_myung_hotel/screen/book_screens/mainScreen.dart';
import 'package:tong_myung_hotel/screen/sign_screens/passwordFind.dart';
import 'package:tong_myung_hotel/state/current_State.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:tong_myung_hotel/widgets/custom-widget-tabs.widget.dart';
import 'package:tong_myung_hotel/widgets/home_slide_dots.dart';
import 'package:tong_myung_hotel/widgets/home_slide_item.dart';
import 'package:url_launcher/url_launcher.dart';

import '../book_screens/select_booking_condition.dart';

//현재 로그인한 사용자의 UID를 보고싶다면 current_State로 갈것.

enum LoginType{
  email,
  google,
}
class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  //final globalKey = GlobalKey<ScaffoldState>();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);


  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _loginUser({@required LoginType type, String email, String password, BuildContext context}) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {

      String _returnString;

      switch(type){
        case LoginType.email:

          _returnString = await _currentUser.loginUserWithEmail(email, password);
          break;
        case LoginType.google:
          _returnString  = await _currentUser.loginUserWithGoogle(email,password);
          break;
        default:
      }

      if (_returnString == 'success') {

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => mainPage()));

      }else{

      scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('아이디 또는 비밀번호를 확인하세요'),
              duration: Duration(seconds: 2),
            ));

      print(_returnString);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _googleButton(){//구글로그인 버튼

    return Container(
      width: MediaQuery.of(context).size.width/1.37,
      height: MediaQuery.of(context).size.height/16,


      //padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/4.5, 0, MediaQuery.of(context).size.width/4.5, 0),
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: (){
          _loginUser(type: LoginType.google, context: context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 5,
       // borderSide: BorderSide(color: Colors.grey),
        child: Padding(
            padding : const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage("assets/images/google.png"),height: MediaQuery.of(context).size.width/20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '구글계정으로 로그인 하기',
                    style: TextStyle(
                      fontFamily: 'NanumSquareR',
                      fontSize: MediaQuery.of(context).size.width/23,
                    ),
                  ),
                )
              ],
            )
        ),

      ),
    );
  }


  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
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

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }






  @override
  Widget build(BuildContext context) {
    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;
    double ratio = (wi+hi)/2;

    return Scaffold(
     //backgroundColor: Colors.transparent,
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/25),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.black,size: ratio/30 ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
//        alignment: Alignment.center,
          child:
          Column(
            children: <Widget>[
              SizedBox(height: hi/15,),
//            //Text('시작하기',//Login 텍스트
//            style: TextStyle(fontSize: ratio/10,fontWeight: FontWeight.bold,color: Colors.green),textAlign: TextAlign.center,),
              Container(
                height: hi/2.5,
                child: Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, i) => HomeSlideItem(i),
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
                              for(int i = 0; i<slideList.length; i++)
                                if( i == _currentPage )
                                  HomeSlideDots(true)
                                else
                                  HomeSlideDots(false)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),),
              Container( // 이메일 입력란
                width: wi/1.37,
                padding: const EdgeInsets.fromLTRB(0,30,0,0),
                child: TextField(
                  style: TextStyle(fontSize: ratio/38, color: Colors.black54),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.alternate_email,size: wi/20,color: Colors.black54,),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: ' 이메일 주소를 입력해주세요',
                    contentPadding: const EdgeInsets.all(5),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(28, 174, 129, 1)),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(28, 174, 129, 1)),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  controller: _emailController,
                ),
              ),
//                SizedBox(
//                  height: MediaQuery.of(context).size.height/150,
//                ),

            SizedBox(height: hi/40,),
              Container( // 패스워드 입력란
                width: wi/1.37,
                height: hi/16,
                //padding: const EdgeInsets.fromLTRB(40,0,40,0),
                child: TextField(
                  obscureText: true,
                  style: TextStyle(fontSize: ratio/38, color: Colors.black54),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline,size: wi/20,color: Colors.black54,),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: ' 비밀번호를 입력해주세요',
                    contentPadding: const EdgeInsets.all(5),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(28, 174, 129, 1)),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color:  Color.fromRGBO(28, 174, 129, 1)),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  controller: _passwordController,
                ),
              ),
              SizedBox(height: hi/40,),
              Container( // 로그인하기
                width: wi/1.37,
                height: hi/16,
                //padding: const EdgeInsets.fromLTRB(10,0,10,0),
                child: FlatButton(//로그인 버튼
                  color: Color.fromRGBO(28, 174, 129, 1),
                  child: Text(
                    '로그인 하기',
                    style: TextStyle(
                      fontFamily: 'NanumSquareB',
                        fontSize: MediaQuery.of(context).size.width/20
                    ),
                  ),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(28, 174, 129, 1)),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  padding: const EdgeInsets.all(5),
                  textColor: Colors.white,
                  onPressed: () {
                    _loginUser(type: LoginType.email, email: _emailController.text, password: _passwordController.text,context: context);
                  },
                ),
              ),
              SizedBox(height: hi/40,),
              _googleButton(),
              SizedBox(height: hi/20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Text('비밀번호',style: TextStyle(decoration: TextDecoration.underline),),
                    onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FindPassword()));

                    },
                  ),
                  Text('가 기억나지 않으세요?'),

                ],
              )
          ,SizedBox(
                height: hi/20,
              )
            ]

          ),

          ),
      ),
      );
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
