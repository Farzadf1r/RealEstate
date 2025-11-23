import 'package:flutter/cupertino.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/pages/Router.dart';

class SplashPage extends StatefulWidget {
  createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {

  bool hasRequestedUserSignInStatus = false;
  final delay = 1000;



  didUpdateWidget( oldWidget) {
    super.didUpdateWidget(oldWidget);
    hasRequestedUserSignInStatus = false;
  }

  Widget build(BuildContext context) {

    _requestUserSignInStatus(context);

    return Center(
      child: Container(
        width: percentageOfDeviceWidth(context, 0.8),
        height: percentageOfDeviceHeight(context, 0.8),
        child: Image.asset(
          "images/HOUSELOGIQLOGO2.jpg",
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  _requestUserSignInStatus(BuildContext context) {

    if(hasRequestedUserSignInStatus)
      return;

    hasRequestedUserSignInStatus = true;

    Future.delayed(Duration(milliseconds: delay), () async{

      await ServerGateway.instance().initialize();
      replaceTopPageWith(context, MainMenuPagePath);


    }).then((value) => null);
  }
}
