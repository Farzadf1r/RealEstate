

enum PropertyStyle
{
  Any,
  NotSpecified,
  Unknown,

  _2_Storey,
  _3_Storey,
  Apartment,
  Bachelor_Studio,
  Bungaloft,
  Bungalow,
  Loft,
  Multi_Level,
  Stacked_Townhouse,
  _1_1_2_Storey,
  _2_1_2_Storey,
  Backsplit_3_Level,
  Backsplit_4_Level,
  Backsplit_5_Level,
  Bungalow_Raised,
  Other,
  Sidesplit_3_Level,
  Sidesplit_4_Level,
  Sidesplit_5_Level,
  Industrial_Loft,
}

PropertyStyle valueOfPropertyStyle(String name)
{
  try{
    return PropertyStyle.values.firstWhere((element) =>element.name == name);
  }catch(e)
  {
    return PropertyStyle.Unknown;
  }
}

extension PropertyTypeExtension on PropertyStyle {

  String get name {

    switch(this)
    {
      case PropertyStyle._2_Storey  : return "2-Storey";
      case PropertyStyle._3_Storey  : return "3-Storey";
      case PropertyStyle.Apartment  : return "Apartment";
      case PropertyStyle.Bachelor_Studio  : return "Bachelor/Studio";
      case PropertyStyle.Bungaloft  : return "Bungaloft";
      case PropertyStyle.Bungalow  : return "Bungalow";
      case PropertyStyle.Loft  : return "Loft";
      case PropertyStyle.Multi_Level  : return "Multi-Level";
      case PropertyStyle.Stacked_Townhouse  : return "Stacked Townhouse";
      case PropertyStyle._1_1_2_Storey  : return "1 1/2 Storey";
      case PropertyStyle._2_1_2_Storey  : return "2 1/2 Storey";
      case PropertyStyle.Backsplit_3_Level  : return "Backsplit 3 Level";
      case PropertyStyle.Backsplit_4_Level  : return "Backsplit 4 Level";
      case PropertyStyle.Backsplit_5_Level  : return "Backsplit 5 Level";
      case PropertyStyle.Bungalow_Raised  : return "Bungalow-Raised";
      case PropertyStyle.Other  : return "Other";
      case PropertyStyle.Sidesplit_3_Level  : return "Sidesplit 3 Level";
      case PropertyStyle.Sidesplit_4_Level  : return "Sidesplit 4 Level";
      case PropertyStyle.Sidesplit_5_Level  : return "Sidesplit 5 Level";
      case PropertyStyle.Industrial_Loft  : return "Industrial Loft";

      case PropertyStyle.Any  : return "Any";
      case PropertyStyle.NotSpecified  : return "NotSpecified";
      case PropertyStyle.Unknown : return "Unknown";
    }

    throw Exception("handle ${this.toString()} in the switch case");
  }
}