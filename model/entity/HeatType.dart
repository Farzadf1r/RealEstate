

enum HeatType
{
  Any,
  NotSpecified,
  Unknown,

  Forced_Air,
  Water,
  Radiant,
  Heat_Pump,
  Baseboard,
  Fan_Coil,
  Hot_Water,
  Water_Radiators,
  Other,
  None,
}

HeatType valueOfHeatType(String name)
{
  try{
    return HeatType.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return HeatType.Unknown;
  }
}

extension PropertyTypeExtension on HeatType {

  String get name {

    switch(this)
    {
      case HeatType.Forced_Air  : return "Forced Air";
      case HeatType.Water  : return "Water";
      case HeatType.Radiant  : return "Radiant";
      case HeatType.Heat_Pump  : return "Heat Pump";
      case HeatType.Baseboard  : return "Baseboard";
      case HeatType.Fan_Coil  : return "Fan Coil";
      case HeatType.Hot_Water  : return "Hot Water";
      case HeatType.Water_Radiators  : return "Water Radiators";
      case HeatType.Other  : return "Other";
      case HeatType.None  : return "None";

      case HeatType.Any  : return "Any";
      case HeatType.NotSpecified  : return "NotSpecified";
      case HeatType.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}