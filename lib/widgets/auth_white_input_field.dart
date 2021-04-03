import 'package:flutter/material.dart';

import '../constants.dart';

class AuthWhiteInputField extends StatelessWidget {
  final void Function(String text) onSaved;
  final double width;
  final String Function(String text) validate;
  final TextEditingController controller;
  final String hintText;
  final FocusNode focusNode;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Function(String) onFieldSibmitted;
  final bool password;
  const AuthWhiteInputField(
      {Key key,
      this.onSaved,
      this.validate,
      this.textInputAction,
      this.hintText,
      this.focusNode,
      this.textInputType,
      this.onFieldSibmitted,
      this.controller,
      this.width = 200,
      this.password = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 22),
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Constants.kAuthBoxColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: TextFormField(
        validator: validate,
        controller: controller,
        onSaved: onSaved,
        focusNode: focusNode,
        obscureText: password,
        maxLines: 1,
        keyboardType: textInputType,
        onFieldSubmitted: onFieldSibmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: EdgeInsets.all(2),
        ),
      ),
    );
  }
}
