

enum AdType
{
  Any,
  NotSpecified,
  Unknown,

  Lease,
  Sale,

}

AdType valueOfAdType(String name)
{
  try{
    return AdType.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return AdType.Unknown;
  }
}

extension PropertyTypeExtension on AdType {

  String get name {

    switch(this)
    {
      case AdType.Lease : return "Lease";
      case AdType.Sale : return "Sale";

      case AdType.Any  : return "Any";
      case AdType.NotSpecified  : return "NotSpecified";
      case AdType.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}