import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laundry/models/user.dart';
import 'package:laundry/repository/api.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, @required this.user}) : super(key: key);

  User user = User();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  final LaundryRepo laundryRepo = LaundryRepo();
  bool switched = true;

  @override
  void initState() {
    final settingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
    super.initState();
  }

  Future onSelectNotification(String payload) async => showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Уведомление'),
          content: Text('Всё хорошо!'),
        );
      });

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
                    onChanged: (bool value) => setState(() => switched = value),
                  ),
                  onTap: () async {
                    setState(() => switched = !switched);
                    var androidPlatformChannelSpecifics =
                        AndroidNotificationDetails('test', 'test', 'test',
                            importance: Importance.Max,
                            priority: Priority.High,
                            enableVibration: true,
                            groupAlertBehavior: GroupAlertBehavior.Children,
                            styleInformation:
                                InboxStyleInformation(['Магия', 'Бэкенд']),
                            ticker: 'ticker');
                    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
                    var platformChannelSpecifics = NotificationDetails(
                        androidPlatformChannelSpecifics,
                        iOSPlatformChannelSpecifics);
                    await notifications.show(
                        0,
                        'Уведомление!',
                        'Ради бонуса, решил сделать и это))',
                        platformChannelSpecifics,
                        payload: 'item x');
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
