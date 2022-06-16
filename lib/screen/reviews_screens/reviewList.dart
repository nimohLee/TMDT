import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class FeedPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  const FeedPage(
      {Key key,
        this.menuScreenContext,
        this.onScreenHideButtonPressed,
        this.hideStatus = false})
      : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _isLoading = true;
  Firestore _db = Firestore.instance;
  double _starRate;
  List<DocumentSnapshot> posts;
  List<DocumentSnapshot> users;
  Color green1 = Color.fromRGBO(133, 192, 64, 100);
  Color green2 = Color.fromRGBO(57, 103, 66, 10);

  File _image;
  var imageName;
  bool imagePick = false;

  final textEditingController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  @override
  void initState() {
    _fetchPosts();
    super.initState();
  }

  _fetchPosts() async {
    try {
      setState(() {
        _isLoading = true;
      });
      QuerySnapshot snap = await _db
          .collection("Reviews")
          .orderBy("date", descending: true)
          .getDocuments();
      setState(() {
        posts = snap.documents;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  showImage() {
    if (!imagePick) {
      return SizedBox(
        width: 0.001,
      );
      imagePick = false;
    } else {
      return Image.file(
        _image,
        width: 100,
        height: 100,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return Container(
        child: LinearProgressIndicator(),
      );
    } else {
      return Container(
        width: width / 1.05,
        height: height / 1.35,
        child: RefreshIndicator(
            color: green1,
            onRefresh: () {
              _fetchPosts();

              return null;
            },
            child: ListView.builder(
              itemCount: posts?.length ?? 0,
              itemBuilder: (ctx, i) {
                return Container(
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
                    horizontal: 10,
                    vertical: 10,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Text(posts[i].data["name"]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(children:[
                        Icon(Icons.calendar_today),
                      ]),
                      Row(children: [
                        SizedBox(
                          width: width / 40,
                        ),
                        RichText(
                          softWrap: true,
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: posts[i].data["name"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          width: width / 3.5,
                        ),
                        SmoothStarRating(
                          rating: posts[i].data['starRate'],
                          color: green1,
                          borderColor: green1,
                          isReadOnly: true,
                          size: 30,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          defaultIconData: Icons.star_border,
                          starCount: 5,
                          allowHalfRating: true,
                          spacing: 2.0,
                        )
                      ]),
                      //SizedBox(height: height/20,),
                      Row(children: [
                        SizedBox(
                          width: width / 40,
                        ),
                        Text(posts[i]
                            .data["date"]
                            .toDate()
                            .toString()
                            .substring(0, 10)),
                      ]),
                      Row(children: [
                        SizedBox(
                          width: width / 40,
                        ),
                        Text(
                          posts[i].data['roomType'],
                          style: TextStyle(fontSize: width / 30),
                        ),
                      ]),
                      Row(
                        children: [
                          FlatButton(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FadeInImage(
                                width: width / 5,
                                height: height / 5,
                                placeholder:
                                AssetImage("assets/images/placeholder.png"),
                                image: NetworkImage(posts[i].data["photoUrl"]),
                              ),
                            ),
                            onPressed: (){
                              setState(() {
                              });

                              List<String> imgList;


                              if(posts[i].data["photoUrl"]=='')
                                imgList =[
                                  'https://firebasestorage.googleapis.com/v0/b/tu-domi.appspot.com/o/Review_Image%2FH49QVtz9ixQe4hl35UEEJvgSviO2%2Fno-image.png?alt=media&token=313fc659-6990-4304-b61b-e01ff9a3abb3',
                                ];
                              else if(posts[i].data["photoUrl2"] == ''&& posts[i].data["photoUrl3"]=='')
                                imgList =[
                                  posts[i].data['photoUrl'],
                                ];
                              else if(posts[i].data["photoUrl"]!= '' && posts[i].data["photoUrl2"]!= '' && posts[i].data["photoUrl3"]=='')
                                imgList=[
                                  posts[i].data['photoUrl'],
                                  posts[i].data['photoUrl2']
                                ];
                              else
                                imgList=[
                                  posts[i].data['photoUrl'],
                                  posts[i].data['photoUrl2'],
                                  posts[i].data['photoUrl3'],
                                ];

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: CarouselSlider(
                                        options: CarouselOptions(height:height/1.5,enableInfiniteScroll: false),
                                        items: imgList.map((item) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Container(
                                                  height: height,
                                                  width: MediaQuery.of(context).size.width,
                                                  // margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                  child: Image.network(item, fit:BoxFit.contain, width:width/2)
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    );});


                            },
                          ),
                          SizedBox(width: width / 10),
                          Text(
                            " ${posts[i].data["caption"]}",
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width / 2,
                          ),
                          Container(
                              width: width / 6,
                              child: FlatButton(
                                child: Text(
                                  '수정',
                                  style: TextStyle(fontSize: width / 30),
                                  textAlign: TextAlign.right,
                                ),
                                onPressed: () async {
                                  FirebaseUser user = await _auth.currentUser();
                                  if (user.uid == posts[i].data["uid"]) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                              StateSetter setState) {
                                            return Dialog(
                                              child: Container(
                                                width: width / 2,
                                                height: height / 1.7,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      AppBar(
                                                        backgroundColor:
                                                        Color.fromRGBO(133,
                                                            192, 64, 100),
                                                        toolbarHeight:
                                                        height / 40,
                                                        automaticallyImplyLeading:
                                                        false,
                                                        shadowColor:
                                                        Colors.transparent,
                                                      ),
                                                      SizedBox(
                                                        height: height / 50,
                                                      ),
                                                      Text(
                                                        '후기 수정',
                                                        style: TextStyle(
                                                            fontSize:
                                                            width / 20,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
//                                                    SizedBox(height: height/20,),
//                                                       Row(children: [
//                                                         SizedBox(
//                                                           width: width / 20,
//                                                         ),
//                                                         // showImage(),
//                                                         _image == null
//                                                             ? Text('No Image')
//                                                             : Image.file(
//                                                                 _image,
//                                                                 width:
//                                                                     width / 3,
//                                                                 height:
//                                                                     height / 5,
//                                                               ),
//                                                         SizedBox(
//                                                           width: width / 8,
//                                                         ),
//
//                                                         FlatButton(
//                                                           child: Icon(Icons
//                                                               .add_a_photo),
//                                                           onPressed: () async {
//                                                             File image =
//                                                                 await ImagePicker
//                                                                     .pickImage(
//                                                                         source:
//                                                                             ImageSource.gallery);
//                                                             imageName =
//                                                                 image.uri;
//                                                             setState(() {
//                                                               _image = image;
//                                                             });
//                                                           },
//                                                         )
//                                                       ]),
                                                      SmoothStarRating(
                                                        rating: 0,
                                                        color: green1,
                                                        borderColor: green1,
                                                        isReadOnly: false,
                                                        size: 50,
                                                        filledIconData:
                                                        Icons.star,
                                                        halfFilledIconData:
                                                        Icons.star_half,
                                                        defaultIconData:
                                                        Icons.star_border,
                                                        starCount: 5,
                                                        allowHalfRating: true,
                                                        spacing: 2.0,
                                                        onRated: (value) {
                                                          _starRate = value;
                                                        },
                                                      ),
                                                      SizedBox(height: height/10,),
                                                      TextField(
                                                        keyboardType:
                                                        TextInputType
                                                            .multiline,
                                                        maxLines: null,
                                                        decoration:
                                                        InputDecoration(
                                                          hintText:
                                                          '   5자 이상 작성해주세요',
                                                          hintStyle: TextStyle(
                                                              fontSize:
                                                              height / 50),
//                          filled: true,
                                                          fillColor:
                                                          Colors.white,
                                                          contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 10),
                                                          focusedBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                                color: Colors
                                                                    .green),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                15),
                                                          ),
                                                          enabledBorder:
                                                          UnderlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                                color: Colors
                                                                    .green),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                15),
                                                          ),
                                                        ),
                                                        controller:
                                                        textEditingController,
                                                      ),
                                                      SizedBox(
                                                        height: height / 8,
                                                      ),
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                                width: width / 5,
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      20),
                                                                  border:
                                                                  Border.all(
                                                                    color: green1,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: FlatButton(
                                                                  child: Text('취소'),
                                                                  onPressed: () {
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop();
                                                                  },
                                                                )),
                                                            Container(
                                                                width: width / 5,
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      20),
                                                                  border:
                                                                  Border.all(
                                                                    color: green1,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                child: FlatButton(
                                                                  child: Text('수정'),
                                                                  onPressed:
                                                                      () async {
                                                                    showDialog(
                                                                        context:
                                                                        context,
                                                                        builder:
                                                                            (context) {
                                                                          return AlertDialog(
                                                                            content:
                                                                            Text('수정하시겠습니까?'),
                                                                            actions: [
                                                                              FlatButton(
                                                                                child:
                                                                                Text('OK', style: TextStyle(color: green2)),
                                                                                onPressed:
                                                                                    () async {

                                                                                  if (textEditingController.text.isNotEmpty && textEditingController.text.length > 4) {
                                                                                    // Firestore.instance.collection('Reviews').document(posts[i].documentID).updateData({'caption':textEditingController.text,});


                                                                                    Firestore.instance.collection('Reviews').document(posts[i].documentID).updateData({
                                                                                      'caption': textEditingController.text,
                                                                                      'starRate': _starRate,
                                                                                    });
                                                                                    if (_image != null){

                                                                                      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + basename(_image.path);

                                                                                      final StorageReference storageReference = _storage.ref().child("Review_Image").child(user.uid).child(fileName);

                                                                                      final StorageUploadTask uploadTask = storageReference.putFile(_image);

                                                                                      StorageTaskSnapshot onComplete = await uploadTask.onComplete;

                                                                                      String photoUrl = await onComplete.ref.getDownloadURL();

                                                                                      Firestore.instance.collection('Reviews').document(posts[i].documentID).updateData({
                                                                                        'photoUrl': photoUrl
                                                                                      });
                                                                                    }
                                                                                    Navigator.of(context).pop();
                                                                                    Navigator.of(context).pop();
                                                                                    textEditingController.clear();
//                                                                                  Firestore.instance.collection('Reviews').document(posts[i].documentID).updateData({
//                                                                                    'caption': textEditingController.text,
//                                                                                    'starRate': _starRate,
//                                                                                    'photoUrl': photoUrl
//                                                                                  });
//
//                                                                                  Firestore.instance.collection('Reviews').document(posts[i].documentID).updateData({
//                                                                                    'caption': textEditingController.text,
//                                                                               'starRate': _starRate
//                                                                                  });
                                                                                    setState(() {

                                                                                    });



                                                                                  } else
                                                                                    Fluttertoast.showToast(
                                                                                      msg: "후기를 5자 이상 작성해주세요.",
                                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                                      gravity: ToastGravity.CENTER,
                                                                                      timeInSecForIosWeb: 1,
                                                                                      backgroundColor: green1,
                                                                                      textColor: Colors.white,
                                                                                      fontSize: height / 40,
                                                                                    );
                                                                                },
                                                                              ),
                                                                              FlatButton(
                                                                                child:
                                                                                Text('Cancel', style: TextStyle(color: green2)),
                                                                                onPressed:
                                                                                    () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                              )
                                                                            ],
                                                                          );
                                                                        });
                                                                  },
                                                                ))
                                                          ]),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                        });
                                  } else
                                    Fluttertoast.showToast(
                                      msg: "본인만 수정 및 삭제가 가능합니다",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: green1,
                                      textColor: Colors.white,
                                      fontSize: height / 40,
                                    );
                                },
                              )),
                          SizedBox(
                            width: width / 40,
                          ),
                          Container(
                              width: width / 6,
                              child: FlatButton(
                                child: Text(
                                  '삭제',
                                  style: TextStyle(fontSize: width / 30),
                                  textAlign: TextAlign.right,
                                ),
                                onPressed: () async {
                                  FirebaseUser user = await _auth.currentUser();
                                  if (user.uid == posts[i].data["uid"]) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text('정말 삭제하시겠습니까?'),
                                            actions: [
                                              FlatButton(
                                                child: Text(
                                                  'OK',
                                                  style:
                                                  TextStyle(color: green2),
                                                ),
                                                onPressed: () async {
                                                  Firestore.instance
                                                      .collection('Reviews')
                                                      .document(
                                                      posts[i].documentID)
                                                      .delete();

                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Cancel',
                                                    style: TextStyle(
                                                        color: green2)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  } else
                                    Fluttertoast.showToast(
                                      msg: "본인만 수정 및 삭제가 가능합니다",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: green1,
                                      textColor: Colors.white,
                                      fontSize: height / 40,
                                    );
                                },
                              )),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )),
      );
      //);
    }
  }
}
