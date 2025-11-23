



import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/customersList/CustomersList.dart';
import 'package:realestate_app/pages/Router.dart';

class CustomersListTab extends StatelessWidget
{
  final showInviteFAB;

  CustomersListTab({this.showInviteFAB = true});
  
  
  build(context) => showInviteFAB ?Scaffold(
    backgroundColor: Colors.white,
      body: CustomersList(),
    floatingActionButton: _buildFloatingActionButton(context) ,
  ):Scaffold(
    backgroundColor: Colors.white,
    body: CustomersList(),
  );

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(child: Icon(Icons.email_outlined),onPressed: (){
    showInvitationPage(context);
  });
  }







}
