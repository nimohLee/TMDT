import 'package:flutter/material.dart';
import 'package:tong_myung_hotel/screen/sign_screens/login_screen.dart';
import 'package:tong_myung_hotel/screen/sign_screens/signup_screen.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/school2.jpg"),fit: BoxFit.cover
              ),
            ),
//            color: Colors.green,
            width: width,
              height: height,
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: height/10,),
              Text('TONGMYONG\nDOMITORY', style: TextStyle(fontFamily: 'NanumSquareB',color: Color.fromRGBO(7, 47, 130, 40),fontSize: width/11),textAlign: TextAlign.center,),
              Text('- 동명 도미토리 -', style: TextStyle(fontFamily: 'NanumSquareB',color: Color.fromRGBO(7, 47, 130, 40),fontSize: width/25),textAlign: TextAlign.center,),
              SizedBox(height: height/20,),
              Text('대학 캠퍼스의 추억을 경험해보고싶지 않나요?', style: TextStyle(fontFamily: 'NanumSquareB',color: Colors.white,fontSize: width/24),),
              // SizedBox(height: height/40,),
              Text('캠퍼스 투어와 함께 하세요!', style: TextStyle(fontFamily: 'NanumSquareB',fontSize: width/18,color: Colors.white),),
              SizedBox(height: height/4,),
              Container(
                height: height/12,
                width: width/1.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: FlatButton(
                  //color: Colors.white,
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontFamily: 'NanumSquareEB',
                        fontSize: MediaQuery.of(context).size.width/19
                   ,color: Color.fromRGBO(28, 174, 129, 1)),
                  ),
//                  shape: OutlineInputBorder(
//                    borderSide: BorderSide(color: Color.fromRGBO(133, 192, 64, 80)),
//                    borderRadius: BorderRadius.circular(60),
//                  ),
                  padding: const EdgeInsets.all(5),
                  textColor: Colors.white,
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));

                  },
                ),
              ),
              // SizedBox(height: height/35,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('회원이 아니신가요?  ',style: TextStyle(
                    fontFamily: 'NanumSquareR',color: Colors.white,
                    fontSize: width/25,
                  )),
                  InkWell(
                    child: Text('회원가입',
                    style: TextStyle(
                        fontFamily: 'NanumSquareEB',
                        fontSize: width/25,color: Colors.white,
                      decoration: TextDecoration.underline
                    ),),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SignupScreen()));

                    },
                  )

                ],
              )
            ],
          )),
        ),

    );
  }
}
