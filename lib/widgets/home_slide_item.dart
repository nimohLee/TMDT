import 'package:flutter/material.dart';

import '../model/homeSlide.dart';

class HomeSlideItem extends StatelessWidget {
  final int index;
  HomeSlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
//      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
       // SizedBox(height: MediaQuery.of(context).size.width/2.5,)
        Container(
          width:  MediaQuery.of(context).size.width/2.5,
          height:  MediaQuery.of(context).size.height/5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(slideList[index].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height/50,
        ),
        Text(
          slideList[index].title,
          style: TextStyle(
            fontFamily: 'NanumSquareEB',
            fontSize:  MediaQuery.of(context).size.width/20,
            color: Color.fromRGBO(28, 174, 129, 1),
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height/50,
        ),
        Text(
          slideList[index].description,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'NanumSquareR',fontSize:  MediaQuery.of(context).size.width/25),
        ),
      ],
    );
  }
}
