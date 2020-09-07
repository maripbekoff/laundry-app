import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:laundry/repository/api.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LaundryRepo laundryRepo = LaundryRepo();

  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LogIn) {
      try {
        yield Loading();
        await laundryRepo.logIn(event.username, event.password);
        yield LoggedIn();
      } catch (e) {
        yield Failure(message: '$e');
      }
    }
  }
}
