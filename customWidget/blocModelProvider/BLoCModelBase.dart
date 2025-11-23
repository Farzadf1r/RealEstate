

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/customersList/CustomersPagedContentModel.dart';
import 'package:rxdart/rxdart.dart';

typedef EventListener<T> =  void Function(String,T);

abstract class BLoCModelBase
{
  static const String AllEvents = "*";
  static const String IsLoadingEvent = "isLoading";
  Map<String , List<EventListener>>  _subscriptions = {};
  Map<String , dynamic> _lastValuePushedToStream = {};


  //@protected
  Map<String,StreamController> _streams = {};

  List _activeUsers = [];

  int get usersRequestedThisModelButNotDisposedCount => _activeUsers.length;

  bool _isDisposed = false;
  bool get isDisposed=> _isDisposed;

  BLoCModelBase()
  {
    createStream(IsLoadingEvent,createBehaviourFormIfNotExists:true);
    broadcastToStream(IsLoadingEvent, false);
  }


  void createStream(String name ,{bool createBehaviourFormIfNotExists = false} )
  {
    if(!_streams.containsKey(name)) {
        _streams[name] = createBehaviourFormIfNotExists ? BehaviorSubject() :StreamController.broadcast();
        _getStreamByName(name).listen((event)=>_eventReceived(name, event));
    }
  }

  void _eventReceived(String eventName,dynamic data)
  {
    var subscriptionsListForThisEvent = _listenersFor(eventName);
    var subscriptionsListForAnyEvent = _listenersFor(AllEvents);

    subscriptionsListForThisEvent.forEach((element) {element(eventName,data);});
    subscriptionsListForAnyEvent.forEach((element) {element(eventName,data);});

    eventReceived(eventName, data);
  }
  
  void eventReceived(String eventName,dynamic data) {}

  StreamController<T>  _getStreamController<T>(String name)
  {
    return _streams[name];
  }

  StreamSink<T>  _getSinkByName<T>(String name)
  {
    return _getStreamController(name).sink as StreamSink<T>;
  }

  Stream<T>  _getStreamByName<T>(String name)
  {
    return _getStreamController(name).stream as Stream<T>;
  }

  void broadcastToStream<T>(String streamName,T value)
  {
    _lastValuePushedToStream[streamName] = value;
    _getSinkByName(streamName).add(value);
  }

  getLastPushedValueToStream(String streamName) => _lastValuePushedToStream[streamName];

  List<EventListener<T>> _listenersFor<T>(String eventName)
  {
    var subscriptionsListForThisEvent = _subscriptions[eventName];
    if(subscriptionsListForThisEvent==null)
      _subscriptions[eventName] = [];


    return _subscriptions[eventName];
  }

  bool hasSubscribedBefore<T>(String eventName,EventListener<T> listener)
  {
    var subscriptionsListForThisEvent = _listenersFor(eventName);
    var subscriptionsListForAllEvents = _listenersFor(AllEvents);

    return (subscriptionsListForThisEvent.contains(listener) || subscriptionsListForAllEvents.contains(listener));
  }

  void subscribeOnEvent<T>(String eventName,EventListener<T> listener)
  {
    var subscriptionsListForThisEvent = _listenersFor(eventName);

    if(hasSubscribedBefore(eventName,listener))
      return;

    subscriptionsListForThisEvent.add(listener);
  }

  void unsubscribe(EventListener listener)
  {
    _subscriptions.forEach((key, value) {
      value.remove(listener);
    });
  }



  int activeSubscriptionsCountFor(String streamName) => _subscriptions[streamName] == null? 0 :_subscriptions[streamName].length;

  bool hasActiveSubscriptions(String streamName) => activeSubscriptionsCountFor(streamName) >0 ;

  bool get isLoading=> (_getStreamByName(IsLoadingEvent) as BehaviorSubject).value;


  dispose(requesterObject)
  {
    _activeUsers.remove(requesterObject);

    if(usersRequestedThisModelButNotDisposedCount>0)
      return;

    _isDisposed = true;
    _subscriptions = {};
    _streams.forEach((key, value) {value.close();});
  }

  void announcingThatWeAreBeingProvidedOnceMore(requesterObject, Object argument) {

    if(!_activeUsers.contains(requesterObject))
      _activeUsers.add(requesterObject);
  }
}