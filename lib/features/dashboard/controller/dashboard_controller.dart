import 'package:dog_dashboard/features/dashboard/models/dashboard_state.dart';
import 'package:dog_dashboard/main.dart';
import 'package:dog_dashboard/services/dashboard/dashboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a StateNotifierProvider for the DashboardController
final dashboardControllerProvider = StateNotifierProvider<DashboardController, DashboardState>((ref) {
  return DashboardController(ref.read(dogApiServiceProvider));
});

// DashboardController is responsible for managing the application state.
class DashboardController extends StateNotifier<DashboardState> {
  final DogApiService _dogApiService;

  // Constructor for DashboardController
  DashboardController(this._dogApiService) : super(DashboardState(breed: 'affenpinscher')) {
    // Initialize the controller by loading data when it's created.
    _loadData();
  }

  // Load initial data for the dashboard.
  Future<void> _loadData() async {
    state = state.copyWith(loading: true);
    try {
      // Load list of breeds, a random dog image, and images by breed.
      final listOfBreeds = await _dogApiService.getAllBreeds();
      final randomDog = await _dogApiService.getRandomDogImage();
      final allImageByBreed = await _dogApiService.getAllImageByBreed(listOfBreeds.message.keys.first);
      final randomImageByBreed = await _dogApiService.getRandomImageByBreed(listOfBreeds.message.keys.first);

      state = state.copyWith(
        loading: false,
        listOfBreeds: listOfBreeds,
        randomDog: randomDog,
        allImageByBreed: allImageByBreed,
        randomImageByBreed: randomImageByBreed,
      );
    } catch (error) {
      // Handle errors if any occur during data loading.
      state = state.copyWith(loading: false);
    }
  }

  // Load a random dog image.
  Future<void> getRandomDogImage() async {
    state = state.copyWith(loading: true);
    try {
      final randomDog = await _dogApiService.getRandomDogImage();
      state = state.copyWith(
        loading: false,
        randomDog: randomDog,
      );
    } catch (error) {
      // Handle errors if any occur during data loading.
      state = state.copyWith(loading: false);
    }
  }

  // Set the selected breed and load images by breed.
  void setSelectedBreed(String breed) async {
    state = state.copyWith(loading: true, breed: breed, subBreed: null);
    final allImageByBreed = await _dogApiService.getAllImageByBreed(breed);
    state = state.copyWith(loading: false, allImageByBreed: allImageByBreed);

    if (state.listOfBreeds?.message[breed] != null && state.listOfBreeds!.message[breed]!.isNotEmpty) {
      // If there are sub-breeds, set the first sub-breed as the selected sub-breed.
      final firstSubBreed = state.listOfBreeds!.message[breed]!.first;
      state = state.copyWith(loading: false, allImageByBreed: allImageByBreed, subBreed: firstSubBreed);
    } else {
      state = state.copyWith(loading: false, allImageByBreed: allImageByBreed, subBreed: null);
    }
  }

  // Set the selected sub-breed and load images for that sub-breed or the main breed.
  void setSelectedSubBreed(String? subBreed) async {
    state = state.copyWith(subBreed: subBreed);

    if (subBreed != null) {
      // Load images for the selected sub-breed.
      final imagesBySubBreed = await _dogApiService.getAllImageByBreed(state.breed, subBreed);
      state = state.copyWith(allImageByBreed: imagesBySubBreed);
    } else {
      // Load images for the main breed if no sub-breed is selected.
      final allImageByBreed = await _dogApiService.getAllImageByBreed(state.breed);
      state = state.copyWith(allImageByBreed: allImageByBreed);
    }
  }
}
