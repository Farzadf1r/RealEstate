import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/blocModelProvider/ModelProvider.dart';
import 'package:realestate_app/customWidget/customersList/CustomerListItem.dart';
import 'package:realestate_app/customWidget/customersList/CustomersPagedContentModel.dart';
import 'package:realestate_app/customWidget/pagedListView/PagedListView.dart';
import 'package:realestate_app/model/entity/Customer.dart';



class CustomersList extends StatelessWidget {

  static const _ContentDescription = "CustomersList";

  CustomersList()
  {
    ModelProvider.instance.provideThisOneTimeAlternativeIfCreatorCouldNotCreate(_ContentDescription, ()=>CustomersPagedContentModel(20, _ContentDescription));
  }

  build(BuildContext context) {
    return PagedListView<Customer>(
        _ContentDescription,
        (context, overallPosition, Customer customer) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomerListItem(customer),
            ));
  }
}
