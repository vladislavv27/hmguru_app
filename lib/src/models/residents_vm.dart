class ResidentTableVM {
  final int? apartmentNumber;
  final String fullName;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String identityNumber;
  final String landRegistry;
  final bool receiveInvoices;
  final bool isOwner;
  final BecomeAnOwnerRequestDTO? ownershipRequest;
  final String fullAddress;

  ResidentTableVM({
    this.apartmentNumber,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.identityNumber,
    required this.landRegistry,
    required this.receiveInvoices,
    required this.isOwner,
    this.ownershipRequest,
    required this.fullAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'apartmentNumber': apartmentNumber,
      'fullName': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'identityNumber': identityNumber,
      'landRegistry': landRegistry,
      'receiveInvoices': receiveInvoices,
      'isOwner': isOwner,
      'ownershipRequest': ownershipRequest?.toJson(),
      'fullAddress': fullAddress,
    };
  }

  factory ResidentTableVM.fromJson(Map<String, dynamic> json) {
    return ResidentTableVM(
      apartmentNumber: json['apartmentNumber'],
      fullName: json['fullName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      identityNumber: json['identityNumber'] ?? '',
      landRegistry: json['landRegistry'] ?? '',
      receiveInvoices: json['receiveInvoices'] ?? false,
      isOwner: json['isOwner'] ?? false,
      ownershipRequest: json['ownershipRequest'] != null
          ? BecomeAnOwnerRequestDTO.fromJson(json['ownershipRequest'])
          : null,
      fullAddress: json['fullAddress'] ?? '',
    );
  }
}

class BecomeAnOwnerRequestDTO {
  final String firstName;
  final String lastName;
  final String address;
  final String leaseholdId;
  final String identityNumber;
  final String phoneNumber;
  final String email;
  final List<FileDto> landRegistries;
  final OwnershipRequestStatus status;
  final String comment;

  BecomeAnOwnerRequestDTO({
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

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'leaseholdId': leaseholdId,
      'identityNumber': identityNumber,
      'phoneNumber': phoneNumber,
      'email': email,
      'landRegistries': landRegistries.map((file) => file.toJson()).toList(),
      'status': formatOwnershipRequestStatus(status),
      'comment': comment,
    };
  }

  factory BecomeAnOwnerRequestDTO.fromJson(Map<String, dynamic> json) {
    return BecomeAnOwnerRequestDTO(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      address: json['address'] ?? '',
      leaseholdId: json['leaseholdId'] ?? '',
      identityNumber: json['identityNumber'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      landRegistries: (json['landRegistries'] as List<dynamic>?)
              ?.map((fileJson) => FileDto.fromJson(fileJson))
              .toList() ??
          [],
      status: parseOwnershipRequestStatus(json['status'] ?? 0),
      comment: json['comment'] ?? '',
    );
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
