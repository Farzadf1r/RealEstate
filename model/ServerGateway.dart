

import 'dart:io';
import 'package:realestate_app/customWidget/map/GeoMarker.dart';
import 'package:realestate_app/customWidget/pagedListView/PageResult.dart';
import 'package:realestate_app/model/ServerGatewayImplementation.dart';
import 'package:realestate_app/model/entity/CustomerSearchFilter.dart';
import 'package:realestate_app/model/entity/PropertyAdSearchFilter.dart';
import 'package:realestate_app/model/entity/User.dart';

import 'entity/Agent.dart';
import 'entity/Customer.dart';
import 'entity/PropertyAd.dart';
import 'entity/Role.dart';

abstract class ServerGateway{

  static ServerGateway _instance;
  User get signedInUser;
  Role selectedRole;

  static ServerGateway instance()
  {
    if(_instance == null)
      {
        _instance = ServerGatewayImplementation();
      //  _instance = ServerGatewayMock();
      }

    return _instance;
  }

  Future<void> initialize();

  /// throws ConnectionToBackendFailed or OTPRecipientWasWrongFormatted
  Future<void> askForSignupOrSingInOTP(String mobileOrEmailRecipient);

  /// throws ConnectionToBackendFailed or VerificationCodeWasWrong
  Future<User> verifyOTP(String mobileOrEmailRecipient,String verificationCode);


  Future<void> logout();

  Future<bool> isUserSignedIn();

  Future<User> getSignedInUser();
  
  Future<void> modifyUserProfile(String firstName,String lastName);
  Future<String> uploadUserProfilePicture(File pic);

  Future<PageResult<PropertyAd>> fetchAds(int pageIndex,int pageSize,PropertyAdSearchFilter searchFilter);

  Future<Agent> fetchSignedInCustomerRepresentativeAgent();

  Future<void> tagAsFavorite(String adId);
  Future<void> untagAsFavorite(String adId);

  Future<PageResult<Customer>> fetchCustomerList(int pageIndex,int pageSize,CustomerSearchFilter searchFilter);
  Future<PageResult<Agent>> fetchAgentsList(int pageIndex,int pageSize);

  Future<void> inviteCustomer(String mobile,String email,String content);

  Future<File> loadImage(String url , {String defaultAssetFile = ""});
  Future<File> loadProfileImage(String url);

  Future<PropertyAd> fetchAdDetails(String propertyId) ;

  Future<void> assignAgentToCustomer(String agentUserId,String customerUserId);
  Future<void> clearCustomerRepresentativeAgent(String customerUserId);

  Future<void> selectRole(Role role) ;

  /// returns all marker data or will
  /// throw GivenCoordinatesHaveDataBeyondThreshold containing the
  /// count of marker data in server within the given range
  Future<List<GeoMarker>> fetchAdsCoordinatesInThisRange(double bottomLeftLongitude,double bottomLeftLatitude,double topRightLongitude,double topRightLatitude) ;
}

class GivenCoordinatesHaveDataBeyondThreshold implements Exception{
  final int dataCount;

  GivenCoordinatesHaveDataBeyondThreshold(this.dataCount);
}