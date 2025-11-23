

import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:realestate_app/customWidget/map/GeoMarker.dart';
import 'package:realestate_app/customWidget/pagedListView/PageResult.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/Agent.dart';
import 'package:realestate_app/model/entity/CustomerSearchFilter.dart';
import 'package:realestate_app/model/entity/PropertyAd.dart';
import 'package:realestate_app/model/entity/PropertyAdSearchFilter.dart';
import 'package:realestate_app/model/entity/User.dart';
import 'package:realestate_app/model/exception/VerificationCodeWasWrong.dart';

import 'entity/Customer.dart';
import 'entity/Role.dart';

class ServerGatewayMock extends ServerGateway
{
  String correctVerificationCode = "12345";
  int delayMillis = 500;

  List<PropertyAd> _properties;
  List<Agent> _agents;
  List<Customer> _customers;

  User _signedInUser;
  User _currentSigningInOrSigningUpUser;


  Future<void> initialize(){}


  ServerGatewayMock()
  {
    _customers = [];
    _properties = [];

    _agents = [
      Agent(0,0,"agent1","John","Johnson!","0912123","Address-Agent-1","prof1.png",true,false,false,""),
      Agent(0,0,"agent2","Bill","Billson!","0912456","Address-Agent-2","prof2.png",true,false,false,""),
      Agent(0,0,"agent3","Ted","Tedson!","0912789","Address-Agent-3","prof3.png",true,false,false,""),
    ];
  }


  Future<List<GeoMarker>> fetchAdsCoordinatesInThisRange(double bottomLeftLongitude,double bottomLeftLatitude,double topRightLongitude,double topRightLatitude){}

  Future _loadAllPropertiesFromRepliersFile() async{

    if(_properties.isNotEmpty)
      return;

    final data = await rootBundle.load("images/repliers/HouseData.json");
    final buffer = data.buffer;
    var list = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var jsonString = utf8.decode(list);
    var json = jsonDecode(jsonString);

    json.forEach((adJson)=>{



        _properties.add(
              PropertyAd()
        )
    });


  }


  // List<String> _selectFromAgentIdRandomly()
  // {
  //   List<String> availableAgentIds = _agents.map((e) => e.userId).toList();
  //   int howMany = Random().nextInt(availableAgentIds.length);
  //
  //   if(howMany == 0)
  //     return [];
  //   else
  //     return availableAgentIds.sublist(0,howMany);
  // }


  @override
  Future<PageResult<PropertyAd>> fetchAds(int pageIndex,int pageSize,PropertyAdSearchFilter searchFilter) {

    return _doAfterDelay(() async{

      await _loadAllPropertiesFromRepliersFile();

      var result = _fetchAllPropertiesSatisfying(searchFilter);

      return _wrapTheResultConsideringPagingInfo(pageIndex,pageSize,searchFilter, result);

    });
  }


  List<PropertyAd> _fetchAllPropertiesSatisfying(PropertyAdSearchFilter searchFilter)
  {
    var result = _properties.map<PropertyAd>((p)=>p.copy).toList();/*.where((prop) =>
    (prop.bathroomCount  >= searchFilter.bathRoomsCountAtLeast) &&
        (prop.bedroomCount  >= searchFilter.bedroomsCount) &&
        (prop.parkingCount  >= searchFilter.parkingCountAtLeast) &&
        (prop.parkingCount  >= searchFilter.parkingCountAtLeast) &&
        (prop.price  >= searchFilter.priceStartingFrom && prop.price<=searchFilter.priceUpTo) &&
        (prop.sizeInSquareFeetMin  >= searchFilter.propertySizeInSquareFeetAtLeast)
    ).toList();*/

    if(searchFilter != null && searchFilter.onlyFavoriteOnes)
      result = result.where((element) => element.isFavorite).toList();

    return result;
  }



  PageResult<PropertyAd> _wrapTheResultConsideringPagingInfo(int pageIndex,int pageSize,PropertyAdSearchFilter searchFilter, List<PropertyAd> result) {
     int startingIndex = pageIndex*pageSize;
    int endingIndex = min(startingIndex + pageSize,result.length);

    int totalItemsCount = result.length ;
    result = result.sublist(startingIndex,endingIndex).toList();

    return PageResult(pageSize, pageIndex,totalItemsCount, result);
  }




  @override
  Future<Agent> fetchAgentProfile(String agentId) {
    return _doAfterDelay(() {
      return _findAgentByAgentId(agentId);
    });
  }

  @override
  Future<User> getSignedInUser() {
    return _doAfterDelay(() async{

      if(await _doesFileExist("loggedInUser"))
        return Customer(null,"","", "", await _getContentOfFile("loggedInUser"), "",  "", false, true, false,"");

      return null;
    });
  }

  @override
  Future<bool> isUserSignedIn() {
    return _doAfterDelay(() async{
      return await _doesFileExist("loggedInUser");
    });
  }

  // User _findUser(String mobile){
  //   if(_isAmongCustomers(mobile))
  //     return _findCustomerByMobile(mobile);
  //   else if(_isAmongAgents(mobile))
  //     return _findAgentByAgentId(mobile);
  //   else
  //     throw NoSuchUserWithGivenMobile();
  // }


  // Agent _findAgentByMobile(String mobile) => _agents.firstWhere((element) => element.mobile == mobile);
  Agent _findAgentByAgentId(String agentId) => _agents.firstWhere((element) => element.userId == agentId);

  // Customer _findCustomerByMobile(String mobile) => _customers.firstWhere((element) => element.mobile == mobile);

  bool _isAmongAgents(String mobile) => _agents.any((element) => element.mobile == mobile);
  bool _isAmongCustomers(String mobile) => _customers.any((element) => element.mobile == mobile);

  @override
  Future<void> signupAsAgent(String agentId, String mobile) {
    return _doAfterDelay(() {
      _currentSigningInOrSigningUpUser = Agent(0,0,agentId,"", "", mobile,"", "", true, false, false,"");
    });
  }

  @override
  Future<void> askForSignupOrSingInOTP(String mobileOrEmailRecipient) {
    return _doAfterDelay(() {
      _currentSigningInOrSigningUpUser = Customer(null,"","", "", mobileOrEmailRecipient,"", "", false, true, false,"");
    });
  }

  @override
  Future<void> tagAsFavorite(String adId) {
    return _doAfterDelay(() {
      _properties.firstWhere((element) => element.id == adId).isFavorite = true;
    });

  }

  @override
  Future<void> untagAsFavorite(String adId) {
    return _doAfterDelay(() {
      _properties.firstWhere((element) => element.id == adId).isFavorite = false;
    });
  }

  @override
  Future<User> verifyOTP(String recipient,String verificationCode) {
    return _doAfterDelay(() {

      if(verificationCode == correctVerificationCode)
      {
          _signedInUser = _currentSigningInOrSigningUpUser;
          _currentSigningInOrSigningUpUser = null;

          if(_signedInUser is Customer) {
            if(!_isAmongCustomers(_signedInUser.mobile))
              _customers.add(_signedInUser);
          }


          if(_signedInUser is Agent) {
            if(!_isAmongAgents(_signedInUser.mobile))
              _agents.add(_signedInUser);
          }

          _saveToFile("loggedInUser", _signedInUser.mobile);

          return _signedInUser;
      }

      throw new VerificationCodeWasWrong();
    });
  }


  Future<PageResult<Agent>> fetchAgentsList(int pageIndex,int pageSize)
  {
    throw UnimplementedError();
  }

  @override
  Future<PageResult<Agent>> assignPropertyToAgent(String propertyId, String agentId) {
    throw UnimplementedError();
  }



  Future<T> _doAfterDelay <T> (FutureOr<T> Function() task)
  {
    return Future.delayed(Duration(milliseconds: delayMillis),(){
      return task();
    });
  }

  @override
  Future<File> loadImage(String url, {String defaultAssetFile = ""}) async{

    return Future.delayed(Duration(milliseconds: delayMillis),()async{
      final data = await rootBundle.load("images/repliers/$url");
      final buffer = data.buffer;
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      var filePath = tempPath + url;
      var file = new File(filePath);

      if(await file.exists())
      return file;

      return file.writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    });


  }

  @override
  Future<void> modifyUserProfile(String firstName, String lastName) {

    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    return _doAfterDelay(() {
      _signedInUser = null;
      _deleteTempFile("loggedInUser");
    });
  }

  Future _saveToFile(String fileName,String content) async {

    File file = await getTempFile(fileName);
    await file.create();

    await file.writeAsString(content);
  }

  Future<String> _getContentOfFile(String fileName) async {
    File file = await getTempFile(fileName);
    return await file.readAsString();
  }

  Future _deleteTempFile(String fileName) async {
    File file = await getTempFile(fileName);
    await file.delete();
  }

  Future<File> getTempFile(String fileName) async {
    var directory = await getApplicationSupportDirectory();
    var file = File(directory.path+"/"+fileName);
    return file;
  }


  Future<bool> _doesFileExist(String fileName) async{
    File file = await getTempFile(fileName);
    return file.exists();
  }


  Future<Agent> fetchSignedInCustomerRepresentativeAgent() {
    return _doAfterDelay(() {
      return _agents[1];
    });
  }


  Future<PropertyAd> fetchAdDetails(String propertyId) {
    return _doAfterDelay(() {
      return _properties.firstWhere((element) => element.id == propertyId);
    });
  }

  @override
  Future<PageResult<Customer>> fetchCustomerList(int pageIndex,int pageSize,CustomerSearchFilter searchFilter) {
    // TODO: implement fetchCustomerList
    throw UnimplementedError();
  }

  @override
  Future<void> inviteCustomer(String mobile,String email, String content) {
    // TODO: implement inviteCustomer
    throw UnimplementedError();
  }

  @override
  Future<void> assignAgentToCustomer(String agentUserId, String customerUserId) {
    // TODO: implement assignAgentToCustomer
    throw UnimplementedError();
  }

  @override
  Future<void> clearCustomerRepresentativeAgent(String customerUserId) {
    // TODO: implement clearCustomerRepresentativeAgent
    throw UnimplementedError();
  }

  @override
  // TODO: implement signedInUser
  User get signedInUser => throw UnimplementedError();

  @override
  Future<String> uploadUserProfilePicture(File pic) {
    // TODO: implement uploadUserProfilePicture
    throw UnimplementedError();
  }

  Future<void> selectRole(Role role)
  {
    // TODO: implement uploadUserProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<File> loadProfileImage(String url) {
    // TODO: implement loadProfileImage
    throw UnimplementedError();
  }



}