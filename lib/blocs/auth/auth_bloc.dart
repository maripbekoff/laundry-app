import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:laundry/helpers/secure_storage.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorage _storage = SecureStorage();
  String authtoken;
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        authtoken = await _storage.readAuthToken;
        if (authtoken.isEmpty) {
          yield UnAuthenticated();
        } else {
          yield Authenticated();
        }
      } catch (e) {
        yield UnAuthenticated();
      }
    }
  }
}
