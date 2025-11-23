

enum ParkingType
{
  Any,
  NotSpecified,
  Unknown,

  None,
  Exclusive,
  Owned,
  Common,
  Rental,
  Stacked,
  Compact,
}

ParkingType valueOfParkingType(String name)
{
  try{
    return ParkingType.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return ParkingType.Unknown;
  }
}

extension PropertyTypeExtension on ParkingType {

  String get name {

    switch(this)
    {
      case ParkingType.None  : return "None";
      case ParkingType.Exclusive  : return "Exclusive";
      case ParkingType.Owned  : return "Owned";
      case ParkingType.Common  : return "Common";
      case ParkingType.Rental  : return "Rental";
      case ParkingType.Stacked  : return "Stacked";
      case ParkingType.Compact  : return "Compact";

      case ParkingType.Any  : return "Any";
      case ParkingType.NotSpecified  : return "NotSpecified";
      case ParkingType.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}