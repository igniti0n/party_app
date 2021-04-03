import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'package:clip_shadow/clip_shadow.dart';

class PurpleButton extends StatelessWidget {
  PurpleButton({
    Key key,
    @required MediaQueryData media,
    @required ThemeData theme,
    @required this.onTap,
    @required this.text,
    this.isPurple = true,
    this.useSplashDelay = true,
  })  : _media = media,
        _theme = theme,
        super(key: key);

  final MediaQueryData _media;
  final ThemeData _theme;
  final Function onTap;
  final String text;
  final bool isPurple;
  final bool useSplashDelay;
  Timer _t;

  @override
  Widget build(BuildContext context) {
    return Container(
      //  clipBehavior: Clip.none,
      // alignment: Alignment.center,
      width: _media.size.width / 1.7,
      decoration: BoxDecoration(
        color: !isPurple ? Colors.grey : Constants.kButtonColor,
        border: Border.all(color: Color.fromRGBO(97, 92, 92, 1), width: 2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(offset: Offset(0, 1), color: Colors.black, blurRadius: 1)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        animationDuration: Duration(milliseconds: 500),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            _t = new Timer(
                Duration(
                  milliseconds: useSplashDelay ? 200 : 0,
                ),
                () => onTap());
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: _theme.textTheme.headline1
                  .copyWith(color: Constants.kPurpleButtonTextColor),
            ),
          ),
        ),
      ),
    );
  }
}

enum ClipedSide { Left, Right }

class PurpleButtonCliped extends StatelessWidget {
  const PurpleButtonCliped({
    Key key,
    @required MediaQueryData media,
    @required ThemeData theme,
    @required this.onTap,
    this.clipedSide = ClipedSide.Right,
    this.child,
  })  : _media = media,
        super(key: key);

  final MediaQueryData _media;

  final Function onTap;

  final ClipedSide clipedSide;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipShadow(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                color: Colors.black,
                blurRadius: 1,
              )
            ],
            clipper: ButtonClipper(this.clipedSide),
            child: Container(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              height: _media.size.height * 0.055,
              //padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              width: _media.size.width / 2.1,
              decoration: BoxDecoration(
                color: onTap == null ? Colors.grey : Constants.kButtonColor,
                // border:
                //Border.all(color: Color.fromRGBO(97, 92, 92, 1), width: 4),
                //borderRadius: BorderRadius.circular(15),
                // boxShadow: [
                //   BoxShadow(offset: Offset(0, 1), color: Colors.black, blurRadius: 1)
                // ],
              ),
              child: Padding(
                padding: clipedSide == ClipedSide.Right
                    ? const EdgeInsets.fromLTRB(0, 4, 40, 4)
                    : const EdgeInsets.fromLTRB(40, 4, 0, 4),
                child: child,
              ),
            ),
          ),
          CustomPaint(
            painter: BorderPainter(
                Size(_media.size.width / 2.1, _media.size.height * 0.055),
                this.clipedSide),
          ),
        ],
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final Size sizeReal;
  final ClipedSide clipedSide;
  const BorderPainter(this.sizeReal, this.clipedSide);
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = new Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Color.fromRGBO(97, 92, 92, 1);

    final _path = new Path();

    if (clipedSide == ClipedSide.Right) {
      _path.lineTo(0, 0);
      _path.lineTo(sizeReal.width, 0);
      _path.lineTo(sizeReal.width - 40, sizeReal.height);
      _path.lineTo(0, sizeReal.height);
      _path.lineTo(0, 0);
    } else {
      _path.moveTo(40, 0);
      _path.lineTo(sizeReal.width, 0);
      _path.lineTo(sizeReal.width, sizeReal.height);
      _path.lineTo(0, sizeReal.height);
      _path.lineTo(40, 0);
    }

    _path.close();

    canvas.drawPath(_path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class ButtonClipper extends CustomClipper<Path> {
  final ClipedSide clipedSide;
  const ButtonClipper(this.clipedSide);
  @override
  Path getClip(Size size) {
    // TODO: implement getClip

    final _path = new Path();

    if (clipedSide == ClipedSide.Right) {
      _path.lineTo(0, 0);
      _path.lineTo(size.width, 0);
      _path.lineTo(size.width - 40, size.height);
      _path.lineTo(0, size.height);
      _path.lineTo(0, 0);
    } else {
      _path.lineTo(40, 0);
      _path.lineTo(size.width, 0);
      _path.lineTo(size.width, size.height);
      _path.lineTo(0, size.height);
      _path.lineTo(40, 0);
    }

    _path.close();

    return _path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
