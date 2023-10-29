import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog_dashboard/features/dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grid_staggered_lite/grid_staggered_lite.dart';

// This widget displays a Dog Image Dashboard using Riverpod for state management.
class DogImageDashboard extends ConsumerStatefulWidget {
  const DogImageDashboard({super.key});

  @override
  ConsumerState<DogImageDashboard> createState() => _DogImageDashboardState();
}

class _DogImageDashboardState extends ConsumerState<DogImageDashboard> {
  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dog Image Dashboard'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Random Image'),
              Tab(text: 'Image List'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Random Image Tab
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Display a loading spinner or random dog image with hero animation.
                  dashboardState.loading
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _viewImageFullscreen(dashboardState.randomDog!.message!),
                                child: Hero(
                                  tag: dashboardState.randomDog!.message!,
                                  child: CachedNetworkImage(
                                    imageUrl: dashboardState.randomDog!.message!,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                _getBreedAndSubBreed(dashboardState.randomDog!.message!),
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                  // Spacer for layout separation.
                  const Spacer(),
                  // Button to get a new random dog image.
                  ElevatedButton(
                    onPressed: () {
                      ref.read(dashboardControllerProvider.notifier).getRandomDogImage();
                    },
                    child: const Text('Get Random Dog Image'),
                  ),
                ],
              ),
            ),

            // Image List Tab
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 0.80),
                          ),
                          child: DropdownButton<String>(
                            value: dashboardState.breed,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            underline: const SizedBox(),
                            onChanged: (String? newValue) {
                              ref.read(dashboardControllerProvider.notifier).setSelectedBreed(newValue!);
                            },
                            items: dashboardState.listOfBreeds?.message.keys.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                          '$value - (${dashboardState.listOfBreeds!.message[value]!.length} subbreeds)'),
                                    );
                                  },
                                ).toList() ??
                                [],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          _showFilterBottomSheet(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Display a loading spinner or a list of images with hero animations.
                  dashboardState.loading
                      ? const Center(child: CircularProgressIndicator())
                      : dashboardState.allImageByBreed!.message.isNotEmpty
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: StaggeredGridView.countBuilder(
                                  shrinkWrap: true,
                                  crossAxisCount: 3,
                                  itemCount: dashboardState.allImageByBreed!.message.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () => _viewImageFullscreen(dashboardState.allImageByBreed!.message[index]),
                                      child: Hero(
                                        tag: dashboardState.allImageByBreed!.message[index],
                                        child: CachedNetworkImage(
                                          imageUrl: dashboardState.allImageByBreed!.message[index],
                                          placeholder: (context, url) =>
                                              const Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                  staggeredTileBuilder: (int index) => const StaggeredTile.count(1, 1.2),
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                ),
                              ),
                            )
                          : const Center(
                              child: Text('No images available.'),
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extract the breed name from the image URL.
  String _getBreedAndSubBreed(String imageUrl) {
    final parts = imageUrl.split('/');
    if (parts.length >= 6) {
      final breed = parts[4];
      return 'Breed - ${breed.toUpperCase()}';
    }
    return 'Unknown Breed';
  }

  // Show a bottom sheet for selecting sub-breeds.
  void _showFilterBottomSheet(BuildContext context) {
    final dashboardState = ref.read(dashboardControllerProvider);
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1 / 2,
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: dashboardState.listOfBreeds!.message[dashboardState.breed]!.isEmpty
                  ? Text('${dashboardState.breed.toUpperCase()} has no subbreeds')
                  : Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      children: dashboardState.listOfBreeds!.message[dashboardState.breed]!.map((String subBreed) {
                        return Padding(
                          padding: EdgeInsets.zero,
                          child: FilterChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: const BorderSide(color: Colors.black),
                            ),
                            label: Text(subBreed),
                            selected: dashboardState.subBreed == subBreed,
                            onSelected: (bool selected) {
                              ref.read(dashboardControllerProvider.notifier).setSelectedSubBreed(
                                    selected ? subBreed : null,
                                  );
                              Navigator.pop(context);
                            },
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
        );
      },
    );
  }

  // Display the selected image in full screen.
  void _viewImageFullscreen(String imageUrl) {
    final dashboardState = ref.read(dashboardControllerProvider);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(dashboardState.breed),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Hero(
                  tag: imageUrl,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
