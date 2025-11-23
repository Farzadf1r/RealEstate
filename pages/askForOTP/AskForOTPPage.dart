
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realestate_app/customWidget/general/DeviceFractionSpace.dart';
import 'package:realestate_app/customWidget/general/Toast.dart';
import 'package:realestate_app/customWidget/Util.dart';
import 'package:realestate_app/customWidget/blocModelProvider/ModelProvidedState.dart';
import 'package:realestate_app/pages/Router.dart';

import 'SignUpSignInModel.dart';

class AskForOTPPage extends StatefulWidget {

  void Function() overrideBackButtonCallback;

  AskForOTPPage({this.overrideBackButtonCallback});

  _AskForOTPPageState createState() => _AskForOTPPageState();
}

class _AskForOTPPageState extends ModelProvidedState<AskForOTPPage,SignUpSignInModel> {
  final phoneController = TextEditingController();
  String get modelId => "SignUpSignInModel";

  initState() {
    super.initState();
    disposeModelWhenStateDisposed = false;
  }

  void eventReceived(String eventName,data)
  {
    switch(eventName)
    {
      case SignUpSignInModel.otpWasSentSuccessfullySignalEvent:
        _goToVerificationPage();
        break;
      case SignUpSignInModel.otpSentFailureMessageEvent:
        toast(data, context);
        break;
    }
  }


  _goToVerificationPage() {
    wipeAllPagesAndGoTo(context, VerificationPagePath);
  }


  buildContent(BuildContext context) => Stack(
    children: [
      Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(flex: 2),
                buildIntroImage(),
                /**_createHallmarkLogo(),*/
                SizedBox(height: 20),
                buildPageTitle(),
                SizedBox(height: 8),
                Hint(),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  /**child: buildLabel(),*/
                ),
                SizedBox(
                  height: 10,
                ),
                buildTextFormField(),
                SizedBox(height: 20),
                createLoginButton(),
                SizedBox(height: 5,),
                /**buildTopImage(),*/
                Spacer(flex: 8),
              ],
            ),
          ),
      IconButton(icon: Icon(Icons.arrow_back,color: Colors.blue,), onPressed: (){

        if(widget.overrideBackButtonCallback!=null)
          widget.overrideBackButtonCallback();
        else
          Navigator.pop(context);
      }),
    ],
  );



  Text buildPageTitle() {
    return Text(
      "Start Your Home Search!",
      style: TextStyle(
          fontSize: 15,
          fontFamily: "Halvetica",
          fontWeight: FontWeight.bold,
          color: Colors.blue[800]),
    );
  }

  Text Hint() {
    return Text(
      "Please enter your email address",
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: "Halvetica",
          color: Colors.black),
    );
  }

  DeviceFractionSpace buildTopImage() {
    return DeviceFractionSpace(
      child: Image.asset('images/Login-Image.png', fit: BoxFit.contain),
      percentageOfDeviceWidth: 1,
      percentageOfDeviceHeight: 0.20,
    );
  }

  DeviceFractionSpace buildIntroImage() {
    return DeviceFractionSpace(
      child: Image.asset('images/houselogiqsmall.png', fit: BoxFit.contain),
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

  TextFormField buildTextFormField() {
    return TextFormField(
      style: TextStyle(
          fontFamily: "Halvetica",
          fontWeight: FontWeight.normal,
          color: Color(0xff484848),
          fontSize: 14),
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
      controller: phoneController,
      validator: (value) {
        if (value.isEmpty) {
          return 'please Enter Phone number';
        }
        return null;
      },
    );
  }

  createLoginButton() => createRoundedCornerRaisedButton("Get My Password",fontSize: 14,
      onPress: () {
    if(phoneController.text.length>4 && phoneController.text.contains("@"))
        model.askForOTP(phoneController.text);
    else
      toast("please enter valid email", context);
  });


}
