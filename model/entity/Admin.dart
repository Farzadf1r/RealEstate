

import 'package:realestate_app/model/entity/User.dart';

class Admin extends User
{
  Admin(String userId,String firstName, String lastName, String mobile, String address,String photoUrl, bool isAgent, bool isCustomer, bool isAdmin,String email) : super(userId,firstName, lastName, mobile, address,photoUrl, isAgent, isCustomer, isAdmin,email);
}