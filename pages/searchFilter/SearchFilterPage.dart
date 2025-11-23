import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';
import 'package:realestate_app/customWidget/Util.dart';
import 'package:realestate_app/customWidget/custom_widgets.dart';
import 'package:realestate_app/model/entity/AdClass.dart';
import 'package:realestate_app/model/entity/AdType.dart';
import 'package:realestate_app/model/entity/AirConditioning.dart';
import 'package:realestate_app/model/entity/BasementType.dart';
import 'package:realestate_app/model/entity/ExteriorConstruction.dart';
import 'package:realestate_app/model/entity/GarageType.dart';
import 'package:realestate_app/model/entity/HeatSource.dart';
import 'package:realestate_app/model/entity/HeatType.dart';
import 'package:realestate_app/model/entity/ParkingType.dart';
import 'package:realestate_app/model/entity/Pool.dart';
import 'package:realestate_app/model/entity/PropertyAdSearchFilter.dart';
import 'package:realestate_app/model/entity/PropertyStyle.dart';
import 'package:realestate_app/model/entity/PropertyType.dart';
import 'package:realestate_app/model/entity/Status.dart';

typedef SearchFilterChangedListener = void Function(PropertyAdSearchFilter filter);

class SearchFilterPage extends StatefulWidget {
  final PropertyAdSearchFilter initialFilter;
  final SearchFilterChangedListener listener;
  final bool popPageWhenDone;

  SearchFilterPage(
      {this.initialFilter,
      this.listener,this.popPageWhenDone = true})
  {
    if(initialFilter == null)
      throw Exception("initial filter cannot be ");
  }

  createState() => _SearchFilterPageState();
}






class _SearchFilterPageState extends State<SearchFilterPage> {

  RangeValues _selectedPropertySizeRange;
  RangeValues _selectedPriceRange;
  PropertyAdSearchFilter _filter;

  Map<String, bool> _selectedAdClasses;
  Map<String, bool> _selectedAdTypes;
  Map<String, bool> _selectedAirConditioning;
  Map<String, bool> _selectedBasementTypes;
  Map<String, bool> _selectedExteriorConstructions;
  Map<String, bool> _selectedGarageTypes;
  Map<String, bool> _selectedHeatSources;
  Map<String, bool> _selectedHeatTypes;
  Map<String, bool> _selectedParkingTypes;
  Map<String, bool> _selectedPools;
  Map<String, bool> _selectedPropertyStyles;
  Map<String, bool> _selectedPropertyTypes;
  Map<String, bool> _selectedStatus;


  Map<String, bool> _selectedBedrooms ;
  Map<String, bool> _selectedBathrooms ;
  Map<String, bool> _selectedParking ;
  Map<String, bool> _selectedRooms ;
  Map<String, bool> _selectedGarageSpaces ;

  PropertyAdSearchFilter get _adSearchFilterBasedOnCurrentUIValues {

    return PropertyAdSearchFilter(
      priceStartingFrom: _selectedPriceRange.start.round(),
      priceUpTo: _selectedPriceRange.end.round(),
      propertySizeInSquareFeetAtLeast: _selectedPropertySizeRange.start.round(),
      propertySizeInSquareFeetAtMost: _selectedPropertySizeRange.end.round(),

      bathRoomsCount: valueOfCount(_selectedBathrooms.filter<String,bool>((entry) => entry.value).first.key),
      bedroomsCount: valueOfCount(_selectedBedrooms.filter<String,bool>((entry) => entry.value).first.key),
      parkingCount: valueOfCount(_selectedParking.filter<String,bool>((entry) => entry.value).first.key),
      roomCount: valueOfCount(_selectedRooms.filter<String,bool>((entry) => entry.value).first.key),
      garageSpacesCount: valueOfCount(_selectedGarageSpaces.filter<String,bool>((entry) => entry.value).first.key),

      adClass: valueOfAdClass(_selectedAdClasses.filter<String,bool>((entry) => entry.value).first.key),
      adType: valueOfAdType(_selectedAdTypes.filter<String,bool>((entry) => entry.value).first.key),
      airConditioning: valueOfAirConditioning(_selectedAirConditioning.filter<String,bool>((entry) => entry.value).first.key),
      basementType: valueOfBasementType(_selectedBasementTypes.filter<String,bool>((entry) => entry.value).first.key),
      construction: valueOfExteriorConstruction(_selectedExteriorConstructions.filter<String,bool>((entry) => entry.value).first.key),
      garageType: valueOfGarageType(_selectedGarageTypes.filter<String,bool>((entry) => entry.value).first.key),
      heatSource: valueOfHeatSource(_selectedHeatSources.filter<String,bool>((entry) => entry.value).first.key),
      heatType: valueOfHeatType(_selectedHeatTypes.filter<String,bool>((entry) => entry.value).first.key),
      parkingType: valueOfParkingType(_selectedParkingTypes.filter<String,bool>((entry) => entry.value).first.key),
      pool: valueOfPool(_selectedPools.filter<String,bool>((entry) => entry.value).first.key),
      propertyStyle: valueOfPropertyStyle(_selectedPropertyStyles.filter<String,bool>((entry) => entry.value).first.key),
      propertyType: valueOfPropertyType(_selectedPropertyTypes.filter<String,bool>((entry) => entry.value).first.key),
      status: valueOfStatus(_selectedStatus.filter<String,bool>((entry) => entry.value).first.key),
    );
  }

  initState() {
    super.initState();
    _filter = widget.initialFilter;
    _reinitializeStateBasedOnWidget();
  }

  didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _filter = widget.initialFilter;
    _reinitializeStateBasedOnWidget();
  }

  _reinitializeStateBasedOnWidget() {
    var priceRangeStart =  _filter.priceStartingFrom.toDouble();
    var priceRangeEnd =  _filter.priceUpTo.toDouble();
    var propertyRangeStart =  _filter.propertySizeInSquareFeetAtLeast.toDouble();
    var propertyRangeEnd =  _filter.propertySizeInSquareFeetAtMost.toDouble();

    _selectedPriceRange = RangeValues(priceRangeStart, priceRangeEnd);
    _selectedPropertySizeRange = RangeValues(propertyRangeStart, propertyRangeEnd);

     _selectedAdClasses =AdClass.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedAdTypes =AdType.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedAirConditioning =AirConditioning.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedBasementTypes =BasementType.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedExteriorConstructions =ExteriorConstruction.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedGarageTypes =GarageType.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedHeatSources =HeatSource.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedHeatTypes =HeatType.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedParkingTypes =ParkingType.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedPools =Pool.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedPropertyStyles =PropertyStyle.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedPropertyTypes =PropertyType.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();
     _selectedStatus =Status.values.where((e)=>_filterEnumValues(e.name)).map((e) => MapEntry(e.name,false)).toMap();

     _selectedBedrooms= Count.values.map((e) => MapEntry(e.name,false)).toMap();
     _selectedBathrooms= Count.values.map((e) => MapEntry(e.name,false)).toMap();
     _selectedParking= Count.values.map((e) => MapEntry(e.name,false)).toMap();
     _selectedRooms= Count.values.map((e) => MapEntry(e.name,false)).toMap();
     _selectedGarageSpaces= Count.values.map((e) => MapEntry(e.name,false)).toMap();


    _selectedAdClasses[_filter.adClass.name] = true;
    _selectedAdTypes[_filter.adType.name] = true;
    _selectedAirConditioning[_filter.airConditioning.name] = true;
    _selectedBasementTypes[_filter.basementType.name] = true;
    _selectedExteriorConstructions[_filter.construction.name] = true;
    _selectedGarageTypes[_filter.garageType.name] = true;
    _selectedHeatSources[_filter.heatSource.name] = true;
    _selectedHeatTypes[_filter.heatType.name] = true;
    _selectedParkingTypes[_filter.parkingType.name] = true;
    _selectedPools[_filter.pool.name] = true;
    _selectedPropertyStyles[_filter.propertyStyle.name] = true;
    _selectedPropertyTypes[_filter.propertyType.name] = true;
    _selectedStatus[_filter.status.name] = true;

    _selectedBedrooms[_filter.bedroomsCount.name] = true;
    _selectedBathrooms[_filter.bathRoomsCount.name] = true;
    _selectedParking[_filter.parkingCount.name] = true;
    _selectedRooms[_filter.roomCount.name] = true;
    _selectedGarageSpaces[_filter.garageSpacesCount.name] = true;
  }

  bool _filterEnumValues<T>(String name)
  {
    return name != "Unknown" && name != "NotSpecified";

  }

  _callChangeListener()
  {
    if(widget.listener!=null)
      widget.listener(_adSearchFilterBasedOnCurrentUIValues);
  }

  build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _createActionBar(),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: _createSearchContent(),
          )),
          SizedBox(
            height: 10,
          ),
          _createShowButton(context)
        ],
      ),
    );
  }

  _createActionBar() => Stack(
    children:[
      IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.blueAccent),
      Row(
          children: [
            SizedBox(
              width: 80,
            ),
            Spacer(
              flex: 1,
            ),
            halveticaNormalText("Filter", color: Color(0xff5e5e5e), fontSize: 14),
            Spacer(
              flex: 1,
            ),
            _createResetButton(),
          ],
        ),
    ]
  );

  _createShowButton(context) => createRoundedCornerRaisedButton("Show Properties",
      fontSize: 13, height: 40, onPress: () {
    _callChangeListener();

      if(widget.popPageWhenDone)
        Navigator.pop(context,_adSearchFilterBasedOnCurrentUIValues);
  });

  _createResetButton() => createRoundedCornerRaisedButton("Reset", onPress: () {
        _filter = PropertyAdSearchFilter(word:_filter.word,onlyFavoriteOnes: _filter.onlyFavoriteOnes);
        _reinitializeStateBasedOnWidget();
        setState(() {});
      },
          shapeColor: Color(0xffef5353),
          textColor: Colors.white,
          minWidth: 80,
          height: 25,
          cornerRadius: 5);

  Column _createSearchContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        _createSelectableProperty("Class",_selectedAdClasses)
            .concat(_createSelectableProperty("Type",_selectedAdTypes),)
            .concat(_createSelectableProperty("Property Type",_selectedPropertyTypes),)
            .concat(_createSelectableProperty("Property Style",_selectedPropertyStyles),)
            .concat( _createSelectableProperty("Status",_selectedStatus),)
            .concat(
          [
            _createSliderTitle('Price', _selectedPriceRange, decorator: (v) => "${decorateWithThousandSeparator(v)}", prefix: "\$ "),
            SizedBox(height: 10.0),
            _createPriceSlider(),
            SizedBox(height: 35.0),
            _createSliderTitle('Property Size', _selectedPropertySizeRange, suffix: " sqft"),
            SizedBox(height: 10.0),
            _createPropertySizeSlider(),
            SizedBox(height: 35.0),
          ]
        ).concat(_createAllSelectableProperties())
      );

  List<Widget> _createAllSelectableProperties()
  {
    return <List<Widget>>[

      _createSelectableProperty("Bedrooms",_selectedBedrooms),
      _createSelectableProperty("Bathrooms",_selectedBathrooms),
      _createSelectableProperty("Parking",_selectedParking),
      _createSelectableProperty("Rooms",_selectedRooms),
      _createSelectableProperty("Garage Spaces",_selectedGarageSpaces),

     // _createSelectableProperty("Basement Type",_selectedBasementTypes),
     // _createSelectableProperty("Exterior Construction",_selectedExteriorConstructions),
     // _createSelectableProperty("Garage Type",_selectedGarageTypes),
     // _createSelectableProperty("Parking Type",_selectedParkingTypes),
     // _createSelectableProperty("Air Conditioning",_selectedAirConditioning),
     // _createSelectableProperty("Heat Source",_selectedHeatSources),
     // _createSelectableProperty("Heat Type",_selectedHeatTypes),
     // _createSelectableProperty("Pool",_selectedPools),


    ].flatList();
  }

  List<Widget> _createSelectableProperty(String title,Map<String,bool> values)
  {
    return [
      _createTitle(title),
      SizedBox(height: 10.0),
      RowOfToggleButtons(
        values,
        singleSelect: true,
        listener: (String buttonToggledThisTime, bool status,
            Map<String, bool> allButtonsStatus) {
          values[buttonToggledThisTime] = status;
        },
      ),
      SizedBox(height: 35.0),
    ];
  }

  CustomSlider _createPropertySizeSlider() {
    return CustomSlider(
      PropertyAdSearchFilter.PropertySQFTMin.toDouble(),
      PropertyAdSearchFilter.PropertySQFTMax.toDouble(),
      100000,
      initialSelectedRange: _selectedPropertySizeRange,
      selectedRangeChangedListener: (changedRange) {
        _selectedPropertySizeRange = changedRange;
        setState(() {});
      },
    );
  }

  CustomSlider _createPriceSlider() {
    return CustomSlider(
      PropertyAdSearchFilter.PriceMin.toDouble(),
      PropertyAdSearchFilter.PriceMax.toDouble(),
      10000000,
      initialSelectedRange: _selectedPriceRange,
      selectedRangeChangedListener: (changedRange) {
        _selectedPriceRange = changedRange;
        setState(() {});

      },
    );
  }

  _createTitle(String title) =>
      halveticaBoldText(title, color: Color(0xff5e5e5e), fontSize: 15);

  _createSliderTitle(String title, RangeValues selectedRange,
      {String Function(String) decorator, String prefix ="", String suffix=""}) {
    var start = decorator == null
        ? "${selectedRange.start.round()}"
        : decorator("${selectedRange.start.round()}");
    var end = decorator == null
        ? "${selectedRange.end.round()}"
        : decorator("${selectedRange.end.round()}");

    return Row(
      children: [
        _createTitle(title),
        Spacer(),
        halveticaBoldText("$prefix$start - $end$suffix",
            fontSize: 10, color: Color(0xff498ed5))
      ],
    );
  }
}
