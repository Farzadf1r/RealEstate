import 'package:flutter/material.dart';
import 'package:realestate_app/model/entity/PropertyAd.dart';
import 'package:realestate_app/model/entity/PropertyAdSearchFilter.dart';
import 'package:realestate_app/pages/mainMenu/AnonymousMainMenuPage.dart';
import 'package:realestate_app/pages/propertyDetails/PropertyDetailsPage.dart';
import 'package:realestate_app/pages/searchFilter/SearchFilterPage.dart';
import 'package:realestate_app/pages/splash/SplashPage.dart';
import 'package:realestate_app/pages/verification/VerificationPage.dart';

import '../customWidget/singleton/AppData.dart';
import 'askForOTP/AskForOTPPage.dart';
import 'invitationPage/InvitationPage.dart';
import 'mainMenu/MainMenu.dart';
import 'map/mapview.dart';

const String AnonymousMainMenu = "anonymous";
const String MainMenuPagePath = "/";
const String AskForOTPPagePath = "otp";
const String VerificationPagePath = "verify";
const String SplashPagePath = "splash";
const String SearchFilterPagePath = "search-filter";
const String PropertyDetailsPagePath = "property-details";
const String InvitationPagePath = "invitation";
const String MapFullOfMarkersPagePath = "full-map";
const String SingleMarkerMapPagePath = "marker-map";
const String ListPagePath = "list";

Route<dynamic> pageRouter(RouteSettings settings) {
  switch (settings.name) {
    case AnonymousMainMenu:
      return _createRoute(AnonymousMainMenuPage());
    case SplashPagePath:
      return _createRoute(SplashPage());
    case MainMenuPagePath:
      appData.text = "List";
      return _createRoute(MainMenu());
    case AskForOTPPagePath:
      return _createRoute(AskForOTPPage());
    case VerificationPagePath:
      return _createRoute(VerificationPage(
          (context) => wipeAllPagesAndGoTo(context, MainMenuPagePath)));
    case InvitationPagePath:
      return _createRoute(InvitationPage());
    case MapFullOfMarkersPagePath:
      appData.text = "Map";
      return _createRoute(MainMenu());
    case ListPagePath:
      appData.text = "List";
      return _createRoute(MainMenu());
    case SingleMarkerMapPagePath:
      return _createRoute(MapView((settings.arguments as List)[0] as double,
          (settings.arguments as List)[1] as double));
    case PropertyDetailsPagePath:
      return _createRoute(PropertyDetailsPage(
        (settings.arguments as List)[0] as PropertyAd,
        modelChangedCallback:
            (settings.arguments as List)[1] as void Function(PropertyAd),
      ));
    case SearchFilterPagePath:
      return _createRoute(SearchFilterPage(
          initialFilter:
              (settings.arguments as List)[0] as PropertyAdSearchFilter,
          listener:
              (settings.arguments as List)[1] as SearchFilterChangedListener));
    default:
      return _createRoute(Center(child: Text("Unknown Page")));
  }
}

void goToPrevPage(context, {result}) => Navigator.pop(context, result);

void showInvitationPage(context) =>
    Navigator.pushNamed(context, InvitationPagePath);

Future showSearchFilterPage(context,
        {PropertyAdSearchFilter initialFilter,
        SearchFilterChangedListener listener}) =>
    Navigator.pushNamed(context, SearchFilterPagePath,
        arguments: [initialFilter, listener]);

Future showMapFullOfMarkersPage(context) =>
    Navigator.pushReplacementNamed(context, MapFullOfMarkersPagePath, arguments: []);

Future showListPage(context) =>
    Navigator.pushReplacementNamed(context, ListPagePath, arguments: []);

Future showSingleMarkerMapPage(context, {double longitude, double latitude}) =>
    Navigator.pushNamed(context, SingleMarkerMapPagePath,
        arguments: [longitude, latitude]);

Future<void> showPropertyDetailsPage(context, PropertyAd ad,
        {void Function(PropertyAd) modelChangedCallback}) =>
    Navigator.pushNamed(context, PropertyDetailsPagePath,
        arguments: [ad, modelChangedCallback]);

void wipeAllPagesAndGoTo(context, path, {args}) =>
    Navigator.pushNamedAndRemoveUntil(context, path, (route) => false,
        arguments: args);

MaterialPageRoute _createRoute(Widget widget) => MaterialPageRoute(
    builder: (c) =>
        Material(color: Colors.white, child: SafeArea(child: widget)));

void replaceTopPageWith(context, path, {args}) =>
    Navigator.popAndPushNamed(context, path, arguments: args);

void bringUpLoginDialog(context) {
  showDialog(
      context: context,
      builder: (c) => MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AskForOTPPagePath,
            routes: {
              AskForOTPPagePath: (c) => Dialog(child: AskForOTPPage(
                    overrideBackButtonCallback: () {
                      Navigator.of(context).pop();
                    },
                  )),
              VerificationPagePath: (c) => Dialog(child: VerificationPage((c) {
                    wipeAllPagesAndGoTo(context, MainMenuPagePath);
                  }))
            },
          ),
      useRootNavigator: false,
      barrierDismissible: true);
  print("please login first!");
}
