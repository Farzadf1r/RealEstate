import 'package:flutter/material.dart';
import 'package:realestate_app/pages/mainMenu/tabs/AnonymousMainMenuNoLoginPage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:realestate_app/customWidget/Util.dart';
import 'package:realestate_app/pages/mainMenu/tabs/AnonymousAdListing.dart';
import 'package:realestate_app/pages/mainMenu/tabs/favorite.dart';
import 'package:realestate_app/pages/mainMenu/tabs/profilePage/ProfilePage.dart';
import 'package:realestate_app/pages/Router.dart';
//import '../Router.dart';

class AnonymousMainMenuNoLogin extends StatefulWidget {
  createState() => AnonymousMainMenuNoLoginState();
}

class AnonymousMainMenuNoLoginState extends State<AnonymousMainMenuNoLogin>
    with SingleTickerProviderStateMixin {
  bool isClosed = false;


  build(BuildContext context) {

    return Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,centerTitle: true,toolbarHeight: 40,
              elevation: 0,
              title:  _getTabTitle() ,
            ),
            body: AnonymousAdListing(),
          ),
          CustomDialog()
        ]
    );
  }

  _createHallmarkLogo()
  {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            height: 30,
            child: Image.asset("images/houselogiqsmall.png",
              fit: BoxFit.contain,
            ),
          ),
          Text("RE/MAX Hallmark Group of Companies*",
              style: TextStyle(color: Colors.black,fontSize: 9)),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
  _getTabTitle() =>  _createHallmarkLogo();

//_alertDialog() =>

}