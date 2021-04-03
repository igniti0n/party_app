import 'package:flutter/material.dart';

import '../screens/navigation_screens/user_wall.dart';
import '../data/models/user.dart';

class VisitingUserScreen extends StatelessWidget {
  final User visitingUser;
  final User currentUser;
  const VisitingUserScreen({
    Key key,
    @required this.visitingUser,
    @required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SizeHelper.init(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: UserWall(
        visitingUser: visitingUser,
      ),
    );
  }
}
