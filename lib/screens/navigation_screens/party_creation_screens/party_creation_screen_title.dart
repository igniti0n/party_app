import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/purple_button.dart';
import '../../../screens/navigation_screens/party_creation_screens/navigation_party_creation_widget.dart';
import '../../../constants.dart';
import '../../../services/ImagePickerService.dart';

import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;

class PartyCreationScreenTitle extends StatefulWidget {
  PartyCreationScreenTitle({
    Key key,
    this.onNext,
    @required this.initialValueText,
    @required this.initialValuePicture,
  }) : super(key: key);
  final String initialValueText;
  final String initialValuePicture;
  final Function(Map<String, dynamic> data) onNext;

  @override
  _PartyCreationScreenTitleState createState() =>
      _PartyCreationScreenTitleState();
}

class _PartyCreationScreenTitleState extends State<PartyCreationScreenTitle> {
  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();

  Map<String, dynamic> _titlePicutureData = {
    'title': '',
    'imageUrl': '',
  };

  void _tryToContinue() {
    if (_formkey.currentState.validate()) {
      // if (_titlePicutureData['imageUrl'] == '' &&
      //     widget.initialValuePicture == '')
      // return; //TODO: ADD SNACKBAR FOR NO IMAGE SELECTED
      _formkey.currentState.save();
      widget.onNext(_titlePicutureData);
    }
  }

  Future<String> _storeImageInAppDocumentsDirectory(String imagePath) async {
    final Directory _externalDirectory =
        await pathProvider.getExternalStorageDirectory();
    //print('IMAGE PATH:::: $imagePath');
    final File _partyImage =
        new File(path.join(_externalDirectory.path, imagePath));
    //print('STORED PATH:::: ${_partyImage.path}');
    return _partyImage.path;
  }

  @override
  void dispose() {
    // _formkey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context);
    final _theme = Theme.of(context);
    print('BUILDING TITLE');

    return Stack(
      children: [
        ...Constants.buildBackground(),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 30, 20, 0),
                child: Form(
                  key: _formkey,
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
                        child: TextFormField(
                          initialValue: widget.initialValueText,
                          validator: (text) {
                            if (text.length > 20) return 'Title too long';
                            return null;
                          },
                          onSaved: (text) {
                            _titlePicutureData['title'] = text.trim();
                          },
                          textAlign: TextAlign.center,
                          style:
                              _theme.textTheme.headline1.copyWith(fontSize: 26),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Your party title',
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
                      Image.asset(
                        'assets/icons/toast.png',
                        height: 50,
                      ),
                    ],
                  ),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: Text(
                  Constants.textPartyCreationTitle,
                  style: _theme.textTheme.bodyText1
                      .copyWith(color: Constants.kHelperTextColor, height: 1.5),
                ),
              ),
              Container(
                color: Color.fromRGBO(199, 199, 214, 0.5),
                height: _media.size.height * 0.3,
                width: _media.size.width,
                child: (widget.initialValuePicture == '' &&
                        _titlePicutureData['imageUrl'] == '')
                    ? Placeholder(
                        color: Colors.grey[400],
                      )
                    : Image.file(
                        File(
                          widget.initialValuePicture == ''
                              ? _titlePicutureData['imageUrl']
                              : widget.initialValuePicture,
                        ),
                        fit: BoxFit.fill,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PurpleButtonCliped(
                      media: _media,
                      theme: _theme,
                      onTap: () async {
                        final File _result =
                            await Provider.of<ImagePickerService>(context,
                                    listen: false)
                                .pickPartyImage(ImageSource.camera);
                        final _appDocPath =
                            await _storeImageInAppDocumentsDirectory(
                                _result.path);
                        if (_result != null)
                          setState(() {
                            _titlePicutureData['imageUrl'] = _appDocPath;
                          });
                      },
                      clipedSide: ClipedSide.Right,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.camera,
                            size: _media.size.height * 0.04,
                          ),
                          Text(
                            'Picture',
                            style: _theme.textTheme.bodyText1.copyWith(
                              color: Constants.kPurpleButtonTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    PurpleButtonCliped(
                      media: _media,
                      theme: _theme,
                      onTap: () async {
                        final File _result =
                            await Provider.of<ImagePickerService>(context,
                                    listen: false)
                                .pickPartyImage(ImageSource.gallery);
                        if (_result != null)
                          setState(() {
                            _titlePicutureData['imageUrl'] = _result.path;
                          });
                      },
                      clipedSide: ClipedSide.Left,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Gallery',
                            style: _theme.textTheme.bodyText1.copyWith(
                              color: Constants.kPurpleButtonTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.image_rounded,
                            size: _media.size.height * 0.04,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: Text(
                  Constants.textPartyCreationImage,
                  style: _theme.textTheme.bodyText1.copyWith(
                    color: Constants.kHelperTextColor,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
        NavigationPartyCreationWidget(
          media: _media,
          onNext: () {
            _tryToContinue();
          },
          onPrevious: () => Navigator.of(context).pop(),
        )
        //   bottom: 40,
        //   left: _media.size.width / 4.6,
        // ),
      ],
    );
  }
}
