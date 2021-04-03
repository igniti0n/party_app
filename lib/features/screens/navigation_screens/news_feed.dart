import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../respositories/user_respository.dart';
import '../../widgets/party_post.dart';
import '../../data/models/party.dart';
import '../../data/models/user.dart';

class NewsFeed extends StatelessWidget {
  const NewsFeed({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Party> _parties =
        Provider.of<List<Party>>(context, listen: false);
    return _parties == null || _parties.isEmpty
        ? Container(
            child: Center(
              child: Text(
                'No parties to show',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ) // Constants.displayLoadingSpinner()
        : ListView.builder(
            itemCount: _parties.length,
            itemBuilder: (BuildContext ctx, int index) {
              return PartyPost(
                party: _parties[_parties.length - 1 - index],
                //TODO: WTF ?! vidi jel se može u party details screen stavit provider i tjt ?
                currentUser:
                    Provider.of<UserRepository>(context, listen: false).user,
              );
            },
          );
  }
}
