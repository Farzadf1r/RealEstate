

enum AirConditioning
{
  Any,
  NotSpecified,
  Unknown,

  Central_Air,
  None,
  Other,
  Wall_Unit,
  Window_Unit,
}

AirConditioning valueOfAirConditioning(String name)
{
  try{
    return AirConditioning.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return AirConditioning.Unknown;
  }
}

extension PropertyTypeExtension on AirConditioning {

  String get name {

    switch(this)
    {
      case AirConditioning.Central_Air : return "Central Air";
      case AirConditioning.None : return "None";
      case AirConditioning.Other : return "Other";
      case AirConditioning.Wall_Unit : return "Wall Unit";
      case AirConditioning.Window_Unit : return "Window Unit";

      case AirConditioning.Any  : return "Any";
      case AirConditioning.NotSpecified  : return "NotSpecified";
      case AirConditioning.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}