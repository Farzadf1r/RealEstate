


import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/general/Toast.dart';
import 'package:realestate_app/customWidget/Util.dart';
import 'package:realestate_app/customWidget/blocModelProvider/ModelProvidedState.dart';
import 'package:realestate_app/pages/Router.dart';

import 'ModifyNameModel.dart';

class ModifyNameDialog extends StatefulWidget {
  final void Function() nameModified;
  final String description;

  ModifyNameDialog({this.nameModified,this.description=""});
  createState() => ModifyNameDialogState();
}

class ModifyNameDialogState extends ModelProvidedState<ModifyNameDialog, ModifyNameModel> {
  final firstController = TextEditingController();
  final lastController = TextEditingController();

  void eventReceived(String eventName,data) {
    switch(eventName)
    {
      case ModifyNameModel.NameModifiedEvent:{
        goToPrevPage(context);
        if(widget.nameModified!=null)
          widget.nameModified();
        break;
      }
      case ModifyNameModel.NameModificationFailedEvent:
        toast(data, context);
    }
  }


  buildContent(context) => Card(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if(widget.description.isNotEmpty)
              _createDescription(),

            if(widget.description.isNotEmpty)
              SizedBox(height: 30),

            _createTitle("First Name"),
            SizedBox(height: 10),
            _createTextField(firstController, 1),
            SizedBox(height: 20),
            _createTitle("Last Name"),
            SizedBox(height: 10),
            _createTextField(lastController, 1),
            SizedBox(height: 20),
            _createActionButton()
          ],
        ),
      ),
    ),
  );

  _createActionButton() => SizedBox(
    width: double.infinity,
    height: 36,
    child: RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onPressed: () async {

        if(firstController.text.length<3 || lastController.text.length<3)
          toast("First and Last Name must be more than 3 characters", context);
        else
          model.modifyName(firstController.text, lastController.text);
      },
      child: Text(
        "Continue",
        style: TextStyle(
            color: Colors.white, fontFamily: "PTSansCaption", fontSize: 13),
      ),
      color: Color(0xff4691d5),
    ),
  );

  _createTitle(String title) =>
      halveticaBoldText(title, color: Color(0xff5e5e5e), fontSize: 16);

  _createDescription() =>
      halveticaBoldText(widget.description, color: Color(0xff5e5e5e), fontSize: 12);

  _createTextField(TextEditingController controller, int lines) {
    return TextFormField(
      maxLines: lines,
      style: TextStyle(
          height: 1.5,
          fontFamily: "Halvetica",
          fontWeight: FontWeight.normal,
          color: Color(0xff484848),
          fontSize: 13),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 5, right: 5),
        filled: true,
        fillColor: Color(0xfffbfbfb),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
      ),
      keyboardType: TextInputType.text,
      controller: controller,
    );
  }
}

