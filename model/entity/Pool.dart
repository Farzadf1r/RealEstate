

enum Pool
{
  Any,
  NotSpecified,
  Unknown,

  None,
  Inground,
  Indoor,
  Above_Ground,
}

Pool valueOfPool(String name)
{
  try{
    return Pool.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return Pool.Unknown;
  }
}

extension PropertyTypeExtension on Pool {

  String get name {

    switch(this)
    {
      case Pool.None  : return "None";
      case Pool.Inground  : return "Inground";
      case Pool.Indoor  : return "Indoor";
      case Pool.Above_Ground  : return "Above Ground";

      case Pool.Any  : return "Any";
      case Pool.NotSpecified  : return "NotSpecified";
      case Pool.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}