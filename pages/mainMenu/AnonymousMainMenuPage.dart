import 'package:flutter/material.dart';
import 'package:realestate_app/pages/Router.dart';
import 'package:realestate_app/pages/mainMenu/tabs/AnonymousAdListing.dart';
import 'package:realestate_app/pages/mainMenu/tabs/AnonymousAdMapListing.dart';

import '../../customWidget/singleton/AppData.dart';

class AnonymousMainMenuPage extends StatefulWidget {
  createState() => AnonymousMainMenuPageState();
}

class AnonymousMainMenuPageState extends State<AnonymousMainMenuPage>
    with SingleTickerProviderStateMixin {
  bool isClosed = false;

  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 40,
        elevation: 0,
        title: _getTabTitle(),
      ),
      body: Stack(children: [
        _showMapOrList(),
        _createFloatingLoginButton(),
      ]),
    );
  }

  _showMapOrList() {
    String showType = appData.text;
    switch (showType) {
      case "Map":
        return AnonymousAdMapListing();
        break;
      default:
        return AnonymousAdListing();
        break;
    }
  }

  _createFloatingLoginButton() => Stack(children: [
        Container(
          child: Positioned(
            bottom: 15.0,
            left: 25.0,
            right: 25.0,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.blueAccent,
              onPressed: () => bringUpLoginDialog(context),
              label: Text(
                'Please Login to gain access to sold listings',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              elevation: 18,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
            ),
          ),
        ),
        Positioned(
          bottom: 55.0,
          left: 20.0,
          right: 20.0,
          child: Image.asset("images/newHouseLogiQIcon.png",
              width: 30, height: 30),
        )
      ]);

  _createHallmarkLogo() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            child: Image.asset(
              "images/houselogiqsmall.png",
              fit: BoxFit.contain,
            ),
          ),
          Text("RE/MAX Hallmark Group of Companies*",
              style: TextStyle(color: Colors.black, fontSize: 9)),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  _getTabTitle() => _createHallmarkLogo();

}