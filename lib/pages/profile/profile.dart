import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/models/user.dart';
import 'package:laundry/repository/api.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, @required this.user}) : super(key: key);

  User user = User();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LaundryRepo laundryRepo = LaundryRepo();
  bool switched = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('${widget.user.login}'),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Material(
          color: CupertinoColors.white,
          child: ListView(
            shrinkWrap: true,
            children: [
              MergeSemantics(
                child: ListTile(
                  title: Text('Уведомления'),
                  trailing: CupertinoSwitch(
                    value: switched,
                    activeColor: CupertinoColors.activeBlue,
                    onChanged: (bool value) {
                      setState(() {
                        switched = value;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      switched = !switched;
                    });
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Выйти',
                  style: TextStyle(color: CupertinoColors.destructiveRed),
                ),
                onTap: () async {
                  await laundryRepo.logOut();
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil('/auth', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
