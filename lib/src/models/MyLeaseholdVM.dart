class MyLeaseholdVM {
  String address;
  String fullAddress;
  String fullNumber;
  int floor;
  int residentCount;
  double fullArea;
  double balconyArea;
  InvoiceDeliveryType billDeliveryType;
  double balance;
  num tendency;
  HouseType? type;
  bool isActive;
  bool isOwner;
  bool awaitingOwnershipApproval;
  OwnershipRequestDTO? ownershipRequest;
  String accessCode;
  List<String> owners;
  String id;
  String created;
  String? createdById;
  String? createdBy;
  String modified;
  String? modifiedById;
  String? modifiedBy;
  bool isDeleted;
  String rowVersion;

  MyLeaseholdVM({
    required this.id,
    required this.address,
    required this.fullAddress,
    required this.fullNumber,
    required this.floor,
    required this.residentCount,
    required this.fullArea,
    required this.balconyArea,
    required this.billDeliveryType,
    required this.balance,
    required this.tendency,
    required this.type,
    required this.isActive,
    required this.isOwner,
    required this.awaitingOwnershipApproval,
    required this.ownershipRequest,
    required this.accessCode,
    required this.owners,
    required this.created,
    this.createdById,
    this.createdBy,
    required this.modified,
    this.modifiedById,
    this.modifiedBy,
    required this.isDeleted,
    required this.rowVersion,
  });

  factory MyLeaseholdVM.fromJson(Map<String, dynamic> json) {
    return MyLeaseholdVM(
      id: json['id'],
      address: json['address'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
      fullNumber: json['fullNumber'] ?? '',
      floor: json['floor']?.toInt() ?? 0,
      residentCount: json['residentCount'] ?? 0,
      fullArea: json['fullArea']?.toDouble() ?? 0.0,
      balconyArea: json['balconyArea']?.toDouble() ?? 0.0,
      billDeliveryType: parseInvoiceDeliveryType(json['billDeliveryType']),
      balance: json['balance']?.toDouble() ?? 0.0,
      tendency: json['tendency']?.toDouble() ?? 0.0,
      type: json['type'] != null ? HouseType.values[json['type']] : null,
      isActive: json['isActive'] ?? false,
      isOwner: json['isOwner'] ?? false,
      awaitingOwnershipApproval: json['awaitingOwnershipApproval'] ?? false,
      ownershipRequest: json['ownershipRequest'] != null
          ? OwnershipRequestDTO.fromJson(json['ownershipRequest'])
          : null,
      accessCode: json['accessCode'] ?? '',
      owners: List<String>.from(json['owners']),
      created: json['created'] ?? '',
      createdById: json['createdById'] ?? '',
      createdBy: json['createdBy'] ?? '',
      modified: json['modified'] ?? '',
      modifiedById: json['modifiedById'] ?? '',
      modifiedBy: json['modifiedBy'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      rowVersion: json['rowVersion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'fullAddress': fullAddress,
      'fullNumber': fullNumber,
      'floor': floor,
      'residentCount': residentCount,
      'fullArea': fullArea,
      'balconyArea': balconyArea,
      'billDeliveryType': billDeliveryType.index,
      'balance': balance,
      'tendency': tendency,
      'type': type?.index,
      'isActive': isActive,
      'isOwner': isOwner,
      'awaitingOwnershipApproval': awaitingOwnershipApproval,
      'ownershipRequest': ownershipRequest?.toJson(),
      'accessCode': accessCode,
      'owners': owners,
      'created': created,
      'createdById': createdById,
      'createdBy': createdBy,
      'modified': modified,
      'modifiedById': modifiedById,
      'modifiedBy': modifiedBy,
      'isDeleted': isDeleted,
      'rowVersion': rowVersion,
    };
  }
}

InvoiceDeliveryType parseInvoiceDeliveryType(int? value) {
  if (value == null) {
    return InvoiceDeliveryType.unknown; // Handle null values with a default
  }

  final index = value - 1; // Adjust to start from 0

  if (index >= 0 && index < InvoiceDeliveryType.values.length) {
    return InvoiceDeliveryType.values[index];
  } else {
    return InvoiceDeliveryType
        .unknown; // Return a default value for unknown values
  }
}

// Rest of your code remains the same

enum InvoiceDeliveryType {
  Email,
  Post,
  Both,
  unknown,
}

enum HouseType {
  Seria_103,
  Seria_104,
  Seria_119,
  Seria_467,
  Seria_602,
  Chech_project,
  Hrushovka,
  Lithuania_project,
  Small_family,
  Prewar,
  Private_house,
  Spec_project,
  Stalinka,
  New_building,
}

class OwnershipRequestDTO {
  String firstName;
  String lastName;
  String address;
  String leaseholdId;
  String identityNumber;
  String phoneNumber;
  String email;
  List<FileDto> landRegistries;
  OwnershipRequestStatus status;
  String comment;

  OwnershipRequestDTO({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.leaseholdId,
    required this.identityNumber,
    required this.phoneNumber,
    required this.email,
    required this.landRegistries,
    required this.status,
    required this.comment,
  });

  factory OwnershipRequestDTO.fromJson(Map<String, dynamic> json) {
    return OwnershipRequestDTO(
      firstName: json['firstName'] != null ? json['firstName'].toString() : '',
      lastName: json['lastName'] != null ? json['lastName'].toString() : '',
      address: json['address'] != null ? json['address'].toString() : '',
      leaseholdId:
          json['leaseholdId'] != null ? json['leaseholdId'].toString() : '',
      identityNumber: json['identityNumber'] != null
          ? json['identityNumber'].toString()
          : '',
      phoneNumber:
          json['phoneNumber'] != null ? json['phoneNumber'].toString() : '',
      email: json['email'] != null ? json['email'].toString() : '',
      landRegistries: (json['landRegistries'] as List<dynamic>?)
              ?.map((x) => FileDto.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      status: parseOwnershipRequestStatus(json['status']),
      comment: json['comment'] != null ? json['comment'].toString() : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'leaseholdId': leaseholdId,
      'identityNumber': identityNumber,
      'phoneNumber': phoneNumber,
      'email': email,
      'landRegistries':
          List<dynamic>.from(landRegistries.map((x) => x.toJson())),
      'status': formatOwnershipRequestStatus(status),
      'comment': comment,
    };
  }
}

enum OwnershipRequestStatus {
  AwaitingApproval,
  Accepted,
  Rejected,
  Cancelled,
}

OwnershipRequestStatus parseOwnershipRequestStatus(dynamic value) {
  if (value == null) {
    // Handle null values, you can return a default status or throw an exception
    throw Exception('OwnershipRequestStatus cannot be null');
  }

  if (value is int) {
    switch (value) {
      case 0:
        return OwnershipRequestStatus.AwaitingApproval;
      case 1:
        return OwnershipRequestStatus.Accepted;
      case 2:
        return OwnershipRequestStatus.Rejected;
      case 3:
        return OwnershipRequestStatus.Cancelled;
    }
  } else if (value is String) {
    switch (value) {
      case 'AwaitingApproval':
        return OwnershipRequestStatus.AwaitingApproval;
      case 'Accepted':
        return OwnershipRequestStatus.Accepted;
      case 'Rejected':
        return OwnershipRequestStatus.Rejected;
      case 'Cancelled':
        return OwnershipRequestStatus.Cancelled;
    }
  }

  throw Exception('Unknown OwnershipRequestStatus: $value');
}

String formatOwnershipRequestStatus(OwnershipRequestStatus status) {
  switch (status) {
    case OwnershipRequestStatus.AwaitingApproval:
      return 'AwaitingApproval';
    case OwnershipRequestStatus.Accepted:
      return 'Accepted';
    case OwnershipRequestStatus.Rejected:
      return 'Rejected';
    case OwnershipRequestStatus.Cancelled:
      return 'Cancelled';
  }
}

class FileDto {
  String fileName;
  String filePath;
  int? width;
  int? height;

  FileDto({
    required this.fileName,
    required this.filePath,
    this.width,
    this.height,
  });

  factory FileDto.fromJson(Map<String, dynamic> json) {
    return FileDto(
      fileName: json['fileName'],
      filePath: json['filePath'],
      width: json['width'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'filePath': filePath,
      'width': width,
      'height': height,
    };
  }
}
