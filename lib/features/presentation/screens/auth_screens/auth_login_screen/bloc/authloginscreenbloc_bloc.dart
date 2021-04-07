import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authloginscreenbloc_event.dart';
part 'authloginscreenbloc_state.dart';

class AuthLoginScreenBloc
    extends Bloc<AuthloginscreenblocEvent, AuthLoginScreenBlocState> {
  AuthLoginScreenBloc() : super(AuthLoginScreenBlocInitial());

  @override
  Stream<AuthLoginScreenBlocState> mapEventToState(
    AuthloginscreenblocEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
