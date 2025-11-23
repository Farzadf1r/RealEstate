import 'package:realestate_app/customWidget/pagedListView/PagedContentModel.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/Customer.dart';
import 'package:realestate_app/model/entity/CustomerSearchFilter.dart';
import 'package:realestate_app/model/entity/Role.dart';

class CustomersPagedContentModel extends PagedContentModel<Customer> {

  CustomersPagedContentModel(
      int pageSize, String contentDescription)
      : super(pageSize, contentDescription,null)
  {
    setFetchNextPageHandler((int nextPageIndex, PagedContentModel<Customer> contentSoFar) async{

      var signedInUser = await ServerGateway.instance().getSignedInUser();
      var selectedRole = ServerGateway.instance().selectedRole;

      if(selectedRole==Role.Seller)
        return ServerGateway.instance().fetchCustomerList(nextPageIndex, pageSize, CustomerSearchFilter(specificAgentId:signedInUser.userId));
      else if(selectedRole==Role.Admin)
        return ServerGateway.instance().fetchCustomerList(nextPageIndex, pageSize, CustomerSearchFilter());
      else
        throw Exception("should not reach here...! $selectedRole");
    });
  }
}
