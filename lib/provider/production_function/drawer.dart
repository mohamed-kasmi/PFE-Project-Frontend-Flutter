import 'package:flutter/material.dart';

Drawer buildProductionDrawer() {
  return Drawer(
    child: ListView(
      children: const <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        ListTile(title: Text('Dashboards')),
        ListTile(title: Text('Analytics')),
        ListTile(title: Text('Production')),
      ],
    ),
  );
}
