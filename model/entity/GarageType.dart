

enum GarageType
{
  Any,
  NotSpecified,
  Unknown,

Underground,
None,
Attached,
Built_In,
Surface,
Detached,
Carport,
Other,
Outside_Surface,
Public,
Plaza,
Visitor,
Reserved_Assigned,
Street,
Boulevard,
Pay,
Double_Detached,
Covered,
In_Out,
}

GarageType valueOfGarageType(String name)
{
  try{
    return GarageType.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return GarageType.Unknown;
  }
}

extension PropertyTypeExtension on GarageType {

  String get name {

    switch(this)
    {
      case GarageType.Underground  : return "Underground" ;
      case GarageType.None  : return "None" ;
      case GarageType.Attached  : return "Attached" ;
      case GarageType.Built_In  : return "Built-In" ;
      case GarageType.Surface  : return "Surface" ;
      case GarageType.Detached  : return "Detached" ;
      case GarageType.Carport  : return "Carport" ;
      case GarageType.Other  : return "Other" ;
      case GarageType.Outside_Surface  : return "Outside/Surface" ;
      case GarageType.Public  : return "Public" ;
      case GarageType.Plaza  : return "Plaza" ;
      case GarageType.Visitor  : return "Visitor" ;
      case GarageType.Reserved_Assigned  : return "Reserved/Assigned" ;
      case GarageType.Street  : return "Street" ;
      case GarageType.Boulevard  : return "Boulevard" ;
      case GarageType.Pay  : return "Pay" ;
      case GarageType.Double_Detached  : return "Double Detached" ;
      case GarageType.Covered  : return "Covered" ;
      case GarageType.In_Out  : return "In/Out" ;

      case GarageType.Any  : return "Any";
      case GarageType.NotSpecified  : return "NotSpecified";
      case GarageType.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}