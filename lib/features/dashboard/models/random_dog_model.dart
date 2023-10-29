class RandomDogImage {
  final String? message;
  final String? status;

  RandomDogImage({
    this.message,
    this.status,
  });

  factory RandomDogImage.fromJson(Map<String, dynamic> json) => RandomDogImage(
        message: json["message"],
        status: json["status"],
      );
}
