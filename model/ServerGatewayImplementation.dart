import 'dart:convert';
import 'dart:io';

import 'package:realestate_app/customWidget/general/FileManager.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:mutex/mutex.dart';
import 'package:realestate_app/customWidget/map/GeoMarker.dart';
import 'package:realestate_app/customWidget/map/GeoPoint.dart';
import 'package:realestate_app/customWidget/pagedListView/PageResult.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/AdClass.dart';
import 'package:realestate_app/model/entity/AdType.dart';
import 'package:realestate_app/model/entity/Agent.dart';
import 'package:realestate_app/model/entity/AirConditioning.dart';
import 'package:realestate_app/model/entity/BasementType.dart';
import 'package:realestate_app/model/entity/Customer.dart';
import 'package:realestate_app/model/entity/CustomerSearchFilter.dart';
import 'package:realestate_app/model/entity/ExteriorConstruction.dart';
import 'package:realestate_app/model/entity/GarageType.dart';
import 'package:realestate_app/model/entity/HeatSource.dart';
import 'package:realestate_app/model/entity/HeatType.dart';
import 'package:realestate_app/model/entity/ParkingType.dart';
import 'package:realestate_app/model/entity/Pool.dart';
import 'package:realestate_app/model/entity/PropertyAd.dart';
import 'package:realestate_app/model/entity/PropertyAdSearchFilter.dart';
import 'package:realestate_app/model/entity/PropertyStyle.dart';
import 'package:realestate_app/model/entity/PropertyType.dart';
import 'package:realestate_app/model/entity/Status.dart';
import 'package:realestate_app/model/entity/User.dart';
import 'package:realestate_app/model/exception/UnexpectedResponseCode.dart';

import 'entity/Admin.dart';
import 'entity/Role.dart';
import 'exception/UserIsAnonymous.dart';
import 'exception/VerificationCodeWasWrong.dart';
import 'dart:developer' as developer;

class ServerGatewayImplementation extends ServerGateway {
  //String _baseUrl = "http://192.168.1.10:11737";
  // String _baseUrl = "https://houselogiq.com";
  String _baseUrl = "https://houselogiq.com:8081";
  String _imageUrl = "https://cdn.repliers.io";

  User _anonymousUser = User(
      "-1", "Anonymous", "User", "", "", "", false, false, false, "",
      isAnonymous: true);

  User _signedInUser;

  Role _selectedRole;

  User get signedInUser => _signedInUser;

  Role get selectedRole => _selectedRole;

  Future<String> get _tokenFilePath async {
    final file =
        await FileManager.instance.getFileInsideSupportDir("user-token");
    return file.path;
  }

  Future<String> get _selectedRoleFilePath async {
    return (await FileManager.instance
            .getFileInsideSupportDir("user-selected-role"))
        .path;
  }

  Future<String> get _signedInUserJsonFilePath async {
    final file =
        await FileManager.instance.getFileInsideSupportDir("signed-in-user");
    return file.path;
  }

  Future<Role> get _selectedRoleSavedInFile async {
    final content = await FileManager.instance
        .getContentOfFile(await _selectedRoleFilePath);

    if (content == "") {
      if (_signedInUser != null) return _signedInUser.roles[0];

      return Role.Anonymous;
    } else
      return valueOfRole(content);
  }

  Future<String> get _userToken async {
    var content =
        await FileManager.instance.getContentOfFile(await _tokenFilePath);
    if (content == null || content.isEmpty) return "";
    return content;
  }

  Future<String> get _signedInUserJson async {
    var content = await FileManager.instance
        .getContentOfFile(await _signedInUserJsonFilePath);

    if (content != null && content.isNotEmpty)
      return content;
    else
      return """
        {"Anonymous":{"id":"-1","representativeSeller":{},"user":{"mobile":"","extraProperties":[],"userName":"","firstName":"Anonymous","rolesIds":[],"password":"","id":"-1","LastName":"User","email":"","rolesTitles":["Anonymous"]}}}
       """;
  }

  Future<void> initialize() async {
    _selectedRole = await _selectedRoleSavedInFile;
    _signedInUser = await _extractSignedInUser();
  }

  List<int> _convertBody(body) {
    throw Exception("we could not convert ${body.runtimeType} to List<int>");
  }

  Future<http.StreamedRequest> _createStreamedRequest(
      String resourceUrl, String method,
      {Map<String, String> headers, Map<String, String> queryStrings}) async {
    final url = _baseUrl.substring(_baseUrl.indexOf("://") + 3);
    final protocol =
        _baseUrl.substring(0, _baseUrl.indexOf("://")).toLowerCase();
    final uri = protocol == "http"
        ? Uri.http(url, "$resourceUrl", queryStrings)
        : Uri.https(url, "$resourceUrl", queryStrings);

    if (headers == null) headers = {};

    headers["content-type"] = "text/plain";
    headers["user-token"] = await _userToken;

    final req = http.StreamedRequest(method, uri);

    headers.forEach((key, value) {
      req.headers[key] = value;
    });

    return req;
  }

  Future<http.StreamedRequest> _createImageStreamedRequest(
      String resourceUrl, String method,
      {Map<String, String> headers, Map<String, String> queryStrings}) async {
    final imageurl = _imageUrl.substring(_imageUrl.indexOf("://") + 3);
    final imageprotocol =
        _imageUrl.substring(0, _imageUrl.indexOf("://")).toLowerCase();
    final imageuri = imageprotocol == "http"
        ? Uri.http(imageurl, "$resourceUrl", queryStrings)
        : Uri.https(imageurl, "$resourceUrl", queryStrings);

    if (headers == null) headers = {};

    headers["content-type"] = "text/plain";
    headers["user-token"] = await _userToken;

    final imagereq = http.StreamedRequest(method, imageuri);

    headers.forEach((key, value) {
      imagereq.headers[key] = value;
    });

    return imagereq;
  }

  Future<http.Request> _createSimpleRequest(String resourceUrl, String method,
      {Map<String, String> headers, Map<String, String> queryStrings}) async {
    final url = _baseUrl.substring(_baseUrl.indexOf("://") + 3);
    final protocol =
        _baseUrl.substring(0, _baseUrl.indexOf("://")).toLowerCase();
    final uri = protocol == "http"
        ? Uri.http(url, "$resourceUrl", queryStrings)
        : Uri.https(url, "$resourceUrl", queryStrings);

    if (headers == null) headers = {};

    headers["user-token"] = await _userToken;

    final req = http.Request(method, uri);

    headers.forEach((key, value) {
      req.headers[key] = value;
    });

    return req;
  }

  Future<http.Request> _createImageSimpleRequest(
      String resourceUrl, String method,
      {Map<String, String> headers, Map<String, String> queryStrings}) async {
    final imageurl = _imageUrl.substring(_imageUrl.indexOf("://") + 3);
    final imageprotocol =
        _imageUrl.substring(0, _imageUrl.indexOf("://")).toLowerCase();
    final imageuri = imageprotocol == "http"
        ? Uri.http(imageurl, "$resourceUrl", queryStrings)
        : Uri.https(imageurl, "$resourceUrl", queryStrings);

    if (headers == null) headers = {};

    headers["user-token"] = await _userToken;

    final imagereq = http.Request(method, imageuri);

    headers.forEach((key, value) {
      imagereq.headers[key] = value;
    });

    return imagereq;
  }

  Future<http.BaseRequest> _createRequest(String resourceUrl, String method,
      {Map<String, String> headers,
      Map<String, String> queryStrings,
      body}) async {
    http.BaseRequest request;

    if (body is File)
      request = await _createStreamedRequest(resourceUrl, method,
          headers: headers, queryStrings: queryStrings);
    else
      request = await _createSimpleRequest(resourceUrl, method,
          headers: headers, queryStrings: queryStrings);

    if (body is File) {
      request.headers["content-type"] = "application/octet-stream";
      (request as http.StreamedRequest).contentLength = body.lengthSync();
      final requestSink = (request as http.StreamedRequest).sink;
      final stream = body.openRead();

      await stream.forEach((element) {
        requestSink.add(element);
      });

      requestSink.close();
    } else if (body is Map) {
      request.headers["content-type"] = "application/x-www-form-urlencoded";
      (request as http.Request).bodyFields = body;
    } else if (body != null) {
      request.headers["content-type"] = "application/octet-stream";
      var convertBody = _convertBody(body);
      (request as http.Request).contentLength = convertBody.length;
      (request as http.Request).bodyBytes = convertBody;
    }

    return request;
  }

  Future<http.BaseRequest> _createImageRequest(
      String resourceUrl, String method,
      {Map<String, String> headers,
      Map<String, String> queryStrings,
      body}) async {
    http.BaseRequest request;

    if (body is File)
      request = await _createImageStreamedRequest(resourceUrl, method,
          headers: headers, queryStrings: queryStrings);
    else
      request = await _createImageSimpleRequest(resourceUrl, method,
          headers: headers, queryStrings: queryStrings);

    if (body is File) {
      request.headers["content-type"] = "application/octet-stream";
      (request as http.StreamedRequest).contentLength = body.lengthSync();
      final requestSink = (request as http.StreamedRequest).sink;
      final stream = body.openRead();

      await stream.forEach((element) {
        requestSink.add(element);
      });

      requestSink.close();
    } else if (body is Map) {
      request.headers["content-type"] = "application/x-www-form-urlencoded";
      (request as http.Request).bodyFields = body;
    } else if (body != null) {
      request.headers["content-type"] = "application/octet-stream";
      var convertBody = _convertBody(body);
      (request as http.Request).contentLength = convertBody.length;
      (request as http.Request).bodyBytes = convertBody;
    }

    return request;
  }

  Future<http.StreamedResponse> _put(String resourceUrl,
      {Map<String, String> headers,
      Map<String, String> queryStrings,
      body}) async {
    final req = await _createRequest(resourceUrl, "PUT",
        headers: headers, body: body, queryStrings: queryStrings);
    return req.send();
  }

  Future<http.StreamedResponse> _delete(String resourceUrl,
      {Map<String, String> headers, Map<String, String> queryStrings}) async {
    final req = await _createRequest(resourceUrl, "DELETE",
        headers: headers, queryStrings: queryStrings);
    return req.send();
  }

  Future<http.StreamedResponse> _post(String resourceUrl,
      {Map<String, String> headers,
      Map<String, String> queryStrings,
      body}) async {
    final req = await _createRequest(resourceUrl, "POST",
        headers: headers, body: body, queryStrings: queryStrings);
    return req.send();
  }

  Future<http.StreamedResponse> _get(String resourceUrl,
      {Map<String, String> headers,
      Map<String, String> queryStrings,
      body}) async {
    final req = await _createRequest(resourceUrl, "GET",
        headers: headers, body: body, queryStrings: queryStrings);
    return req.send();
  }

  Future<http.StreamedResponse> _getImage(String resourceUrl,
      {Map<String, String> headers,
      Map<String, String> queryStrings,
      body}) async {
    final req = await _createImageRequest(resourceUrl, "GET",
        headers: headers, body: body, queryStrings: queryStrings);
    return req.send();
  }

  Future<void> askForSignupOrSingInOTP(String mobileOrEmailRecipient) async {
    var response =
        await _post("otp", headers: {"recipient": mobileOrEmailRecipient});
    var responseCode = response.statusCode;

    if (responseCode != 200) throw UnexpectedResponseCode();
  }

  Future<User> verifyOTP(
      String mobileOrEmailRecipient, String verificationCode) async {
    var response = await _post("otp-verification", headers: {
      "recipient": mobileOrEmailRecipient,
      "otp": verificationCode,
    });

    var responseCode = response.statusCode;
    var bodyAsString = await response.stream.bytesToString();

    if (responseCode == 401 || responseCode == 404)
      throw VerificationCodeWasWrong();

    if (responseCode != 200) throw UnexpectedResponseCode(bodyAsString);

    final userToken = response.headers["user-token"];
    final userJson = bodyAsString;
    developer.log(userJson,name: "userJson" );
    developer.log(userToken,name: "userToken" );

    await FileManager.instance.saveToFile(await _tokenFilePath, userToken);
    developer.log("processing ...",name: "before FileManager.instance.saveToFile(await _signedInUserJsonFilePath, userJson)" );

    await FileManager.instance
        .saveToFile(await _signedInUserJsonFilePath, userJson);
    developer.log(userJson,name: "before await getSignedInUser()" );

    var user = await getSignedInUser();
    //print("user after verify $user");
    return user;
  }

  Future<User> getSignedInUser() async {
    // if (!(await isUserSignedIn())) return _anonymousUser;
    User user;
    try {

      user = await _extractSignedInUser();
      if (user.isAnonymous) user = _anonymousUser;
    } catch (e, stack) {
      developer.log("user is not signed in !!!!!!!!!!!!!!!!! ",
          name: "getSignedInUser",error: e, stackTrace: stack);
    }
    return user;
  }

  Future<User> _extractSignedInUser() async {
    var source = await _signedInUserJson;

    final json = jsonDecode(source);
    // developer.log(json,name: "jsonDecode");

    final role = await _selectedRoleSavedInFile;
    // print("extracting sighned in use ($role) : $source");
    developer.log(role.toString(),name: "_selectedRoleSavedInFile");

    User user;

    if (role != null && role != Role.Anonymous) {
      user = _convertJsonToUser(json[role.name], role);
      selectRole(role);
    } else {
      if (json.containsKey(Role.Admin.name)) {
        user = _convertJsonToUser(json[Role.Admin.name], Role.Admin);
        selectRole(Role.Admin);
      } else if (json.containsKey(Role.Seller.name)) {
        user = _convertJsonToUser(json[Role.Seller.name], Role.Seller);
        selectRole(Role.Seller);
      } else if (json.containsKey(Role.Customer.name)) {
        user = _convertJsonToUser(json[Role.Customer.name], Role.Customer);
        selectRole(Role.Customer);
      } else
        user = _anonymousUser;
    }

    if (user == null) throw Exception("There is no singed in user!");

    _signedInUser = user;
    return user;
  }

  User _convertJsonToUser(json, Role role) {
    if (json == null || json.isEmpty || !(json is Map)) return null;

    var userJson = json["user"];
    var user = _convertUserJson(userJson);

    if (!user.hasRole(role))
      throw Exception("user in json does not have the asked role!");

    if (role == Role.Customer) {
      final representativeAgent =
          _convertJsonToUser(json["representativeSeller"], Role.Seller);
      return Customer(
          representativeAgent,
          user.userId,
          user.firstName,
          user.lastName,
          user.mobile,
          user.address,
          user.photoUrl,
          user.isAgent,
          user.isCustomer,
          user.isAdmin,
          user.email);
    } else if (role == Role.Seller) {
      final invitationsCount = json["invitationsCount"] as int;
      final customersRepresentedCount =
          json["representingCustomersCount"] as int;
      final company = user.extraProperties["agentCompany"];
      final website = user.extraProperties["agentWebsite"];
      return Agent(
          invitationsCount,
          customersRepresentedCount,
          user.userId,
          user.firstName,
          user.lastName,
          user.mobile,
          user.address,
          user.photoUrl,
          user.isAgent,
          user.isCustomer,
          user.isAdmin,
          user.email,
          company: company,
          website: website);
    } else if (role == Role.Admin)
      return Admin(
          user.userId,
          user.firstName,
          user.lastName,
          user.mobile,
          user.address,
          user.photoUrl,
          user.isAgent,
          user.isCustomer,
          user.isAdmin,
          user.email);
    else
      return user;
  }

  User _convertUserJson(userJson) {
    final roles = userJson["rolesTitles"] as List;

    final user = User(
        userJson["id"],
        userJson["firstName"],
        userJson["LastName"],
        userJson["mobile"],
        "",
        userJson["profilePictureFile"],
        roles.contains("Seller"),
        roles.contains("Customer"),
        roles.contains("Admin"),
        userJson["email"],
        extraProperties: extractExtraProperties(userJson),
        isAnonymous: roles.contains("Anonymous"));

    return user;
  }

  Map<String, dynamic> extractExtraProperties(json) {
    var extraProperties = <String, dynamic>{};

    try {
      (json["extraProperties"] as List).forEach((e) {
        var value = e["currentValue"];
        var title = e["specification"]["title"];
        extraProperties[title] = value;
      });
    } catch (e) {}

    return extraProperties;
  }

  Future<bool> isUserSignedIn() async {
    bool flag = false;
    try {
      final user = await _extractSignedInUser();
      flag = !user.isAnonymous;
    } catch (e, stack) {
      print("user is not signed in !!!!!!!!!!!!!!!!!  $e  $stack");
      // return false;
    }
    developer.log('flag', name: 'is User SignedIn Anonymously?');
    return flag;
  }

  Future<void> logout() async {
    _signedInUser = _anonymousUser;
    _selectedRole = Role.Anonymous;
    FileManager.instance.deleteFile(await _signedInUserJsonFilePath);
    FileManager.instance.deleteFile(await _tokenFilePath);
    FileManager.instance.deleteFile(await _selectedRoleFilePath);
  }

  Future<PageResult<PropertyAd>> fetchAds(
      int pageIndex, int pageSize, PropertyAdSearchFilter searchFilter) async {
    developer.log('fetchAds', name: 'fetchAds method is called...');

    var qs = {"pageIndex": "$pageIndex", "pageSize": "$pageSize"};

    if (searchFilter == null) searchFilter = PropertyAdSearchFilter();

    if (searchFilter.word.isNotEmpty) qs["word"] = searchFilter.word;

    qs["parkingCount"] = searchFilter.parkingCount.numericalName;
    qs["bedroomsCount"] = searchFilter.bedroomsCount.numericalName;
    qs["bathRoomsCount"] = searchFilter.bathRoomsCount.numericalName;
    qs["roomsCount"] = searchFilter.roomCount.numericalName;
    qs["garagesCount"] = searchFilter.garageSpacesCount.numericalName;

    qs["propertySizeInSquareFeetAtMost"] =
        "${searchFilter.propertySizeInSquareFeetAtMost}";
    qs["propertySizeInSquareFeetAtLeast"] =
        "${searchFilter.propertySizeInSquareFeetAtLeast}";
    qs["priceStartingFrom"] = "${searchFilter.priceStartingFrom}";
    qs["priceUpTo"] = "${searchFilter.priceUpTo}";
    qs["onlyFavoriteOnes"] = "${searchFilter.onlyFavoriteOnes}";
    qs["onlyMaps"] = "${searchFilter.onlyMaps}";

    qs["adClass"] = searchFilter.adClass.name;
    qs["adType"] = searchFilter.adType.name;
    qs["airConditioning"] = searchFilter.airConditioning.name;
    qs["basementType"] = searchFilter.basementType.name;
    qs["construction"] = searchFilter.construction.name;
    qs["garageType"] = searchFilter.garageType.name;
    qs["heatSource"] = searchFilter.heatSource.name;
    qs["heatType"] = searchFilter.heatType.name;
    qs["parkingType"] = searchFilter.parkingType.name;
    qs["pool"] = searchFilter.pool.name;
    qs["propertyStyle"] = searchFilter.propertyStyle.name;
    qs["propertyType"] = searchFilter.propertyType.name;
    qs["status"] = searchFilter.status.name;

    final response = await _get("ads", queryStrings: qs);
    var bodyAsString = await response.stream.bytesToString();

    if (response.statusCode != 200)
      throw UnexpectedResponseCode("$bodyAsString ${response.statusCode}");

    final body = jsonDecode(bodyAsString);
    final pi = body["pageIndex"];
    final ps = body["pageSize"];
    final totalEntriesCount = body["totalEntriesCount"];
    final result = body["result"] == null ? [] : body["result"];

    if(searchFilter.onlyMaps){
      final mappedResult = result
          .map<PropertyAd>((jsonObject) => jsonObjectToPropertyAdMap(jsonObject))
          .toList();

      return PageResult<PropertyAd>(ps, pi, totalEntriesCount, mappedResult);
    } else {
      final mappedResult = result
          .map<PropertyAd>((jsonObject) => jsonObjectToPropertyAd(jsonObject))
          .toList();

      return PageResult<PropertyAd>(ps, pi, totalEntriesCount, mappedResult);
    }
  }

  PropertyAd jsonObjectToPropertyAdMap(jsonObject) {
    var mlsNumber = jsonObject["mlsNumber"];
    var latitude = jsonObject["latitude"];
    var longitude = jsonObject["longitude"];
    var ad = PropertyAd();
    ad.id = mlsNumber;
    ad.latitude = latitude;
    ad.longitude = longitude;
    return ad;
  }

    PropertyAd jsonObjectToPropertyAd(jsonObject) {
    final images =
        ((jsonObject["images"] != null ? jsonObject["images"] : "") as String)
            .split(",");
    var mlsNumber = jsonObject["mlsNumber"];
    var price = jsonObject["price"].toInt();
    var state = jsonObject["state"];
    var city = jsonObject["city"];
    var streetName = jsonObject["streetName"];
    var minSQFT = jsonObject["minSqFt"];
    var maxSQFT = jsonObject["maxSqFt"];
    var description = jsonObject["description"];
    var isFavorite = jsonObject["isFavorite"];

    var propertyType = valueOfPropertyType(jsonObject["propertyType"]);
    var clazz = valueOfAdClass(jsonObject["class"]);
    var type = valueOfAdType(jsonObject["type"]);
    var status = valueOfStatus(jsonObject["status"]);
    var propertyTypeStyle =
        valueOfPropertyStyle(jsonObject["propertyTypeStyle"]);
    var exteriorConstruction1 =
        valueOfExteriorConstruction(jsonObject["exteriorConstruction1"]);
    var exteriorConstruction2 =
        valueOfExteriorConstruction(jsonObject["exteriorConstruction2"]);
    var garage = valueOfGarageType(jsonObject["garage"]);
    var parkingType = valueOfParkingType(jsonObject["parkingType"]);
    var basement1 = valueOfBasementType(jsonObject["basement1"]);
    var basement2 = valueOfBasementType(jsonObject["basement2"]);
    var heatSource = valueOfHeatSource(jsonObject["heatSource"]);
    var heatType = valueOfHeatType(jsonObject["heatType"]);
    var airConditioning = valueOfAirConditioning(jsonObject["airConditioning"]);
    var swimmingPool = valueOfPool(jsonObject["swimmingPool"]);

    var listDate = jsonObject["listDate"];
    var updatedOn = jsonObject["updatedOn"];
    var exposure = jsonObject["exposure"];
    var lockerNumber = jsonObject["lockerNumber"];
    var locker = jsonObject["locker"];
    var areaInfluencesList = jsonObject["areaInfluencesList"];
    var buildingInfluencesList = jsonObject["buildingInfluencesList"];
    var brokerageName = jsonObject["brokerageName"];
    var area = jsonObject["area"];
    var country = jsonObject["country"];
    var district = jsonObject["district"];
    var majorIntersection = jsonObject["majorIntersection"];
    var neighborhood = jsonObject["neighborhood"];
    var streetDirection = jsonObject["streetDirection"];
    var streetNumber = jsonObject["streetNumber"];
    var streetSuffix = jsonObject["streetSuffix"];
    var unitNumber = jsonObject["unitNumber"];
    var zip = jsonObject["zip"];
    var latitude = jsonObject["latitude"];
    var longitude = jsonObject["longitude"];
    var extras = jsonObject["extras"];
    var approximateAge = jsonObject["approximateAge"];
    var hasFirePlace = jsonObject["hasFirePlace"];
    var petsPermitted = jsonObject["petsPermitted"];
    var elevatorType = jsonObject["elevatorType"];
    var lotAcres = jsonObject["lotAcres"];
    var lotDepth = jsonObject["lotDepth"];
    var lotIrregular = jsonObject["lotIrregular"];
    var lotLegalDescription = jsonObject["lotLegalDescription"];
    var lotMeasurement = jsonObject["lotMeasurement"];
    var lotWidth = jsonObject["lotWidth"];
    var displayAddressPermission = jsonObject["displayAddressPermission"];
    var displayPublicPermission = jsonObject["displayPublicPermission"];
    var hasElevator = jsonObject["hasElevator"];
    var hasCentralVacuum = jsonObject["hasCentralVacuum"];
    var hasBuildingInsurance = jsonObject["hasBuildingInsurance"];
    var cableIncludedInMaintenanceFees =
        jsonObject["cableIncludedInMaintenanceFees"];
    var heatIncludedInMaintenanceFees =
        jsonObject["heatIncludedInMaintenanceFees"];
    var hydroIncludedInMaintenanceFees =
        jsonObject["hydroIncludedInMaintenanceFees"];
    var parkingIncludedInMaintenanceFees =
        jsonObject["parkingIncludedInMaintenanceFees"];
    var taxesIncludedInMaintenanceFees =
        jsonObject["taxesIncludedInMaintenanceFees"];
    var waterIncludedInMaintenanceFees =
        jsonObject["waterIncludedInMaintenanceFees"];
    var maintenanceFees = jsonObject["maintenanceFees"];
    var taxesAnnualAmount = jsonObject["taxesAnnualAmount"];
    var taxesAssessmentYear = jsonObject["taxesAssessmentYear"];
    var numBathroomsPlus = jsonObject["numBathroomsPlus"];
    var numBedroomsPlus = jsonObject["numBedroomsPlus"];
    var numGarageSpaces = jsonObject["numGarageSpaces"];
    var numRooms = jsonObject["numRooms"];
    var numRoomsPlus = jsonObject["numRoomsPlus"];
    var numBedrooms = jsonObject["numBedrooms"];
    var numBathrooms = jsonObject["numBathrooms"];
    var numParkingSpaces = jsonObject["numParkingSpaces"];
    var room1Details = jsonObject["room1Details"];
    var room2Details = jsonObject["room2Details"];
    var room3Details = jsonObject["room3Details"];
    var room4Details = jsonObject["room4Details"];
    var room5Details = jsonObject["room5Details"];
    var room6Details = jsonObject["room6Details"];
    var room7Details = jsonObject["room7Details"];
    var room8Details = jsonObject["room8Details"];
    var room9Details = jsonObject["room9Details"];
    var room10Details = jsonObject["room10Details"];
    var room11Details = jsonObject["room11Details"];
    var room12Details = jsonObject["room12Details"];
    var soldPrice = jsonObject["soldPrice"];
    var soldDate = jsonObject["soldDate"];
    var history = jsonObject["history"];

    var ad = PropertyAd();
    ad.id = mlsNumber;
    ad.address = "" + state + " | " + city + " | " + streetName;
    ad.imagesUrls = images;
    ad.thumbnailUrl = images[0];
    ad.isFavorite = isFavorite ?? false;
    ad.sizeInSquareFeetMin = minSQFT;
    ad.sizeInSquareFeetMax = maxSQFT;
    ad.description = description;
    ad.price = price;
    ad.propertyType = propertyType;
    ad.adClass = clazz;
    ad.adType = type;
    ad.status = status;
    ad.propertyStyle = propertyTypeStyle;
    ad.exteriorConstruction1 = exteriorConstruction1;
    ad.exteriorConstruction2 = exteriorConstruction2;
    ad.garageType = garage;
    ad.parkingType = parkingType;
    ad.basementType1 = basement1;
    ad.basementType2 = basement2;
    ad.heatSource = heatSource;
    ad.heatType = heatType;
    ad.airConditioning = airConditioning;
    ad.pool = swimmingPool;

    ad.listDate = listDate;
    ad.updatedOn = updatedOn;
    ad.exposure = exposure;
    ad.lockerNumber = lockerNumber;
    ad.locker = locker;
    ad.areaInfluencesList = areaInfluencesList;
    ad.buildingInfluencesList = buildingInfluencesList;
    ad.brokerageName = brokerageName;
    ad.area = area;
    ad.country = country;
    ad.district = district;
    ad.majorIntersection = majorIntersection;
    ad.neighborhood = neighborhood;
    ad.streetDirection = streetDirection;
    ad.streetNumber = streetNumber;
    ad.streetName = streetName;
    ad.streetSuffix = streetSuffix;
    ad.unitNumber = unitNumber;
    ad.state = state;
    ad.city = city;
    ad.zip = zip;
    ad.latitude = latitude;
    ad.longitude = longitude;
    ad.extras = extras;
    ad.approximateAge = approximateAge;
    ad.hasFirePlace = hasFirePlace;
    ad.petsPermitted = petsPermitted;
    ad.elevatorType = elevatorType;
    ad.lotAcres = lotAcres;
    ad.lotDepth = lotDepth;
    ad.lotIrregular = lotIrregular;
    ad.lotLegalDescription = lotLegalDescription;
    ad.lotMeasurement = lotMeasurement;
    ad.lotWidth = lotWidth;
    ad.displayAddressPermission = displayAddressPermission;
    ad.displayPublicPermission = displayPublicPermission;
    ad.hasElevator = hasElevator;
    ad.hasCentralVacuum = hasCentralVacuum;
    ad.hasBuildingInsurance = hasBuildingInsurance;
    ad.cableIncludedInMaintenanceFees = cableIncludedInMaintenanceFees;
    ad.heatIncludedInMaintenanceFees = heatIncludedInMaintenanceFees;
    ad.hydroIncludedInMaintenanceFees = hydroIncludedInMaintenanceFees;
    ad.parkingIncludedInMaintenanceFees = parkingIncludedInMaintenanceFees;
    ad.taxesIncludedInMaintenanceFees = taxesIncludedInMaintenanceFees;
    ad.waterIncludedInMaintenanceFees = waterIncludedInMaintenanceFees;
    ad.maintenanceFees = maintenanceFees;
    ad.taxesAnnualAmount = taxesAnnualAmount;
    ad.taxesAssessmentYear = taxesAssessmentYear;
    ad.numBathroomsPlus = numBathroomsPlus;
    ad.numBedroomsPlus = numBedroomsPlus;
    ad.numGarageSpaces = numGarageSpaces;
    ad.numRooms = numRooms;
    ad.numRoomsPlus = numRoomsPlus;
    ad.numBedrooms = numBedrooms;
    ad.numBathrooms = numBathrooms;
    ad.numParkingSpaces = numParkingSpaces;
    ad.room1Details = room1Details;
    ad.room2Details = room2Details;
    ad.room3Details = room3Details;
    ad.room4Details = room4Details;
    ad.room5Details = room5Details;
    ad.room6Details = room6Details;
    ad.room7Details = room7Details;
    ad.room8Details = room8Details;
    ad.room9Details = room9Details;
    ad.room10Details = room10Details;
    ad.room11Details = room11Details;
    ad.room12Details = room12Details;
    ad.soldPrice = soldPrice.toString();
    ad.soldDate = soldDate;
    ad.history = history;

    return ad;
  }

  Future<PropertyAd> fetchAdDetails(String propertyId) async {
    final response = await _get("ad/$propertyId");
    var bodyAsString = await response.stream.bytesToString();

    if (response.statusCode != 200) throw UnexpectedResponseCode(bodyAsString);

    return jsonObjectToPropertyAd(jsonDecode(bodyAsString));
  }

  final _imagesBeingLoaded = {};
  final _mutex = Mutex();

  Future<File> loadImage(String url, {String defaultAssetFile = ""}) async {
    await _mutex.acquire();

    if (_imagesBeingLoaded.containsKey(url)) {
      var imageBeingLoaded = _imagesBeingLoaded[url];
      _mutex.release();
      return imageBeingLoaded;
    }

    var future = _loadImage(url, defaultAssetFile: defaultAssetFile);

    _imagesBeingLoaded[url] = future;

    future.then((value) {
      _imagesBeingLoaded.remove(url);
    });

    _mutex.release();
    return future;
  }

  Future<File> loadProfileImage(String url) async {
    await _mutex.acquire();

    if (_imagesBeingLoaded.containsKey(url)) {
      var imageBeingLoaded = _imagesBeingLoaded[url];
      _mutex.release();
      return imageBeingLoaded;
    }

    var future = _loadProfileImage(url);

    _imagesBeingLoaded[url] = future;

    future.then((value) {
      _imagesBeingLoaded.remove(url);
    });

    _mutex.release();
    return future;
  }

  Future<File> _loadProfileImage(String url) async {

    File file = await FileManager.instance.getFileInsideSupportDir(url);

    // if (await file.exists()) {
    //   if (file.lengthSync() > 0)
    //     return file;
    // }
    var headers = {"user-agent": "D4xdcWRDC5VuHAyw"};

    final response = await _getProfileImage("user/profilepic", headers: headers);

    await file.create(recursive: true);
    var sink = file.openWrite();
    await response.stream.pipe(sink);
    sink.close();
    return file;
  }

  Future<http.StreamedResponse> _getProfileImage(String resourceUrl,
      {Map<String, String> headers,
        Map<String, String> queryStrings,
        body}) async {
    final req = await _createRequest(resourceUrl, "GET",
        headers: headers, body: body, queryStrings: queryStrings);
    return req.send();
  }

  Future<File> _loadImage(String url, {String defaultAssetFile = ""}) async {
    String assetFile =
        defaultAssetFile.isNotEmpty ? defaultAssetFile : "images/No_Image.png";
    String defaultFileName = assetFile.substring(assetFile.indexOf("/") + 1);

    if (url == null || url.isEmpty)
      return saveAssetToLocalFile(assetFile, defaultFileName);

    File file = await FileManager.instance.getFileInsideSupportDir(url);

    if (await file.exists()) {
      if (file.lengthSync() > 0)
        return file;
      else
        return saveAssetToLocalFile(assetFile, defaultFileName);
    }

    //final response = await _get("images/$url");
    var headers = {"user-agent": "D4xdcWRDC5VuHAyw"};

    final response = await _getImage("$url", headers: headers);

    if (response.statusCode != 200)
      return saveAssetToLocalFile(assetFile, defaultFileName);

    await file.create(recursive: true);
    var sink = file.openWrite();
    await response.stream.pipe(sink);
    sink.close();

    final fileLength = await file.length();

    if (fileLength == 0) {
      file.deleteSync();
      return saveAssetToLocalFile(assetFile, defaultFileName);
    }

    return file;
  }

  // int _extractContentLength(http.StreamedResponse response) {
  //   var cl = -1;
  //
  //   response.headers.keys.forEach((element) {
  //     if (element.toLowerCase() == "content-length")
  //       cl = int.parse(response.headers[element]);
  //   });
  //
  //   return cl;
  // }

  Future<void> tagAsFavorite(String adId) async {
    final user = await getSignedInUser();

    if (user.isAnonymous) throw UserIsAnonymous();

    var response;

    if (user.isCustomer)
      response = await _put("favorites-buy-tag/$adId");
    else
      response = await _put("favorites-sell-tag/$adId");

    if (response.statusCode != 200) throw UnexpectedResponseCode(response.body);
  }

  Future<void> untagAsFavorite(String adId) async {
    final user = await getSignedInUser();
    var response;

    if (user.isAnonymous) throw UserIsAnonymous();

    if (user.isCustomer)
      response = await _delete("favorites-buy-tag/$adId");
    else
      response = await _delete("favorites-sell-tag/$adId");

    if (response.statusCode != 200) throw UnexpectedResponseCode(response.body);
  }

  Future<Agent> fetchSignedInCustomerRepresentativeAgent() async {
    var user = await getSignedInUser();

    if (!user.isCustomer)
      throw Exception("only customers can have representative agent!");

    var agent = (user as Customer).representativeAgent;

    if (!(await _checkIfAtLeast30MinutesHasPassedSinceLastAgentCheck()))
      return agent;

    final response = await _get("customers/${user.userId}");
    var bodyAsString = await response.stream.bytesToString();

    if (response.statusCode != 200) throw UnexpectedResponseCode(bodyAsString);

    final prevJson = jsonDecode(await _signedInUserJson);
    prevJson["Customer"] = jsonDecode(bodyAsString);

    await FileManager.instance
        .saveToFile(await _signedInUserJsonFilePath, jsonEncode(prevJson));
    _saveTimeForRepresentativeAgentCheck();

    var customer = await getSignedInUser() as Customer;
    return (customer).representativeAgent;
  }

  Future<bool> _checkIfAtLeast30MinutesHasPassedSinceLastAgentCheck() async =>
      (await _elapsedTimeMillisSinceLastCheckForRepresentativeAgent() >
          30 * 60 * 1000);

  Future<int> _elapsedTimeMillisSinceLastCheckForRepresentativeAgent() async {
    final path = await FileManager.instance.getFileInsideSupportDir(
        "LastTimeCheckForRepresentativeAgentTimeMillis");
    var content = await FileManager.instance.getContentOfFile(path.path,
        defaultValue: "${DateTime.now().millisecondsSinceEpoch}");

    return DateTime.now().millisecondsSinceEpoch - int.parse(content);
  }

  void _saveTimeForRepresentativeAgentCheck() async {
    final path = await FileManager.instance.getFileInsideSupportDir(
        "LastTimeCheckForRepresentativeAgentTimeMillis");
    FileManager.instance
        .saveToFile(path.path, "${DateTime.now().millisecondsSinceEpoch}");
  }

  Future<PageResult<Customer>> fetchCustomerList(
      int pageIndex, int pageSize, CustomerSearchFilter searchFilter) async {
    var qs = {
      "pageIndex": "$pageIndex",
      "pageSize": "$pageSize",
      "representedByAgentId": "${searchFilter.specificAgentId}"
    };

    final response = await _get("customers", queryStrings: qs);
    var bodyAsString = await response.stream.bytesToString();

    if (response.statusCode != 200) throw UnexpectedResponseCode(bodyAsString);

    final body = jsonDecode(bodyAsString);
    final pi = body["pageIndex"];
    final ps = body["pageSize"];
    final totalEntriesCount = body["totalEntriesCount"];
    final result = body["result"] == null ? [] : body["result"];

    final mappedResult = result.map<Customer>((jsonObject) {
      final customer =
          _convertJsonToUser(jsonObject, Role.Customer) as Customer;
      return customer;
    }).toList();

    return PageResult<Customer>(ps, pi, totalEntriesCount, mappedResult);
  }

  Future<void> inviteCustomer(
      String mobile, String email, String content) async {
    var headers = {
      "mobile": "$mobile",
      "email": "$email",
      "message": "$content"
    };

    final response = await _post("customer-invitation", headers: headers);
    var bodyAsString = await response.stream.bytesToString();

    if (response.statusCode != 200) throw UnexpectedResponseCode(bodyAsString);
  }

  Future<PageResult<Agent>> fetchAgentsList(int pageIndex, int pageSize) async {
    var qs = {"pageIndex": "$pageIndex", "pageSize": "$pageSize"};

    final response = await _get("agents", queryStrings: qs);
    var bodyAsString = await response.stream.bytesToString();
    developer.log(bodyAsString,name: "fetchAgentsList" );
    developer.log(response.statusCode.toString(),name: "fetchAgentsList" );

    if (response.statusCode != 200) throw UnexpectedResponseCode(bodyAsString);

    final body = jsonDecode(bodyAsString);
    final pi = body["pageIndex"];
    final ps = body["pageSize"];
    final totalEntriesCount = body["totalEntriesCount"];
    final result = body["result"] == null ? [] : body["result"];
    developer.log(result,name: "body[result]" );

    final mappedResult = result.map<Agent>((jsonObject) {
      final agent = _convertJsonToUser(jsonObject, Role.Seller) as Agent;
      return agent;
    }).toList();

    return PageResult<Agent>(ps, pi, totalEntriesCount, mappedResult);
  }

  Future<List<GeoMarker>> fetchAdsCoordinatesInThisRange(
      double bottomLeftLongitude,
      double bottomLeftLatitude,
      double topRightLongitude,
      double topRightLatitude) async {
    print(
        "was asked to download $bottomLeftLongitude  $bottomLeftLatitude  $topRightLongitude  $topRightLatitude");
    var headers = {
      "bl-lat": "$bottomLeftLatitude",
      "bl-lon": "$bottomLeftLongitude",
      "tr-lon": "$topRightLongitude",
      "tr-lat": "$topRightLatitude"
    };

    var timeBeforeConnectToAdsGeo = currentTimeMillis;
    final response = await _get("adsgeo", headers: headers);

    var bodyAsString = await response.stream.bytesToString();

    if (response.statusCode != 200) throw UnexpectedResponseCode(bodyAsString);

    if (bodyAsString.length < 100)
      try {
        var count = int.parse(bodyAsString);
        print(
            "was asked to download $bottomLeftLongitude  $bottomLeftLatitude  $topRightLongitude  $topRightLatitude and count was $count");
        throw GivenCoordinatesHaveDataBeyondThreshold(count);
      } catch (e) {
        if (e is GivenCoordinatesHaveDataBeyondThreshold) throw e;
      }

    var jsonObject = jsonDecode(bodyAsString) as Map;
    printTimeSince(timeBeforeConnectToAdsGeo,
        message: "Connect And Download Geo json");

    var map = jsonObject.keys.map((id) {
      var lonLat = jsonObject[id];
      var longitude = lonLat[0] as num;
      var latitude = lonLat[1] as num;
      return GeoMarker(id, GeoPoint(longitude.toDouble(), latitude.toDouble()));
    }).toList();

    return map;
  }

  Future<void> assignAgentToCustomer(
      String agentUserId, String customerUserId) async {
    final response =
        await _put("agents/$agentUserId/customers/$customerUserId");
    var bodyAsString = await response.stream.bytesToString();

    if (response.statusCode != 202) throw UnexpectedResponseCode(bodyAsString);
  }

  Future<void> clearCustomerRepresentativeAgent(String customerUserId) async {
    final response = await _delete("customers/$customerUserId/agents");
    var bodyAsString = await response.stream.bytesToString();

    if (response.statusCode != 202) throw UnexpectedResponseCode(bodyAsString);
  }

  Future<void> modifyUserProfile(String firstName, String lastName) async {
    var qs = {"first": "$firstName", "last": "$lastName"};

    final response = await _put("user/profile", queryStrings: qs);
    var bodyAsString = await response.stream.bytesToString();

    if (response.statusCode != 200) throw UnexpectedResponseCode(bodyAsString);

    _updateSignedInUserFullName(firstName, lastName);
  }

  Future<String> uploadUserProfilePicture(File pic) async {
    final response = await _put("user/profilepic", body: pic);
    var bodyAsString = await response.stream.bytesToString();

    if (response.statusCode != 200) throw UnexpectedResponseCode(bodyAsString);

    final fileId = jsonDecode(bodyAsString)["fileId"];
    await _updateSignedInUserProfilePicture(fileId);

    return fileId;
  }

  _updateSignedInUserProfilePicture(fileId) async {
    await _updateUserJsonWith({
      "profilePictureFile": fileId,
    });
  }

  _updateSignedInUserFullName(first, last) async {
    await _updateUserJsonWith({
      "firstName": first,
      "LastName": last,
    });
  }

  _updateUserJsonWith(Map<String, dynamic> update) async {
    final json = jsonDecode(await _signedInUserJson);

    if (json.containsKey(Role.Admin.name)) {
      final userJson = json[Role.Admin.name]["user"];
      update.forEach((key, value) {
        userJson[key] = value;
      });
    }

    if (json.containsKey(Role.Customer.name)) {
      final userJson = json[Role.Customer.name]["user"];
      update.forEach((key, value) {
        userJson[key] = value;
      });
    }

    if (json.containsKey(Role.Seller.name)) {
      final userJson = json[Role.Seller.name]["user"];
      update.forEach((key, value) {
        userJson[key] = value;
      });
    }

    await FileManager.instance
        .saveToFile(await _signedInUserJsonFilePath, jsonEncode(json));
    await getSignedInUser();
  }

  Future<void> selectRole(Role role) async {
    await FileManager.instance
        .saveToFile(await _selectedRoleFilePath, role.name);

    _selectedRole = role;
  }
}
