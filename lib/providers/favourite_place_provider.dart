import 'dart:io';

import 'package:favourite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatebase() async {
  final dbPath = await sql.getDatabasesPath();
  var db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT )',
      );
    },
    version: 1,
  );

  return db;
}

class FavouritePlaces extends StateNotifier<List<Place>> {
  FavouritePlaces() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatebase();
    final data = await db.query('user_places');
    final places = data.map(
      (row) {
        return Place(
          id: row['id'] as String,
          title: row['title'] as String,
          image: File(row['image'] as String),
          location: PlaceLocation(
            lat: row['lat'] as double,
            lng: row['lng'] as double,
            address: row['address'] as String,
          ),
        );
      },
    ).toList();

    state = places;
  }

  void addFavourite(
    String id,
    String title,
    File image,
    PlaceLocation location,
  ) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    final db = await _getDatebase();

    await db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.lat,
      'lng': newPlace.location.lng,
      'address': newPlace.location.address,
    });

    state = [...state, newPlace];
  }

  void removeFavourite(Place place) {
    state.remove(place);
  }
}

final favouritesProvider =
    StateNotifierProvider<FavouritePlaces, List<Place>>((ref) {
  return FavouritePlaces();
});
