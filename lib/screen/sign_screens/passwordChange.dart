import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _currentpw = TextEditingController();
  TextEditingController _changepw = TextEditingController();
  TextEditingController _changepw2 = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;


  Future<bool> validatePassword(String password) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    var authCredentials = EmailAuthProvider.getCredential(
        email: user.email,
        password: password
    );

    try{
    var authResult = await user.reauthenticateWithCredential(authCredentials);

    return authResult.user != null;}
    catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> validateCurrentPassword(String password) async{
    return await validatePassword(password);
  }

  void _changePassword(String password) async{
    //Create an instance of the current user.
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_){
      print("Your password changed Succesfully ");
    }).catchError((err){
      print("You can't change the Password" + err.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double ratio = (width+height)/2;
    final Color sig = Color.fromRGBO(28, 174, 129, 1);
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height /15),
        child: AppBar(
          title: Row(children: [
            SizedBox(
              width: width / 5,
            ),
            Text('비밀번호 변경하기', style: TextStyle(color: Colors.black, fontFamily: 'NanumSquareB', fontSize: ratio/30),textAlign: TextAlign.center,)
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
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              SizedBox(height: height/10,),
              Row(children: [

                Text(
                  '현재 비밀번호',
                  style: TextStyle(
                      fontFamily: 'NanumSquareB', fontSize: ratio / 33),
                ),
                SizedBox(
                  width: width / 10,
                ),
                Container(
                  width: width / 1.6,
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(
                        fontFamily: 'NanumSquareB',
                        fontSize: ratio / 33,),
                    textAlign: TextAlign.center,
                    controller: _currentpw,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(28, 174, 129, 1)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(168, 168, 168, 1)),
                      ),
//                      focusedBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Color.fromRGBO(133, 192, 64, 100),)
//                      ),
                      hintStyle: TextStyle(fontFamily: 'NanumSquareR', fontSize: ratio / 36),
                      hintText: '현재 비밀번호를 입력해주세요',
                    ),
                    validator: (value){
                      return _currentpw.text == value ? null : '패스워드를 확인해주세요.';
                    },
                  ),
                )
              ]),
              SizedBox(height: height/15,),
              Row(children: [
                Text(
                  '새 비밀번호',
                  style: TextStyle(
                      fontFamily: 'NanumSquareB', fontSize: ratio / 33),
                ),
                SizedBox(
                  width: width / 7.5,
                ),
                Container(
                  width: width / 1.6,
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(
                      fontFamily: 'NanumSquareB',
                      fontSize: ratio / 33,),
                    textAlign: TextAlign.center,
                    controller: _changepw,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(28, 174, 129, 1)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(168, 168, 168, 1)),
                        ),
//                      focusedBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Color.fromRGBO(133, 192, 64, 100),)
//                      ),
                        hintStyle: TextStyle(fontFamily: 'NanumSquareR', fontSize: ratio / 36),
                        hintText: '새 비밀번호를 입력해주세요'
                    ),
                  ),
                )
              ]),
              SizedBox(height: height/15,),
              Row(children: [
                Text(
                  '새 비밀번호 확인',
                  style: TextStyle(
                      fontFamily: 'NanumSquareB', fontSize: ratio / 33),
                ),
                SizedBox(
                  width: width / 19,
                ),
                Container(
                  width: width / 1.6,
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(
                      fontFamily: 'NanumSquareB',
                      fontSize: ratio / 33,),
                    textAlign: TextAlign.center,
                    controller: _changepw2,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(28, 174, 129, 1)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(168, 168, 168, 1)),
                        ),
//                      focusedBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Color.fromRGBO(133, 192, 64, 100),)
//                      ),
                        hintStyle: TextStyle(fontFamily: 'NanumSquareR', fontSize: ratio / 36),
                        hintText: '새 비밀번호를 한 번 더 입력해주세요'
                    ),
                  ),
                )
              ]),

              SizedBox(height: height/15,),
              Container(
                width: width/1.28,
                child:RaisedButton(
                  color: sig,
                  child: Text(
                    '비밀번호 변경하기',
                    style: TextStyle(
                        fontSize: width /22,
                        fontFamily: 'NanumSquareB'
                    ),
                  ),
                  shape: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Color.fromRGBO(133, 192, 64, 80)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(15),
                  textColor: Colors.white,
                  onPressed: () async{
    var checkCurrentPasswordValid = await validateCurrentPassword(_currentpw.text);
    setState(() {

    });

    if(checkCurrentPasswordValid){
    if(_changepw.text==_changepw2.text){
    _changePassword(_changepw.text);
    Fluttertoast.showToast(
        msg: "메일을 전송했습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color.fromRGBO(133, 192, 64, 80),
        textColor: Colors.white,
        fontSize: 25.0
    );
    Navigator.of(context).pop();
    }
    else
    scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text("새 비밀번호를 다시 확인해주세요.")));
    }
    else
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("현재 비밀번호를 확인해주세요.")));

                  },
                ),),
            ]
        ),
      ),
    );
  }

  checkCurrentPassword() {}
}
