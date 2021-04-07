import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../../data/datasources/FirebaseAuthService.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/auth_white_input_field.dart';

class AuthLoginScreen extends StatefulWidget {
  AuthLoginScreen({Key key}) : super(key: key);

  @override
  _AuthLoginScreenState createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  final FocusNode _passwordFocusNode = new FocusNode();
  final FocusNode _confirmationFocusNode = new FocusNode();
  String _userEmail = '';
  String _userPassword = '';

  bool _isLogin = true;

  void _validateInputAndContinue(BuildContext ctx) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final _authenticationProvider =
          Provider.of<FirebaseAuthService>(ctx, listen: false);
      if (_isLogin) {
        try {
          await _authenticationProvider.logIn(_userEmail, _userPassword);

          //TODO:LOGIN NAVIGATION, watch out for user filling out data !!!!
        } catch (error) {
          Constants.displaySnackbar(ctx, error.toString());
        }
      } else {
        try {
          await _authenticationProvider.signIn(_userEmail, _userPassword);
          // Navigator.of(ctx)
          //     .pushReplacementNamed(SignupScreen.routeName, arguments: {
          //   'email': _userEmail,
          //   'password': _userPassword,
          // });
        } catch (error) {
          Constants.displaySnackbar(
              ctx,
              error
                  .toString()); //TODO:ERROR HANDLING - DISPLAYING ERROR MESSAGE
        }
      }

      _userEmail = '';
      _userPassword = '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
    _confirmationFocusNode.dispose();
    //  _formKey.currentState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('::: BUILDIN AUTH LOGIN SCREEN :::');
    final double size = MediaQuery.of(context).viewInsets.bottom;

    // final deviceWidth = queryData.size.width;
    // final deviceHeight = queryData.size.height - queryData.viewPadding.vertical;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ...Constants.buildBackground(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthWhiteInputField(
                        hintText: '  email..',
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSaved: (email) {
                          _userEmail = email.trim();
                        },
                        onFieldSibmitted: (_) => FocusScope.of(context)
                            .requestFocus(_passwordFocusNode),
                        validate: (text) {
                          if (text == null || !EmailValidator.validate(text))
                            return 'Invalid email.';
                          return null;
                        },
                      ),
                      AuthWhiteInputField(
                        hintText: '  password..',
                        textInputAction: _isLogin
                            ? TextInputAction.done
                            : TextInputAction.next,
                        onFieldSibmitted: (_) {
                          if (!_isLogin) {
                            FocusScope.of(context)
                                .requestFocus(_confirmationFocusNode);
                          }
                        },
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        onSaved: (password) {
                          _userPassword = password;
                        },
                        password: true,
                        validate: (text) {
                          if (text.length < 8)
                            return 'Lenght of minimum 8 characters.';
                          return null;
                        },
                      ),
                      if (!_isLogin)
                        AuthWhiteInputField(
                          hintText: '  confirm..',
                          textInputAction: TextInputAction.done,
                          focusNode: _confirmationFocusNode,
                          password: true,
                          validate: (text) {
                            return _passwordController.value.text == text
                                ? null
                                : 'Password does not match.';
                          },
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _isLogin ? 40 : 20,
                ),
                Builder(
                  builder: (ctx) => AuthButton(
                    width: 150,
                    height: 50,
                    onPressed: () => _validateInputAndContinue(ctx),
                    text: _isLogin ? 'Let\'s party' : 'Continue',
                  ),
                ),
                AuthButton(
                  width: 150,
                  height: 50,
                  onPressed: () {
                    if (this.mounted)
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                  },
                  text: _isLogin ? 'Signup ?' : 'Login ?',
                ),
                SizedBox(
                  height: size / 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
