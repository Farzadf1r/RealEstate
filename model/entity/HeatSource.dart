

enum HeatSource
{
  Any,
  NotSpecified,
  Unknown,

  Electric,
  Gas,
  Propane,
  Other,
  None,
  Oil,
  Ground_Source,
  Solar,
  Wood,
}

HeatSource valueOfHeatSource(String name)
{
  try{
    return HeatSource.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return HeatSource.Unknown;
  }
}

extension PropertyTypeExtension on HeatSource {

  String get name {

    switch(this)
    {
      case HeatSource.Electric  : return "Electric";
      case HeatSource.Gas  : return "Gas";
      case HeatSource.Propane  : return "Propane";
      case HeatSource.Other  : return "Other";
      case HeatSource.None  : return "None";
      case HeatSource.Oil  : return "Oil";
      case HeatSource.Ground_Source  : return "Ground Source";
      case HeatSource.Solar  : return "Solar";
      case HeatSource.Wood  : return "Wood";


      case HeatSource.Any  : return "Any";
      case HeatSource.NotSpecified  : return "NotSpecified";
      case HeatSource.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}