

import 'package:realestate_app/model/entity/Agent.dart';
import 'package:realestate_app/model/entity/User.dart';

class Customer extends User
{
  Agent representativeAgent;

  bool get hasRepresentativeAgent => representativeAgent!= null;

  Customer(this.representativeAgent,String userId,String firstName, String lastName, String mobile, String address,String photoUrl, bool isAgent, bool isCustomer, bool isAdmin,String email) : super(userId,firstName, lastName, mobile, address,photoUrl, isAgent, isCustomer, isAdmin,email);

}