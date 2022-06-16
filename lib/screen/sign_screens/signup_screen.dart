import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:tong_myung_hotel/screen/book_screens/hotel_motel_choice.dart';
import 'package:tong_myung_hotel/screen/book_screens/mainScreen.dart';
import 'package:tong_myung_hotel/state/currentUser.dart';
import 'package:tong_myung_hotel/state/current_State.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tong_myung_hotel/widgets/custom-widget-tabs.widget.dart';
import '../book_screens/select_booking_condition.dart';


class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final signUpKey = GlobalKey<ScaffoldState>();
  final Color sig = Color.fromRGBO(28, 174, 129, 1);

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  CurrentUser _currentUser;

  void _signUpUser(String name, String email, String password, String phone,
      BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: null,
        verificationFailed: null,
        codeSent: null,
        codeAutoRetrievalTimeout: null
    );

    CurrentUser _currentUser =
        Provider.of<CurrentUser>(context, listen: false); //context는 무엇?

    try {
      String _returnString =
          await _currentUser.signUpUser(name, email, password, phone);
      if (_returnString == 'success') {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => mainPage()));
      } else {
//        Scaffold.of(context).showSnackBar(
//            SnackBar(
//              content: Text(_returnString),
//              duration: Duration(seconds: 2),
//            )
//        );
        signUpKey.currentState.showSnackBar(SnackBar(
          content: Text('가입정보를 확인해주세요'),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;
    double ratio = (wi + hi) / 2;
    return Scaffold(
      key: signUpKey,
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 15),
        child: AppBar(
          title: Row(children: [
            SizedBox(
              width: wi / 5,
            ),
            Text(
              '회원가입',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'NanumSquareB',
                  fontSize: ratio / 30),
              textAlign: TextAlign.center,
            )
          ]),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Colors.black, size: ratio / 30),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            //color: Theme.of(context).primaryColor,
            width: double.infinity,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/signup_logo.gif',
                      height: hi / 5,
                      width: wi / 5,
                    ), //TU 로고이미지
                    SizedBox(
                      height: hi / 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,

                      // Email 주소 입력란
                      style: TextStyle(
                          fontSize: wi / 22,
                          color: Colors.black,
                          fontFamily: 'NanumSquareR'),
//
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontSize: wi / 22,
                            color: Colors.black54,
                            fontFamily: 'NanumSquareR'),
                        prefixIcon: Icon(
                          Icons.alternate_email,
                          size: wi / 20,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: ' 이메일 주소를 입력해주세요',
                        contentPadding: const EdgeInsets.all(5),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: sig),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.2),
                        ),
                      ),
                      validator: (val) => val.isEmpty ? '이메일을 입력해주세요' : null,
                      controller: _emailController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      // 이름 입력란
                      style: TextStyle(
                          fontSize: wi / 22,
                          color: Colors.black,
                          fontFamily: 'NanumSquareR'),
//
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontSize: wi / 22,
                            color: Colors.black54,
                            fontFamily: 'NanumSquareR'),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          size: wi / 20,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: ' 이름을 입력해주세요',
                        contentPadding: const EdgeInsets.all(5),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: sig),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.2),
                        ),
                      ),
                      controller: _usernameController,
                      validator: (val) => val.isEmpty ? '이름을 입력해주세요' : null,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(11),
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      // 전화번호 입력란
                      style: TextStyle(
                          fontSize: wi / 22,
                          color: Colors.black,
                          fontFamily: 'NanumSquareR'),
//
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontSize: wi / 22,
                            color: Colors.black54,
                            fontFamily: 'NanumSquareR'),
                        prefixIcon: Icon(
                          Icons.phone,
                          size: wi / 20,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: ' 휴대폰번호를 입력해주세요',
                        contentPadding: const EdgeInsets.all(5),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: sig),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.2),
                        ),
                      ),
                      controller: _phoneController,
                      validator: (val) => val.isEmpty ? '휴대폰번호를 입력해주세요' : null,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(14),
                        WhitelistingTextInputFormatter(
                          RegExp("[a-z,0-9,!,@,#]"),
                        )
                      ],

                      // 비밀번호 입력란
                      obscureText: true,

                      style: TextStyle(
                          fontSize: wi / 22,
                          color: Colors.black,
                          fontFamily: 'NanumSquareR'),
//
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontSize: wi / 22,
                            color: Colors.black54,
                            fontFamily: 'NanumSquareR'),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          size: wi / 20,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '비밀번호를 입력해주세요',
                        contentPadding: const EdgeInsets.all(5),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: sig),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.2),
                        ),
                      ),
                      controller: _passwordController,
                      validator: (val) => val.isEmpty ? '비밀번호를 입력해주세요' : null,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(14),
                        WhitelistingTextInputFormatter(
                          RegExp("[a-z,0-9,!,@,#]"),
                        )
                      ],
                      //비밀번호 확인 입력란
                      obscureText: true,
                      style: TextStyle(
                          fontSize: wi / 22,
                          color: Colors.black,
                          fontFamily: 'NanumSquareR'),
//
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontSize: wi / 22,
                            color: Colors.black54,
                            fontFamily: 'NanumSquareR'),
                        prefixIcon: Icon(
                          Icons.lock,
                          size: wi / 20,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: ' 비밀번호를 한 번 더 입력해주세요',
                        contentPadding: const EdgeInsets.all(5),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: sig),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.2),
                        ),
//                        enabledBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: sig),
//                          borderRadius: BorderRadius.circular(30),
//                        ),
                      ),
                      controller: _confirmPasswordController,
                      validator: (val) =>
                          val.isEmpty ? '비밀번호를 한 번 더 입력해주세요' : null,
                    ),
                    SizedBox(
                      height: hi / 20,
                    ),
                    FlatButton(
                      color: sig,
                      child: Text(
                        '회원가입 하기',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 20,
                            fontFamily: 'NanumSquareB'),
                      ),
                      shape: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(133, 192, 64, 80)),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      padding: const EdgeInsets.all(15),
                      textColor: Colors.white,
                      onPressed: () {
                        if (_passwordController.text ==
                            _confirmPasswordController.text) {
                          if (_emailController.text.contains('@') &&
                              _usernameController.text.isNotEmpty &&
                              _phoneController.text.isNotEmpty) // 이메일 비었을 시
                            _signUpUser(
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text,
                                _phoneController.text,
                                context);
                          else if (_emailController.text.isEmpty)
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("이메일을 입력해주세요"),
                              //화면 하단에  잠깐  나오는 오류 바
                              duration: Duration(seconds: 2),
                            ));
                          else if(!_emailController.text.contains('@'))
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("유효하지 않은 이메일 형식입니다"),
                              //화면 하단에  잠깐  나오는 오류 바
                              duration: Duration(seconds: 2),
                            ));
                          else if (_usernameController.text.isEmpty)
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("이름을 입력해주세요"),
                              //화면 하단에  잠깐  나오는 오류 바
                              duration: Duration(seconds: 2),
                            ));
                          else if (_phoneController.text.isEmpty ||
                              _phoneController.text.length <= 10)
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("휴대폰 번호를 확인해주세요"),
                              //화면 하단에  잠깐  나오는 오류 바
                              duration: Duration(seconds: 2),
                            ));
                        } else if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("패스워드를 확인하세요"),
                            //화면 하단에  잠깐  나오는 오류 바
                            duration: Duration(seconds: 2),
                          ));
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Alert Dialog"),
                                  content: Text("Dialog Content"),
                                );
                              });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

