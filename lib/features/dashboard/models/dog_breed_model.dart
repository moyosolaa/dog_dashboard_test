class DogImagesResponse {
  final List<String> message;
  final String status;

  DogImagesResponse({
    required this.message,
    required this.status,
  });

  factory DogImagesResponse.fromJson(Map<String, dynamic> json) {
    return DogImagesResponse(
      message: (json['message'] as List).cast<String>(),
      status: json['status'],
    );
  }
}

class DogBreedsResponse {
  final Map<String, List<String>> message;
  final String status;

  DogBreedsResponse({
    required this.message,
    required this.status,
  });

  factory DogBreedsResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> messageMap = json['message'] as Map<String, dynamic>;
    final Map<String, List<String>> breeds = {};
    messageMap.forEach((breed, subBreeds) {
      breeds[breed] = List<String>.from(subBreeds);
    });
    return DogBreedsResponse(
      message: breeds,
      status: json['status'],
    );
  }
}

