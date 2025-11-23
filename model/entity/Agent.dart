

import 'package:realestate_app/model/entity/User.dart';

class Agent extends User
{
  final int invitationsCount;
  final int representingCustomersCount;
  final String company;
  final String website;

  Agent(this.invitationsCount,this.representingCustomersCount,String userId,String firstName, String lastName, String mobile, String address,String photoUrl, bool isAgent, bool isCustomer, bool isAdmin,String email,{this.company = "", this.website = ""}) : super(userId,firstName, lastName, mobile, address,photoUrl, isAgent, isCustomer, isAdmin,email);
}