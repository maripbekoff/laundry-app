import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/cart/cart_bloc.dart';
import 'package:laundry/utils/theme/theme.dart';

import 'blocs/auth/auth_bloc.dart';
import 'pages/auth/auth.dart';
import 'pages/home/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFFFFFF),
      statusBarColor: Color(0xFFFFFFFF),
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AppStarted()),
        ),
        BlocProvider<CartBloc>(
          create: (BuildContext context) => CartBloc(),
        ),
      ],
      child: CupertinoApp(
        title: 'Laundry',
        theme: CustomThemeData().theme,
        debugShowCheckedModeBanner: false,
        routes: {
          '/auth': (BuildContext context) => AuthPage(),
          '/home': (BuildContext context) => HomePage(),
        },
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial)
              return AuthPage();
            else if (state is UnAuthenticated)
              return AuthPage();
            else if (state is Authenticated) return HomePage();
          },
        ),
      ),
    );
  }
}
