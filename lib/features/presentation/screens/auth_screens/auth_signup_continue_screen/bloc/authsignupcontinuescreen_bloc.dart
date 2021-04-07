import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authsignupcontinuescreen_event.dart';
part 'authsignupcontinuescreen_state.dart';

class AuthSignupContinueScreenBloc
    extends Bloc<AuthSignupContinueScreenEvent, AuthSignupContinueScreenState> {
  AuthSignupContinueScreenBloc() : super(AuthSignupContinueScreenInitial());

  @override
  Stream<AuthSignupContinueScreenState> mapEventToState(
    AuthSignupContinueScreenEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
