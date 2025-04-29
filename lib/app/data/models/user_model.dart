class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String address;
  final String documentType;
  final String kycDocumentUrl;
  final String kycStatus;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber = '',
    this.address = '',
    this.documentType = '',
    this.kycDocumentUrl = '',
    this.kycStatus = 'pending',
    this.isAdmin = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'documentType': documentType,
      'kycDocumentUrl': kycDocumentUrl,
      'kycStatus': kycStatus,
      'isAdmin': isAdmin,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      documentType: map['documentType'] ?? '',
      kycDocumentUrl: map['kycDocumentUrl'] ?? '',
      kycStatus: map['kycStatus'] ?? 'pending',
      isAdmin: map['isAdmin'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? address,
    String? documentType,
    String? kycDocumentUrl,
    String? kycStatus,
    bool? isAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      kycStatus: kycStatus ?? this.kycStatus,
      kycDocumentUrl: kycDocumentUrl ?? this.kycDocumentUrl,
      documentType: documentType ?? this.documentType,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
