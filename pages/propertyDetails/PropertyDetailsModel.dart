import 'dart:io';

import 'package:realestate_app/customWidget/blocModelProvider/BLoCModelBase.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/Agent.dart';
import 'package:realestate_app/model/entity/PropertyAd.dart';
import 'package:realestate_app/model/entity/User.dart';
import 'package:realestate_app/model/exception/ConnectionToBackendFailed.dart';
import 'package:realestate_app/model/exception/UserIsAnonymous.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailsModel extends BLoCModelBase {
  static const String favoriteToggleErrorMessagesEvent = "favoriteToggleErrorMessagesEvent";
  static const String userWasAnonymousErrorMessagesEvent = "userWasAnonymousMessagesEvent";
  static const String fetchErrorMessagesEvent = "fetchErrorMessagesEvent";
  static const String contactErrorMessagesEvent = "contactErrorMessagesEvent";

  PropertyAd _propertyAd;

  PropertyAd get propertyAd => _propertyAd;
  String _propertyAdId;

  bool get propertyIsFetched => propertyAd != null;

  bool get propertyIsNotFetched => !propertyIsFetched;

  bool get hasFailedLoading => propertyIsNotFetched && !isLoading;
  
  Agent _representativeAgent;
  User _user;

  Agent get customerRepresentativeAgent {
    return _representativeAgent;
  }


  Agent get customerRepresentativeAgentOrRemaxAsTheAgentIfNoRepresentativeAssignedYet {

    if(_representativeAgent!=null)
      return _representativeAgent;
    else
      return Agent(1, 1, "-1", "Remax/Hallmark", "", "", "", "", true, false, false, "info@remaxhallmark.com");
  }

  bool get isCustomer => _user!=null?_user.isCustomer:false;
  bool get isAnonymous => _user!=null?_user.isAnonymous:true;
  String get userContactInfo
  {
    return _user.phoneOrEmail;
  }


  PropertyDetailsModel(this._propertyAd) {
    createStream(favoriteToggleErrorMessagesEvent);
    createStream(fetchErrorMessagesEvent);
    createStream(userWasAnonymousErrorMessagesEvent);
    createStream(contactErrorMessagesEvent);
    _propertyAdId = _propertyAd.id;
    _syncCustomerAgentAndAnnounceListingHit(_propertyAdId);
  }

  void _syncCustomerAgentAndAnnounceListingHit(String propertyId) {
    broadcastToStream(BLoCModelBase.IsLoadingEvent, true);

    var result = _loadStuffAndReturnPropertyAd(propertyId);

    result.then((value) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
    }, onError: (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);

      if (e is ConnectionToBackendFailed)
        broadcastToStream(fetchErrorMessagesEvent, "Check Internet Connection");
      else
        broadcastToStream(fetchErrorMessagesEvent, "Something ain't right $e");
    });
  }

  Future<PropertyAd> _loadStuffAndReturnPropertyAd(String propertyId)async{
    _user = await ServerGateway.instance().getSignedInUser();

    if(_user.isCustomer)
      _representativeAgent = await ServerGateway.instance().fetchSignedInCustomerRepresentativeAgent();

    ServerGateway.instance().fetchAdDetails(propertyId);

    return _propertyAd;
  }

  void tryFetchingPropertyDetailsAgain() {
    if (propertyIsFetched) return;

    _syncCustomerAgentAndAnnounceListingHit(_propertyAdId);
  }

  void invertFavoriteStatus() {
    if (isLoading || propertyIsNotFetched) return;

    broadcastToStream(BLoCModelBase.IsLoadingEvent, true);

    var result;
    if (propertyAd.isFavorite)
      result = ServerGateway.instance().untagAsFavorite(propertyAd.id);
    else
      result = ServerGateway.instance().tagAsFavorite(_propertyAdId);

    result.then((value) {
      propertyAd.isFavorite = !propertyAd.isFavorite;
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
    }, onError: (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);

      if (e is ConnectionToBackendFailed)
        broadcastToStream(
            favoriteToggleErrorMessagesEvent, "Check Internet Connection");
      else if (e is UserIsAnonymous)
        broadcastToStream(
            userWasAnonymousErrorMessagesEvent, "user was anonymous");
      else
        broadcastToStream(
            favoriteToggleErrorMessagesEvent, "Something ain't right $e");
    });
  }




  Future<File> loadImage(String url,{String defaultAssetFile = ""}) {
    return ServerGateway.instance().loadImage(url,defaultAssetFile: defaultAssetFile);
  }

  void callAgent() {
    _evaluateWhileLoading(_call(), (value) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
    }, (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);

      broadcastToStream(contactErrorMessagesEvent, "Could not call agent!");
    });
  }

  Future<bool> _call() async {
    var agent = customerRepresentativeAgent;
    return await launch("tel:${agent.mobile}");
  }

  Future<bool> _sendSms(String mobile , {String content = ""}) async {

    var body = "body=$content";
    
    body = Uri.encodeFull(body);
    
    if (Platform.isAndroid) {
      var uri = "sms:$mobile?$body";
      return await launch(uri);
    } else if (Platform.isIOS) {
      var uri = "sms:$mobile&$body";
      return await launch(uri);
    }else
      throw "sending sms is not supported!";
  }


  Future<bool> _sendEmail(String to,{String subject="",String body = "" }) async{

    var bodySubject = "subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}";


    final Uri params = Uri(
      scheme: 'mailto',
      path: to,
      query: bodySubject,
    );

    var url = params.toString();
    if (await canLaunch(url))
      return await launch(url);
    else
      throw 'Could not email agent!';
  }
  
  void sendEmail( String to , {String subject = "",String content=""}) async{
    _evaluateWhileLoading(_sendEmail(to,body: content,subject: subject), (value) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
    }, (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
      broadcastToStream(contactErrorMessagesEvent, "Could not mail agent!");
    });
  }

  void mailAgentAboutProperty(Agent agent) async{

    if(!agent.hasEmail)
    {
      broadcastToStream(contactErrorMessagesEvent, "Agent does not have email address for sending email!");
      return;
    }

    String content = "Please Call me back\n"+"Address:${propertyAd.addressInDetail(includeTitle: false,separator: "  ")}";
    if(_user.hasEmail)
      content+="\nEmail:${_user.email}";

    if(_user.hasMobile)
      content+="\nMobile:${_user.mobile}";

    _evaluateWhileLoading(_sendEmail(agent.email,
        subject: "Interested in ${propertyAd.id}",
        body: content,
       ), (value) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
    }, (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);

      broadcastToStream(contactErrorMessagesEvent, "Could not mail agent!");
    });
  }

  void smsAgentAboutProperty() {

    if(!customerRepresentativeAgent.hasMobile)
    {
      broadcastToStream(contactErrorMessagesEvent, "Agent does not have mobile for sending sms!");
      return;
    }

    String content = "Interested in ${propertyAd.id}, Please Call me back\n"+"Address:${propertyAd.addressInDetail(includeTitle: false,separator: "  ")}";
    if(_user.hasEmail)
      content+="\nEmail:${_user.email}";

    if(_user.hasMobile)
      content+="\nMobile:${_user.mobile}";

    _evaluateWhileLoading(_sendSms(customerRepresentativeAgent.mobile,content: content), (value) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
    }, (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);

      broadcastToStream(contactErrorMessagesEvent, "Could not sms agent!");
    });
  }

  void _evaluateWhileLoading(Future futureToEvaluate,
      void Function(dynamic) onSuccess, void Function(dynamic) onError) {
    if (isLoading || propertyIsNotFetched) return;

    broadcastToStream(BLoCModelBase.IsLoadingEvent, true);

    futureToEvaluate.then((value) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
      onSuccess(value);
    }, onError: (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
      onError(e);
    });
  }


}
