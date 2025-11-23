import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:realestate_app/customWidget/general/FutureWidget.dart';
import 'package:realestate_app/customWidget/general/PercentageWidget.dart';
import 'package:realestate_app/customWidget/general/Toast.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';
import 'package:realestate_app/customWidget/Util.dart';
import 'package:realestate_app/customWidget/blocModelProvider/ModelProvidedState.dart';
import 'package:realestate_app/model/entity/AdClass.dart';
import 'package:realestate_app/model/entity/AdType.dart';
import 'package:realestate_app/model/entity/Agent.dart';
import 'package:realestate_app/model/entity/PropertyAd.dart';
import 'package:realestate_app/model/entity/Status.dart';
import 'package:realestate_app/pages/propertyDetails/PropertyDetailsModel.dart';
import 'package:flutter_svg/svg.dart';

import 'package:realestate_app/model/entity/AirConditioning.dart';
import 'package:realestate_app/model/entity/BasementType.dart';
import 'package:realestate_app/model/entity/ExteriorConstruction.dart';
import 'package:realestate_app/model/entity/GarageType.dart';
import 'package:realestate_app/model/entity/HeatSource.dart';
import 'package:realestate_app/model/entity/HeatType.dart';
import 'package:realestate_app/model/entity/ParkingType.dart';
import 'package:realestate_app/model/entity/Pool.dart';
import 'package:realestate_app/model/entity/PropertyType.dart';
import 'package:realestate_app/model/entity/PropertyStyle.dart';
import 'package:realestate_app/pages/Router.dart';


import 'ImagePager.dart';

class PropertyDetailsPage extends StatefulWidget {
  final PropertyAd _propertyAd;
  final void Function(PropertyAd) modelChangedCallback;

  const PropertyDetailsPage(this._propertyAd, {this.modelChangedCallback});

  State<StatefulWidget> createState() => PropertyDetailsPageState();
}

class PropertyDetailsPageState
    extends ModelProvidedState<PropertyDetailsPage, PropertyDetailsModel> {
  String get modelId => widget._propertyAd.id;
  get modelArgument => widget._propertyAd;

  void eventReceived(String eventName, data) {
    if (widget.modelChangedCallback != null && model.propertyAd != null)
      widget.modelChangedCallback(model.propertyAd);

    switch (eventName) {
      case PropertyDetailsModel.favoriteToggleErrorMessagesEvent:
      case PropertyDetailsModel.fetchErrorMessagesEvent:
      case PropertyDetailsModel.contactErrorMessagesEvent:
        toast(data, context);
        break;
      case PropertyDetailsModel.userWasAnonymousErrorMessagesEvent:
        bringUpLoginDialog(context);
    }
  }

  buildContent(BuildContext context) {
    if (!model.propertyIsFetched) {
      if (!model.isLoading)
        return createReloadModelWidget();
      else
        return Container();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
              color: Colors.blueAccent
          ),
        title: Row(
          children: [
            Flexible(
              flex:1,
              child: _createBackArrowButton(context),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex:4,
                child: Column(children: [
                  _createLogo("images/houselogiqsmall.png",30),
                  Text("RE/MAX Hallmark Group of Companies*",
                      style: TextStyle(color: Colors.black,fontSize: 9))
                ],)
            )
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  createTopSlider(context),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        createPriceRow(context),
                        SizedBox(
                          height: 10,
                        ),

                        createAddressRow(context),

                        createDetailsRow(context),
                        SizedBox(
                          height:3,
                        ),

                        if(model.isCustomer)SizedBox(height:2),
                        if(model.isCustomer || model.isAnonymous)createRepresentativeAgent(context),

                        SizedBox(
                          height:20,
                        ),


                        if(model.propertyAd.hasRoomsDescription)
                        Text('Description',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff0054a4)),),
                        SizedBox(height: 8,),
                        if(model.propertyAd.hasRoomsDescription)
                        createDescriptionContent(context),
                        SizedBox(height: 15,),


                        if(model.propertyAd.hasRoomsDescription)
                          Text('Detail Address',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff0054a4)),),
                        SizedBox(height: 8,),
                        createDetailAddressRow(context),
                        SizedBox(height: 15,),



                        if(model.propertyAd.hasExtraData)
                        Text('Extras',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff0054a4)),),
                        SizedBox(height: 8,),
                        if(model.propertyAd.hasExtraData)
                          _createExtraInfo(),
                        SizedBox(height: 15,),


                        if(model.propertyAd.hasLotData)
                        Text('Lot',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff0054a4)),),
                        SizedBox(height: 8,),
                        if(model.propertyAd.hasLotData)
                          _createLot(),
                        SizedBox(height: 15,),


                        if(model.propertyAd.hasRoomsDescription)
                        Text('Rooms',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff0054a4)),),
                        if(model.propertyAd.hasRoomsDescription)
                          _createRoomInfo(),
                        SizedBox(height: 15,),


                          Text('More Info',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff0054a4)),),
                        SizedBox(height: 8,),
                          _createRealtorInfo(),
                        SizedBox(height: 15,),


                        if(model.propertyAd.hasHistoryData)
                          Text('History',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff0054a4)),),
                        SizedBox(height: 8,),
                        if(model.propertyAd.hasHistoryData)
                          _createHistory(),
                        SizedBox(height: 15,),


                        if(model.propertyAd.hasBuildingInfluences)
                          Text('Building Influences/Amenities',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff0054a4)),),
                        SizedBox(height: 8,),
                        if(model.propertyAd.hasBuildingInfluences)
                          _createBuildinInfluences(),
                        SizedBox(height: 15,),


                        if(model.propertyAd.hasAreaInfluences)
                          Text('Area Influences/Amenities',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff0054a4)),),
                        SizedBox(height: 8,),
                        if(model.propertyAd.hasAreaInfluences)
                          _createAreaInfluences(),
                        SizedBox(height: 15,),



                          Text('Disclaimer',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff0054a4)),),
                        SizedBox(height: 8,),
                          _createDisclaimer(),
                        SizedBox(height: 5,),

                        _createHallmarkInfo(),
                        SizedBox(height: 15,),


                       /** _createDescriptions(),*/

                       /** if(model.propertyAd.hasRoomsDescription)
                          _createRoomsDescriptions(),*/

                        /**if(model.propertyAd.hasBuildingInfluences)
                          _createBuildingInfluencesDescriptions(),*/

                        /**if(model.propertyAd.hasAreaInfluences)
                          _createAreaInfluencesDescriptions(),*/

                       /** if(model.propertyAd.hasLotData)
                          _createLotDescriptions(),*/

                        //_createAddressInDetailDescription(),
                        //_createMoreInformationDescription(),

                        /**if(model.propertyAd.hasHistoryData)
                          _createHistoryDescription(),*/
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                right: 10,
                top: percentageOfDeviceHeight(context, 0.27),
                child: Row(
                  children: [
                    /**share(),*/
                    createMapButton(),
                    SizedBox(width: 10,),
                    createFavoriteButton(),


                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

   _createRealtorInfo(){
     var info = "MLS Number : " + model.propertyAd.id +"\n";

     if(model.propertyAd.brokerageName.isNotEmpty && model.propertyAd.brokerageName!="NotSpecified")
       info += "Brokerage Name : "+model.propertyAd.brokerageName+"\n";

     if(model.propertyAd.adClass!=AdClass.NotSpecified)
       info += "Class : "+model.propertyAd.adClass.name+"\n";
     if( model.propertyAd.adType!=AdType.NotSpecified)
       info += "Type : "+model.propertyAd.adType.name+"\n";
     if(model.propertyAd.status!=Status.NotSpecified)
       info += "Status : "+model.propertyAd.status.name+"\n";
     if(model.propertyAd.listDate.isNotEmpty && model.propertyAd.listDate!="NotSpecified")
     {
       if(model.propertyAd.listDate.contains("T"))
         info += "ListDate : "+model.propertyAd.listDate.substring(0,model.propertyAd.listDate.indexOf("T"))+"\n";
       else
         info += "ListDate : "+model.propertyAd.listDate+"\n";
     }
     if(model.propertyAd.updatedOn.isNotEmpty && model.propertyAd.updatedOn!="NotSpecified")
     {
       if(model.propertyAd.updatedOn.contains("T"))
         info += "Updated On : "+model.propertyAd.updatedOn.substring(0,model.propertyAd.updatedOn.indexOf("T"))+"\n";
       else
         info += "Updated On : "+model.propertyAd.updatedOn+"\n";
     }
     if(model.propertyAd.lockerNumber.isNotEmpty && model.propertyAd.lockerNumber!="NotSpecified")
       info += "Locker Number : "+model.propertyAd.lockerNumber+"\n";
     if(model.propertyAd.locker.isNotEmpty && model.propertyAd.locker!="NotSpecified")
       info += "Locker : "+model.propertyAd.locker+"\n";
     if(model.propertyAd.elevatorType.isNotEmpty && model.propertyAd.elevatorType!="NotSpecified" && !model.propertyAd.elevatorType.contains("Unknown"))
       info += "Elevator Type : "+model.propertyAd.elevatorType+"\n";
     if(model.propertyAd.cableIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.cableIncludedInMaintenanceFees!="NotSpecified")
       info += "Cable Included In Maintenance Fees : "+model.propertyAd.cableIncludedInMaintenanceFees+"\n";
     if(model.propertyAd.heatIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.heatIncludedInMaintenanceFees!="NotSpecified")
       info += "Heat Included In Maintenance Fees : "+model.propertyAd.heatIncludedInMaintenanceFees+"\n";
     if(model.propertyAd.hydroIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.hydroIncludedInMaintenanceFees!="NotSpecified")
       info += "Hydro Included In Maintenance Fees : "+model.propertyAd.hydroIncludedInMaintenanceFees+"\n";
     if(model.propertyAd.parkingIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.parkingIncludedInMaintenanceFees!="NotSpecified")
       info += "Parking Included In Maintenance Fees : "+model.propertyAd.parkingIncludedInMaintenanceFees+"\n";
     if(model.propertyAd.taxesIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.taxesIncludedInMaintenanceFees!="NotSpecified")
       info += "Taxes Included In Maintenance Fees : "+model.propertyAd.taxesIncludedInMaintenanceFees+"\n";
     if(model.propertyAd.waterIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.waterIncludedInMaintenanceFees!="NotSpecified")
       info += "Water Included In Maintenance Fees : "+model.propertyAd.waterIncludedInMaintenanceFees+"\n";

     return Text(info,
    style: TextStyle(
       height: 1.5,
       fontWeight: FontWeight.w500,
       color: Colors.black,
       fontSize: 15,
       fontFamily: "Halvetica",
     ),);
  }

  _createRoomInfo(){

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 18.0),
      child: Wrap(
        children: [
          Text("${model.propertyAd.roomsDescription}",
            style: TextStyle(
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 15,
              fontFamily: "Halvetica",
            ),
          )
        ],
      ),
    );
  }


  _createExtraInfo(){

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 18.0),
      child: Wrap(
        children: [
          Text("${model.propertyAd.extras}",
            style: TextStyle(
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 15,
              fontFamily: "Halvetica",
            ),
          )
        ],
      ),
    );
  }

  _createLot(){

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 18.0),
      child: Wrap(
        children: [
          Text("${model.propertyAd.lotDecorated}",
            style: TextStyle(
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 15,
              fontFamily: "Halvetica",
            ),
          )
        ],
      ),
    );
  }


  _createHistory(){

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 18.0),
      child: Wrap(
        children: [
          Text("${model.propertyAd.history}",
            style: TextStyle(
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 15,
              fontFamily: "Halvetica",
            ),
          )
        ],
      ),
    );
  }

  _createBuildinInfluences(){

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 18.0),
      child: Wrap(
        children: [
          Text("${model.propertyAd.buildingInfluencesList}",
            style: TextStyle(
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 15,
              fontFamily: "Halvetica",
            ),
          )
        ],
      ),
    );
  }


  _createAreaInfluences(){

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 18.0),
      child: Wrap(
        children: [
          Text("${model.propertyAd.areaInfluencesList}",
            style: TextStyle(
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 15,
              fontFamily: "Halvetica",
            ),
          )
        ],
      ),
    );
  }


  _createDisclaimer(){

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 18.0),
      child: Wrap(
        children: [
          Text("The information shown on this listing is provided by the Toronto Regional Real Estate Board. The data is considered reliable but is not guaranteed to be accurate by the information provider.",
            style: TextStyle(
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 15,
              fontFamily: "Halvetica",
            ),
          )
        ],
      ),
    );
  }

  _createHallmarkInfo(){

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 18.0),
      child: Wrap(
        children: [
          Text("*RE/MAX Hallmark Group of Companies: RE/MAX Hallmark Realty Ltd., Brokerage; RE/MAX Hallmark Realty Group, Brokerage; RE/MAX Hallmark First Group Realty Ltd., Brokerage; RE/MAX Hallmark York Group Realty Ltd., Brokerage; RE/MAX Hallmark Chay Realty Inc., Brokerage. Independently Owned and Operated. Not intended to solicit buyers/sellers currently under contract",
            style: TextStyle(
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 15,
              fontFamily: "Halvetica",
            ),
          )
        ],
      ),
    );
  }

  _createDescriptions() => createExpansionTile("Description",model.propertyAd.description);
  _createLotDescriptions() => createExpansionTile("Lot",model.propertyAd.lotDecorated);
  _createRoomsDescriptions() => createExpansionTile("Rooms Description",model.propertyAd.roomsDescription);
  _createBuildingInfluencesDescriptions() => createExpansionTile("Building Influences/Amenities",model.propertyAd.buildingInfluencesList);
  _createAreaInfluencesDescriptions() => createExpansionTile("Area Influences/Amenities",model.propertyAd.areaInfluencesList);
  _createExtrasDescription() => createExpansionTile("Extras",model.propertyAd.extras);
  _createAddressInDetailDescription() => createExpansionTile("Address In Detail",model.propertyAd.addressInDetail());
  _createHistoryDescription() => createExpansionTile("History",model.propertyAd.history);
  _createMoreInformationDescription()
  {

    var info = "MLS Number : " + model.propertyAd.id +"\n";

    if(model.propertyAd.brokerageName.isNotEmpty && model.propertyAd.brokerageName!="NotSpecified")
      info += "Brokerage Name : "+model.propertyAd.brokerageName+"\n";

    if(model.propertyAd.adClass!=AdClass.NotSpecified)
        info += "Class : "+model.propertyAd.adClass.name+"\n";
    if( model.propertyAd.adType!=AdType.NotSpecified)
        info += "Type : "+model.propertyAd.adType.name+"\n";
    if(model.propertyAd.status!=Status.NotSpecified)
        info += "Status : "+model.propertyAd.status.name+"\n";
    if(model.propertyAd.listDate.isNotEmpty && model.propertyAd.listDate!="NotSpecified")
    {
      if(model.propertyAd.listDate.contains("T"))
        info += "ListDate : "+model.propertyAd.listDate.substring(0,model.propertyAd.listDate.indexOf("T"))+"\n";
      else
        info += "ListDate : "+model.propertyAd.listDate+"\n";
    }
    if(model.propertyAd.updatedOn.isNotEmpty && model.propertyAd.updatedOn!="NotSpecified")
    {
      if(model.propertyAd.updatedOn.contains("T"))
        info += "Updated On : "+model.propertyAd.updatedOn.substring(0,model.propertyAd.updatedOn.indexOf("T"))+"\n";
      else
        info += "Updated On : "+model.propertyAd.updatedOn+"\n";
    }
    if(model.propertyAd.lockerNumber.isNotEmpty && model.propertyAd.lockerNumber!="NotSpecified")
        info += "Locker Number : "+model.propertyAd.lockerNumber+"\n";
    if(model.propertyAd.locker.isNotEmpty && model.propertyAd.locker!="NotSpecified")
        info += "Locker : "+model.propertyAd.locker+"\n";
    if(model.propertyAd.elevatorType.isNotEmpty && model.propertyAd.elevatorType!="NotSpecified" && !model.propertyAd.elevatorType.contains("Unknown"))
        info += "Elevator Type : "+model.propertyAd.elevatorType+"\n";
    if(model.propertyAd.cableIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.cableIncludedInMaintenanceFees!="NotSpecified")
        info += "Cable Included In Maintenance Fees : "+model.propertyAd.cableIncludedInMaintenanceFees+"\n";
    if(model.propertyAd.heatIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.heatIncludedInMaintenanceFees!="NotSpecified")
        info += "Heat Included In Maintenance Fees : "+model.propertyAd.heatIncludedInMaintenanceFees+"\n";
    if(model.propertyAd.hydroIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.hydroIncludedInMaintenanceFees!="NotSpecified")
        info += "Hydro Included In Maintenance Fees : "+model.propertyAd.hydroIncludedInMaintenanceFees+"\n";
    if(model.propertyAd.parkingIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.parkingIncludedInMaintenanceFees!="NotSpecified")
        info += "Parking Included In Maintenance Fees : "+model.propertyAd.parkingIncludedInMaintenanceFees+"\n";
    if(model.propertyAd.taxesIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.taxesIncludedInMaintenanceFees!="NotSpecified")
        info += "Taxes Included In Maintenance Fees : "+model.propertyAd.taxesIncludedInMaintenanceFees+"\n";
    if(model.propertyAd.waterIncludedInMaintenanceFees.isNotEmpty && model.propertyAd.waterIncludedInMaintenanceFees!="NotSpecified")
        info += "Water Included In Maintenance Fees : "+model.propertyAd.waterIncludedInMaintenanceFees+"\n";

    return createExpansionTile("More Info",info);
  }


  ExpansionTile createExpansionTile(String title,String description) {
    return ExpansionTile(
      backgroundColor: Colors.grey[100],
    title: halveticaBoldText(title,color: Color(0xff868686)),
    expandedAlignment: Alignment.centerLeft,
    tilePadding: EdgeInsets.all(7),
    childrenPadding: EdgeInsets.only(left: 4, right: 4),
    children: [
      halveticaNormalText(description,textAlign: TextAlign.justify,lineHeight: 1.7),
    ],

  );
  }



  _createLogo(String image, double height)
  {
    return Container(
      height: height,
      child: Image.asset(image,
        fit: BoxFit.contain,
      ),
    );
  }

  IconButton _createBackArrowButton(BuildContext context,{Color color = Colors.blueAccent}) {
    return IconButton(icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color:color);
  }

  RaisedButton createFavoriteButton() {
    return RaisedButton(
      elevation: 5,
        color: Colors.white,
        shape: CircleBorder(),
        onPressed: model.invertFavoriteStatus,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            model.propertyAd.isFavorite
                ? Icons.star
                : Icons.star_border,
            color: model.propertyAd.isFavorite ? Colors.red : Colors.grey,
          ),
        ));
  }

  RaisedButton createMapButton() {
    return RaisedButton(
      elevation: 5,
        color: Colors.white,
        shape: CircleBorder(),
        onPressed: _goToMap,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(Icons.location_on,color: Colors.blueAccent,),
        ));
  }

 /** MaterialButton share(){
    return MaterialButton(
      elevation: 5,
      onPressed: () {
        shareBox(context);
      },
      color: Colors.white,
      textColor: Colors.blue,
      child: Icon(
        Icons.ios_share,
      ),
      padding: EdgeInsets.all(4.0),
      shape: CircleBorder(),
    );
  }*/

  /**void shareBox(BuildContext context){
    final String text = 'My Favorite Listing';
    final RenderBox box = context.findRenderObject();

    Share.share(text,subject: 'Subject of the Share' ,sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }*/


  _goToMap(){
    showSingleMarkerMapPage(context , longitude:double.parse(model.propertyAd.longitude),latitude:double.parse(model.propertyAd.latitude));
  }

  RaisedButton createReloadModelWidget() => RaisedButton(
        onPressed: model.tryFetchingPropertyDetailsAgain,
        color: Colors.red,
        child: Icon(
          Icons.autorenew,
          size: 100,
        ),
      );

   createTopSlider(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: percentageOfDeviceHeight(context, 0.3),
            child: FlatButton(
                onPressed: () {
                  _showFullScreenImagesDialog();
                },
                child: ImagePager(model.propertyAd.imagesUrls,fit: BoxFit.cover,borderRadius: 0,))),
        if(model.propertyAd.isSoldButNotConditionally)
        _createSoldStatus(),
      ],
    );
  }

  _showFullScreenImagesDialog() {
    showDialog(
        context: context,
        builder:(context)=> Scaffold(
          appBar: AppBar(leading: _createBackArrowButton(context),backgroundColor: Colors.white,),
          backgroundColor: Colors.transparent,
          body: Center(
              child: Container(
                  width: percentageOfDeviceWidth(context, 0.96),
                  child: ImagePager(model.propertyAd.imagesUrls,fit: BoxFit.fitWidth,padding: 3,)
              )
          ),
        )
    );
  }

  createPriceRow(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            model.propertyAd.priceDecorated,
            style: TextStyle(
                color: Color(0xff0054a4),
                fontSize: 18,
                fontFamily: "Halvetica",
                fontWeight: FontWeight.bold),
          ),
          Text(
            "${model.propertyAd.propertyTypeAndStyleDescription}",
            style: TextStyle(color: Colors.black, fontSize: 10),
          ),
        ],
      );

  createAddressRow(context) => Padding(
    padding: const EdgeInsets.all(5.0),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
          children: [
            Text(
              "${model.propertyAd.addressInDetail(includeTitle: false,separator: "  ")}",
              style: TextStyle(
                height: 1.5,
                  fontSize: 16,
                  fontFamily: "Halvetica",
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "3h ago",
              style: TextStyle(color: Color(0x00b7b7b7), fontSize: 8),
            ),
          ],
        ),
  );

  createDetailAddressRow(context) => Padding(
    padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 18.0),
    child: Wrap(
      //alignment: WrapAlignment.spaceBetween,
      children: [
        Text(
          "${model.propertyAd.addressInDetailColumn()}",
          style: TextStyle(
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 15,
            fontFamily: "Halvetica",
          ),
        ),
        Text(
          "3h ago",
          style: TextStyle(color: Color(0x00b7b7b7), fontSize: 8),
        ),
      ],
    ),
  );

  createDetailsRow(context) => Card(
    color: Colors.blue[100],
    elevation: 4.0,
    child: Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                if(model.propertyAd.hasBedroomData) createDetailWithIconAsTitle(context, model.propertyAd.bedroomCountDescription,'images/bedroom.svg'),
                if(model.propertyAd.hasBathroomData) createDetailWithIconAsTitle(context, model.propertyAd.bathroomCountDescription,'images/bathtub.svg'),
                if(model.propertyAd.hasRoomData) createDetailWithIconAsTitle(context, model.propertyAd.roomCountDescription,'images/noun_room_2072711.svg'),
                if(model.propertyAd.hasParkingSpacesData) createDetailWithIconAsTitle(context, model.propertyAd.parkingCountDescription, 'images/parking-area.svg'),
                if(model.propertyAd.hasGarageData) createDetailWithIconAsTitle(context, model.propertyAd.garageSpacesCountDescription, 'images/garage.svg'),
                if(model.propertyAd.hasSQFTData) createDetailWithIconAsTitle(context, "${model.propertyAd.sizeInSquareFeetMin}-${model.propertyAd.sizeInSquareFeetMax}", 'images/house.svg'),


                if(model.propertyAd.hasApproximateAgeData)createDetailWithIconAsTitle(context, model.propertyAd.approximateAge, 'images/age.svg'),
                if(model.propertyAd.hasExposureData)createDetailWithIconAsTitle(context, model.propertyAd.exposure, 'images/brightness.svg'),
                if(model.propertyAd.hasTaxAssessmentYearData) createDetailWithIconAsTitle(context, model.propertyAd.taxesAssessmentYear, 'images/tax.svg'),
                if(model.propertyAd.hasTaxAnnualAmountData) createDetailWithIconAsTitle(context, model.propertyAd.taxesAnnualAmountDecorated, 'images/piggy-bank.svg'),

                if(model.propertyAd.hasBasement1Data) createDetailWithIconAsTitle(context, model.propertyAd.basementType1.name, 'images/noun_Basement_216424.svg'),
                if(model.propertyAd.hasBasement2Data) createDetailWithIconAsTitle(context, model.propertyAd.basementType2.name, 'images/noun_Basement_216424.svg'),

                if(model.propertyAd.hasExteriorConstruction1Data) createDetailWithIconAsTitle(context, model.propertyAd.exteriorConstruction1.name, 'images/noun_House_165027.svg'),
                if(model.propertyAd.hasExteriorConstruction2Data) createDetailWithIconAsTitle(context, model.propertyAd.exteriorConstruction2.name, 'images/noun_House_165027.svg'),

                if(model.propertyAd.hasPoolData)createDetailWithIconAsTitle(context, model.propertyAd.pool.name, 'images/swimming.svg'),
                if(model.propertyAd.hasAirConditioningData)createDetailWithIconAsTitle(context, model.propertyAd.airConditioning.name, 'images/air_conditioning.svg'),
                if(model.propertyAd.hasHeatSourceData)createDetailWithIconAsTitle(context, model.propertyAd.heatSource.name, 'images/fire.svg'),
                if(model.propertyAd.hasHeatTypeData)createDetailWithIconAsTitle(context, model.propertyAd.heatType.name, 'images/radiator.svg'),
                if(model.propertyAd.hasPetsAllowedData)createDetailWithIconAsTitle(context, model.propertyAd.petsPermitted, 'images/pet.svg'),
                if(model.propertyAd.hasFirePlaceData)createDetailWithIconAsTitle(context, model.propertyAd.hasFirePlace, 'images/fireplace_2.svg'),
                if(model.propertyAd.hasElevatorData)createDetailWithIconAsTitle(context, model.propertyAd.hasElevator, 'images/elevator.svg'),
                if(model.propertyAd.hasCentralVacuumData)createDetailWithIconAsTitle(context, model.propertyAd.hasCentralVacuum, 'images/vacuum_1.svg'),
                if(model.propertyAd.hasBuildingInsuranceData)createDetailWithIconAsTitle(context, model.propertyAd.hasBuildingInsurance, 'images/insurance.svg'),
              ],
            ),
      ),
    ),
  );



  createDetailWithIconAsTitle(context,value,assetSvgIconPath,{EdgeInsetsGeometry padding = const EdgeInsets.all(12)}) => Padding(
    padding: padding,
    child: Column(
      children: [
        halveticaBoldText("$value",color: Colors.black87, fontSize: 13,),
        SizedBox(height: 7,),
       _assetSvgIcon(assetSvgIconPath),
      ],
    ),
  );

  createDetailPieceWithTextTitle(context, String title, value,{EdgeInsetsGeometry padding = const EdgeInsets.all(12)}) => Padding(
    padding: padding,
    child: Column(
      children: [
        halveticaBoldText("$value",color: Color(0xff868686), fontSize: 13,),
        SizedBox(
          height: 10,
        ),
        halveticaNormalText(value)
      ],
    ),
  );


  _assetSvgIcon(String path,{double width = 30,double height = 30, Color color = const Color(0xff505050),String semanticLabel = ""}) => SvgPicture.asset(
    path,
    semanticsLabel: semanticLabel,
    width: width,
    height: height,
    color: color,
  );


  createDescriptionTitle(context) => SizedBox(
        width: double.infinity,
        child: Text(
          "Description",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(0xff868686),
              fontSize: 17,
              fontFamily: "Halvetica",
              fontWeight: FontWeight.bold),
        ),
      );

  createDescriptionContent(context) => Padding(
    padding: const EdgeInsets.only(left: 4.0, right:4.0, bottom:18.0),
    child: Text(
          model.propertyAd.description,
          textAlign: TextAlign.justify,
          style: TextStyle(
            height: 1.2,
              color: Colors.black,
              fontSize: 15,
              fontFamily: "Halvetica",
              fontWeight: FontWeight.w500),
        ),
  );

  createBrokerageName(context) => Text(
    model.propertyAd.brokerageName,
    textAlign: TextAlign.justify,
    style: TextStyle(
        color: Colors.black,
        fontSize: 8,
        height: 1.2,
        fontFamily: "Halvetica",
        fontWeight: FontWeight.normal),
  );

  createRepresentativeAgent(context) => model.propertyIsFetched
      ? (model.isCustomer ?
          _createAgent(context) :
        (model.isAnonymous?_createAnonymousAgent(context):Container()))
      : CircularProgressIndicator();

  _createAnonymousAgent(context)
  {
    return createRoundedCornerRaisedButton("Please Login To Get an Agent",fontSize: 14,onPress: ()=>bringUpLoginDialog(context));
  }

  _createAgent(context) {
    final agent = model.customerRepresentativeAgentOrRemaxAsTheAgentIfNoRepresentativeAssignedYet;
    return Container(
      height: percentageOfDeviceHeight(context, 0.15),
      child: Card(
        elevation: 4.0,
        child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 5),
                  createAgentProfilePic(agent),
                  SizedBox(width: 5),
                  createAgentName(agent),
                  Spacer(),
                  createAgentCallButtons(agent)
                ],
              ),
      ),
    );
  }

  SvgPicture svgAssetPicture(String path,
      {String semantics = "", double width = 20, double height = 20, Color color = const Color(
          0xff505050) ,BoxFit fit=BoxFit.contain}) {
    return SvgPicture.asset(
      path,fit:fit,
      semanticsLabel: semantics,
      width: width,
      height: height,
      color: color,
    );
  }

  _createSoldStatus()
  {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        width: 80,height: 80,
        child: Stack(fit: StackFit.expand,alignment: AlignmentDirectional.topStart,
          children: [
            svgAssetPicture("images/sold.svg",width: 80,height: 80,fit: BoxFit.contain,color: null),
            Transform.rotate(
              angle: -3.14/4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Spacer(flex: 4,),
                  halveticaBoldText(model.propertyAd.status.name,color: Colors.white,fontSize: 9,),
                  SizedBox(height: 1,),
                  _createPriceText(model.propertyAd.soldPriceDecorated,color: Colors.white,fontSize: 9),
                  Spacer(flex: 5,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createPriceText(String price,{Color color = const Color(0xff0054a4),double fontSize = 17,EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) => halveticaBoldText(
      price,
      color: color,
      fontSize: fontSize,
      padding: padding);

  createAgentProfilePic(Agent agent) {
    return FutureWidget(
      initialLoadingBoxWidth: 10,
      initialLoadingBoxHeight: 10,
      future: model.loadImage(agent.photoUrl,defaultAssetFile: "images/hallmark_square.jpg"),
      builder: (context, profilePicFile) => PercentageWidget(
        widthRatio: "0.5ph",
        heightRatio: "0.5ph",
        child: ClipOval(
          child: Image.file(
            profilePicFile,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  createAgentName(Agent agent) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Agent",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 11,
                fontFamily: "Halvetica",
                fontWeight: FontWeight.w100),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "${agent.fullNameIfNotNullOrMobileOrEmail}",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 8,
                fontFamily: "Halvetica",
                fontWeight: FontWeight.w100),
          )
        ],
      );

  createAgentCallButtons(Agent agent)
  {

    var height = 0.0;

    if(agent.hasMobile && agent.hasEmail)
      height=20;
    else
      height = 30;

    return PercentageWidget(
      widthRatio: "0.5dw",
      heightRatio: "1ph",
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            if(agent.hasMobile)
              createRoundedCornerRaisedButton("Call", fontSize: 10, height: height, onPress: model.callAgent),

            if(agent.hasMobile)
              createRoundedCornerFlatButton("Message",
                  fontWeight: FontWeight.w100,
                  shapeColor: Colors.transparent,
                  fontFamily: "Halvetica",
                  fontSize: 10,
                  height: height,
                  onPress: model.smsAgentAboutProperty),

            if(agent.hasEmail)
              createRoundedCornerRaisedButton("Email", fontSize: 14, height: height, onPress: ()=>model.mailAgentAboutProperty(agent))
          ],
        ),
      ),
    );
  }
}
