import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/Util.dart';
import 'package:realestate_app/customWidget/adProperty/AdPropertyList.dart';
import 'package:realestate_app/model/entity/AdType.dart';
import 'package:realestate_app/model/entity/PropertyAdSearchFilter.dart';
import 'package:realestate_app/pages/Router.dart';
import 'package:realestate_app/model/entity/Suggestion.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';


class AnonymousAdListing extends StatefulWidget {
  createState() => AnonymousAdListingState();
}

class AnonymousAdListingState extends State<AnonymousAdListing> {

  GlobalKey<AutoCompleteTextFieldState<Suggestions>> key = new GlobalKey();

  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();

  void _loadData() async {
    await SuggestionsViewModel.loadsuggestions();
  }

  final searchController = TextEditingController();
  PropertyAdSearchFilter _lastSearchFilter = PropertyAdSearchFilter(
      adType: AdType.Sale);
  ValueNotifier<PropertyAdSearchFilter> searchFilter = ValueNotifier(
      PropertyAdSearchFilter(adType: AdType.Sale));

  @override
  void initState() {
    _loadData();
    super.initState();

    searchController.addListener(() {
      _filterTheListing(unfocus: false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  build(context) =>
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _createSegmentHeader(),
          //_createSearchBox(),
          _createSuggestions(),
          Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [_createMapButon(), _createFilterButton(context),]),
          Expanded(child: _createFutureListing()),
          SizedBox(
            height: 5,
          ),
        ],
      );


  _createMapButon() {
    return Align(
      //alignment: Alignment.centerRight,
        child: SizedBox(
          height: 30,
          child: IconButton(padding: EdgeInsets.all(2),
            onPressed: () {
              showMapFullOfMarkersPage(context);
            },
            icon: Icon(Icons.location_on, color: Colors.blue, size: 25.0,),

          ),
        )
    );
  }

  _createFilterButton(context) {
    return Align(
      //alignment: Alignment.centerRight,
        child: SizedBox(
          height: 30,
          child: IconButton(padding: EdgeInsets.all(2),
            onPressed: () {
              FocusScope.of(context).unfocus();
              showSearchFilterPage(context, initialFilter:
              searchFilter.value)
                  .then((value) {
                if (value == null)
                  return;

                searchFilter.value.load(value);
                _filterTheListing();
              });
            },
            icon: Icon(Icons.filter_alt_rounded,
                color: searchFilter == null || !searchFilter.value.isFiltered
                    ? Color(0xff868686)
                    : Colors.blue),),
        )
    );
  }


  void _filterTheListing({bool unfocus = true}) {
    if (unfocus)
      FocusScope.of(context).unfocus();

    final searchWord = searchController.text == null ? "" : searchController
        .text;
    searchFilter.value.word = searchWord;

    if (_lastSearchFilter.equals(searchFilter.value))
      return;

    _lastSearchFilter.load(searchFilter.value);
    searchFilter.notifyListeners();
  }

  _createSuggestions() {

    return Center(
        child: Column(children: <Widget>[
          Column(children: <Widget>[
            searchTextField = AutoCompleteTextField<Suggestions>(
              suggestionsAmount: 12,
                style: TextStyle(height: 1,
                    fontFamily: "Halvetica",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5),
                  isDense: false,
                  filled: true,
                  suffixIconConstraints: BoxConstraints.tightFor(width:30,height:33),
                  fillColor: Color(0xfff5f5f5),
                  hintText: "Enter an Address, Neighbourhood, City ...",
                  suffixIcon:IconButton(iconSize: 20,
                    padding: EdgeInsets.only(left: 6,right: 6),
                    onPressed: () {
                      _filterTheListing();
                    },
                    icon: Icon(Icons.search),
                  ),
                  focusedBorder: _createTextFieldBorder(),
                  border: _createTextFieldBorder(),
                  enabledBorder: _createTextFieldBorder(),
                ),
                controller: searchController,
                itemSubmitted: (item) {
                  setState(() => searchTextField.textField.controller.text =
                      item.autocompleteterm);
                },
                clearOnSubmit: false,
                key: key,
                suggestions: SuggestionsViewModel.suggestions,
                itemBuilder: (context, item) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Padding(
                        padding: const EdgeInsets.only(left:7.0),
                        child: Text(item.autocompleteterm,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0
                          ),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 1.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:7.0),
                        child: Text(item.country,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black54
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                      )
                    ],
                  );
                },
                itemSorter: (a, b) {
                  return a.autocompleteterm.compareTo(b.autocompleteterm);
                },
                itemFilter: (item, query) {
                  return item.autocompleteterm
                      .toLowerCase()
                      .startsWith(query.toLowerCase());
                }),
          ]),
        ]));

  }



  OutlineInputBorder _createTextFieldBorder() {
    return const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffd9d9d9)));
  }

  _createSegmentHeader() {

    var selectedIndex = -1;
    switch(searchFilter.value.adType)
    {
      case AdType.Lease:
        selectedIndex = 2;
        break;
      case AdType.Sale:
        selectedIndex = 1;
        break;
      default : selectedIndex = 0;
    }

    return CupertinoSlidingSegmentedControl(
        children: _createLogos(),
        groupValue: selectedIndex,
        onValueChanged: (index) {
          setState(() {
            switch(index)
            {
              case 2:
                searchFilter.value.adType = AdType.Lease;
                break;
              case 1:
                searchFilter.value.adType = AdType.Sale;
                break;
              default : searchFilter.value.adType = AdType.Any;
            }
            _filterTheListing();
          });
        });
  }

  _createLogos() => <int, Widget>{
        0: halveticaLightText("All", fontSize: 12),
        1: halveticaLightText("Sale", fontSize: 12),
        2: halveticaLightText("Lease", fontSize: 12),
      };

  _createFutureListing() => AdPropertyList(searchFilter, "PropertyAd");

}