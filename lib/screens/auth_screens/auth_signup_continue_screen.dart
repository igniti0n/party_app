import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/ImagePickerService.dart';
import '../../services/FirebaseStorageService.dart';
import '../../services/FirebaseFirestoreService.dart';
import '../../widgets/auth_white_input_field.dart';
import '../../widgets/auth_button.dart';
import '../../constants.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key, @required this.uid}) : super(key: key);
  static const routeName = '/signupScreen';
  final String uid;

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  File _userImage;
  Map<String, dynamic> _userData = {
    'username': '',
    'imageUrl': '',
    'attendedPartyIds': [],
    'createdPartyIds': [],
    'friends': [],
    'friendRequests': [],
  };

  void _pickImage(BuildContext ctx, ImageSource source) async {
    final File picked =
        await Provider.of<ImagePickerService>(ctx, listen: false)
            .pickUserImage(source);
    print('PICKED IMAGE::::' + picked.toString());
    if (mounted) {
      if (picked != null) {
        if (_userImage != null) _userImage.delete();
        setState(() {
          _userImage = picked;
        });
      }
    }
  }

  void _validateInput(BuildContext ctx) async {
    if (_userImage == null) {
      Constants.displaySnackbar(ctx, 'User image not selected.');
      return;
    }
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    try {
      _userData['imageUrl'] =
          await Provider.of<FirebaseStorageService>(context, listen: false)
              .storeUserImage(_userImage, widget.uid);
      await Provider.of<FirebaseFirestoreService>(context, listen: false)
          .storeUserInACollection(_userData, widget.uid);
    } catch (error) {
      //TODO: ERROR HANDLING IN ALL PLACES, NOT JUST THIS
      Constants.displaySnackbar(ctx, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, String> _arguments =
    //     ModalRoute.of(context).settings.arguments as Map<String, String>;
    final double size = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ...Constants.buildBackground(),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    minRadius: 50,
                    maxRadius: 65,
                    backgroundImage:
                        _userImage == null ? null : FileImage(_userImage),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PictureButton(
                        icon: Icons.camera,
                        onPressed: () =>
                            _pickImage(context, ImageSource.camera),
                      ),
                      PictureButton(
                        icon: Icons.picture_in_picture_rounded,
                        onPressed: () =>
                            _pickImage(context, ImageSource.gallery),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthWhiteInputField(
                          hintText: 'username',
                          onSaved: (text) {
                            _userData['username'] = text.trim();
                          },
                          validate: (text) {
                            if (text.isEmpty) return 'username empty.';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (ctx) => AuthButton(
                      width: 150,
                      height: 50,
                      onPressed: () => _validateInput(ctx),
                      text: 'LET\'S PARTY',
                    ),
                  ),
                  SizedBox(
                    height: size / 1.5,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PictureButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  const PictureButton({Key key, @required this.icon, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: FlatButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Constants.kButtonBorderColor,
                width: 1.5,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        color: Constants.kButtonColor,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            icon,
            size: 33,
          ),
        ),
      ),
    );
  }
}
