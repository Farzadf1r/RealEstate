


import 'dart:math';

import 'package:realestate_app/customWidget/general/Utils.dart';
import 'package:realestate_app/model/entity/PropertyType.dart';

import 'AdClass.dart';
import 'AdType.dart';
import 'AirConditioning.dart';
import 'BasementType.dart';
import 'ExteriorConstruction.dart';
import 'GarageType.dart';
import 'HeatSource.dart';
import 'HeatType.dart';
import 'ParkingType.dart';
import 'Pool.dart';
import 'PropertyStyle.dart';
import 'Status.dart';

class PropertyAd
{
  String id;
  num price;
  String address;

  AdClass adClass;
  AdType adType;
  AirConditioning airConditioning;
  BasementType basementType1;
  BasementType basementType2;
  ExteriorConstruction exteriorConstruction1;
  ExteriorConstruction exteriorConstruction2;
  GarageType garageType;
  HeatSource heatSource;
  HeatType heatType;
  ParkingType parkingType;
  Pool pool;
  PropertyStyle propertyStyle;
  PropertyType propertyType;
  Status status;

  int sizeInSquareFeetMin;
  int sizeInSquareFeetMax;
  String description;
  String thumbnailUrl;
  List<String> imagesUrls;
  bool isFavorite;

  String listDate;
  String updatedOn;
  String exposure;
  String lockerNumber;
  String locker;
  String areaInfluencesList;
  String buildingInfluencesList;
  String brokerageName;

  String state;
  String city;
  String area;
  String country;
  String district;
  String majorIntersection;
  String neighborhood;
  String streetDirection;
  String streetNumber;
  String streetSuffix;
  String unitNumber;
  String zip;
  String streetName;

  String latitude;
  String longitude;
  String extras;
  String approximateAge;
  String hasFirePlace;
  String petsPermitted;
  String elevatorType;
  String lotAcres;
  String lotDepth;
  String lotIrregular;
  String lotLegalDescription;
  String lotMeasurement;
  String lotWidth;
  String displayAddressPermission;
  String displayPublicPermission;
  String hasElevator;
  String hasCentralVacuum;
  String hasBuildingInsurance;
  String cableIncludedInMaintenanceFees;
  String heatIncludedInMaintenanceFees;
  String hydroIncludedInMaintenanceFees;
  String parkingIncludedInMaintenanceFees;
  String taxesIncludedInMaintenanceFees;
  String waterIncludedInMaintenanceFees;
  num maintenanceFees;
  num taxesAnnualAmount;
  num taxesAssessmentYear;
  num numBathroomsPlus;
  num numBedroomsPlus;
  num numGarageSpaces;
  num numRooms;
  num numRoomsPlus;
  num numBedrooms;
  num numBathrooms;
  num numParkingSpaces;
  String room1Details;
  String room2Details;
  String room3Details;
  String room4Details;
  String room5Details;
  String room6Details;
  String room7Details;
  String room8Details;
  String room9Details;
  String room10Details;
  String room11Details;
  String room12Details;
  String soldPrice;
  String soldDate;
  String history;




  bool get hasBedroomData => numBedrooms>=0 || numBedroomsPlus>=0;
  bool get hasBathroomData => numBathrooms>=0 || numBathroomsPlus>=0;
  bool get hasRoomData => numRooms>=0 || numRoomsPlus>=0;
  bool get hasGarageData => numGarageSpaces >=0;
  bool get hasParkingSpacesData => numParkingSpaces >=0;
  bool get hasSQFTData => sizeInSquareFeetMin >=0 && sizeInSquareFeetMax>=0;
  bool get hasTaxAnnualAmountData => taxesAnnualAmount>=0;
  bool get hasTaxAssessmentYearData => taxesAssessmentYear>0;
  bool get hasBasement1Data => basementType1!=BasementType.NotSpecified;
  bool get hasBasement2Data => basementType2!=BasementType.NotSpecified;
  bool get hasExteriorConstruction1Data => exteriorConstruction1!=ExteriorConstruction.NotSpecified;
  bool get hasExteriorConstruction2Data => exteriorConstruction2!=ExteriorConstruction.NotSpecified;
  bool get hasPoolData => pool!=Pool.NotSpecified;
  bool get hasAirConditioningData => airConditioning!=AirConditioning.NotSpecified;
  bool get hasHeatSourceData => heatSource!=HeatSource.NotSpecified;
  bool get hasHeatTypeData => heatType!=HeatType.NotSpecified;
  bool get hasFirePlaceData => hasFirePlace!="NotSpecified";
  bool get hasPetsAllowedData => petsPermitted!="NotSpecified";
  bool get hasElevatorData => hasElevator!="NotSpecified";
  bool get hasCentralVacuumData => hasCentralVacuum!="NotSpecified";
  bool get hasBuildingInsuranceData => hasBuildingInsurance!="NotSpecified";
  bool get hasApproximateAgeData => approximateAge!="NotSpecified";
  bool get hasExposureData => exposure!="NotSpecified";
  bool get hasExtraData => extras.isNotEmpty;
  bool get hasLotData => lotDecorated.isNotEmpty;
  bool get hasHistoryData => history!=null && history.isNotEmpty;


  bool get hasBuildingInfluences => buildingInfluencesList.isNotEmpty;
  bool get hasAreaInfluences => areaInfluencesList.isNotEmpty;
  bool get hasRoomsDescription => roomsDescription.isNotEmpty;

  bool get isSold => status == Status.Sold
          ||  status == Status.SoldConditionally
          ||  status == Status.Leased
          ||  status == Status.LeasedConditionally;

  bool get isSoldButNotConditionally => status == Status.Sold
      ||  status == Status.Leased;


  String get propertyTypeAndStyleDescription{

    var desc = propertyType.name;

    if(propertyStyle!=PropertyStyle.NotSpecified)
      desc+="/${propertyStyle.name}";
    return desc;
  }

  String addressInDetail({bool includeTitle = true,String separator = "\n"}){

    var desc = "";

    if(streetNumber.isNotEmpty && streetNumber!="NotSpecified")
      desc += (includeTitle ?"Street Number : " : "")+streetNumber + separator;
    if(streetName.isNotEmpty && streetName!="NotSpecified")
      desc += (includeTitle ?"Street Name : " : "")+streetName + separator;
    if(streetSuffix.isNotEmpty && streetSuffix!="NotSpecified")
      desc += (includeTitle ?"Street Suffix : " : "")+streetSuffix + separator;
    if(streetDirection.isNotEmpty && streetDirection!="NotSpecified")
      desc += (includeTitle ?"Street Direction : " : "")+streetDirection + separator;
    if(unitNumber.isNotEmpty && unitNumber!="NotSpecified")
      desc += (includeTitle ?"Unit Number : " : "")+unitNumber + separator;
    if(city.isNotEmpty && city!="NotSpecified")
      desc += (includeTitle ?"City : " : "")+city + separator;
    if(state.isNotEmpty && state!="NotSpecified")
      desc += (includeTitle ?"State : " : "")+state + separator;
    if(zip.isNotEmpty && zip!="NotSpecified")
      desc += (includeTitle ?"Postal Code : " : "")+zip + separator;
    if(neighborhood.isNotEmpty && neighborhood!="NotSpecified")
      desc += (includeTitle ?"Neighborhood : " : "")+neighborhood + separator;
    if(area.isNotEmpty && area!="NotSpecified")
      desc += (includeTitle ?"Area : " : "")+area + separator;
    /**if(country.isNotEmpty && country!="NotSpecified")
      desc += (includeTitle ?"Country : " : "")+country + separator;
    if(district.isNotEmpty && district!="NotSpecified")
      desc += (includeTitle ?"District : " : "")+district + separator;
    if(majorIntersection.isNotEmpty && majorIntersection!="NotSpecified")
      desc += (includeTitle ?"Major Intersection : " : "")+majorIntersection + separator;*/

    return desc.substring(0,desc.lastIndexOf(separator));
  }

  String addressInDetailColumn({bool includeTitle = true,String separator = "\n"}){

    var desc = "";

    if(streetNumber.isNotEmpty && streetNumber!="NotSpecified")
      desc += (includeTitle ?"Street Number : " : "")+streetNumber + separator;
    if(streetName.isNotEmpty && streetName!="NotSpecified")
      desc += (includeTitle ?"Street Name : " : "")+streetName + separator;
    if(streetSuffix.isNotEmpty && streetSuffix!="NotSpecified")
      desc += (includeTitle ?"Street Suffix : " : "")+streetSuffix + separator;
    if(streetDirection.isNotEmpty && streetDirection!="NotSpecified")
      desc += (includeTitle ?"Street Direction : " : "")+streetDirection + separator;
    if(unitNumber.isNotEmpty && unitNumber!="NotSpecified")
      desc += (includeTitle ?"Unit Number : " : "")+unitNumber + separator;
    if(city.isNotEmpty && city!="NotSpecified")
      desc += (includeTitle ?"City : " : "")+city + separator;
    if(state.isNotEmpty && state!="NotSpecified")
      desc += (includeTitle ?"Province : " : "")+state + separator;
    if(zip.isNotEmpty && zip!="NotSpecified")
      desc += (includeTitle ?"Postal Code : " : "")+zip + separator;
    if(neighborhood.isNotEmpty && neighborhood!="NotSpecified")
      desc += (includeTitle ?"Neighborhood : " : "")+neighborhood + separator;
    if(area.isNotEmpty && area!="NotSpecified")
      desc += (includeTitle ?"Area : " : "")+area + separator;
    if(country.isNotEmpty && country!="NotSpecified")
        desc += (includeTitle ?"Country : " : "")+country + separator;
        if(district.isNotEmpty && district!="NotSpecified")
        desc += (includeTitle ?"District : " : "")+district + separator;
        if(majorIntersection.isNotEmpty && majorIntersection!="NotSpecified")
        desc += (includeTitle ?"Major Intersection : " : "")+majorIntersection + separator;

    return desc.substring(0,desc.lastIndexOf(separator));
  }


  String get lotDecorated{
    var desc = "";

    if(lotAcres.isNotEmpty && lotAcres!="NotSpecified")
      desc += "Acres : $lotAcres\n";

    if(lotDepth.isNotEmpty && lotDepth!="NotSpecified")
      desc+= "Depth : $lotDepth\n";


    if(lotMeasurement.isNotEmpty && lotMeasurement!="NotSpecified")
      desc+= "Measurement : $lotMeasurement\n";

    if(lotWidth.isNotEmpty && lotWidth!="NotSpecified")
      desc+= "Width : $lotWidth\n";


    if(lotIrregular.isNotEmpty && lotIrregular!="NotSpecified")
      desc+= "Irregular : $lotIrregular\n";

    if(lotLegalDescription.isNotEmpty && lotLegalDescription!="NotSpecified")
      desc+= "Legal Description : $lotLegalDescription\n";


    return desc;
  }

  String get soldDateDecorated{
    if(soldDate.contains("T"))
      return soldDate.substring(0,soldDate.indexOf("T"));
    else
      return soldDate;
  }

  String get soldPriceDecorated{
    if(soldPrice.contains("."))
      return "\$ "+decorateWithThousandSeparator(soldPrice.substring(0,soldPrice.indexOf(".")));
    else
      return "\$ "+decorateWithThousandSeparator(soldPrice);
  }

  String get priceDecorated{
    if(price.toString().contains("."))
      return "\$ "+decorateWithThousandSeparator(price.toString().substring(0,soldPrice.indexOf(".")));
    else
      return "\$ "+decorateWithThousandSeparator(price.toString());
  }

  String get taxesAnnualAmountDecorated{
    var tax = taxesAnnualAmount.toString();
    if(tax.contains("."))
      return "\$ "+decorateWithThousandSeparator(tax.substring(0,tax.indexOf(".")));
    else
      return "\$ "+"${decorateWithThousandSeparator(tax)}";
  }

  String get roomsDescription{
    
    var desc = "";
    
    desc+=_decorateRoomDetail(room1Details,"\n\n");
    desc+=_decorateRoomDetail(room2Details,"\n\n");
    desc+=_decorateRoomDetail(room3Details,"\n\n");
    desc+=_decorateRoomDetail(room4Details,"\n\n");
    desc+=_decorateRoomDetail(room5Details,"\n\n");
    desc+=_decorateRoomDetail(room6Details,"\n\n");
    desc+=_decorateRoomDetail(room7Details,"\n\n");
    desc+=_decorateRoomDetail(room8Details,"\n\n");
    desc+=_decorateRoomDetail(room9Details,"\n\n");
    desc+=_decorateRoomDetail(room10Details,"\n\n");
    desc+=_decorateRoomDetail(room11Details,"\n\n");
    desc+=_decorateRoomDetail(room12Details,"\n\n");

    if(desc.isNotEmpty)
      desc = desc.substring(0,desc.length-2);

    return desc;
  }

  String _decorateRoomDetail(String roomDetail,String suffix)
  {
    if(roomDetail.isEmpty)
      return "";

    roomDetail = roomDetail.substring(roomDetail.indexOf("\n")+1);
    String title = roomDetail . substring(0,roomDetail.indexOf("\n"));
    roomDetail = roomDetail.substring(title.length+1);
    String lengthDesc = roomDetail . substring(0,roomDetail.indexOf("\n"));
    roomDetail = roomDetail.substring(lengthDesc.length+1);
    String widthDesc = roomDetail . substring(0,roomDetail.indexOf("\n"));
    roomDetail = roomDetail.substring(widthDesc.length+1);
    String features = roomDetail ;


    double length = double.parse(lengthDesc.substring(lengthDesc.indexOf(":")+1).trim());
    double width = double.parse(widthDesc.substring(widthDesc.indexOf(":")+1).trim());

    String description = title;

    if(length == 0)
      description += "\nLength : Not Specified";
    else
      description += "\nLength : ${length}m (${(length*3.28084).toStringAsFixed(2)} ft)";

    if(width == 0)
      description += "\nWidth : Not Specified";
    else
      description += "\nWidth : ${width}m (${(width*3.28084).toStringAsFixed(2)} ft)";

    if(features.isNotEmpty)
      description+="\n$features";

    return description + suffix;
  }

  String get bedroomCountDescription{

    var desc = "";

    if(numBedrooms >= 0)
    {
      desc += "$numBedrooms";

      if(numBedroomsPlus > 0 )
        desc += "+$numBedroomsPlus";
    }

    return desc;
  }

  String get bathroomCountDescription{

    var desc = "";

    if(numBathrooms >= 0)
    {
      desc += "$numBathrooms";

      if(numBathroomsPlus > 0 )
        desc += "+$numBathroomsPlus";
    }

    return desc;
  }

  String get roomCountDescription{

    var desc = "";

    if(numRooms >= 0)
    {
      desc += "$numRooms";

      if(numRoomsPlus > 0 )
        desc += "+$numRoomsPlus";
    }

    return desc;
  }

  String get parkingCountDescription{

    if(numParkingSpaces.toInt() == numParkingSpaces)
      return numParkingSpaces.toInt().toString();
    else
      return numParkingSpaces.toString();
  }

  String get garageSpacesCountDescription{

    if(numGarageSpaces.toInt() == numGarageSpaces)
      return numGarageSpaces.toInt().toString();
    else
      return numGarageSpaces.toString();
  }

  String get sqftConsideringRange=>sizeInSquareFeetMin!=sizeInSquareFeetMax?"$sizeInSquareFeetMin-$sizeInSquareFeetMax":"$sizeInSquareFeetMin";

  PropertyAd get copy  {
    var ad = PropertyAd();

    ad.id = id;
    ad.price = price;
    ad.address = address;
    ad.adClass = adClass;
    ad.adType = adType;
    ad.airConditioning = airConditioning;
    ad.basementType1 = basementType1;
    ad.basementType2 = basementType2;
    ad.exteriorConstruction1 = exteriorConstruction1;
    ad.exteriorConstruction2 = exteriorConstruction2;
    ad.garageType = garageType;
    ad.heatSource = heatSource;
    ad.heatType = heatType;
    ad.parkingType = parkingType;
    ad.pool = pool;
    ad.propertyStyle = propertyStyle;
    ad.propertyType = propertyType;
    ad.status = status;
    ad.sizeInSquareFeetMin = sizeInSquareFeetMin;
    ad.sizeInSquareFeetMax = sizeInSquareFeetMax;
    ad.description = description;
    ad.thumbnailUrl = thumbnailUrl;
    ad.imagesUrls = imagesUrls;
    ad.isFavorite = isFavorite;
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
    ad.streetSuffix = streetSuffix;
    ad.unitNumber = unitNumber;
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
    ad.soldPrice = soldPrice;
    ad.soldDate = soldDate;

    return ad;
  }

  toString() {
    return 'PropertyAd{id: $id, price: $price, address: $address, adClass: $adClass, adType: $adType, airConditioning: $airConditioning, basementType1: $basementType1, basementType2: $basementType2, exteriorConstruction1: $exteriorConstruction1, exteriorConstruction2: $exteriorConstruction2, garageType: $garageType, heatSource: $heatSource, heatType: $heatType, parkingType: $parkingType, pool: $pool, propertyStyle: $propertyStyle, propertyType: $propertyType, status: $status, sizeInSquareFeetMin: $sizeInSquareFeetMin, sizeInSquareFeetMax: $sizeInSquareFeetMax, description: $description, thumbnailUrl: $thumbnailUrl, imagesUrls: $imagesUrls, isFavorite: $isFavorite, listDate: $listDate, updatedOn: $updatedOn, exposure: $exposure, lockerNumber: $lockerNumber, locker: $locker, areaInfluencesList: $areaInfluencesList, buildingInfluencesList: $buildingInfluencesList, brokerageName: $brokerageName, area: $area, country: $country, district: $district, majorIntersection: $majorIntersection, neighborhood: $neighborhood, streetDirection: $streetDirection, streetNumber: $streetNumber, streetSuffix: $streetSuffix, unitNumber: $unitNumber, zip: $zip, latitude: $latitude, longitude: $longitude, extras: $extras, approximateAge: $approximateAge, hasFirePlace: $hasFirePlace, petsPermitted: $petsPermitted, elevatorType: $elevatorType, lotAcres: $lotAcres, lotDepth: $lotDepth, lotIrregular: $lotIrregular, lotLegalDescription: $lotLegalDescription, lotMeasurement: $lotMeasurement, lotWidth: $lotWidth, displayAddressPermission: $displayAddressPermission, displayPublicPermission: $displayPublicPermission, hasElevator: $hasElevator, hasCentralVacuum: $hasCentralVacuum, hasBuildingInsurance: $hasBuildingInsurance, cableIncludedInMaintenanceFees: $cableIncludedInMaintenanceFees, heatIncludedInMaintenanceFees: $heatIncludedInMaintenanceFees, hydroIncludedInMaintenanceFees: $hydroIncludedInMaintenanceFees, parkingIncludedInMaintenanceFees: $parkingIncludedInMaintenanceFees, taxesIncludedInMaintenanceFees: $taxesIncludedInMaintenanceFees, waterIncludedInMaintenanceFees: $waterIncludedInMaintenanceFees, maintenanceFees: $maintenanceFees, taxesAnnualAmount: $taxesAnnualAmount, taxesAssessmentYear: $taxesAssessmentYear, numBathroomsPlus: $numBathroomsPlus, numBedroomsPlus: $numBedroomsPlus, numGarageSpaces: $numGarageSpaces, numRooms: $numRooms, numRoomsPlus: $numRoomsPlus, numBedrooms: $numBedrooms, numBathrooms: $numBathrooms, numParkingSpaces: $numParkingSpaces, room1Details: $room1Details, room2Details: $room2Details, room3Details: $room3Details, room4Details: $room4Details, room5Details: $room5Details, room6Details: $room6Details, room7Details: $room7Details, room8Details: $room8Details, room9Details: $room9Details, room10Details: $room10Details, room11Details: $room11Details, room12Details: $room12Details, soldPrice: $soldPrice, soldDate: $soldDate}';
  }
}
