import 'package:flutter/cupertino.dart';
import 'package:realestate_app/customWidget/blocModelProvider/ModelProvider.dart';
import 'package:realestate_app/customWidget/map/GeoCoordinationLoader.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/Role.dart';
import 'package:realestate_app/pages/mainMenu/AnonymousMainMenuPage.dart';

import 'AdminMainMenuPage.dart';
import 'AgentMainMenuPage.dart';
import 'AnonymousMainMenuPage.dart';
import 'CustomerMainMenuPage.dart';

class MainMenu extends StatelessWidget {
  build(context) {
    // final user = ServerGateway.instance().signedInUser;
    final role = ServerGateway.instance().selectedRole;

    var model = ModelProvider.instance.provideModelFor<GeoCoordinationLoader>(
        "GeoCoordinationLoader",
        requesterObject: this,
        argument: null);
    model.loadPage(-180.0, -90.0, 180.0, 90.0);
    if (role == Role.Admin)
      return AdminMainMenu();
    else if (role == Role.Seller)
      return AgentMainMenu();
    else if (role == Role.Customer)
      return CustomerMainMenu();
    else
      return AnonymousMainMenuPage();
  }
}
