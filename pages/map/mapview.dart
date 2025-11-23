
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SingleMarkerMapPage extends StatelessWidget {

  final double latitude;
  final double longitude;

  SingleMarkerMapPage(this.longitude,this.latitude);

  build(BuildContext context) {
    return MaterialApp(
      home:MapView(longitude,latitude) ,
    );
  }
}

class MapView extends StatefulWidget {

  final double latitude;
  final double longitude;

  MapView(this.longitude,this.latitude);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  CameraPosition _initialPosition ;


  initState() {
    super.initState();
    _initialPosition = CameraPosition(
        target: LatLng(widget.latitude,widget.longitude),
        zoom: 12);
  }

  _createHallmarkLogo()
  {
    return Center(
      child: Column(
        children: [
          Container(
            height: 30,
            child: Image.asset("images/houselogiqsmall.png",
              fit: BoxFit.contain,
            ),
          ),
          Text("RE/MAX Hallmark Group of Companies*",
              style: TextStyle(color: Colors.black,fontSize: 9))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.blueAccent
        ),
        title: Row(
          children: [
            Flexible(
              flex:1,
              child: SizedBox(),
            ),
            Flexible(
                fit: FlexFit.tight,
                flex:4,
                child: _createHallmarkLogo())
          ],
        ),
      ),
      body:GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _initialPosition,
          markers: [
            Marker(markerId: MarkerId("1"),position: LatLng(widget.latitude,widget.longitude))
          ].toSet(),
        ),
    );
  }
}
