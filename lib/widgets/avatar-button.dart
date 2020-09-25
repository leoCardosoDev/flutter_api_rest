import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvatarButton extends StatelessWidget {
  final String url;
  final VoidCallback onPressed;
  final double imageSize;

  const AvatarButton({this.imageSize = 100, this.url, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black26,
                spreadRadius: 5,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              this.url ?? "https://www.w3schools.com/howto/img_avatar.png",
              width: this.imageSize,
              height: this.imageSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CupertinoButton(
            onPressed: this.onPressed,
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1.8,
                ),
                color: Colors.pinkAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
