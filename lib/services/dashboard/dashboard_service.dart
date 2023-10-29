import 'dart:convert';
import 'dart:developer';

import 'package:dog_dashboard/features/dashboard/models/dog_breed_model.dart';
import 'package:dog_dashboard/features/dashboard/models/random_dog_model.dart';
import 'package:http/http.dart' as http;

class DogApiService {
  final String baseUrl = 'https://dog.ceo/api';

  // Fetch a random dog image by breed and sub-breed.
  Future<RandomDogImage> getRandomImageByBreed(String breed, [String? subBreed]) async {
    final subBreedSegment = subBreed != null ? '/$subBreed' : '';
    final response = await http.get(Uri.parse('$baseUrl/breed/$breed$subBreedSegment/images/random'));
    log(response.request.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return RandomDogImage.fromJson(data);
    } else {
      throw Exception('GetRandomImagesByBreed :: Failed to load random image by breed');
    }
  }

  // Fetch all dog images by breed and sub-breed.
  Future<DogImagesResponse> getAllImageByBreed(String breed, [String? subBreed]) async {
    final subBreedSegment = subBreed != null ? '/$subBreed' : '';
    final response = await http.get(Uri.parse('$baseUrl/breed/$breed$subBreedSegment/images'));
    log(response.request.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return DogImagesResponse.fromJson(data);
    } else {
      throw Exception('GetAllImagesByBreed :: Failed to load random image by breed');
    }
  }

  // Fetch a list of all dog breeds.
  Future<DogBreedsResponse> getAllBreeds() async {
    final response = await http.get(Uri.parse('$baseUrl/breeds/list/all'));
    log(response.request.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return DogBreedsResponse.fromJson(data);
    } else {
      throw Exception('GetAllBreeds :: Failed to load all dog breeds');
    }
  }

  // Fetch a random dog image.
  Future<RandomDogImage> getRandomDogImage() async {
    final response = await http.get(Uri.parse('$baseUrl/breeds/image/random'));
    log(response.request.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return RandomDogImage.fromJson(data);
    } else {
      throw Exception('GetRandomImagesByBreed :: Failed to load random image by breed');
    }
  }
}
