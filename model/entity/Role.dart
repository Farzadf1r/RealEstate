

enum Role{
 Admin,Customer,Seller,Anonymous
}

Role valueOfRole(String name) => Role.values.firstWhere((element) => element.name == name);
extension PropertyTypeExtension on Role {

 String get name {
  return this.toString().substring(5);
 }
}