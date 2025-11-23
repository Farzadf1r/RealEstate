

enum Status
{
  Any,
  NotSpecified,
  Unknown,

  New,
  Leased,
  LeasedConditionally,
  PriceChange,
  Sold,
  SoldConditionally,
  DealFellThrough,
  Extended,
  Terminated,
  Expired,
  Suspended,
}

Status valueOfStatus(String name)
{
  try{
    return Status.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return Status.Unknown;
  }
}

extension PropertyTypeExtension on Status {

  String get name {

    switch(this)
    {
      case Status.Suspended  : return "Suspended";
      case Status.Expired  : return "Expired";
      case Status.Sold  : return "Sold";
      case Status.DealFellThrough  : return "Deal Fell Through";
      case Status.SoldConditionally  : return "Sold Conditionally";
      case Status.LeasedConditionally  : return "Leased Conditionally";
      case Status.PriceChange  : return "Price Change";
      case Status.Extended  : return "Extended";
      case Status.Terminated  : return "Terminated";
      case Status.Leased  : return "Leased";
      case Status.New  : return "New";

      case Status.Any  : return "Any";
      case Status.NotSpecified  : return "NotSpecified";
      case Status.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}