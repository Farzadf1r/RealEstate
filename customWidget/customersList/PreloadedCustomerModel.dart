import 'dart:io';

import 'package:realestate_app/customWidget/blocModelProvider/BLoCModelBase.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/Agent.dart';
import 'package:realestate_app/model/entity/Customer.dart';
import 'package:realestate_app/model/entity/PropertyAd.dart';
import 'package:realestate_app/model/exception/ConnectionToBackendFailed.dart';

class PreloadedCustomerModel extends BLoCModelBase {

  static const RepresentativeAgentWasClearedEvent = "RepresentativeAgentWasClearedEvent";
  static const RepresentativeAgentWasSetEvent = "RepresentativeAgentWasSetEvent";
  static const RepresentativeAgentClearingErrorEvent = "RepresentativeAgentClearingErrorEvent";
  static const RepresentativeAgentSettingErrorEvent = "RepresentativeAgentSettingErrorEvent";

  Customer _customer;

  Customer get customer => _customer;

  bool get signedInUserIsAdmin => ServerGateway.instance().signedInUser.isAdmin;

  PreloadedCustomerModel(Customer customer) {
    createStream(RepresentativeAgentWasClearedEvent);
    createStream(RepresentativeAgentClearingErrorEvent);
    createStream(RepresentativeAgentSettingErrorEvent);
    createStream(RepresentativeAgentWasSetEvent);
    _customer = customer;
  }


  void clearRepresentative() {

    if(isLoading || !customer.hasRepresentativeAgent)
      return;

    broadcastToStream(BLoCModelBase.IsLoadingEvent, true);

    var result;

    result =  ServerGateway.instance().clearCustomerRepresentativeAgent(customer.userId);

    result.then((value) {
      customer.representativeAgent = null;
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
      broadcastToStream(RepresentativeAgentWasClearedEvent, false);
    }, onError: (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);

      if (e is ConnectionToBackendFailed)
        broadcastToStream(RepresentativeAgentClearingErrorEvent, "Check Internet Connection");
      else
        broadcastToStream(RepresentativeAgentClearingErrorEvent, "Something ain't right $e");
    });
  }

  void setCustomerRepresentative(Agent agent) {
    if(isLoading || customer.hasRepresentativeAgent)
      return;

    broadcastToStream(BLoCModelBase.IsLoadingEvent, true);

    var result;

    result =  ServerGateway.instance().assignAgentToCustomer(agent.userId,customer.userId);

    result.then((value) {
      customer.representativeAgent = agent;
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
      broadcastToStream(RepresentativeAgentWasSetEvent, false);
    }, onError: (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);

      if (e is ConnectionToBackendFailed)
        broadcastToStream(RepresentativeAgentSettingErrorEvent, "Check Internet Connection");
      else
        broadcastToStream(RepresentativeAgentSettingErrorEvent, "Something ain't right $e");
    });
  }

  updateBasedOn(Customer changedModel) {
    _customer.representativeAgent = changedModel.representativeAgent;
  }
}
