

enum ExteriorConstruction
{
  Any,
  NotSpecified,
  Unknown,

  Aluminum_Siding,
  Board_Batten,
  Brick,
  Brick_Front,
  Concrete,
  Insulbrick,
  Log,
  Metal_Steel_Siding,
  Other,
  Shingle,
  Stone,
  Stucco_Plaster,
  Vinyl_Siding,
  Wood,
  None,
}

ExteriorConstruction valueOfExteriorConstruction(String name)
{
  try{
    return ExteriorConstruction.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return ExteriorConstruction.Unknown;
  }
}

extension PropertyTypeExtension on ExteriorConstruction {

  String get name {

    switch(this)
    {
      case ExteriorConstruction. Aluminum_Siding : return "Aluminum Siding";
      case ExteriorConstruction. Board_Batten : return "Board & Batten";
      case ExteriorConstruction. Brick : return "Brick";
      case ExteriorConstruction. Brick_Front : return "Brick Front";
      case ExteriorConstruction. Concrete : return "Concrete";
      case ExteriorConstruction. Insulbrick : return "Insulbrick";
      case ExteriorConstruction. Log : return "Log";
      case ExteriorConstruction. Metal_Steel_Siding : return "Metal/Steel Siding";
      case ExteriorConstruction. Other : return "Other";
      case ExteriorConstruction. Shingle : return "Shingle";
      case ExteriorConstruction. Stone : return "Stone";
      case ExteriorConstruction. Stucco_Plaster : return "Stucco (Plaster)";
      case ExteriorConstruction. Vinyl_Siding : return "Vinyl Siding";
      case ExteriorConstruction. Wood : return "Wood";
      case ExteriorConstruction. None : return "None";

      case ExteriorConstruction.Any  : return "Any";
      case ExteriorConstruction.NotSpecified  : return "NotSpecified";
      case ExteriorConstruction.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}