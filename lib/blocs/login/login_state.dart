part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {
  final bool isLoading = false;
}

class Failure extends LoginState {
  final String message;

  Failure({@required this.message});
}

class LoggedIn extends LoginState {
  final bool isLoading = false;
}

class Loading extends LoginState {
  final bool isLoading = true;
}
