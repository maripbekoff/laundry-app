import 'package:flutter/cupertino.dart';
import 'package:laundry/intercessors/laundry.dart';
import 'package:laundry/intercessors/profile.dart';
import 'package:laundry/models/catalog.dart';
import 'package:laundry/models/user.dart';
import 'package:laundry/pages/cart/cart.dart';
import 'package:laundry/repository/api.dart';
import 'package:laundry/utils/icons/laundry_icons.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LaundryRepo laundryRepo = LaundryRepo();
  Future<List<Catalog>> _catalog;
  Future<User> _user;
  final TextStyle _navbarItemsStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    super.initState();
    _catalog = laundryRepo.getCatalog;
    _user = laundryRepo.getName;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoTabScaffold(
        tabBar: _buildCupertinoTabBar(),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              switch (index) {
                case 0:
                  return LaundryIntercessor(catalog: _catalog);
                  break;
                case 1:
                  return ProfileIntercessor(user: _user);
                  break;
                case 2:
                  return CartPage();
                  break;
                default:
                  return LaundryIntercessor(catalog: _catalog);
              }
            },
          );
        },
      ),
    );
  }

  CupertinoTabBar _buildCupertinoTabBar() {
    return CupertinoTabBar(
      activeColor: Color(0xFF172853),
      iconSize: 24.0,
      backgroundColor: Color(0xFFFFFFFF),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Laundry.laundry, size: 20),
          title: Text(
            'Прачечная',
            style: _navbarItemsStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: Text(
            'Профиль',
            style: _navbarItemsStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.shopping_cart),
          title: Text(
            'Корзина',
            style: _navbarItemsStyle,
          ),
        ),
      ],
    );
  }
}
