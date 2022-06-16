import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tong_myung_hotel/screen/reviews_screens/review_Write.dart';
import 'package:tong_myung_hotel/screen/reviews_screens/reviewList.dart';

class Review extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  const Review(
      {Key key,
        this.menuScreenContext,
        this.onScreenHideButtonPressed,
        this.hideStatus = false})
      : super(key: key);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  String _uid;
  String _checkIn;
  String _checkOut;
  String _people;
  String _book='0'; // 방 유형 이름
  String _imageUrl; // 방 사진 url
  String _roomName; // 방 유형 숫자
  var _star;
  var _note;
  String _reviewName;
  bool first = false;
  Color green1 = Color.fromRGBO(133, 192, 64, 100);
  Color green2 = Color.fromRGBO(57, 103, 66, 10);



  // ignore: missing_return
  Widget refresh(){
    first = true;
    return FlatButton(

        child: Text('이용내역 불러오기',style: TextStyle(fontFamily: 'NanumSquareB',fontSize: MediaQuery.of(context).size.width/23),),
        onPressed: (){setState(() {
        });});
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var ratio = (width+height)/2;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 15),
        child: AppBar(
          title: Row(children: [
            SizedBox(
              width: width / 5,
            ),
            Text(
              '별점 / 후기',
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
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            _uid = snapshot.data.uid;
            Firestore.instance.collection('Users').document(_uid).get().then((DocumentSnapshot ds){
              _roomName = ds.data['방 유형후기'];
              _checkIn = ds.data['입실일후기'];
              _checkOut = ds.data['퇴실일후기'];
              _people = ds.data['인원후기'];
            });

            if (_roomName == '1' ||
                _roomName == '2' ||
                _roomName == '7' ||
                _roomName == '8') // 방 유형 번호에 따른 사진출력
              _imageUrl = 'gs://tu-domi.appspot.com/room_type/three_room.png';
            else if (_roomName == '3' ||
                _roomName == '4' ||
                _roomName == '9' ||
                _roomName == '10')
              _imageUrl = 'gs://tu-domi.appspot.com/room_type/two_room.png';
            else if (_roomName == '5' || _roomName == '6')
              _imageUrl = 'gs://tu-domi.appspot.com/room_type/four_room.png';
            else
              _imageUrl = 'gs://tu-domi.appspot.com/room_type/no-image.png';



            switch (_roomName) {
            // 방 유형 번호에 따른 방 이름 지정
              case '0':
                _book = '예약내역 없음';
                break;
              case '1':
                _book = '남성 3인 도미토리';
                break;
              case '2':
                _book = '남성 3인실';
                break;
              case '3':
                _book = '남성 2인 도미토리';
                break;
              case '4':
                _book = '남성 2인실';
                break;
              case '5':
                _book = '여성 4인 도미토리';
                break;
              case '6':
                _book = '여성 4인실';
                break;
              case '7':
                _book = '여성 3인 도미토리';
                break;
              case '8':
                _book = '여성 3인실';
                break;
              case '9':
                _book = '여성 2인 도미토리';
                break;
              case '10':
                _book = '여성 2인실';
                break;
            }

            return SingleChildScrollView(
              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Color.fromRGBO(246, 246, 246, 1),
                    height: height/18,
                    alignment: Alignment.center,
                    child:Text('소중한 후기를 남겨주세요.',textAlign: TextAlign.center,style: TextStyle(fontFamily: 'NanumSquareB',fontSize: ratio/33 ),),),
//                  SizedBox(
//                    height: height / 10,
//                    child: Container(
//                      alignment: Alignment.bottomRight,
//                      child: FlatButton(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(20)
//,                        ),
//                        color: green1,
//                        child: Text('리뷰작성',style: TextStyle(color: Colors.white),),
//                        onPressed: () {
//                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ReviewWrite()));
//                        },
//                      ),
//                    ),
//                  ),
//                  Divider(
//                    color: Colors.grey,
//                    indent: 10,
//                    endIndent: 10,
//                  ),
                  SizedBox(height: height/30,),
                  Text('\t\t\t\t이용내역',style: TextStyle(fontFamily: 'NanumSquareB',fontSize: ratio/30)),
                  SizedBox(height: height/50,),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Color(0x22000000),
                            offset: Offset(0, 4),
                          ),
                        ]),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: first==false ?  refresh() : Column(
                      children: [
                        Row(
                            children:[
                              Icon(Icons.calendar_today),
                              Text('  $_checkIn ~ $_checkOut',style: TextStyle(fontFamily: 'NanumSquareB',fontSize: ratio/36),),


                            ]),
                        Row(children:[

                          Container(
                            width: width/3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage(
                                width: width / 5,
                                height: height / 5,
                                placeholder:
                                AssetImage("assets/images/placeholder.png"),
                                image: FirebaseImage(
                                    _imageUrl),
                              ),
                            ),),
                          SizedBox(width: width/15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_book,style: TextStyle(fontFamily: 'NanumSquareB',fontSize: ratio/33),),
                              SizedBox(height: height/100,),
                              Text('$_people인',style: TextStyle(fontFamily: 'NanumSquareR',fontSize: ratio/33),),
                              SizedBox(height: height/50,),

                              Container(
                                  height: height/20,
                                  width: width/2.5,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(214, 214, 214, 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: FlatButton(
                                    child: Text('후기작성하기',style: TextStyle(fontFamily: 'NanumSquareR',fontSize: ratio/36)),
                                    onPressed: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ReviewWrite(checkIn: _checkIn,checkOut: _checkOut,people: _people,roomName: _book,imageUrl: _imageUrl,)));
                                    },
                                  )),
                            ],
                          )
                        ])
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),child:FeedPage()),
////                  Row(children: [
//////                    SmoothStarRating(
//////                      //rating: rating,
//////                      isReadOnly: true,
//////                      size: 30,
//////                      filledIconData: Icons.star,
//////                      halfFilledIconData: Icons.star_half,
//////                      defaultIconData: Icons.star_border,
//////                      starCount: 5,
//////                      rating: _star,
//////                      allowHalfRating: true,
//////                      spacing: 2.0,
//////                      onRated: (value){
//////                        print("rating value -> $value");
//////                      },
//////                    )
////                  ],
//
//                  ),
                ],
              ),
            );
          }
          else {
            return Text('Loading...');
          }
        },
      ),
    );
  }
}
