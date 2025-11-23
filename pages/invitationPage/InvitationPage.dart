import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/general/Toast.dart';
import 'package:realestate_app/customWidget/Util.dart';
import 'package:realestate_app/customWidget/blocModelProvider/ModelProvidedState.dart';
import 'package:realestate_app/pages/Router.dart';
import 'package:realestate_app/pages/invitationPage/InvitationModel.dart';

class InvitationPage extends StatefulWidget {
  createState() => InvitationPageState();
}

class InvitationPageState
    extends ModelProvidedState<InvitationPage, InvitationModel> {
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final contentController = TextEditingController(text: 'Please Download "HouseLogiQ" from the AppStore and GooglePlay. AppStore Link: https://apps.apple.com/ca/app/houselogiq/id1555801565      '
      'GooglePlay Link: https://play.google.com/store/apps/details?id=com.houselogic.flutter_appcustomer');

  void eventReceived(String eventName,data) {
    switch(eventName)
    {
      case InvitationModel.CustomerInvitedEvent:{
        goToPrevPage(context);
        break;
      }
      case InvitationModel.CustomerInvitationFailedEvent:
        toast(data, context);

    }
  }


  buildContent(context) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.blueAccent),
            SizedBox(height: 20,),
            _createTitle("Mobile"),
            SizedBox(height: 10),
            _createTextField(mobileController, 1),
            SizedBox(height: 20),
            _createTitle("Email"),
            SizedBox(height: 10),
            _createTextField(emailController, 1),
            SizedBox(height: 20),
            _createTitle("Content"),
            SizedBox(height: 10),
            _createTextField(contentController, 5),
            SizedBox(height: 50),
            _createInviteButton2()
          ],
        ),
      ),
    );

  /**_createInviteButton() => SizedBox(
        width: double.infinity,
        height: 36,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          onPressed: () async {
            model.invite(mobileController.text, emailController.text, contentController.text);
          },
          child: Text(
            "Invite Client",
            style: TextStyle(
                color: Colors.white, fontFamily: "PTSansCaption", fontSize: 16),
          ),
          color: Color(0xff4691d5),
        ),
      );*/


  _createInviteButton2() => SizedBox(
    width: double.infinity,
    height: 36,
    child: ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
          )
        )),
      onPressed: () async {
        model.invite(mobileController.text, emailController.text, contentController.text);
      },
      child: Text(
        "Invite Client",
        style: TextStyle(
            color: Colors.white, fontFamily: "PTSansCaption", fontSize: 16),
      ),
    )
  );



  _createTitle(String title) =>
      halveticaBoldText(title, color: Color(0xff5e5e5e), fontSize: 16);

  _createTextField(TextEditingController controller, int lines) {
    return TextField(
      maxLines: lines,
      style: TextStyle(
          height: 1.5,
          fontFamily: "Halvetica",
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 5, right: 5),
        filled: true,
        fillColor: Color(0xfffbfbfb),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black54)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black54)),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black54)),
      ),
      keyboardType: TextInputType.text,
      controller: controller,
    );
  }
}
