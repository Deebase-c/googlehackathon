class User {

  String streetAddress;
  String homeCity;
  String homePostalCode;
  String homeCountry;
  bool admin;

  User(this.homeCountry,this.streetAddress );

  Map<String, dynamic> toJson() => {
    'streetAddress': streetAddress,
    'homeCity': homeCity,
    'homePostalCode': homePostalCode,
    'homeCountry': homeCountry,
    'admin': admin,
  };
}