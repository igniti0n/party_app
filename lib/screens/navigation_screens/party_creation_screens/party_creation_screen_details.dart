import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';
import 'navigation_party_creation_widget.dart';

class PartyCreationScreenDetails extends StatefulWidget {
  PartyCreationScreenDetails(
      {Key key,
      this.onNext,
      this.onPrevious,
      this.sloganInitialValue,
      this.descriptionInitialValue})
      : super(key: key);

  final Function(String slogan, String details) onNext;
  final Function(String slogan, String details) onPrevious;
  final String sloganInitialValue;
  final String descriptionInitialValue;

  @override
  _PartyCreationScreenDetailsState createState() =>
      _PartyCreationScreenDetailsState();
}

class _PartyCreationScreenDetailsState
    extends State<PartyCreationScreenDetails> {
  final GlobalKey<FormState> _formkey2 = new GlobalKey<FormState>();

  String _slogan = '';
  String _description = '';

  void _saveData() {
    if (_formkey2.currentState.validate()) {
      _formkey2.currentState.save();
      print('slogan: $_slogan');
      print('description: $_description');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context);
    final _theme = Theme.of(context);
    print('BUILDING DETAILS');

    return Stack(
      children: [
        ...Constants.buildBackground(),
        SingleChildScrollView(
          child: Form(
            key: _formkey2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 30, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/icons/beer.png',
                        height: 50,
                      ),
                      Container(
                        width: _media.size.width / 1.5,

                        //TODO: ENFORCE TITLE LENGHT
                        child: Text(
                          'Description',
                          textAlign: TextAlign.center,
                          style:
                              _theme.textTheme.headline1.copyWith(fontSize: 26),
                        ),
                      ),
                      Image.asset(
                        'assets/icons/toast.png',
                        height: 50,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 2,
                  thickness: 1,
                  endIndent: 20,
                  color: Colors.blueGrey.shade300,
                  indent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    children: [
                      Text(
                        "\"",
                        style: _theme.textTheme.headline1,
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: widget.sloganInitialValue,
                          validator: (slogan) {
                            if (slogan.length > 44) return '';
                            return null;
                          },
                          onSaved: (newSlogan) {
                            _slogan = newSlogan.trim();

                            print(' THIS IS TYPED IN: '); //$newSlogan');
                          },
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(
                                44), // for mobile
                          ],
                          style: _theme.textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 20),
                          decoration: InputDecoration(
                            hintText: 'Slogan...',
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Text(
                        "\"",
                        style: _theme.textTheme.headline1,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    'Set a catchy slogan for your party! Slogan can have a maximum of 44 characters, keep it short and fun!',
                    style: _theme.textTheme.bodyText1.copyWith(
                        color: Constants.kHelperTextColor, height: 1.5),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  height: _media.size.height * 0.35,
                  color: Color.fromRGBO(30, 30, 30, 0.05),
                  child: SingleChildScrollView(
                    child: TextFormField(
                      initialValue: widget.descriptionInitialValue,
                      onSaved: (newDescription) {
                        _description = newDescription;
                      },
                      validator: (text) {
                        return null;
                      },
                      // keyboardType: TextInputType.text,
                      maxLines: 20,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'Description....',
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20),
                  child: Text(
                    Constants.textPartyCreationDescription,
                    style: _theme.textTheme.bodyText1.copyWith(
                        color: Constants.kHelperTextColor, height: 1.5),
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
        NavigationPartyCreationWidget(
          media: _media,
          onNext: () {
            _saveData();
            widget.onNext(_slogan, _description);
          },
          onPrevious: () {
            _saveData();
            widget.onPrevious(_slogan, _description);
          },
        ),
        //   bottom: 40,
        //   left: _media.size.width / 4.6,
        // ),
      ],
    );
  }
}
