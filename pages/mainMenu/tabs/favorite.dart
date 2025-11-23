import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/adProperty/AdPropertyList.dart';
import 'package:realestate_app/customWidget/pagedListView/PagedContentModel.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/PropertyAd.dart';
import 'package:realestate_app/model/entity/PropertyAdSearchFilter.dart';

class Favorite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _createFutureListing();
  }

  _createFutureListing() {
    return AdPropertyList( ValueNotifier(PropertyAdSearchFilter(onlyFavoriteOnes: true)),"FavoritesPropertyAds");
  }
}
