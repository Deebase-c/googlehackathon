import 'package:square_in_app_payments_example/services/auth_service.dart';
import 'package:flutter/material.dart';

class Prov extends InheritedWidget {
  final AuthService auth;
  final db;

  Prov({Key key, Widget child, this.auth, this.db}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;


  static Prov of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Prov>());

}