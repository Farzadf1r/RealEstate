

import 'package:realestate_app/customWidget/blocModelProvider/BLoCModelBase.dart';
import 'package:realestate_app/model/ServerGateway.dart';

class ModifyNameModel extends BLoCModelBase
{
  static const NameModifiedEvent = "NameModifiedEvent";
  static const NameModificationFailedEvent = "NameModificationFailedEvent";


  ModifyNameModel()
  {
    createStream(NameModifiedEvent);
    createStream(NameModificationFailedEvent);
  }

  void modifyName(String first,String last)
  {
    if(isLoading)
      return;

    broadcastToStream(BLoCModelBase.IsLoadingEvent, true);

    final result = ServerGateway.instance().modifyUserProfile(first,last);

    result.then((value) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
      broadcastToStream(NameModifiedEvent,"");
    }, onError: (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);

        broadcastToStream(NameModificationFailedEvent,"Something is not right $e");
    });
  }
}