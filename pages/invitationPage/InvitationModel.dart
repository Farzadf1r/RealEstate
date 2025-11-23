

import 'package:realestate_app/customWidget/blocModelProvider/BLoCModelBase.dart';
import 'package:realestate_app/model/ServerGateway.dart';

class InvitationModel extends BLoCModelBase
{
  static const CustomerInvitedEvent = "CustomerInvitedEvent";
  static const CustomerInvitationFailedEvent = "CustomerInvitationFailedEvent";


  InvitationModel()
  {
    createStream(CustomerInvitedEvent);
    createStream(CustomerInvitationFailedEvent);
  }

  void invite(String mobile,String email,String message)
  {
    if(isLoading)
      return;

    broadcastToStream(BLoCModelBase.IsLoadingEvent, true);

    final result = ServerGateway.instance().inviteCustomer(mobile,email,message);

    result.then((value) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
      broadcastToStream(CustomerInvitedEvent,"");
    }, onError: (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);

        broadcastToStream(CustomerInvitationFailedEvent,"Something ain't right $e");
    });
  }
}