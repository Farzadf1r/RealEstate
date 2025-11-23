


import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';
import 'package:realestate_app/pages/animation/animatedLoadScreen.dart';
import 'BLoCModelBase.dart';
import 'ModelProvider.dart';




abstract class ModelProvidedState<W extends StatefulWidget,M extends BLoCModelBase>  extends State<W>
{


  M get model=> ModelProvider.instance.provideModelFor<M>(modelId,requesterObject: this,argument: modelArgument);
  dynamic get modelArgument=> null;

  String get modelId => runtimeType.toString();
  bool disposeModelWhenStateDisposed = true;
  bool showLoadingAnimationPreventingTouchWhileLoading = true;
  
  ModelProvidedState() {}

  void _eventReceived(String eventName,data)
  {
    if(eventName == BLoCModelBase.IsLoadingEvent)
      setState(() {});

    eventReceived(eventName,data);
  }


  void eventReceived(String eventName,data) {}



  dispose() {
    _unsubscribeFromModel();

    if(disposeModelWhenStateDisposed)
      model.dispose(this);

    ModelProvider.instance.announcingModelRequesterDisposal(modelId,this);

    super.dispose();
  }

  
  void _subscribeToAllEvents() {
    if(!model.hasSubscribedBefore(BLoCModelBase.AllEvents,_eventReceived))
    {
      model.subscribeOnEvent(BLoCModelBase.AllEvents,_eventReceived);
      weHaveBoundToModel();
    }
  }

  void weHaveBoundToModel() {}
  void weHaveUnboundFromModel() {}
  
  _unsubscribeFromModel() {
    model.unsubscribe(_eventReceived);
    weHaveUnboundFromModel();
  }


  ///dont override this function
  ///use buildContent(context) instead
  ///you can provide custom loading widget
  ///if you want to by overriding buildLoadingContent(context)
  build(BuildContext context) {

    _subscribeToAllEvents();

    return wrapItInAnimatedLoadingWidgetOnTopWhichInterceptsTouch(context,
        buildContent(context),showLoadingAnimationPreventingTouchWhileLoading && model.isLoading );
  }






  Widget buildContent(BuildContext context);


}
