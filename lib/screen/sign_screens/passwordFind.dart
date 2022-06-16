import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FindPassword extends StatefulWidget {
  @override
  _FindPasswordState createState() => _FindPasswordState();
}

class _FindPasswordState extends State<FindPassword> {

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  @override
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double ratio = (width+height)/2;
    final Color sig = Color.fromRGBO(28, 174, 129, 1);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height /15),
        child: AppBar(
          title: Row(children: [
            SizedBox(
              width: width / 5,
            ),
            Text('비밀번호 찾기', style: TextStyle(color: Colors.black, fontFamily: 'NanumSquareB', fontSize: ratio/30),textAlign: TextAlign.center,)
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
          Image.asset('tu_logo.png',
          height: height/5,
          width: width/5,),
        Center(child:Text('회원가입 시 입력했던 정보를 적어주세요.',textAlign: TextAlign.center,)),
          SizedBox(height: height/10,),
        Padding(padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child:TextFormField(
                style:
                TextStyle(fontSize: width / 22, color: Colors.black,fontFamily: 'NanumSquareR'),
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: width / 22, color: Colors.black54,fontFamily: 'NanumSquareR'),
                  prefixIcon: Icon(
                    Icons.alternate_email,
                    size: width / 20,
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
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey,width: 0.2),
                  ),
                ),
                validator: (val) => val.isEmpty ? '이메일 주소를 입력해주세요' : null,
                controller: _emailController,
              ),),
              SizedBox(height: height/40,),
              Padding(padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child:TextFormField(
                  style:
                  TextStyle(fontSize: width / 22, color: Colors.black,fontFamily: 'NanumSquareR'),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: width / 22, color: Colors.black54,fontFamily: 'NanumSquareR'),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      size: width / 20,
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
                    enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey,width: 0.2),
                    ),
                  ),
                  validator: (val) => val.isEmpty ? '이름을 입력해주세요' : null,
                  controller: _usernameController,
                ),),
              SizedBox(height: height/40,),
              Padding(padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child:TextFormField(
                  style:
                  TextStyle(fontSize: width / 22, color: Colors.black,fontFamily: 'NanumSquareR'),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: width / 22, color: Colors.black54,fontFamily: 'NanumSquareR'),
                    prefixIcon: Icon(
                      Icons.phone,
                      size: width / 20,
                      color: Colors.black54,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: ' 휴대폰 번호를 입력해주세요',
                    contentPadding: const EdgeInsets.all(5),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: sig),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey,width: 0.2),
                    ),
                  ),
                  validator: (val) => val.isEmpty ? '휴대폰 번호를 입력해주세요' : null,
                  controller: _phoneController,
                ),),

        SizedBox(height: height/17,),
        Container(
          width: width/1.28,
          child:RaisedButton(
              color: sig,
              child: Text(
                '변경 메일 전송하기',
                style: TextStyle(
                    fontSize: width /22,
                    fontFamily: 'NanumSquareB'
                ),
              ),
              shape: OutlineInputBorder(
                borderSide:
                BorderSide(color: Color.fromRGBO(133, 192, 64, 80)),
                borderRadius: BorderRadius.circular(60),
              ),
              padding: const EdgeInsets.all(15),
              textColor: Colors.white,
              onPressed: () {
                resetPassword(_emailController.text);
                Fluttertoast.showToast(
                    msg: "메일을 전송했습니다.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Color.fromRGBO(133, 192, 64, 80),
                    textColor: Colors.white,
                    fontSize: 25.0
                );
                Navigator.of(context).pop();
              },
            ),),


          ]
        ),
      ),
    );
  }
}
