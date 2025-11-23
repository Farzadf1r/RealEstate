

enum PropertyType
{
  Any,
  NotSpecified,
  Unknown,

  Attached_Row_Street_Townhouse,
  Cottage,
  Detached,
  Duplex,
  Farm,
  Fourplex,
  Link,
  Mobile_Trailer,
  Multiplex,
  Rural_Residential,
  Semi_Detached,
  Store_with_Apt_Office,
  Triplex,
  Vacant_Land,
  Common_Element_Condo,
  Condo_Apartment,
  Condo_Townhouse,
  Co_Op_Apartment,
  Co_Ownership_Apartment,
  Detached_Condo,
  Leasehold_Condo,
  Locker,
  Other,
  Parking_Space,
  Detached_with_Common_Elements,
  Phased_Condo,
  Semi_Detached_Condo,
  Time_Share,
  Vacant_Land_Condo,
  Industrial,
  Upper_Level,
  Room,
  Lower_Level,
  Shared_Room,
  Sale_Of_Business,
  Commercial_Retail,
  Office,
  Land,
  Investment,
}

PropertyType valueOfPropertyType(String name)
{
  try{
    return PropertyType.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return PropertyType.Unknown;
  }
}

extension PropertyTypeExtension on PropertyType {

  String get name {

    switch(this)
    {
      case PropertyType.Attached_Row_Street_Townhouse  : return "Attached/Row/Street Townhouse";
      case PropertyType.Cottage  : return "Cottage";
      case PropertyType.Detached  : return "Detached";
      case PropertyType.Duplex  : return "Duplex";
      case PropertyType.Farm  : return "Farm";
      case PropertyType.Fourplex  : return "Fourplex";
      case PropertyType.Link  : return "Link";
      case PropertyType.Mobile_Trailer  : return "Mobile/Trailer";
      case PropertyType.Multiplex  : return "Multiplex";
      case PropertyType.Rural_Residential  : return "Rural Residential";
      case PropertyType.Semi_Detached  : return "Semi-Detached";
      case PropertyType.Store_with_Apt_Office  : return "Store with Apt/Office";
      case PropertyType.Triplex  : return "Triplex";
      case PropertyType.Vacant_Land  : return "Vacant Land";
      case PropertyType.Common_Element_Condo  : return "Common Element Condo";
      case PropertyType.Condo_Apartment  : return "Condo Apartment";
      case PropertyType.Condo_Townhouse  : return "Condo Townhouse";
      case PropertyType.Co_Op_Apartment  : return "Co-Op Apartment";
      case PropertyType.Co_Ownership_Apartment  : return "Co-Ownership Apartment";
      case PropertyType.Detached_Condo  : return "Detached Condo";
      case PropertyType.Leasehold_Condo  : return "Leasehold Condo";
      case PropertyType.Locker  : return "Locker";
      case PropertyType.Other  : return "Other";
      case PropertyType.Parking_Space  : return "Parking Space";
      case PropertyType.Detached_with_Common_Elements  : return "Detached with Common Elements";
      case PropertyType.Phased_Condo  : return "Phased Condo";
      case PropertyType.Semi_Detached_Condo  : return "Semi-Detached Condo";
      case PropertyType.Time_Share  : return "Time Share";
      case PropertyType.Vacant_Land_Condo  : return "Vacant Land Condo";
      case PropertyType.Industrial  : return "Industrial";
      case PropertyType.Upper_Level  : return "Upper Level";
      case PropertyType.Room  : return "Room";
      case PropertyType.Lower_Level  : return "Lower Level";
      case PropertyType.Shared_Room  : return "Shared Room";
      case PropertyType.Sale_Of_Business  : return "Sale Of Business";
      case PropertyType.Commercial_Retail  : return "Commercial/Retail";
      case PropertyType.Office  : return "Office";
      case PropertyType.Land  : return "Land";
      case PropertyType.Investment  : return "Investment";

      case PropertyType.Any  : return "Any";
      case PropertyType.NotSpecified  : return "NotSpecified";
      case PropertyType.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}