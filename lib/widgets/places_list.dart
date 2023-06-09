import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/favourite_place_provider.dart';
import 'package:favourite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (places.isNotEmpty) {
      return ListView.builder(
        itemCount: places.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(places[index].id),
          onDismissed: (direction) {
            ref
                .read(favouritesProvider.notifier)
                .removeFavourite(places[index]);
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: FileImage(
                places[index].image,
              ),
            ),
            title: Text(
              places[index].title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            subtitle: Text(
              places[index].location.address,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => PlaceDetail(
                    place: places[index],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Center(
      child: Text(
        'No Places Yet',
        style: TextStyle(
          color: Theme.of(context).copyWith().colorScheme.onBackground,
        ),
      ),
    );
  }
}
