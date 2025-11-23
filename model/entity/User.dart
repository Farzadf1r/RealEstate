

import 'Role.dart';

class User
{
  final String userId;
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String address;

  final bool isAgent;
  final bool isCustomer;
  final bool isAdmin;
  final bool isAnonymous;

  bool get hasFullName{
    return firstName!=null && firstName.length > 0 && lastName!=null && lastName.length>0;
  }

  bool get hasMobile{
    return mobile!=null && mobile.length > 0;
  }

  bool get hasEmail{
    return email!=null && email.length > 0;
  }

  final Map<String,dynamic> extraProperties;

  final String photoUrl;

  List<Role> get roles {
    var r = <Role>[];
    if(isAdmin)
      r.add(Role.Admin);

    if(isAgent)
      r.add(Role.Seller);

    if(isCustomer)
      r.add(Role.Customer);

    if(isAnonymous)
      r.add(Role.Anonymous);

    return r;
  }

  int get rolesCount => roles.length;
  bool get hasMoreThanOneRole=> roles.length >1;



  User(this.userId,this.firstName, this.lastName, this.mobile, this.address , this.photoUrl,
      this.isAgent, this.isCustomer, this.isAdmin,this.email,{this.extraProperties = const {},this.isAnonymous = false});


  String get fullNameIfNotNullOrMobileOrEmail {
    return firstName == null || firstName.isEmpty
        ? (mobile == null || mobile.isEmpty ? email : mobile)
        : "$firstName $lastName";
  }

  String get fullNameOrNoName {

    String result="";
    if(firstName != null && firstName.isNotEmpty)
      result = firstName +" ";

    if(lastName != null && lastName.isNotEmpty)
      result +=lastName;

    if(result.isEmpty)
      return "Name Not Set Yet";
    else
      return result;
  }

  String get phoneOrEmail {
    if(mobile ==null || mobile.isEmpty)
      return email;
    else
      return mobile;
  }

  String toString() {
    return 'User{userId: $userId, firstName: $firstName, lastName: $lastName, mobile: $mobile, address: $address, isAgent: $isAgent, isCustomer: $isCustomer, isAdmin: $isAdmin, photoUrl: $photoUrl}';
  }

  bool hasRole(Role role) {
    return roles.contains(role);
  }
}