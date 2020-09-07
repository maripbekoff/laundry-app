import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/blocs/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key key}) : super(key: key);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final EdgeInsets textFieldPadding =
      EdgeInsets.symmetric(vertical: 24, horizontal: 16);

  LoginBloc _loginBloc;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _loginBloc = context.bloc<LoginBloc>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Войти'),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoTextField(
                controller: _usernameController,
                keyboardType: TextInputType.name,
                placeholder: 'Логин',
                padding: textFieldPadding,
              ),
              CupertinoTextField(
                controller: _passwordController,
                placeholder: 'Пароль',
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                padding: textFieldPadding,
              ),
              SizedBox(height: 32),
              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoggedIn) {
                    _isLoading = state.isLoading;
                    return Navigator.of(context, rootNavigator: true)
                        .pushReplacementNamed('/home');
                  } else if (state is Failure) {
                    return showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text('Ошибка'),
                          content: Text('${state.message}'),
                          actions: [
                            CupertinoDialogAction(
                              child: Text('Ок'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is Loading) {
                    _isLoading = state.isLoading;
                  }
                },
                builder: (context, state) {
                  return _buildLoginButton(_isLoading);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildLoginButton(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CupertinoButton.filled(
          child: Text(
            'Войти',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 18,
          ),
          disabledColor: CupertinoColors.inactiveGray,
          onPressed: isLoading
              ? null
              : () async => _loginBloc.add(LogIn(
                    username: _usernameController.text,
                    password: _passwordController.text,
                  ))),
    );
  }
}
