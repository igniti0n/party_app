import 'package:flutter/material.dart';

import '../../../widgets/purple_button.dart';

class NavigationPartyCreationWidget extends StatelessWidget {
  const NavigationPartyCreationWidget({
    Key key,
    @required MediaQueryData media,
    @required this.onNext,
    @required this.onPrevious,
  })  : _media = media,
        super(key: key);

  final MediaQueryData _media;
  final Function onNext;
  final Function onPrevious;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: _media.size.width / 4.6,
      child: Column(
        children: [
          PurpleButton(
            text: 'Next',
            media: _media,
            theme: Theme.of(context),
            onTap: onNext,
          ),
          SizedBox(
            height: 10,
          ),
          PurpleButton(
            text: 'Previous',
            media: _media,
            theme: Theme.of(context),
            onTap: onPrevious,
          ),
        ],
      ),
    );
  }
}
