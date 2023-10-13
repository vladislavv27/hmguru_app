class UserVM {
  UserVM({
    this.username,
    this.fullName,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.savedCardDataId,
    this.role,
    this.isHouseAdmin,
    this.leaseholds,
    this.emailConfirmed,
    this.authorizedUsingEparaksts,
    this.identityNumber,
  });

  String? username;
  String? fullName;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? savedCardDataId;
  LeaseholdFullAddressWithIdVM? leaseholds;
  RoleVM? role;
  bool? isHouseAdmin;
  bool? emailConfirmed;
  bool? authorizedUsingEparaksts;
  String? identityNumber;
}

class RoleVM {
  String name;

  RoleVM({
    required this.name,
  });
}

class LeaseholdFullAddressWithIdVM {
  String id;
  String fullAddress;
  bool isActive;
  bool isLeaseholdOwner;

  LeaseholdFullAddressWithIdVM({
    required this.id,
    required this.fullAddress,
    required this.isActive,
    required this.isLeaseholdOwner,
  });
}
