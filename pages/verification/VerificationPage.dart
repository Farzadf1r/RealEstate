
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realestate_app/customWidget/general/DeviceFractionSpace.dart';
import 'package:realestate_app/customWidget/general/Toast.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';
import 'package:realestate_app/customWidget/Util.dart';
import 'package:realestate_app/customWidget/blocModelProvider/ModelProvidedState.dart';
import 'package:realestate_app/model/entity/Role.dart';
import 'package:realestate_app/pages/askForOTP/SignUpSignInModel.dart';
import 'package:realestate_app/pages/mainMenu/tabs/profilePage/ModifyNameDialog.dart';

import '../Router.dart';

class VerificationPage extends StatefulWidget {

  final void Function(BuildContext) doOnVerification;

  VerificationPage(this.doOnVerification);

  createState() => _VerificationPageState();
}

class _VerificationPageState extends ModelProvidedState<VerificationPage,SignUpSignInModel> {
  final codeController = TextEditingController();
  String get modelId => "SignUpSignInModel";

  initState() {
    super.initState();
    disposeModelWhenStateDisposed = false;
  }

  void eventReceived(String eventName,data)
  {
    switch(eventName)
    {
      case SignUpSignInModel.verificationSucceededSignalEvent:
        _chooseARole();
        break;
      case SignUpSignInModel.verificationFailureMessageEvent:
        toast(data, context);
        break;
      case SignUpSignInModel.roleWasSelectedEvent:
        _decideToAskForFullNameOrGoToMainMenu();
        break;  
    }
  }

  _decideToAskForFullNameOrGoToMainMenu()
  {
    if(model.userWhoVerifiedOTP.hasFullName)
      _goToMainMenu();
    else
      _modifyName();
  }

  _modifyName() {
    showDialog(
        context: context,barrierDismissible: false,
        builder:(context)=> WillPopScope(
          onWillPop: ()async{return model.userWhoVerifiedOTP.hasFullName;},
          child: Center(
            child: Container(
                width: percentageOfDeviceWidth(context, 0.8),
                child: ModifyNameDialog(
                  description: "Please enter your first and last name",
                  nameModified: () {
                    _goToMainMenu();
                  },
                )),
          ),
        ));
  }

  _chooseARole() {
    
    if(model.userWhoVerifiedOTP.hasMoreThanOneRole)
      _showChooseARoleDialog();
    else
      model.chooseFirstRoleWhateverItIs();
  }

  _goToMainMenu() {
    model.dispose(this);
    widget.doOnVerification(context);
  }

  Text Hint() {
    return Text(
      "Please enter the code sent to your email address",
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          fontFamily: "Halvetica",
          color: Colors.black),
    );
  }
  
  _showChooseARoleDialog()
  {
    final retValue = showDialog(context: context,barrierDismissible: false,builder:(context)=> Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: percentageOfDeviceWidth(context,0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                halveticaText("Choose Among Your Roles"),
                SizedBox(height: 20,),

                if(model.userWhoVerifiedOTP.isAdmin)
                  createRoundedCornerRaisedButton("Admin",onPress: (){
                    model.chooseRole(Role.Admin);
                    goToPrevPage(context,result :"Admin");
                  }),

                SizedBox(height: 20,),

                if(model.userWhoVerifiedOTP.isAgent)
                  createRoundedCornerRaisedButton("Agent",onPress: (){
                    model.chooseRole(Role.Seller);
                    goToPrevPage(context,result :"Agent");
                  }),

                SizedBox(height: 20,),

                if(model.userWhoVerifiedOTP.isCustomer)
                  createRoundedCornerRaisedButton("Customer",onPress: (){
                    model.chooseRole(Role.Customer);
                    goToPrevPage(context,result :"Customer");
                  }),

                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    ));


    retValue.then((value) {
      if(value == null)
        model.chooseFirstRoleWhateverItIs();
    });
  }

  Widget buildContent(context) => Scaffold(
    body: Stack(
      children: [Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(flex: 2),
                buildIntroImage(),
                /**_createHallmarkLogo(),*/
                /**buildTopImage(),*/
                SizedBox(height: 20),
                buildPageTitle(),
                SizedBox(height: 10),
                Hint(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [buildEditRecipientButton(), buildSendAgainButton()],
                ),
                buildTextFormField(),
                SizedBox(height: 6),
                createVerifyCodeButton(),
               /** buildTopImage(),*/
                Spacer(flex: 8),
              ],
            ),
          ),
        IconButton(icon: Icon(Icons.arrow_back,color: Colors.blue,),
            onPressed: (){
              goBackAndEditRecipient();
            }),
      ]
    ),
  );

  Widget buildEditRecipientButton() {
    return createRoundedCornerFlatButton("Change my email address",
        fontFamily: "Halvetica",textColor:  Colors.blueAccent, fontWeight: FontWeight.bold,
        onPress:goBackAndEditRecipient,minWidth: 0,shapeColor: Colors.transparent );
  }

  void goBackAndEditRecipient() {
    wipeAllPagesAndGoTo(context,AskForOTPPagePath);
  }

  Widget buildSendAgainButton() {
    return createRoundedCornerFlatButton("I didn’t receive my password",
        fontFamily: "Halvetica",textColor:  Color(0xff4790d5),fontWeight: FontWeight.bold,
        onPress:sendVerificationCodeAgain,minWidth: 0,shapeColor: Colors.transparent );


  }

  sendVerificationCodeAgain() => model.askForOTPWithLastRecipientAgain();

  Text buildPageTitle() {
    return Text(
      "You’re almost there!",
      style: TextStyle(
          fontSize: 15,
          fontFamily: "Halvetica",
          fontWeight: FontWeight.bold,
          color: Colors.blue[800]),
    );
  }

  DeviceFractionSpace buildTopImage() {
    return DeviceFractionSpace(
      child: Image.asset('images/Login-Image.png', fit: BoxFit.contain),
      percentageOfDeviceWidth: 1,
      percentageOfDeviceHeight: 0.20,
    );
  }

  _createHallmarkLogo()
  {
    return Container(

      height: 20,
      child: Image.asset("images/Hallmarklogosmall.png",
        fit: BoxFit.contain,
      ),
    );
  }

  DeviceFractionSpace buildIntroImage() {
    return DeviceFractionSpace(
      child: Image.asset('images/houselogiqsmall.png', fit: BoxFit.contain),
      percentageOfDeviceWidth: 1,
      percentageOfDeviceHeight: 0.20,
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      style: TextStyle(
          fontFamily: "Halvetica",
          fontWeight: FontWeight.normal,
          color: Color(0xff484848),
          fontSize: 13),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 5, right: 5),
        filled: true,
        fillColor: Color(0xfffbfbfb),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffe5e5e5))),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffe5e5e5))),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: codeController,
      validator: (value) {
        if (value.isEmpty) {
          return 'please Enter Phone number';
        }
        return null;
      },
    );
  }

  createVerifyCodeButton() => SizedBox(
        width: double.infinity,
        height: 36,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          onPressed: () => model.verifyOTP(codeController.text),
          child: Text(
            "Continue",
            style: TextStyle(
                color: Colors.white, fontFamily: "PTSansCaption", fontSize: 14),
          ),
          color: Color(0xff4691d5),
        ),
      );
}
