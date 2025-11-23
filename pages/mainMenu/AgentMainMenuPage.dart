import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/Util.dart';
import 'package:realestate_app/pages/mainMenu/tabs/AuthorizedAdListing.dart';
import 'package:realestate_app/pages/mainMenu/tabs/AuthorizedAdMapListing.dart';
import 'package:realestate_app/pages/mainMenu/tabs/CustomersListTab.dart';
import 'package:realestate_app/pages/mainMenu/tabs/favorite.dart';
import 'package:realestate_app/pages/mainMenu/tabs/profilePage/ProfilePage.dart';

import '../../customWidget/singleton/AppData.dart';

class AgentMainMenu extends StatefulWidget {
  createState() => AgentMainMenuState();
}

class AgentMainMenuState extends State<AgentMainMenu>
    with SingleTickerProviderStateMixin {
  TabController controller;

  dispose() {
    if (controller != null) controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5 , vsync: this);
  }

  build(BuildContext context) {

    if(controller==null)
    {
      controller.addListener(() { setState(() {});});
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 40,
        elevation: 0,
        title: _getTabTitle(),
      ),
      body: TabBarView(
        children: <Widget>[
          Favorite(),
          AuthorizedAdListing(),
          AuthorizedAdMapListing(),
          CustomersListTab(),
          ProfilePage()
        ],
        controller: controller,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: controller.index,
        onTap: (index) {
          setState(() {
            controller.index = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon:  Icon(Icons.star,size: 28),label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.home,size: 28),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map,size: 28),label: "Map"),
          BottomNavigationBarItem(icon:  Icon(Icons.supervisor_account,size: 28),label: "Clients"),
          BottomNavigationBarItem(icon:  Icon(Icons.account_circle,size: 28),label:"Your Info"),
        ],
      ),
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

  _getTabTitle() {
    switch (controller.index) {
      case 1:
      case 2:
        return  _createHallmarkLogo();
      case 0:
        return halveticaText("Favorites", color: Color(0xff5e5e5e), fontSize: 13);
      case 3:
        return halveticaText("Clients", color: Color(0xff5e5e5e), fontSize: 13);
      case 4:
        return halveticaText("Your Info", color: Color(0xff5e5e5e), fontSize: 15);
    }
  }
}
