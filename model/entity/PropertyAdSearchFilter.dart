
import 'package:realestate_app/model/entity/AirConditioning.dart';
import 'package:realestate_app/model/entity/BasementType.dart';
import 'package:realestate_app/model/entity/ExteriorConstruction.dart';
import 'package:realestate_app/model/entity/GarageType.dart';
import 'package:realestate_app/model/entity/HeatSource.dart';
import 'package:realestate_app/model/entity/HeatType.dart';
import 'package:realestate_app/model/entity/ParkingType.dart';
import 'package:realestate_app/model/entity/PropertyType.dart';

import 'AdClass.dart';
import 'AdType.dart';
import 'Pool.dart';
import 'PropertyStyle.dart';
import 'Status.dart';

enum Count{
  Any,One,Two,Three,Four,FivePlus
}

Count valueOfCount(String name) => Count.values.firstWhere((element) => element.name == name);
extension CountExtension on Count {
  String get name {
    switch(this)
    {
      case Count.Any : return "Any";
      case Count.One : return "1";
      case Count.Two : return "2";
      case Count.Three : return "3";
      case Count.Four : return "4";
      case Count.FivePlus : return "5+";
    }
  }

  String get numericalName {
    if(name == "Any")return "0+";
    else return name;
  }
}

class PropertyAdSearchFilter {

  static const PriceMin = 0;
  static const PriceMax = 10000000;
  static const PropertySQFTMin = 0;
  static const PropertySQFTMax = 100000;

  ///search key word, could be left empty
  String word;

  AdClass adClass;
  AdType adType;
  AirConditioning airConditioning;
  BasementType basementType;
  ExteriorConstruction construction;
  GarageType garageType;
  HeatSource heatSource;
  HeatType heatType;
  ParkingType parkingType;
  Pool pool;
  PropertyStyle propertyStyle;
  PropertyType propertyType;
  Status status;


  int priceStartingFrom;
  int priceUpTo;
  int propertySizeInSquareFeetAtLeast;
  int propertySizeInSquareFeetAtMost;
  bool onlyFavoriteOnes;
  bool onlyMaps;

  Count bathRoomsCount;
  Count parkingCount;
  Count bedroomsCount;
  Count roomCount;
  Count garageSpacesCount;

  bool get isFiltered{
    return
         adClass!=AdClass.Any
      || adClass != AdClass.Any
      || adType != AdType.Any
      || airConditioning != AirConditioning.Any
      || basementType != BasementType.Any
      || construction != ExteriorConstruction.Any
      || garageType != GarageType.Any
      || heatSource != HeatSource.Any
      || heatType != HeatType.Any
      || parkingType != ParkingType.Any
      || pool != Pool.Any
      || propertyStyle != PropertyStyle.Any
      || propertyType != PropertyType.Any
      || status != Status.Any

      || bathRoomsCount != Count.Any
      || parkingCount != Count.Any
      || bedroomsCount != Count.Any
      || roomCount != Count.Any
      || garageSpacesCount != Count.Any

      || priceStartingFrom != PriceMin
      || priceUpTo != PriceMax
      || propertySizeInSquareFeetAtLeast != PropertySQFTMin
      || propertySizeInSquareFeetAtMost != PropertySQFTMax;
  }

  PropertyAdSearchFilter({
    this.word = "",
    
    this.adClass = AdClass.Any,
    this.adType = AdType.Any,
    this.airConditioning = AirConditioning.Any,
    this.basementType = BasementType.Any,
    this.construction = ExteriorConstruction.Any,
    this.garageType = GarageType.Any,
    this.heatSource = HeatSource.Any,
    this.heatType = HeatType.Any,
    this.parkingType = ParkingType.Any,
    this.pool = Pool.Any,
    this.propertyStyle = PropertyStyle.Any,
    this.propertyType = PropertyType.Any,
    this.status = Status.Any,
    
    this.priceStartingFrom = PriceMin,
    this.priceUpTo = PriceMax,
    this.bedroomsCount = Count.Any,
    this.parkingCount =  Count.Any,
    this.bathRoomsCount =  Count.Any,
    this.roomCount = Count.Any,
    this.garageSpacesCount = Count.Any,
    this.propertySizeInSquareFeetAtLeast = PropertySQFTMin,
    this.propertySizeInSquareFeetAtMost = PropertySQFTMax,
    this.onlyFavoriteOnes = false,
    this.onlyMaps = false
  });


  toString() {
    return 'PropertyAdSearchFilter{word: $word, adClass: $adClass, adType: $adType, airConditioning: $airConditioning, basementType: $basementType, construction: $construction, garageType: $garageType, heatSource: $heatSource, heatType: $heatType, parkingType: $parkingType, pool: $pool, propertyStyle: $propertyStyle, propertyType: $propertyType, priceStartingFrom: $priceStartingFrom, priceUpTo: $priceUpTo, propertySizeInSquareFeetAtLeast: $propertySizeInSquareFeetAtLeast, propertySizeInSquareFeetAtMost: $propertySizeInSquareFeetAtMost, onlyFavoriteOnes: $onlyFavoriteOnes, bathRoomsCount: $bathRoomsCount, parkingCount: $parkingCount, bedroomsCount: $bedroomsCount, roomCount: $roomCount, garageSpacesCount: $garageSpacesCount}';
  }

  bool equals(PropertyAdSearchFilter searchFilter) {

    if(searchFilter == null) {

      return word == ""
              && adClass ==  AdClass.Any
              && adType ==  AdType.Any
              && airConditioning ==  AirConditioning.Any
              && basementType ==  BasementType.Any
              && construction ==  ExteriorConstruction.Any
              && garageType ==  GarageType.Any
              && heatSource ==  HeatSource.Any
              && heatType ==  HeatType.Any
              && parkingType ==  ParkingType.Any
              && pool ==  Pool.Any
              && propertyStyle ==  PropertyStyle.Any
              && propertyType ==  PropertyType.Any
              && status ==  Status.Any

              && priceStartingFrom == PriceMin
              && priceUpTo == PriceMax

              && bedroomsCount == Count.Any
              && parkingCount == Count.Any
              && bathRoomsCount == Count.Any
              && roomCount == Count.Any
              && garageSpacesCount == Count.Any

              && propertySizeInSquareFeetAtLeast == PropertySQFTMin
              && propertySizeInSquareFeetAtMost == PropertySQFTMax

              && onlyFavoriteOnes == false ;
    }

    return word == searchFilter.word
        && adClass == searchFilter.adClass
        && adType == searchFilter.adType
        && airConditioning == searchFilter.airConditioning
        && basementType == searchFilter.basementType
        && construction == searchFilter.construction
        && garageType == searchFilter.garageType
        && heatSource == searchFilter.heatSource
        && heatType == searchFilter.heatType
        && parkingType == searchFilter.parkingType
        && pool == searchFilter.pool
        && propertyStyle == searchFilter.propertyStyle
        && propertyType == searchFilter.propertyType
        && status == searchFilter.status

        && priceStartingFrom == searchFilter.priceStartingFrom
        && priceUpTo == searchFilter.priceUpTo

        && bedroomsCount == searchFilter.bedroomsCount
        && parkingCount == searchFilter.parkingCount
        && bathRoomsCount == searchFilter.bathRoomsCount
        && roomCount == searchFilter.roomCount
        && garageSpacesCount == searchFilter.garageSpacesCount

        && propertySizeInSquareFeetAtLeast == searchFilter.propertySizeInSquareFeetAtLeast
        && propertySizeInSquareFeetAtMost == searchFilter.propertySizeInSquareFeetAtMost

        && onlyFavoriteOnes == searchFilter.onlyFavoriteOnes
        && onlyMaps == searchFilter.onlyMaps;
  }

  PropertyAdSearchFilter copy() =>PropertyAdSearchFilter(
    word:word,

    adClass:adClass ,
    adType:adType ,
    airConditioning:airConditioning ,
    basementType:basementType ,
    construction:construction ,
    garageType:garageType ,
    heatSource:heatSource ,
    heatType:heatType ,
    parkingType:parkingType ,
    pool:pool ,
    propertyStyle:propertyStyle ,
    propertyType:propertyType ,
    status: status,

    priceStartingFrom:priceStartingFrom,
    priceUpTo:priceUpTo,

    bedroomsCount:bedroomsCount,
    parkingCount:parkingCount,
    bathRoomsCount:bathRoomsCount,
    roomCount:roomCount,
    garageSpacesCount: garageSpacesCount,

    propertySizeInSquareFeetAtLeast:propertySizeInSquareFeetAtLeast,
    propertySizeInSquareFeetAtMost:propertySizeInSquareFeetAtMost,

    onlyFavoriteOnes:onlyFavoriteOnes,
    onlyMaps: onlyMaps,
  );

  void load(PropertyAdSearchFilter f)
  {
    this.word = f.word;
    this.adClass = f.adClass;
    this.adType = f.adType;
    this.airConditioning = f.airConditioning;
    this.basementType = f.basementType;
    this.construction = f.construction;
    this.garageType = f.garageType;
    this.heatSource = f.heatSource;
    this.heatType = f.heatType;
    this.parkingType = f.parkingType;
    this.pool = f.pool;
    this.propertyStyle = f.propertyStyle;
    this.propertyType = f.propertyType;
    this.status = f.status;
    this.priceStartingFrom = f.priceStartingFrom;
    this.priceUpTo = f.priceUpTo;
    this.propertySizeInSquareFeetAtLeast = f.propertySizeInSquareFeetAtLeast;
    this.propertySizeInSquareFeetAtMost = f.propertySizeInSquareFeetAtMost;
    this.onlyFavoriteOnes = f.onlyFavoriteOnes;
    this.onlyMaps = f.onlyMaps;
    this.bathRoomsCount = f.bathRoomsCount;
    this.parkingCount = f.parkingCount;
    this.bedroomsCount = f.bedroomsCount;
    this.roomCount = f.roomCount;
    this.garageSpacesCount = f.garageSpacesCount;
  }
}
