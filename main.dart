import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/map/GeoCoordinationLoader.dart';
import 'package:realestate_app/model/entity/PropertyAd.dart';
import 'package:realestate_app/pages/Router.dart';
import 'package:realestate_app/pages/askForOTP/SignUpSignInModel.dart';
import 'package:realestate_app/pages/invitationPage/InvitationModel.dart';
import 'package:realestate_app/pages/mainMenu/tabs/profilePage/ModifyNameModel.dart';
import 'package:realestate_app/pages/mainMenu/tabs/profilePage/ProfileModel.dart';
import 'package:realestate_app/pages/propertyDetails/PropertyDetailsModel.dart';
import 'customWidget/adProperty/PreLoadedPropertyDetailsModel.dart';
import 'customWidget/blocModelProvider/ModelProvider.dart';
import 'customWidget/customersList/PreloadedCustomerModel.dart';

import 'dart:developer' as developer;

void main() {
  developer.log('log me', name: 'my.app.category');

  WidgetsFlutterBinding.ensureInitialized();

  ModelProvider.instance.creator = (type, id, argument,prevModel) {
    if (type == SignUpSignInModel) return SignUpSignInModel();

    if (type == PropertyDetailsModel) return PropertyDetailsModel(argument as PropertyAd);

    if (type == PreLoadedPropertyDetailsModel)
      return PreLoadedPropertyDetailsModel(argument);

    if (type == PreloadedCustomerModel)
      return PreloadedCustomerModel(argument);

    if(type == InvitationModel)
      return InvitationModel();

    if(type == ModifyNameModel)
      return ModifyNameModel();

    if(type == ProfileModel)
      return ProfileModel();

    if(type == GeoCoordinationLoader)
      return GeoCoordinationLoader();

    throw Exception("No candidate for $type");
  };


  runApp(RealStateApp());


}

class RealStateApp extends StatelessWidget {
  build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: pageRouter,
      color: Colors.white,
      initialRoute: SplashPagePath,

      theme: ThemeData(
        buttonTheme: ButtonThemeData(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 0,
            height: 0,
            padding: EdgeInsets.zero),
        primarySwatch: Colors.blue,
      ),
    );
  }
}


