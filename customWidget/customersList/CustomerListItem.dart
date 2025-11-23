import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/general/FutureWidget.dart';
import 'package:realestate_app/customWidget/general/PercentageWidget.dart';
import 'package:realestate_app/customWidget/general/Toast.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';
import 'package:realestate_app/customWidget/agentsList/AgentsList.dart';
import 'package:realestate_app/customWidget/blocModelProvider/ModelProvidedState.dart';
import 'package:realestate_app/customWidget/customersList/PreloadedCustomerModel.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/Agent.dart';
import 'package:realestate_app/model/entity/Customer.dart';
import '../Util.dart';

class CustomerListItem extends StatefulWidget
{
  final Customer customer;
  CustomerListItem(this.customer);
  createState()=>CustomerListItemState();
}

class CustomerListItemState extends ModelProvidedState<CustomerListItem,PreloadedCustomerModel> {

  String get modelId => widget.customer.userId;
  Object get modelArgument => widget.customer;


  void eventReceived(String eventName, data) {
    switch (eventName) {
      case PreloadedCustomerModel.RepresentativeAgentSettingErrorEvent:
      case PreloadedCustomerModel.RepresentativeAgentClearingErrorEvent:
        toast(data, context);
        break;
      case PreloadedCustomerModel.RepresentativeAgentWasClearedEvent:
        toast("Customer's Representative Agent is Removed!", context);
        break;
      case PreloadedCustomerModel.RepresentativeAgentWasSetEvent:
        toast("Representative Agent of Customer(${model.customer.fullNameIfNotNullOrMobileOrEmail}) is Changed to ${model.customer.representativeAgent.fullNameIfNotNullOrMobileOrEmail}", context);
        break;
    }
  }

  buildContent(context) => !model.signedInUserIsAdmin
      ? _createItemContent(context)
      : FlatButton(
          onPressed: () => _whenItemIsPressed(context),
          child: _createItemContent(context));

  _whenItemIsPressed(context) {
    showDialog(
        context: context,
        builder:(context)=> Center(
          child: Container(
            width: percentageOfDeviceWidth(context, 0.8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _createDialogContentBasedOnCustomerStatus(context),
              ),
            ),
          ),
        ));
  }

  Column _createDialogContentBasedOnCustomerStatus(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (model.customer.hasRepresentativeAgent)
          halveticaText(
              "Do You Want to Remove Customer's Representative Agent? Later You Can Assign Other Agent by tapping again")
        else
          halveticaText(
              "Do You Want to Assign Representative Agent to Customer?"),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _createYesButton(context),
            _createNoButton(context)
          ],
        )
      ],
    );
  }

  _createYesButton(context) {
    return createRoundedCornerRaisedButton("Yes",
        minWidth: percentageOfDeviceWidth(context, 0.35), onPress: () async {

      goToPrevPage();

      if (model.customer.hasRepresentativeAgent) model.clearRepresentative();
      else _showCustomerSelectDialog();
    });
  }

  _showCustomerSelectDialog()
  {
    showDialog(
        context: context,
        builder:(context)=> Center(
          child: Container(
            width: percentageOfDeviceWidth(context, 0.9),
            height: percentageOfDeviceHeight(context, 0.9),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AgentsList(agentSelected: _agentWasSelected,),
              ),
            ),
          ),
        )
    );
  }
  
  _agentWasSelected(Agent agent)
  {
    goToPrevPage();
    model.setCustomerRepresentative(agent);
  }

  _createNoButton(context) {
    return createRoundedCornerRaisedButton("No",
        minWidth: percentageOfDeviceWidth(context, 0.35),
        onPress: goToPrevPage);
  }

  goToPrevPage()=>Navigator.pop(context);

  Container _createItemContent(BuildContext context) {
    return Container(
      height: percentageOfDeviceHeight(context, 0.15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 5),
          createProfilePic(),
          SizedBox(width: 15),
          createAgentName(),
        ],
      ),
    );
  }

  createProfilePic() {
    return FutureWidget(
      initialLoadingBoxWidth: 10,
      initialLoadingBoxHeight: 10,
      future: ServerGateway.instance().loadImage(model.customer.photoUrl),
      errorBuilder: (context, exception) => PercentageWidget(
        widthRatio: "0.5ph",
        heightRatio: "0.5ph",
        child: ClipOval(child: Placeholder()),
      ),
      builder: (context, profilePicFile) => PercentageWidget(
        widthRatio: "0.65ph",
        heightRatio: "0.65ph",
        child: ClipOval(
          child: Image.file(
            profilePicFile,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  createAgentName() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.customer.fullNameIfNotNullOrMobileOrEmail,
            style: TextStyle(
                color: Color(0xff000000),
                fontSize: 14,
                fontFamily: "Halvetica",
                fontWeight: FontWeight.w100),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            _getRepresentativeAgentName(),
            style: TextStyle(
                color: Color(0xff868686),
                fontSize: 13,
                fontFamily: "Halvetica",
                fontWeight: FontWeight.w100),
          )
        ],
      );

  _getRepresentativeAgentName() => model.customer.representativeAgent == null
      ? "No Representative Agent Assigned"
      : "Representative Agent : ${model.customer.representativeAgent.fullNameIfNotNullOrMobileOrEmail}";
}
