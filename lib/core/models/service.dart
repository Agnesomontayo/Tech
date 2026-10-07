class ServiceDisplayData {
  final int id;
  final String label;
  final String? imageUrl; // Utilisez String? si l'image est optionnelle

  ServiceDisplayData({
    required this.id,
    required this.label,
    this.imageUrl,
  });

  factory ServiceDisplayData.fromJson(Map<String, dynamic> json) {
    return ServiceDisplayData(
      id: json['id'] as int,
      label: json['label'] as String,
      imageUrl: json['image'] as String?, // Assurez-vous que votre API renvoie 'image_url'
    );
  }
}

class UserDisplayData {
  final int id;
  final String name;
  final String? avatarUrl;
  final String? profile_photo_url;

  UserDisplayData({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.profile_photo_url,
  });

  factory UserDisplayData.fromJson(Map<String, dynamic> json) {
    return UserDisplayData(
      id: json['id'] as int,
      name: json['firstName']+' '+json['lastName'] as String,
      avatarUrl: json['avatar'] as String?,
      profile_photo_url: json['profile_photo_url'] as String?
    );
  }
}

class ServiceRequestDisplayData {
  final int id;
  final int? price;
  final ServiceDisplayData? service;
  final UserDisplayData? client;
  final UserDisplayData? professional;
  final int? client_id;
  final int? professional_id;

  ServiceRequestDisplayData({
    required this.id,
    this.price,
    this.service,
    this.client,
    this.professional,
    this.client_id,
    this.professional_id,
  });

  factory ServiceRequestDisplayData.fromJson(Map<String, dynamic> json) {
    return ServiceRequestDisplayData(
      id: json['id'] as int,
      client_id: json['client_id'] as int,
      professional_id: json['professional_id'] as int,
      service: ServiceDisplayData.fromJson(json['service']),
      client: UserDisplayData.fromJson(json['client']['user']),
      professional: UserDisplayData.fromJson(json['professional']['user']),
    );
  }
}