import 'package:flutter/material.dart';
import 'package:party/respositories/user_respository.dart';

import '../constants.dart';
import '../services/FirebaseFirestoreService.dart';
import '../data/models/user.dart';
import '../processWidgets/wall_manager.dart';
import '../data/models/party.dart';

import 'package:provider/provider.dart';

class PartyDelegator extends StatelessWidget {
  const PartyDelegator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: Provider.of<FirebaseFirestoreService>(context)
            .getPartyDataStream(
                Provider.of<UserRepository>(context, listen: false).user.uid),
        builder: (ctx, partySnapshot) {
          if (partySnapshot.connectionState != ConnectionState.active &&
              partySnapshot.hasData) return Constants.displayLoadingSpinner();

          final List<Party> _partyList = partySnapshot.data
              ?.map((Map<String, dynamic> party) => Party.fromMap(party))
              ?.toList();
          print('::::PARTIES::::' + _partyList.toString());
          return Provider.value(
            value: _partyList,
            builder: (ctx, _) {
              return WallManager();
            },
          );
        });
  }
}