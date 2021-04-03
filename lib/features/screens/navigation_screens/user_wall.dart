import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../respositories/user_respository.dart';
import '../../data/models/party.dart';
import '../../data/models/user.dart';
import '../../services/FirebaseFirestoreService.dart';
import '../../widgets/party_post.dart';
import '../../widgets/user_wall_navigator.dart';

class UserWall extends StatefulWidget {
  final User visitingUser;
  //final User logedInUser;
  const UserWall({
    Key key,
    @required this.visitingUser,
  }) : super(key: key);

  @override
  _UserWallState createState() => _UserWallState();
}

class _UserWallState extends State<UserWall> {
  bool _buildCreated = true;
  // List<Party> _createdParties;
  // List<Party> _attendedParties;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final logedInUser = Provider.of<UserRepository>(context).user;
    final bool _isVisitingUserCurrentUser =
        logedInUser.uid == widget.visitingUser.uid;
    ; //is user opening up his/her profile
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: _size.height * 0.3,
          child: UserWallNavigator(
            userToBeDisplayed: widget.visitingUser,
            logedUser: logedInUser,
            isCreated: _buildCreated,
            availableSize: Size(
              _size.width,
              _size.height * 0.3,
            ),
            onTapChange: (_newBuildCreated) {
              if (_buildCreated != _newBuildCreated)
                setState(() {
                  _buildCreated = _newBuildCreated;
                });
            },
          ),
        ),
        Expanded(
          child: _buildParties(logedInUser),
        ),
      ],
    );
  }

  Widget _buildParties(User logedInUser) {
    print(widget.visitingUser.attendedPartyIds);

    final _reference =
        Provider.of<FirebaseFirestoreService>(context, listen: false);
    return StreamBuilder(
      stream: _buildCreated
          ? _reference.getPartyDataForCreatedByUser(widget.visitingUser.uid)
          : _reference.getPartyDataForAttendedByUser(
              widget.visitingUser.attendedPartyIds.isEmpty
                  ? ['abcd']
                  : widget.visitingUser.attendedPartyIds),
      builder: (contxt, asyncSnapshot) {
        if (asyncSnapshot.connectionState != ConnectionState.active &&
            asyncSnapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        final List<Map<String, dynamic>> _data =
            asyncSnapshot.data as List<Map<String, dynamic>>;

        return _data == null
            ? Container()
            : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (ctx, index) {
                  return PartyPost(
                    party: Party.fromMap(_data[index]),
                    isUserWall: _buildCreated,
                    currentUser: logedInUser,
                  );
                },
              );
      },
    );
  }
}
