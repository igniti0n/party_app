import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/presentation/widgets/deligators/auth_screen_builder.dart';
import 'features/presentation/widgets/deligators/auth_widget.dart';
import 'features/presentation/widgets/deligators/user_deligator.dart';
import 'features/presentation/screens/party_detail_screen.dart';
import 'features/data/datasources/FirebaseAuthService.dart';
import 'core/native/ImagePickerService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (ctx) => FirebaseAuthService(),
        ),
        Provider<ImagePickerService>(
          create: (ctx) => ImagePickerService(),
        )
      ],
      child: AuthScreenBuilder(
        builderFn: (ctx, userSnapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Let\'s Party',
            theme: ThemeData(
              primaryColor: Color.fromRGBO(42, 31, 31, 1),
              textTheme: TextTheme(
                headline1: TextStyle(
                    fontFamily: 'Sylfaen',
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                headline2: TextStyle(
                    fontFamily: 'Rockwell',
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
                bodyText1: TextStyle(
                    fontFamily: 'Sylfaen',
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
                bodyText2: TextStyle(
                    fontFamily: 'Rockwell',
                    fontSize: 11,
                    fontWeight: FontWeight.normal),
              ),
              appBarTheme: AppBarTheme(color: Color.fromRGBO(42, 31, 31, 1)),
            ),
            routes: {
              UserDeligator.routeName: (ctx) => UserDeligator(),
              PartyDetailScreen.routeName: (ctx) => PartyDetailScreen(),
            },

            // initialRoute: SignupScreen.routeName,
            home: AuthenticationWidget(
              snapshot: userSnapshot,
            ),
          );
        },
      ),
    );
  }
}
