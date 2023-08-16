import 'package:flutter/widgets.dart';
import 'package:relay/app/app.dart';
import 'package:relay/app_lock/view/app_lock_page.dart';
import 'package:relay/home/home.dart';
import 'package:relay/welcome/welcome.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.unauthenticated:
      return [WelcomePage.page()];
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.locked:
      return [AppLockPage.page()];
  }
}
