import 'package:dog_dashboard/features/dashboard/models/dog_breed_model.dart';
import 'package:dog_dashboard/features/dashboard/models/random_dog_model.dart';

class DashboardState {
  final bool loading;
  final String breed;
  final String? subBreed;
  final DogBreedsResponse? listOfBreeds;
  final RandomDogImage? randomDog;
  final DogImagesResponse? allImageByBreed;
  final RandomDogImage? randomImageByBreed;

  DashboardState({
    required this.breed,
    this.loading = false,
    this.subBreed,
    this.listOfBreeds,
    this.randomDog,
    this.allImageByBreed,
    this.randomImageByBreed,
  });

  DashboardState copyWith({
    bool? loading,
    String? breed,
    String? subBreed,
    DogBreedsResponse? listOfBreeds,
    RandomDogImage? randomDog,
    DogImagesResponse? allImageByBreed,
    RandomDogImage? randomImageByBreed,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      breed: breed ?? this.breed,
      subBreed: subBreed,
      allImageByBreed: allImageByBreed ?? this.allImageByBreed,
      listOfBreeds: listOfBreeds ?? this.listOfBreeds,
      randomDog: randomDog ?? this.randomDog,
      randomImageByBreed: randomImageByBreed ?? this.randomImageByBreed,
    );
  }
}
