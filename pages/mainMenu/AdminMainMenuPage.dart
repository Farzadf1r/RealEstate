import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/Util.dart';
import 'package:realestate_app/customWidget/agentsList/AgentsList.dart';
import 'package:realestate_app/pages/mainMenu/tabs/CustomersListTab.dart';
import 'package:realestate_app/pages/mainMenu/tabs/profilePage/ProfilePage.dart';

class AdminMainMenu extends StatefulWidget {
  createState() => AdminMainMenuState();
}

class AdminMainMenuState extends State<AdminMainMenu>
    with SingleTickerProviderStateMixin {
  TabController controller;

  dispose() {
    if (controller != null) controller.dispose();
    super.dispose();
  }

  build(BuildContext context) {
    if (controller == null) {
      controller = TabController(length: 3, vsync: this);
      controller.addListener(() {
        setState(() {});
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 40,
        elevation: 0,
        title: halveticaText(_getTabTitle(),
            color: Color(0xff5e5e5e), fontSize: 13),
      ),
      body: TabBarView(
        children: <Widget>[
          AgentsList(),
          CustomersListTab(
            showInviteFAB: false,
          ),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account), label: "Agents"),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account_outlined), label: "Clients"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Your Info")
        ],
      ),
    );
  }

  _getTabTitle() {
    switch (controller.index) {
      case 0:
        return "Agents";
      case 1:
        return "Clients";
      case 2:
        return "Your Info";
    }
  }
}
