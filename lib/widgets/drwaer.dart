import 'package:flutter/material.dart';
import '../utils/user.dart' as cUser;

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Chose"),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("main page"),
            onTap: () => pushFirst(context, "/products"),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("manager page"),
            onTap: () => pushFirst(context, "/admin"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Log out"),
            onTap: () => logOut(context),
          ),
        ],
      ),
    );
  }

  void logOut(BuildContext context) {
    cUser.removeData();
    pushFirst(context, "/");
  }

  void pushFirst(BuildContext context, String pageRoute) {
    NavigatorState nav = Navigator.of(context);
    while (nav.canPop()) {
      print("poped");
      nav.pop();
    }

    nav.pushReplacementNamed(pageRoute);
  }
}
