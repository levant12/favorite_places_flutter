import 'dart:io';

import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/favourite_place_provider.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddPlaceState();
  }
}

class _AddPlaceState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).copyWith().colorScheme.onBackground,
                ),
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                controller: _titleController,
              ),
              const SizedBox(height: 12),
              ImageInput(
                onPickImage: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              LocationInput(onSelectLocations: (location) {
                _selectedLocation = location;
              }),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  final enteredTitle = _titleController.value.text;
                  if (enteredTitle.isEmpty ||
                      _selectedImage == null ||
                      _selectedLocation == null) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid Input'),
                      ),
                    );
                    return;
                  }
                  ref.read(favouritesProvider.notifier).addFavourite(
                        uuid.v4(),
                        enteredTitle,
                        _selectedImage!,
                        _selectedLocation!,
                      );

                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
