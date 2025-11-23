

enum BasementType
{
  Any,
  NotSpecified,
  Unknown,

  Apartment,
  Crawl_Space,
  Finished,
  Finished_with_Walk_Out,
  Full,
  Half,
  None,
  Other,
  Partial_Basement,
  Partially_Finished,
  Separate_Entrance,
  Unfinished,
  Walk_Out,
  Walk_Up,
}


BasementType valueOfBasementType(String name)
{
  try{
    return BasementType.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return BasementType.Unknown;
  }
}

extension PropertyTypeExtension on BasementType {

  String get name {

    switch(this)
    {
      case BasementType.Apartment  : return "Apartment";
      case BasementType.Crawl_Space  : return "Crawl Space";
      case BasementType.Finished  : return "Finished";
      case BasementType.Finished_with_Walk_Out  : return "Finished with Walk-Out";
      case BasementType.Full  : return "Full";
      case BasementType.Half  : return "Half";
      case BasementType.None  : return "None";
      case BasementType.Other  : return "Other";
      case BasementType.Partial_Basement  : return "Partial Basement";
      case BasementType.Partially_Finished  : return "Partially Finished";
      case BasementType.Separate_Entrance  : return "Separate Entrance";
      case BasementType.Unfinished  : return "Unfinished";
      case BasementType.Walk_Out  : return "Walk-Out";
      case BasementType.Walk_Up  : return "Walk-Up";

      case BasementType.Any  : return "Any";
      case BasementType.NotSpecified  : return "NotSpecified";
      case BasementType.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}