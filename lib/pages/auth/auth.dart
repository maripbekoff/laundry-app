import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/repository/api.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key key}) : super(key: key);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final EdgeInsets textFieldPadding =
      EdgeInsets.symmetric(vertical: 24, horizontal: 16);
      

  @override
  Widget build(BuildContext context) {
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
              Padding(
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
                    onPressed: () async {
                      await LaundryRepo().logIn(
                        _usernameController.text,
                        _passwordController.text,
                      );
                      Navigator.of(context, rootNavigator: true).pushReplacementNamed('/home');
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
