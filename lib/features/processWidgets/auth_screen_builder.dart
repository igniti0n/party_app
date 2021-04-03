import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/FirebaseFirestoreService.dart';
import '../services/FirebaseStorageService.dart';
import '../services/FirebaseAuthService.dart';

class AuthScreenBuilder extends StatelessWidget {
  AuthScreenBuilder({Key key, this.builderFn}) : super(key: key);
  final Widget Function(BuildContext ctx, AsyncSnapshot<auth.User> snapshot)
      builderFn;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<FirebaseAuthService>(context, listen: false)
            .userSnapshot,
        builder: (ctx, userSnapshot) {
          print(':::USER STREAM:::');
          if (userSnapshot.data != null) {
            return MultiProvider(
              providers: [
                Provider<FirebaseFirestoreService>(
                  create: (ctx) => FirebaseFirestoreService(),
                ),
                Provider<FirebaseStorageService>(
                  create: (ctx) => FirebaseStorageService(),
                ),
              ],
              child: builderFn(ctx, userSnapshot),
            );
          } else {
            return builderFn(ctx, userSnapshot);
          }
        });
  }
}
