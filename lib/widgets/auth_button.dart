import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Function onPressed;

  const AuthButton(
      {Key key, this.height, this.width, this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: this.height,
        width: this.width,
        alignment: Alignment.center,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline2
              .copyWith(color: Colors.white),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                offset: Offset(0, 1),
                blurRadius: 1,
                spreadRadius: 1)
          ],
          color: Theme.of(context).primaryColor,
          border: Border.all(color: Color.fromRGBO(68, 56, 56, 1), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
