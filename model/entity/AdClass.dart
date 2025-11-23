

enum AdClass
{
  Any,
  NotSpecified,
  Unknown,

  Commercial,
  Condo,
  Residential,
}

AdClass valueOfAdClass(String name)
{
  try{
    return AdClass.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return AdClass.Unknown;
  }
}

extension PropertyTypeExtension on AdClass {

  String get name {

    switch(this)
    {
      case AdClass.Commercial  : return "Commercial";
      case AdClass.Condo  : return "Condo";
      case AdClass.Residential  : return "Residential";

      case AdClass.Any  : return "Any";
      case AdClass.NotSpecified  : return "NotSpecified";
      case AdClass.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}