import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/models/user.dart';
import 'package:laundry/pages/profile/profile.dart';

class ProfileIntercessor extends StatelessWidget {
  ProfileIntercessor({Key key, @required this.user}) : super(key: key);
  Future<User> user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(
              child: SizedBox(
                width: 200.0,
                height: 200.0,
                child: CupertinoActivityIndicator(),
              ),
            );
          default:
            if (snapshot.hasError)
              return Offstage();
            else
              return ProfilePage(user: snapshot.data);
        }
      },
    );
  }
}
