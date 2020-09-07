part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LogIn extends LoginEvent {
  final String username;
  final String password;

  LogIn({@required this.username, @required this.password});
}
