import 'package:realestate_app/customWidget/pagedListView/PagedContentModel.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/Agent.dart';
import 'package:realestate_app/model/entity/Customer.dart';
import 'package:realestate_app/model/entity/CustomerSearchFilter.dart';
import 'package:realestate_app/model/entity/PropertyAd.dart';
import 'package:realestate_app/model/entity/PropertyAdSearchFilter.dart';

class AgentsPagedContentModel extends PagedContentModel<Agent> {

  AgentsPagedContentModel(
      int pageSize, String contentDescription)
      : super(pageSize, contentDescription,null)
  {
    setFetchNextPageHandler((int nextPageIndex, PagedContentModel<Agent> contentSoFar) async{

      return ServerGateway.instance().fetchAgentsList(nextPageIndex, pageSize);

    });
  }
}
