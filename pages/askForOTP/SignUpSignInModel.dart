
import 'package:realestate_app/customWidget/blocModelProvider/BLoCModelBase.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/Role.dart';
import 'package:realestate_app/model/entity/User.dart';
import 'package:realestate_app/model/exception/ConnectionToBackendFailed.dart';
import 'package:realestate_app/model/exception/OTPRecipientWasWrongFormatted.dart';
import 'package:realestate_app/model/exception/VerificationCodeWasWrong.dart';

class SignUpSignInModel extends BLoCModelBase
{
  static const String  otpWasSentSuccessfullySignalEvent = "otpWasSentSuccessfullySignal";
  static const String  otpSentFailureMessageEvent = "otpSentFailureMessage";
  static const String  verificationSucceededSignalEvent = "verificationSucceededSignal";
  static const String  verificationFailureMessageEvent = "verificationFailureMessage";
  static const String  roleWasSelectedEvent = "roleWasSelectedEvent";

  String _lastRecipient="";
  String get lastRecipient=> _lastRecipient;
  User get userWhoVerifiedOTP =>ServerGateway.instance().signedInUser;

  SignUpSignInModel()
  {
    createStream(otpWasSentSuccessfullySignalEvent);
    createStream(otpSentFailureMessageEvent);
    createStream(verificationSucceededSignalEvent);
    createStream(verificationFailureMessageEvent);
    createStream(roleWasSelectedEvent);
  }
  

  void askForOTP(String recipient)
  {
    if(isLoading)
      return;


    this._lastRecipient = recipient;

    broadcastToStream(BLoCModelBase.IsLoadingEvent, true);

    var result = ServerGateway.instance().askForSignupOrSingInOTP(recipient);

    result.then((value) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
      broadcastToStream(otpWasSentSuccessfullySignalEvent,"");
    }, onError: (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
      
      if(e is ConnectionToBackendFailed)
        broadcastToStream(otpSentFailureMessageEvent,"Check Internet Connection and entered Recipient!");
      else if(e is OTPRecipientWasWrongFormatted)
        broadcastToStream(otpSentFailureMessageEvent,"the entered recipient was not formatted correctly : $recipient");
      else
        broadcastToStream(otpSentFailureMessageEvent,"Something ain't right $e");
    });
  }

  void verifyOTP(String verificationCode)
  {
    if(isLoading)
      return;

    broadcastToStream(BLoCModelBase.IsLoadingEvent, true);

    var result = ServerGateway.instance().verifyOTP(_lastRecipient,verificationCode);

    result.then((value) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
      broadcastToStream(verificationSucceededSignalEvent,"");
    }, onError: (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);

      if(e is ConnectionToBackendFailed)
        broadcastToStream(verificationFailureMessageEvent,"Check Internet Connection, Could not send verification");
      else if(e is VerificationCodeWasWrong)
        broadcastToStream(verificationFailureMessageEvent,"verification code was wrong");
      else
        broadcastToStream(verificationFailureMessageEvent,"Something ain't right $e");
    });

  }


  askForOTPWithLastRecipientAgain()
  {
    if(isLoading)
      return;

    if(lastRecipient.isNotEmpty)
        askForOTP(lastRecipient);
  }

  void chooseRole(Role role) {
    ServerGateway.instance().selectRole(role).then((value) {
      broadcastToStream(roleWasSelectedEvent,"");
    });

  }
  
  void chooseFirstRoleWhateverItIs() {
    chooseRole(userWhoVerifiedOTP.roles[0]);
  }
}